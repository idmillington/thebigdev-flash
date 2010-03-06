package com.thebigdev.framework.keyboard
{
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	/**
	 * Maps keyboard events to actions. This system allows the
	 * software to register the actions that it understands and allow the
	 * user to remap them (with a suitable UI).
	 */
	public class KeyMapper
	{
		protected var keyCodeLookup:Dictionary;
		protected var actionCodeLookup:Dictionary;
		
		public function KeyMapper()
		{
			keyCodeLookup = new Dictionary();
			actionCodeLookup = new Dictionary();
		}
				
		/**
		 * Returns a string that represents the binding to the given
		 * action code. This is suitable for display.
		 */
		public function getBinding(actionCode:uint):String
		{
			return actionCodeLookup[actionCode];
		}

		/**
		 * Registers or re-registers the given action code to the
		 * given key data.
		 */		
		public function registerKey(
			actionCode:uint, 
			keyCode:uint, shift:Boolean, ctrl:Boolean, alt:Boolean
			):void
		{
			var id:String = createKeyId(keyCode, shift, ctrl, alt);
			keyCodeLookup[id] = actionCode;
			actionCodeLookup[actionCode] = id;
		}

		/**
		 * Registers, or re-registers the given action code to the key
		 * press expressed by the given event. This can be used when 
		 * the user overrides the keybindings associated with an action.
		 */
		public function registerKeyEvent(
			actionCode:uint, event:KeyboardEvent
			):void
		{
			registerKey(
				actionCode, 
				event.keyCode, event.shiftKey, event.ctrlKey, event.altKey
				);
		}
		
		/**
		 * Maps the key press expressed in the given event into an 
		 * action for the action registered against that keypress.
		 */
		public function map(event:KeyboardEvent):uint
		{
			var id:String = createKeyId(
				event.keyCode, event.shiftKey, event.ctrlKey, event.altKey
				);
			return keyCodeLookup[id];
		}
		
		/** 
		 * Creates the unique id for a particular key press.
		 */
		private function createKeyId(
			keyCode:uint, shift:Boolean, ctrl:Boolean, alt:Boolean
			):String
		{
			return (shift?'Shift+':'') + (ctrl?'Ctrl+':'') + (alt?'Alt+':'') + 
				keyCode.toString();
		}
	}
}