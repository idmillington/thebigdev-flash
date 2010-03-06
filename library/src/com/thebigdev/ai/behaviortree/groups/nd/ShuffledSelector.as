package com.thebigdev.ai.behaviortree.groups.nd
{
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.groups.Selector;
	
	/** 
	 * This class behaves just like a normal selector, only it chooses
	 * its children in a random order. But it does choose all its children,
	 * in some order, it doesn't just select one at random each time, so it
	 * can still be used to try all of a set of options.
	 */
	public class ShuffledSelector extends Selector
	{
		public function ShuffledSelector()
		{
			super();
		}
		
		/**
		 * Holds our shuffled version of the children array.
		 */
		protected var shuffled:Array;
		
		protected override function selectFirstChildInGroup():Task
		{
			active = true;
			childIndex = 0;
			
			// Let's create the shuffled version of the array. We're using
			// Knuth's Algorithm P. First create a copy of our child array.
			shuffled = [];
			for (var i:int = 0; i < children.length; i++) {
				shuffled.push(children[i]);
			}
			
			// Now do the selecting and swapping.
			var n:int = shuffled.length();
			var temp:Task;
			while (n > 1) {
				// Select an element
				var k:int = int(Math.random() * n);
				n--;
				
				// Swap the selected element to the end.
				temp = shuffled[n] as Task;
				shuffled[n] = shuffled[k];
				shuffled[k] = temp;
			}
			
			return shuffled[0] as Task;
		}
		
		protected override function selectNextChildInGroup():Task
		{
			childIndex++;
			return shuffled[childIndex] as Task;
		}
		
		protected override function hasMoreChildrenInGroup():Boolean
		{
			return (childIndex+1 < shuffled.length());
		}
		
		public override function clone():Task
		{
			var task:ShuffledSelector = new ShuffledSelector();
			addClonedChildren(task);
			return task;	
		}			
	}
}