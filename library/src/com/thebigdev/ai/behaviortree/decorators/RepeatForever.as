package com.thebigdev.ai.behaviortree.decorators
{
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;

	/**
	 * This decorator repeats its child forever, and never returns anything
	 * but MORE_TIME.
	 */
	public class RepeatForever extends RepeatUntil
	{
		public function RepeatForever(child:Task)
		{
			super(child);
		}
		
		public override function clone():Task
		{
			return new RepeatForever(child.clone());
		}
		
	}
}