package com.thebigdev.ai.behaviortree.groups
{
	import com.thebigdev.ai.behaviortree.base.GroupOfTasks;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	
	/**
	 * This sequence runs through its entire set of children on
	 * every frame, no matter where it got to last time. This allows
	 * you to hang conditions off this node and have them checked constantly
	 * while another child task is completing. It is normal for the children
	 * of this task to consist of only conditions and further groups.
	 */
	public class AllOrNothingSequence extends GroupOfTasks
	{
		protected var lastActiveIndex:int;
		
		public function AllOrNothingSequence()
		{
			super(true, false, TaskResult.SUCCESS);
			lastActiveIndex = -1;
		}
		
		public override function run(scope:Scope):TaskResult
		{
			active = false;
			var result:TaskResult;
			var index:int = 0;
			for each (var task:Task in children) {
				result = task.run(scope);
				
				// If we're active (we're leaving a child running), then
				// check if it was the child that was running last time, 
				// if it was an earlier one, we need to terminate the child
				// that we left running.
				active = (result === TaskResult.MORE_TIME);
				if (active) {
					if (lastActiveIndex >= 0 && index < lastActiveIndex) {
						(children[lastActiveIndex] as Task).terminate();
					}
					lastActiveIndex = index;
				}
				
				// If we've got anything but success, that's our result
				if (result !== TaskResult.SUCCESS) {
					return result
				}
				index += 1
			}
			
			lastActiveIndex = -1;
			return TaskResult.SUCCESS;
		}
		
		public override function terminate():void
		{
			if (lastActiveIndex >= 0) {
				(children[lastActiveIndex] as Task).terminate();
			}
		}
		
		public override function clone():Task
		{
			var task:AllOrNothingSequence = new AllOrNothingSequence();
			addClonedChildren(task);
			return task;
		}
		
	}
}