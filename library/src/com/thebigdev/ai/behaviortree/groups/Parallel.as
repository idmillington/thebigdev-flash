package com.thebigdev.ai.behaviortree.groups
{
	import com.thebigdev.ai.behaviortree.base.GroupOfTasks;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;

	/**
	 * A group of tasks that are conceptually run at the same time.
	 * This class runs the update for all its group tasks and only
	 * returns when all of them complete. 
	 * 
	 * The result when all of the tasks are complete can be set in
	 * the constructor. If it is set to MORE_TIME, then the parallel tasks
	 * keep running, each one starting again as soon as it has finished.
	 * If the setting is anything other than MORE_TIME, then finished
	 * tasks won't be restarted, and the result will be returned when
	 * all tasks are complete.
	 */
	public class Parallel extends GroupOfTasks
	{
		/**
		 * Holds the child records corresponding to the children of
		 * this task.
		 */
		protected var childRecords:Array = null;
		
		public function Parallel(ficf:Boolean, tict:Boolean, rinmc:TaskResult)
		{
			super(ficf, tict, rinmc);
		}
		
		/**
		 * Creates the child records associated with the current set of 
		 * childen.
		 */
		protected final function createChildRecords():void
		{
			var i:int;
			
			// Re-create the array if we're the wrong size.
			if (childRecords === null ||childRecords.length != children.length)
			{
				childRecords = [];
				for (i = 0; i < children.length(); i++) {
					childRecords.push(new ChildRecord());
				}			
			}
			
			// Assign the children to the records
			for (i = 0; i < children.length(); i++) {
				var child:Task = children[i] as Task;
				var record:ChildRecord = childRecords[i] as ChildRecord;
				
				record.task = child;
				record.active = true;
			}
			active = true;
		} 
		
		/**
		 * Updates all children that need it and returns if it can.
		 */
		public override function run(scope:Scope):TaskResult
		{
			var result:TaskResult;
			
			// Make sure we're active.
			if (!active) {
				createChildRecords();
				active = true;
			}
			
			// Update those children that need it.
			var allDone:Boolean = true;
			for (var i:int = 0; i < childRecords.length(); i++) {
				var record:ChildRecord = childRecords[i] as ChildRecord;
				
				// If we're in progress, or we're never stopping, then
				// run the task.
				if (record.active || 
					resultIfNoMoreChilden === TaskResult.MORE_TIME) 
				{
					result = record.task.run(scope);
					
					// If we're never going to end, then there's no point
					// stopping this task, we may as well run it again 
					// right now.
					if (resultIfNoMoreChilden !== TaskResult.MORE_TIME) {
						record.active = (result === TaskResult.MORE_TIME);
					}
					
					// Check for the result we're looking for.
					if (result === TaskResult.SUCCESS && 
						successIfChildSucceeded) 
					{
						// We're going to return, so terminate any active
						// children first.
						terminate();
						return TaskResult.SUCCESS;
					} else if (result === TaskResult.FAILURE && 
						failIfChildFailed) 
					{
						terminate();
						return TaskResult.FAILURE;
					} else if (result === TaskResult.MORE_TIME) {
						allDone = false;
					}
				}
			}
			
			// Are we all done?
			if (allDone) {
				active = false;
				return resultIfNoMoreChilden;
			} else {
				return TaskResult.MORE_TIME;
			}
		}
		
		public override function terminate():void
		{
			active = false;
			
			// Terminate all active children.
			for (var i:int = 0; i < childRecords.length(); i++) {
				var record:ChildRecord = childRecords[i] as ChildRecord;
				if (record.active) {
					record.task.terminate();
					record.active = false;
				}
			}
		}
		
		public override function clone():Task
		{
			var parallel:Parallel = new Parallel(
				failIfChildFailed, successIfChildSucceeded, 
				resultIfNoMoreChilden
				);
			addClonedChildren(parallel);
			return parallel;	
		}
		
	}
}

import com.thebigdev.ai.behaviortree.base.Task;	

class ChildRecord
{
	public var task:Task;
	public var active:Boolean;
}