package com.thebigdev.ai.behaviortree.base
{
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	
	/**
	 * A base class for tasks that manage a variable number of other
	 * tasks. There are three policy values given to the constructor
	 * that control whether this tasks should respond to a true or false
	 * result from its children, and what result it should return if
	 * it goes through all its children without event.
	 */
	public class GroupOfTasks extends Task
	{
		/**
		 * If this is true then the update of this task will return
		 * false as soon as its active child returns false.
		 */
		protected var failIfChildFailed:Boolean = false;
		
		/**
		 * If this is true then the update of this task will return
		 * true as soon as its active child return true.
		 */
		protected var successIfChildSucceeded:Boolean = false;
		
		/**
		 * If we've been through all the children in this group, what
		 * result should we return. If we return null it means that
		 * we're likely to get more time to run through them all again.
		 */
		protected var resultIfNoMoreChilden:TaskResult = TaskResult.FAILURE;
		
		/** 
		 * Holds the list of children that this task is managing.
		 */
		protected var children:Array;
		
		/**
		 * Holds whether this task is active or not. This allows us to
		 * know if we can change the children in the task or not.
		 */
		protected var active:Boolean;
		
		public function GroupOfTasks(
			ficf:Boolean, tict:Boolean, rinmc:TaskResult
			)
		{
			super();
			children = [];
			successIfChildSucceeded = tict;
			failIfChildFailed = ficf;
			resultIfNoMoreChilden = rinmc;
		}		

		public override function run(scope:Scope):TaskResult
		{
			active = true;
			return super.run(scope);			
		}		
		
		public override function terminate():void
		{
			active = false;
		}
		
		/**
		 * Adds a task to the group. This cannot be called if the 
		 * group is currently active. Wait for it to complete or terminate
		 * it first.
		 */
		public function addChild(task:Task):void
		{
			if (active) {
				throw new Error("You can't add children to an active task.");
			} else {
				var index:int = children.indexOf(task);
				if (index >= 0) {
					throw new Error("That task is already in this group.");
				} else {
					children.push(task);
				}
			}
		}
		
		/**
		 * Removes the task from the group. This cannot be done if the 
		 * group is currently active. Wait for it to complete or terminate
		 * it first.
		 */
		public function removeChild(task:Task):void
		{
			if (active) {
				throw new Error("You can't add children to an active task.");
			} else {
				var index:int = children.indexOf(task);
				if (index >= 0) {
					children.splice(index, 1);
				} else {
					throw new Error("The given task wasn't in this group.");
				}
			}
		}
		
		/**
		 * When cloning a group, this convenience function adds cloned
		 * versions of the children to the cloned task.
		 */
		protected function addClonedChildren(clone:GroupOfTasks):void
		{
			for each (var child:Task in children) {
				clone.addChild(child.clone());
			}
		}
	}
}