package com.thebigdev.ai.behaviortree.simple
{
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	
	/** 
 	 * A simple task that always, immediately, returns false.
 	 */
	public class Failure extends Task
	{
		public function Failure()
		{
			super();
		}
	
		public override function run(scope:Scope):TaskResult
		{
			return TaskResult.FAILURE;
		}
		
		public override function clone():Task
		{
			return new Failure();
		}	
	}
}