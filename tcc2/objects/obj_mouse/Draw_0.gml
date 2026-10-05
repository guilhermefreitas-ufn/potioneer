
//SPRITE DO DRAG
if(item_drag != -1)
{
	draw_set_alpha(.5);
	
	draw_sprite(
		global.Ingredientes[item_drag].sprite,
		0,
		mouse_x,
		mouse_y
	);
	
	draw_set_alpha(1);
}

//SPRITE DA POÇÃO SENDO ARRASTADA
if(!is_undefined(pocao_drag))
{
	draw_set_alpha(0.5);
	
	
	if(!is_undefined(pocao_drag.sprite))
	{
		draw_sprite_ext(
			pocao_drag.sprite,
			0,
			mouse_x,
			mouse_y,
			1,
			1,
			0,
			pocao_drag.cor,
			1
		);
	}
	else
	{
		draw_set_colour(
			pocao_drag.cor
		);
		
		draw_circle(
			mouse_x,
			mouse_y,
			slot_tam / 4,
			true
		);
		
		draw_set_colour(c_white);
	}
	
	
	draw_set_alpha(1);
}

//ANIMAÇÃO DO CLICK
if(click_animando && click_anim_item != -1)
{
	var _t = click_anim_tempo / click_anim_duracao;
	
	var _xx = lerp(
		click_anim_x,
		click_anim_dest_x,
		_t
	);
	
	var _yy = lerp(
		click_anim_y,
		click_anim_dest_y,
		_t
	);
	
	draw_set_alpha(0.5);
	
	draw_sprite(
		global.Ingredientes[click_anim_item].sprite,
		0,
		_xx,
		_yy
	);
	
	draw_set_alpha(1);
}