// Inherit the parent event
event_inherited();

if(room == rm_masmorra)
{
	if(mostrar_area)
	{
		draw_circle(
			mouse_x,
			mouse_y,
			raio_teste,
			true
		);
	}
	
	define_align();
	draw_set_alpha(.33);
	draw_set_font(fnt_placeholder_pequena);
	draw_text(mouse_x, mouse_y, "Área da poção.")
	draw_set_alpha(1);
	reseta_draw();
}