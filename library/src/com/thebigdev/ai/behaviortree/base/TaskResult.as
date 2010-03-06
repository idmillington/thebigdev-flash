package com.thebigdev.ai.behaviortree.base
{
	/**
	 * This is a simple enumeration, not intended for user instantiation.
	 * Use one of the static instances.
	 */
	public class TaskResult
	{
		/**
		 * Status code to return if the task completes successfully.
		 */
		public static var SUCCESS:TaskResult = new TaskResult();
		
		/**
		 * Status code to return if the task completes in failure.
		 */
		public static var FAILURE:TaskResult = new TaskResult();
		
		/**
		 * Status code to return if the task does not complete, and needs
		 * more time.
		 */
		public static var MORE_TIME:TaskResult = new TaskResult();
		
		/**
		 * Creates a new TaskResult, you won't need to do this.
		 */
		public function TaskResult()
		{
		}

	}
}