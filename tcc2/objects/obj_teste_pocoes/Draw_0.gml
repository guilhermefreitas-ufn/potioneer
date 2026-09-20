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

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	draw_set_font(fnt_placeholder_media);

	draw_text(
		20,
		20,
		"POÇÃO 1 / 2"
	);

	draw_text(
		20,
		40,
		"Mouse = área da poção"
	);

	draw_text(
		20,
		60,
		"1 = poção 1"
	);

	draw_text(
		20,
		80,
		"2 = poção 2"
	);

	reseta_draw();
}