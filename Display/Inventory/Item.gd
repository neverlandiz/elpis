extends TextureButton

var itemName;
var itemImg;
var itemAmount;

func _init(_itemName, _itemImg, _itemAmount): 
	texture_normal = _itemImg
	self.itemName = _itemName
	self.itemImg = _itemImg
	self.itemAmount = _itemAmount
	mouse_filter = Control.MOUSE_FILTER_PASS
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
