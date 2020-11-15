package {
	import flash.utils.describeType;

	public class StringUtilities {
		public static function InitEnumConstants(inType:*) {
			var type:XML = flash.utils.describeType(inType);
			for each (var constant:XML in type.constant) {
				inType[constant.@name].Text = constant.@name;
			}
		}
	}
}