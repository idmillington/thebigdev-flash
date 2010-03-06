package com.thebigdev.ai.behaviortree.base
{
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	
	/**
	 * This is the base-class for groups that manage multiple tasks,
	 * of which only one is active at any one time.
	 */
	public class OneTaskFromGroup extends GroupOfTasks
	{
		/**
		 * Holds the current child from the group of tasks
		 * we're managing.
		 */
		protected var currentChild:Task = null;
		
		/**
		 * True if the current child returned null from its last update.
		 */
		protected var isChildActive:Boolean = false;
				
		public function OneTaskFromGroup(
			ficf:Boolean, tict:Boolean, rinmc:TaskResult
			)
		{
			super(ficf, tict, rinmc);
		}
		
		public override function run(scope:Scope):TaskResult
		{
			var result:TaskResult;
			
			// First make sure we have a task to run
			if (currentChild === null) {
				 result = nextChild();
				 if (result !== TaskResult.MORE_TIME) {
				 	return result;
				 }
			}
			
			// Run the current child task and check the return status
			result = currentChild.run(scope);
			active = isChildActive = (result === TaskResult.MORE_TIME);
			if (result === TaskResult.SUCCESS) {
				if (successIfChildSucceeded) {
					currentChild = null;
					return TaskResult.SUCCESS;
				} else {
					return nextChild();		
				}
			} else if (result === TaskResult.FAILURE) {
				if (failIfChildFailed) {
					currentChild = null;
					return TaskResult.FAILURE;
				} else {
					return nextChild();
				}
			} else {
				return TaskResult.MORE_TIME;
			}
		}
		
		public override function terminate():void
		{
			active = false;
			if (isChildActive) {
				currentChild.terminate();
				isChildActive = false;
			}
		}
		
		/**
		 * An internal counter to work out where we are in the iteration.
		 */
		protected var childIndex:int = 0;

		/**
		 * Starts the iteration over the childen in this task again
		 * from the start. This can be overridden to implement different
		 * ways of iterating over the tasks in the group.
		 */
		protected function selectFirstChildInGroup():Task
		{
			active = true;
			childIndex = 0;
			return children[0] as Task;
		}
		
		/**
		 * Continues the iteration so the next child in the group is
		 * current. This can be overridden to use different orderings.
		 */
		protected function selectNextChildInGroup():Task
		{
			childIndex++;
			return children[childIndex] as Task;
		}
		
		/**
		 * Checks if there are any more children in the group to make
		 * current. This is always called before selectNextChildInGroup.
		 */
		protected function hasMoreChildrenInGroup():Boolean
		{
			return (childIndex+1 < children.length());
		}
		
		/**
		 * Tries to update the current child to be the next in the
		 * sequence, returns null if there is a next child, or
		 * resultIfNoMoreChildren otherwise.
		 */
		protected function nextChild():TaskResult
		{
			if (childIndex < 0) {
				currentChild = selectFirstChildInGroup();
				return TaskResult.MORE_TIME;
			} else if (hasMoreChildrenInGroup()) {
				active = false;
				return resultIfNoMoreChilden;
			} else {
				currentChild = selectNextChildInGroup();
				return TaskResult.MORE_TIME;
			}
		}
	}
}