//Inherit the parent event
event_inherited();

if(global.debug)
{
	draw_set_alpha(.5);
	
	draw_set_colour(c_lime);
	
	if(path_exists(caminho))
	{
		draw_path(caminho, 0, 0, true);
	}
	
	draw_set_colour(c_white);
	
	if(instance_exists(obj_player))
	{
		draw_line(
			x+sprite_width/2,
			y+sprite_height/2,
			obj_player.x+obj_player.sprite_width/2,
			obj_player.y+obj_player.sprite_height/2
		);
	}
	
	reseta_draw();
}