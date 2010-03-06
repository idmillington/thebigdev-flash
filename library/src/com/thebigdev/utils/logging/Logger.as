package com.thebigdev.utils.logging
{
	/**
	 * This class provides a logging system for outputting data about
	 * the running of the game.
	 */
	public class Logger
	{
		protected static var loggers:Object = {}
		
		public static function getLogger(name:String="root"):Logger
		{
			if (!(name in loggers)) {
				loggers[name] = new Logger(name, ConstructorGuard.guard);
			}
			return loggers[name];
		}
		
		public var name:String;
		public var parent:Logger;
		
		public function Logger(name:String, guard:ConstructorGuard)
		{
			this.name = name;
			
			// Find inheritance
			var lastDot:int = name.lastIndexOf("."); 	
			if (lastDot > 0) {
				var parentName:String = name.substr(0, lastDot);
				parent = getLogger(parentName);
			}
		}
		
		public static const DEBUG:int = -2;
		public static const INFO:int = -1;
		public static const WARNING:int = 0;
		public static const ERROR:int = 1;
		public static const CRITICAL:int = 2;
		
		public var outputLevel:int = ERROR; 
		
		public function configure(level:int):void
		{
			outputLevel = level;
		}
		
		
		// Logging at various levels.
		public function debug(msg:String):void
		{
			if (outputLevel <= DEBUG) {
				output("DEDUG", msg);
			}
		}
		 
		public function info(msg:String):void
		{
			if (outputLevel <= INFO) {
				output("INFO", msg);
			}		 	
		}
		
		public function warning(msg:String):void
		{
			if (outputLevel <= WARNING) {
				output("WARNING", msg);
			}		 				
		}
		
		public function error(msg:String):void
		{
			if (outputLevel <= ERROR) {
				output("ERROR", msg);
			}		 				
		}
		
		public function errorObject(error:Error):void
		{
			this.error(error.message);
		}
		
		public function critical(msg:String):void
		{
			if (outputLevel <= CRITICAL) {
				output("CRITICAL", msg);
			}
		}
		
		protected function output(type:String, msg:String):void
		{
			trace(name+"("+type+"): "+msg);
		}

	}
}

class ConstructorGuard
{
	public static var guard:ConstructorGuard = new ConstructorGuard();
}