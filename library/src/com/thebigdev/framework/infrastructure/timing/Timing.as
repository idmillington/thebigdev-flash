package com.thebigdev.framework.infrastructure.timing
{
	import flash.utils.getTimer;
	
	/**
	 * Represents timing data for the game, such as the frame number
	 * and the game-time elapsed since the previous frame.
	 */
	public class Timing
	{
		/**
		 * The current frame number. This begins at 0 and counts up
		 * from the start of world-simulation (normally the start
		 * of a level, or the last loss of life if the game is reset
		 * each time).
		 */
		public function get frameNumber():uint { return _frameNumber; }
		private var _frameNumber:uint;
		
		/**
		 * The amount of game time that elapsed in the last frame.
		 * The value is given in milliseconds (i.e. 1 thousandth of 
		 * a second).
		 */
		public function get lastFrameDuration():uint { 
			return _lastFrameDuration; 
		}
		private var _lastFrameDuration:uint;
		
		/**
		 * Holds the number of seconds passed in the last frame.
		 * This is derived from the millisecond, and can have problems
		 * with precision for large durations.
		 */
		public function get lastFrameDurationInSeconds():Number {
		 	return _lastFrameDurationInSeconds;
		}
		private var _lastFrameDurationInSeconds:Number;
		
		/**
		 * The current time, in milliseconds, since this timing system
		 * was started.
		 */
		public function get currentTime():uint { return _currentTime; }
		private var _currentTime:uint;
		
		/**
		 * The maximum number of milliseconds to allow any frame to
		 * take up. This should be kept relatively small so that when
		 * the user pauses the simulation, it doesn't return with a huge
		 * physics update.
		 */
		public var frameDurationLimit:int = 1000;
		
		/**
		 * A recency weighted moving average of the duration of frames.
		 */
		public function get rwaFrameDuration():Number { 
			return _rwaFrameDuration; 
		}
		private var _rwaFrameDuration:Number;
		
		/**
		 * The strength of the recency weighted average. This should
		 * be a number greater than 0.0 (small numbers indicate the
		 * average should be longer-term and more stable) but less
		 * than 1.0. A value of 0.0 would never change, a value of 1.0
		 * would just use the last frame's data and so would not be an
		 * average. Values between 0.01 and 0.1 are the most useful.
		 */
		public var rwaCoefficient:Number = 0.05;
		
		/**
		 * The system time on the last execution of the frame update
		 * method.
		 */
		private var _lastSystemTime:int;
		
		public function Timing()
		{
			_currentTime = 0;
			_frameNumber = 0;
			_lastFrameDuration = 0;
			_lastFrameDurationInSeconds = 0;
			_lastSystemTime = getTimer();
			_rwaFrameDuration = 0;
		}
		
		/**
		 * Notifies the timing object that a frame has passed. The timing
		 * system will query the system clock and determine how much
		 * time has passed.
		 */
		public function frameUpdate():void
		{
			_frameNumber++;
			
			// Update the low level timer.
			var thisSystemTime:int = getTimer();
			_lastFrameDuration = (thisSystemTime - _lastSystemTime);
			if (_lastFrameDuration > frameDurationLimit) {
				_lastFrameDuration = frameDurationLimit;
			}			
			_lastSystemTime = thisSystemTime;
			_rwaFrameDuration = 
				(1.0 - rwaCoefficient) * _rwaFrameDuration + 
				rwaCoefficient * lastFrameDuration;
			
			// Update our internal clock.
			_currentTime += _lastFrameDuration;
			
			// And the frame duration in seconds.
			_lastFrameDurationInSeconds = _lastFrameDuration * 0.001;
		}
		
		/**
		 * Returns the current frames per second as determined by
		 * this timing unit.
		 */
		public function get fps():Number
		{
			if (_rwaFrameDuration > 0) {
				return 1.0 / _rwaFrameDuration;
			} else {
				return 0.0;
			}
		}
	}
}