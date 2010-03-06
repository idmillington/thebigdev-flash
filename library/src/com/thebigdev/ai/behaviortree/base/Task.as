package com.thebigdev.ai.behaviortree.base
{
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	
	/**
	 * Represents the base-class of the behavior tree hierarchy. This
	 * call is the foundation of all nodes in the tree. It consists of
	 * two methods - one to run the task (update) and another to notify
	 * the task that it is being interrupted and won't be allowed to 
	 * complete (terminate).
	 * 
	 * Tasks can be thought of as executing for a while and returning true
	 * or false. Unfortunately, because flash is a single-threaded system,
	 * we can't allow tasks to just run until a result is available. 
	 * Instead the behavior tree also implements a cooperative multitasking
	 * scheduler. Each task is given some cpu time to do its thing, but
	 * should be capable of being interrupted and requesting more time.
	 * The tree will then make sure the interrupted tasks get the extra
	 * time they need, and will only process their responses when they
	 * are happy to commit to one. It is the responsibility of tasks to
	 * do only a small amount of work in their run functions and to
	 * avoid hogging the CPU.
	 */
	public class Task
	{
		public function Task()
		{
		}

		/**
		 * This is called to run the task. 
		 * 
		 * The function should return a result instance - either SUCCESS
		 * if the task
		 * succeeded, FAILURE if it failed, or MORE_TIME if it didn't come 
		 * to a
		 * result and should be called again to complete its processing.
		 * 
		 * This base class does nothing and always returns MORE_TIME for more
		 * time. As such this base-class is not useful on its own.. 
		 */
		public function run(scope:Scope):TaskResult
		{
			return TaskResult.MORE_TIME;
		}
		
		/**
		 * When a task is in progress, it can be interrupted by another
		 * part of the behavior tree. Any resources it is using for its
		 * processing should be released. This method is called by the
		 * behavior tree system to notify the task that it won't be 
		 * getting the extra time it requested, and it should tidy up
		 * accordingly.
		 */
		public function terminate():void
		{
		}
		
		/**
		 * This method is used to create a copy of the behavior tree.
		 * Tasks should implement this to return a copy of themselves. Any
		 * child tasks (for various types of grouped-tasks) should also
		 * be cloned. This allows you to call clone on the top of the tree
		 * and receive a copy of the entire tree.
		 */
		public function clone():Task
		{
			throw new Error("This method must be overridden in subclasses");
		}
	}
}