extends TextureButton

var itemName;
var itemImg;

func _init(_itemName, _itemImg): 
	texture_normal = _itemImg
	self.itemName = _itemName
	self.itemImg = _itemImg
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
