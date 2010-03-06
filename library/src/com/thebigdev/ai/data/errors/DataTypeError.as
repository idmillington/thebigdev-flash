package com.thebigdev.ai.data.errors
{
	import com.thebigdev.ai.data.Blackboard;
	
	/**
	 * An error to raise if a piece of data returned from the blackboard
	 * is not of the expected type.
	 */
	public class DataTypeError extends Error
	{
		public var blackboard:Blackboard;
		public var dataName:String;
		
		public function DataTypeError(
			blackboard:Blackboard, dataName:String, expectedTypeString:String
			)
		{
			this.blackboard = blackboard;
			this.dataName = dataName;
				
			var message:String = "Expected "+expectedTypeString+" from "+
				dataName + " on blackboard.";
				
			super(message, 0);
		}
		
	}
}