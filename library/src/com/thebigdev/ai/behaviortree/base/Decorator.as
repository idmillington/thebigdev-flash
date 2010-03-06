package com.thebigdev.ai.behaviortree.base
{
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	
	/**
	 * Decorators are particular kinds of task that have a single child
	 * task and somehow modify its behavior. This is the base class
	 * for these kind of tasks.
	 * 
	 * The class is named for the 'decorator' object-oriented pattern.
	 */
	public class Decorator extends Task
	{
		/**
		 * Holds the child task we're decorating.
		 */
		protected var _child:Task = null;
		
		/**
		 * Records whether or not the current child is active (i.e. it
		 * returned null from its update method last time it was called).
		 * This allows us to know if we need to terminate it.
		 */
		protected var isChildActive:Boolean = false;
		
		public function Decorator(child:Task)
		{
			super();
			this.child = child;	
		}
		
		/**
		 * The task that this decorator is wrapping. You can't set the
		 * child if the current child is already active.
		 */
		public function set child(newChild:Task):void
		{
			if (isChildActive) {
				throw new Error("You can't add a child to an active task.");
			} else {
				_child = newChild;	
			}
		}
		public function get child():Task
		{
			return _child;
		}
		
		/**
		 * Calls the child task to do its thing. This implementation
		 * keeps track of whether the child is active or not, so we
		 * know whether to terminate it later. Because of this functionality
		 * subclasses overriding this method normally call this base class
		 * method.
		 */
		public override function run(scope:Scope):TaskResult
		{
			var result:TaskResult = _child.run(scope);
			isChildActive = (result === TaskResult.MORE_TIME);
			return result;
		}
		
		/**
		 * Terminates the child task if required. Subclasses should call
		 * this base class implementation to do its thing.
		 */
		public override function terminate():void
		{
			if (isChildActive) {
				_child.terminate();
				isChildActive = false;
			}
		}
	}
}