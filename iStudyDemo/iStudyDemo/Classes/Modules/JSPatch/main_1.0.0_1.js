require('UIAlertAction')

defineClass("UIAlertAction",{},{
	actionWithTitle_style_handler:function(cancelTitle,style,handler) {
		if (cancelTitle) {
			var tempBlock = block('UIAlertAction*',function(alertAction){
				handler(alertAction);
			});
			return UIAlertAction.ORIGactionWithTitle_style_handler(cancelTitle,style,tempBlock);
		} else {
			return null;
		}
	}
});

require('UIAlertController')

defineClass("UIAlertController",{
	addAction:function(action){
		if (action) {
			self.ORIGaddAction(action);
		};
	}
},{});