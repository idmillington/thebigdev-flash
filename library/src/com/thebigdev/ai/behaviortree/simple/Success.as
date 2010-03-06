package com.thebigdev.ai.behaviortree.simple
{
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;

	/** 
 	 * A simple task that always, immediately, returns true.
 	 */
	public class Success extends Task
	{
		public function Success()
		{
			super();
		}
	
		public override function run(scope:Scope):TaskResult
		{
			return TaskResult.SUCCESS;
		}
		
		public override function clone():Task
		{
			return new Success();
		}	
	}
}