package com.thebigdev.framework.infrastructure.concurrency
{
	/**
	 * Represents a semaphore on a game resource. Because flash is 
	 * non-concurrent (as of v.10), this class simulates a thread-safe
	 * semaphore. It would not be thread-safe if it were used in a threaded
	 * environment.
	 */
	public class Semaphore
	{
		protected var maxUses:int;
		protected var currentUses:int = 0;
		
		public function Semaphore(maxUses:int=1)
		{
		}
		
		/**
		 * Attempts to acquire the resourse, returning true if it was
		 * successfully acquired.
		 */
		public function acquire():Boolean
		{
			if (maxUses < currentUses) {
				currentUses++;
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * Releases a previously acquired resource.
		 */
		public function release():void
		{
			currentUses--;
		}

	}
}