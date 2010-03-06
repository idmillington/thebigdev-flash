package com.thebigdev.ai.behaviortree.decorators
{
	import com.thebigdev.ai.behaviortree.base.Decorator;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;

	/**
	 * A simple decorator that returns true if its child returns false,
	 * and vice versa. Results of null (for more time) are returned
	 * without change.
	 */
	public class Inverter extends Decorator
	{
		public function Inverter(child:Task)
		{
			super(child);
		}
		
		public override function run(scope:Scope):TaskResult
		{
			var result:TaskResult = super.run(scope);
			if (result === TaskResult.MORE_TIME) {
				return TaskResult.MORE_TIME;
			} else if (result === TaskResult.SUCCESS) {
				return TaskResult.FAILURE;
			} else {
				return TaskResult.SUCCESS;
			}
		}	
		
		public override function clone():Task
		{
			return new Inverter(child.clone());
		}
	}
}