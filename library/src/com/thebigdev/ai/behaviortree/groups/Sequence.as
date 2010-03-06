package com.thebigdev.ai.behaviortree.groups
{
	import com.thebigdev.ai.behaviortree.base.OneTaskFromGroup;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;

	/**
	 * A sequence is one of the basic building blocks of a behavior
	 * tree: it tries its children in order and returns False when any
	 * of them return False, and returns True if it gets through them
	 * all.
	 * 
	 * It is used to execute tasks in order, failing the whole group
	 * if it can't carry out one of the steps.
	 */
	public class Sequence extends OneTaskFromGroup
	{
		public function Sequence()
		{
			super(true, false, TaskResult.SUCCESS);
		}

		public override function clone():Task
		{
			var task:Sequence = new Sequence();
			addClonedChildren(task);
			return task;	
		}			
	}
}