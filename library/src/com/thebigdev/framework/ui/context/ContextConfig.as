package com.thebigdev.framework.ui.context
{
	/**
	 * A struct-like class that holds data on how a context should
	 * be added to a display.
	 */
	public class ContextConfig
	{
		/**
		 * Set this to true if you want previous contexts to disappear.
		 * This should be false if your context doesn't fill the entire 
		 * screen.
		 */
		public var removePrevious:Boolean = false;

		/**
		 * If this is true then all execution updates stop at this context,
		 * none are passed higher up. This means that higher up contexts
		 * cannot do any updates, including animation (unless they 
		 * independently track the global FRAME_ENTER method, of course,
		 * which cannot be overridden). You may want to avoid this very
		 * simple timing system and roll your own Pause facility.
		 */
		public var pausePrevious:Boolean = false;
		
		/**
		 * Makes such that the previous items in the stack get no keypress
		 * information. This is usually not what you want (you can just
		 * override any particular keypress you don't want sent down), because
		 * you'll also be overriding keypresses for stopping music, for 
		 * example, or quitting the game. Still it may be useful in some 
		 * highly modal-ui cases.
		 */
		public var hideKeysFromPrevous:Boolean = false;

		/**
		 * If we're not removing the previous contexts, then we can
		 * optionally apply the given set of filters to them. This allows
		 * us to, e.g. blur and darken the main level while displaying a
		 * menu on top of it.
		 */
		public var filterPrevious:Array = [];
				
		public function ContextConfig()
		{
		}

	}
}