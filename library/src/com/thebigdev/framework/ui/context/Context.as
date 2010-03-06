package com.thebigdev.framework.ui.context
{
	import com.thebigdev.framework.ui.Manager;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**
	 * A context is a UI element that can be nested in a stack.
	 */
	public class Context extends Sprite
	{
		/**
		 * The manager that is currently managing this context. This should
		 * not be set manually by your code - it is configured automatically
		 * when the context is added or removed from a manager.
		 */
		public var manager:Manager;
		
		public function Context()
		{
			super();
		}
		
		/**
		 * Notifies this context that it is starting out. This should be
		 * used instead of listening to ADDED_TO_STAGE events, as the
		 * manager may add a context to the stage several times in one
		 * session.
		 */
		public function start():void
		{
			
		}
		
		/**
		 * Notifies the context that, while it is still active, it is 
		 * being hidden and won't be visible for a while.
		 */
		public function hidden():void
		{
			
		}
		
		/**
		 * Notifies the context that it is being shown again after
		 * previously being hidden.
		 */
		public function shown():void
		{
			
		}
		
		/**
		 * Notifies this context that it is ended and is being removed
		 * from the manager. This should be used rather than REMOVED_FROM_STAGE
		 * events, because the manager adds and removes contexts from the
		 * stage in many ways in one session.
		 */
		public function end():void
		{
			
		}
		
		/**
		 * This method should be overloaded to return how this context
		 * wants to be displayed. This should be constant throughout
		 * the life of the context, as it may be cached.
		 */
		public function getConfig():ContextConfig
		{
			return new ContextConfig();
		}
		
		/**
		 * Gets notified when a key down has occurred somewhere in the game.
		 * The context should not register to be notified of key events,
		 * instead allow them to be automatically handled by the manager.
		 * 
		 * If this method returns true, then the event will be considered
		 * to be handled (calling cancelDefault or stopPropagation on the
		 * event has no effect, as we're faking bubbling at this point).
		 * You can discriminate among different keypresses here: returning
		 * false for those you don't understand, and true for those you do.
		 */
		public function handleKeyDown(event:KeyboardEvent):Boolean
		{
			return false;			
		}
		
		/**
		 * Gets notified when a key up has occurred somewhere in the game.
		 * The context should not register to be notified of key events,
		 * instead allow them to be automatically handled by the manager.
		 * 
		 * If this method returns true, then the event will be considered
		 * to be handled (calling cancelDefault or stopPropagation on the
		 * event has no effect, as we're faking bubbling at this point).
		 */
		public function handleKeyUp(event:KeyboardEvent):Boolean
		{
			return false;
		}
		
		/**
		 * Gets notified when a frame update needs to occur. The context
		 * can take any frame-specific action it needs to at this point.
		 * If the function returns true, then the update is considered
		 * to be handled, and anything higher in the stack is not passed
		 * the update. This can be used to implement a pause-type
		 * function.
		 */
		public function update():Boolean
		{
			return false;
		}
	}
}