package com.thebigdev.ai.behaviortree.groups.nd
{
	import com.thebigdev.ai.behaviortree.base.Task;
	import com.thebigdev.ai.behaviortree.groups.Selector;
	
	/**
	 * A selector that chooses one child at random whenever it needs
	 * to. This selector will never stop selecting children (so it
	 * will never return SUCCESS), but it will return FAILURE if 
	 * a task fails. It will not attempt to select children in order,
	 * and some tasks may be repeated any number of times before others
	 * are carried out once. 
	 * 
	 * Don't use this node, therefore, to select among different options
	 * for strategies. ShuffledSelector is the class for that. This is
	 * more suitable for playing random animations, or doing random jobs.
	 */
	public class RandomChoice extends Selector
	{
		public function RandomChoice()
		{
			super();
		}
		
		protected override function selectFirstChildInGroup():Task
		{
			active = true;
			return children[int(Math.random() * children.length())] as Task;
		}
		
		protected override function selectNextChildInGroup():Task
		{
			return children[int(Math.random() * children.length())] as Task;
		}
		
		protected override function hasMoreChildrenInGroup():Boolean
		{
			return true;
		}	
		
		public override function clone():Task
		{
			var task:RandomChoice = new RandomChoice();
			addClonedChildren(task);
			return task;	
		}		
	}
}