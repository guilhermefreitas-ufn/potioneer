// Inherit the parent event
event_inherited();

if(estado == "perseguindo")
{
	//draw_path(caminho,x, y, true);
}

if(global.debug && instance_exists(obj_player))
{
	draw_line(x+sprite_width/2,y+sprite_height/2,obj_player.x+obj_player.sprite_width/2,obj_player.y+obj_player.sprite_height/2);
}