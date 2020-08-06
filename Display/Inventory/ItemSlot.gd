extends Panel

var empty = true
var style
var subscript

func _init(): 
	rect_min_size = Vector2(16, 16)
	style = StyleBoxFlat.new()
	style.bg_color = Color("#8B7258")
	style.border_color = Color("#534434")
	style.set_border_width_all(1)
	set('custom_styles/panel', style)
	
func fillSlot(newItem, itemAmount): 
	empty = false
	add_child(newItem)
	if itemAmount != -1: 		
		subscript = Label.new()
		subscript.set_text(str(itemAmount))
	
		var dynamic_font = DynamicFont.new()
		dynamic_font.font_data = load("res://Display/Handlee-Regular.ttf")
		dynamic_font.size = 8
		dynamic_font.outline_size = 0
		subscript.rect_size.x = 14
		subscript.rect_size.y = 16
		subscript.align = Label.ALIGN_RIGHT
		subscript.valign = Label.VALIGN_BOTTOM
		subscript.add_font_override("font", dynamic_font)
		subscript.add_color_override("font_color", Color.green)
		set('custom_styles/label', subscript)
		add_child(subscript)

