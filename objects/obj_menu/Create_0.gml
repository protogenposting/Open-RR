draw_set_font(fn_font)

draw_set_halign(fa_center)

draw_set_valign(fa_middle)

font_enable_effects(fn_font,true,{
    outlineEnable: true,
    outlineDistance: 2,
    outlineColour: c_black
})

menuContainer = new MenuContainer()

menuContainer.AddButton(
	"New Run",
	spr_button,
	{x: screenWidth/2,y: screenHeight/2},
	{x:128,y:64},
	function(){
		var _inst = instance_create_depth(0,0,depth-1000,obj_transition)
		_inst.roomToGoTo = rm_character_select
		audio_play_sound(snd_select,1000,false)
	}
)