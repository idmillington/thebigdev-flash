package com.thebigdev.ai.behaviortree.decorators
{
	import com.thebigdev.ai.behaviortree.base.Decorator;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	
	/** 
	 * A decorator that keeps on running its child node until
	 * it gets the result it is looking for, whereupon it returns.
	 * 
	 * By default this class repeats until its child returns in FAILURE.
	 * You can give it a different exit condition in the constructor. Note
	 * that a value of null for exitIf (the default) is treated as 
	 * TaskResult.FAILURE.
	 */
	public class RepeatUntil extends RepeatNTimes
	{
		public function RepeatUntil(child:Task, exitIf:TaskResult=null)
		{
			if (exitIf === null) {
				exitIf = TaskResult.FAILURE;
			}
			super(0, child, exitIf);
		}
		
		public override function clone():Task
		{
			return new RepeatUntil(child.clone(), exitIf);
		}
	}
}