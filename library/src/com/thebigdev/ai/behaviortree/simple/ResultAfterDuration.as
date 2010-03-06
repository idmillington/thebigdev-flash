package com.thebigdev.ai.behaviortree.simple
{
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;

	/**
	 * A simple task that waits until a particular amount of game time
	 * has elapsed before returning a particular result. This can act as
	 * a 'wait' action.
	 */
	public class ResultAfterDuration extends Task
	{
		protected var timeToWait:Number;
		protected var timeWaited:Number = 0;
		
		protected var resultToReturn:TaskResult;
		
		public function ResultAfterDuration(duration:Number, result:TaskResult)
		{
			super();
			timeToWait = duration;
			resultToReturn = result;
		}
		
		public override function run(scope:Scope):TaskResult
		{
			timeWaited += scope.timing.lastFrameDurationInSeconds;
			
			// Have we found our limit?
			if (timeWaited >= timeToWait) {
				timeWaited = 0;
				return resultToReturn;
			} else {
				return TaskResult.MORE_TIME;
			}
		}

		/**
		 * Resets the counter, as this process has been terminated mid-
		 * wait.
		 */		
		public override function terminate():void
		{
			timeWaited = 0;
		}
		
		public override function clone():Task
		{
			return new ResultAfterDuration(timeToWait, resultToReturn);
		}
	}
}