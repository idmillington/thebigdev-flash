package com.thebigdev.ai.behaviortree.decorators
{
	import com.thebigdev.ai.behaviortree.base.Decorator;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;

	/**
	 * A decorator that will return a result after a given duration 
	 * if its child doesn't return before then.
	 * 
	 * By default the decorator returns FAILURE if it times out, although
	 * you can give it a different value in the constructor. Note that
	 * passing null as the timeOutResult (the default) is interpreted as
	 * wanting to return FAILURE.
	 */
	public class TimeOutAfter extends Decorator
	{
		protected var timeToWait:Number;
		protected var timeWaited:Number = 0;
		protected var timeOutResult:TaskResult;

		public function TimeOutAfter(
			timeToWait:Number, child:Task, timeOutResult:TaskResult=null
			)
		{
			super(child);
			if (timeOutResult === null) {
				timeOutResult = TaskResult.FAILURE;
			}
			this.timeOutResult = timeOutResult;
		}
		
		public override function terminate():void
		{
			super.terminate();
			timeWaited = 0;
		}
		
		public override function run(scope:Scope):TaskResult
		{
			var result:TaskResult = super.run(scope);
			
			// If we got a result, reset the timer and return.
			if (result !== TaskResult.MORE_TIME) {
				timeWaited = 0;
				return result;
			}
			
			// Otherwise work out if we're timed out yet.
			timeWaited += scope.timing.lastFrameDurationInSeconds;
			if (timeWaited >= timeToWait) {
				// Time to bail
				terminate();
				return timeOutResult;
			} else {
				// We're still okay, keep working.
				return TaskResult.MORE_TIME;
			}
		}
		
		public override function clone():Task
		{
			return new TimeOutAfter(
				timeToWait, child.clone(), timeOutResult
				);
		}
	}
}