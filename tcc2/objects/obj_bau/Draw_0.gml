DesenhaSombra();

draw_self();

if(especial && global.debug)
{
	draw_set_colour(c_aqua);
	draw_line(x,y,obj_player.x,obj_player.y);
	draw_set_colour(-1);
}