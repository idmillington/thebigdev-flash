package com.thebigdev.ai.behaviortree.decorators
{
	import com.thebigdev.ai.behaviortree.base.Decorator;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;

	/**
	 * Runs its child a given number of times, optionally exiting
	 * if the child returns a specific value. The last time through
	 * we'll exit with whatever our child exited with. If you give a 
	 * times value of zero, the child will run forever.
	 */
	public class RepeatNTimes extends Decorator
	{
		protected var times:int;
		protected var exitIf:TaskResult;
		
		protected var timesRun:int = 0;
		
		public function RepeatNTimes(
			times:int, child:Task, exitIf:TaskResult=null
			)
		{
			super(child);
			this.times = times;
			this.exitIf = exitIf;
		}
		
		public override function terminate():void
		{
			timesRun = 0;
			super.terminate();
		}
		
		public override function run(scope:Scope):TaskResult
		{
			var result:TaskResult = super.run(scope);
			if (result !== TaskResult.MORE_TIME) {
				// We got a result, check if it is our hot button
				if (result === exitIf) {
					timesRun = 0;
					return result;
				} else {
					// Otherwise we've passed another count.
					times++;
					
					// Have we finished?
					if (times > 0 && timesRun >= times) {
						// Return our final value.
						return result;
					} else {
						// We're going for another go. Reactivate
						return TaskResult.MORE_TIME;
					}
				}
			}
			return result
		}
		
		public override function clone():Task
		{
			return new RepeatNTimes(times, child.clone(), exitIf);
		}
		
	}
}