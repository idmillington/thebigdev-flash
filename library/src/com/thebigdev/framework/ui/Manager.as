package com.thebigdev.framework.ui
{
	import caurina.transitions.Tweener;
	
	import com.thebigdev.framework.ui.context.Context;
	import com.thebigdev.framework.ui.context.ContextConfig;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	/**
	 *  The top level UI element in the framework. This isn't overloaded
	 * normally. Instead it holds a stack of context subclasses that provide
	 * the functionality.
	 */
	public class Manager extends Sprite
	{
		protected var contextStack:Array;
		protected var dataStack:Array;
		protected var configStack:Array;
		protected var dgStack:Array;
		
		/**
		 * Holds the main content being managed.
		 */
		protected var content:Sprite;
				
		public function Manager()
		{
			super();
			
			contextStack = [];
			dataStack = [];
			configStack = [];
			dgStack = [];
			
			registerLocalEvents();
		}
		
		/**
		 * Register any events that don't rely on having been added
		 * to the stage yet. I.e. those that listen to this object's
		 * event displatch.
		 */
		protected function registerLocalEvents():void
		{
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		/**
		 * Called when we're added to the stage. This is used to register
		 * any stage-specific events.
		 */
		protected function handleAddedToStage(event:Event):void
		{
			// All events registered with the stage should end their call
			// with 'true' for useWeakReference - to avoid the manager being
			// kept alive just by its event registrations.
			stage.addEventListener(
				Event.ENTER_FRAME, handleEnterFrame, false, 0, true
				);
			stage.addEventListener(
				KeyboardEvent.KEY_DOWN, handleKeyDown, false, 0, true
				);
			stage.addEventListener(
				KeyboardEvent.KEY_UP, handleKeyUp, false, 0, true
				);
		}
		
		/**
		 * Called each frome. Passes the update to the context stack, so
		 * they can update.
		 */
		protected function handleEnterFrame(event:Event):void
		{
			for (var i:int = contextStack.length-1; i >= 0; i--) 
			{
				var context:Context = contextStack[i] as Context;
				var config:ContextConfig = configStack[i] as ContextConfig;
				if (context.update() || config.pausePrevious) break;
			}
		}
		
		/**
		 * Handles the pressing of a key. To make sure that keypresses
		 * don't rely on (invisible) display object focus, these 
		 * are all handled globally.
		 */
		protected function handleKeyDown(event:KeyboardEvent):void
		{
			for (var i:int = contextStack.length-1; i >= 0; i--) 
			{
				var context:Context = contextStack[i] as Context;
				var config:ContextConfig = configStack[i] as ContextConfig;
				if (context.handleKeyDown(event) ||
					config.hideKeysFromPrevous) break;
			}			
		} 
		
		/**
		 * Handles the release of a key. To make sure that keypresses
		 * don't rely on (invisible) display object focus, these 
		 * are all handled globally.
		 */
		protected function handleKeyUp(event:KeyboardEvent):void
		{
			for (var i:int = contextStack.length-1; i >= 0; i--) 
			{
				var context:Context = contextStack[i] as Context;
				var config:ContextConfig = configStack[i] as ContextConfig;
				if (context.handleKeyUp(event) || 
					config.hideKeysFromPrevous) break;
			}						
		}
		
		/**
		 * Registers a piece of data that we can retrieve by name. Registering
		 * the data in this way allows us to not care about where in the
		 * stack is it defined, and to allow higher up data to  hide lower
		 * data. The optional given context allows us to associate the datum 
		 * with some specific context in the stack, otherwise it is 
		 * associated with the context on top of the stack.
		 */
		public function registerDatum(
			name:String, datum:Object, owner:Context=null
			):void
		{
			var index:int = 
				(owner === null)?
				contextStack.length-1:
				contextStack.lastIndexOf(owner);
				
			if (dataStack[index] === null) {
				dataStack[index][name] = datum;
			} else {
				var obj:Object = {};
				obj[name] = datum;
				dataStack[index] = obj;
			}
		}
		
		/**
		 * Returns the given named piece of data from the first context 
		 * that defines it (searching down from the top, or from the given
		 * context if we're not starting at the top). If no matching data
		 * is found, null is returned.
		 */
		public function getDatum(name:String, searchFrom:Context=null):Object
		{
			var index:int =
				(searchFrom === null)?
				contextStack.length - 1:
				contextStack.lastIndexOf(searchFrom);
				
			for (var i:int = index; i >= 0; i--) {
				if (dataStack[index] !== null && name in dataStack[index]) {
					
					return dataStack[index][name];
				}
			}
			return null;
		}
		
		/**
		 * Pushes a new context onto the end of the stack.
		 */
		public function pushContext(context:Context, commit:Boolean=true):void
		{
			var i:int;
			
			contextStack.push(context);
			dataStack.push(null);
			context.manager = this;
			
			// Find the display config.
			var config:ContextConfig = context.getConfig();
			configStack.push(config);
			
			// Create the display group.
			var dg:DisplayGroup;
			if 	(dgStack.length) {
				dg = dgStack[dgStack.length-1];
				dg = dg.createDisplayGroup(context, config);
			} else {
				dg = new DisplayGroup();
				dg.children = [context];
				dg.filters = [];
			}
			dgStack.push(dg);
			
			// Update the UI.
			if (commit) updateContent();
		}
		
		/**
		 * Updates the UI by asking the top element in the display
		 * group stack to create a sprite of content.
		 */
		private function updateContent():void
		{
			var next:DisplayGroup = dgStack[dgStack.length-1] as DisplayGroup; 
			var afterFade:Function = function():void {
				if (content !== null) {
					removeChild(content);	
				}
				content = next.createSprite();
				if (content !== null) {
					content.alpha = 0.0;
					addChild(content);
					Tweener.addTween(content, {alpha: 1.0, time:0.5});
				}
			};
		
			if (content !== null) {
				Tweener.addTween(
					content, {alpha: 0, time:0.25, onComplete:afterFade}
					);
			} else {
				afterFade();
			}
		}
		
		/**
		 * Removes the top context from the stack.
		 */
		public function popContext(commit:Boolean=true):void
		{
			contextStack.pop();
			dataStack.pop();
			configStack.pop();
			dgStack.pop();
			
			// Update the UI.
			if (commit) updateContent();
		}
		
		/**
		 * Pushes the given context after the given existing context
		 * in the stack, popping everything else that used to be
		 * above it.
		 */
		public function pushContextAfter(existing:Context, next:Context):void
		{
			var index:int = contextStack.lastIndexOf(existing);
			while (contextStack.length-1 > index) {
				popContext(false);
			}
			pushContext(next, false);
			
			updateContent();
		}
		
		/**
		 * Pops the given context, and anything above it, from the stack.
		 */
		public function popSpecificContext(context:Context):void
		{
			var index:int = contextStack.lastIndexOf(context);
			while (contextStack.length > index) {
				popContext(false);
			}		
			
			updateContent();
		}
		
		/**
		 * Replaces the given context in the stack with the given new
		 * context. Everything that used to be above the context in the stack
		 * is popped.
		 */
		public function replaceContext(existing:Context, next:Context):void
		{
			var index:int = contextStack.lastIndexOf(existing);
			while (contextStack.length > index) {
				popContext(false);
			}
			pushContext(next, false);
			
			updateContent();
		}
	}
}

import flash.display.Sprite;
import com.thebigdev.framework.ui.context.Context;
import com.thebigdev.framework.ui.context.ContextConfig;	

/**
 * Performs a shallow copy of the given array.
 */
function _arrayCopy(array:Array):Array
{
	var result:Array = [];
	for each (var object:Object in array) {
		result.push(object);
	}
	return result;
}

/**
 * This holds a series of contexts for display. It represents the state
 * of the display object list for one location in the stack.
 */
class DisplayGroup 
{
	/**
	 * Holds a list of filters to be assigned to this group.
	 */
	public var filters:Array;
	
	/**
	 * Holds a list of child display objects, which may be either 
	 * contexts or further display-groups.
	 */
	public var children:Array;

	/**
	 * Builds a sprite from the contents of this group.
	 */	
	public function createSprite():Sprite
	{
		var sprite:Sprite = new Sprite();
		
		// Add the children, in turn.
		for each (var object:Object in children) {
			if (object is Context) {
				var context:Context = object as Context;
				sprite.addChild(context);
			} else if (object is DisplayGroup) {
				var dg:DisplayGroup = object as DisplayGroup;
				sprite.addChild(dg.createSprite());
			} else {
				throw new Error(
					'Unknown type in the children of a display group.'
					);
			}
		}
		
		// Add the filters
		sprite.filters = filters;
		
		return sprite;
	}
	
	/**
	 * Builds a new display group from this display group and the given 
	 * context and config.
	 */
	public function createDisplayGroup(
		context:Context, config:ContextConfig
		):DisplayGroup
	{
		var dg:DisplayGroup = new DisplayGroup();
		dg.filters = [];

		if (config.removePrevious) {
			dg.children = [context];
		} else {
			// Create a copy of the current group.
			var current:DisplayGroup = new DisplayGroup();
			current.filters = _arrayCopy(this.filters);
			current.children = _arrayCopy(this.children);
						
			if (config.filterPrevious) {
				current.filters = config.filterPrevious;
				dg.children = [current, context];
			} else if (current.filters) {
				dg.children = [current, context];
			} else {
				current.children.push(context);
				dg.children = current.children;			
			}
		}
		return dg;
	}
}

