package com.thebigdev.ai.behaviortree.decorators
{
	import com.thebigdev.ai.behaviortree.base.Decorator;
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.base.TaskResult;
	import com.thebigdev.ai.behaviortree.base.scope.Scope;
	import com.thebigdev.ai.data.errors.DataTypeError;
	import com.thebigdev.framework.infrastructure.concurrency.Semaphore;

	/** 
	 * This decorator is used to protect some resource. The decorator
	 * is created with an id-string. which should correspond to a
	 * record in the blackboard given to the run method, and that record
	 * should point to a Semaphore object. 
	 * 
	 * Despite the name, this class isn't intended to be thread-safe - it
	 * is intended for microthread use.
	 */
	public class SemaphoreFilter extends Decorator
	{
		protected var semaphoreName:String;
		protected var active:Boolean;
		
		/**
		 * Once the semaphore has been found, it is stored here.
		 */
		protected var semaphore:Semaphore;
		
		/**
		 * Creates a new semaphore filter based on the given name.
		 */
		public function SemaphoreFilter(semaphoreName:String, child:Task)
		{
			super(child);
			this.semaphoreName = semaphoreName;
		}
		
		public override function terminate():void
		{
			if (active) {
				active = false;
				semaphore.release();
			}
		}
		
		public override function run(scope:Scope):TaskResult
		{
			var result:TaskResult;
			
			if (semaphore === null) {
				// Find the semaphore
				var found:* = scope.blackboard.read(this.semaphoreName);
				if (found !== undefined) {
					semaphore = found as Semaphore;
					
					// If we got something back that wasn't correct, throw
					// an error.
					if (semaphore === null) {
						throw new DataTypeError(
							scope.blackboard, this.semaphoreName, "Semaphore"
							);
					}
				} else {
					// There was no defined semaphore - so create one.
					// Note that this can cause bugs - if we create a 
					// semaphore with the same name in two parts of the 
					// tree, they could be in different blackboards. It
					// is better to ensure that semaphores are created
					// and added where they are needed. That is also the 
					// only way to use semaphores with greater than 1 
					// max users.
					semaphore = new Semaphore(1);
					scope.blackboard.write(this.semaphoreName, semaphore);
				}
			}
			
			if (active) {
				result = super.run(scope);
				if (result !== TaskResult.MORE_TIME) {
					// We got a value to return, so free the semaphore.
					semaphore.release();
					active = false;
				}
			} else {
				// Try to acquire the semaphor
				if (semaphore.acquire()) {
					active = true;
					result = super.run(scope);
					if (result !== TaskResult.MORE_TIME) {
						// We're done immediately, free the semaphore
						semaphore.release();
						active = false; 
					}
				} else {
					// We failed to get it.
					return TaskResult.FAILURE;
				}				
			}
			return result;
		}
		
		public override function clone():Task
		{
			return new SemaphoreFilter(semaphoreName, child.clone());
		}
		
	}
}