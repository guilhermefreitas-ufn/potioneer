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
		
		define_align();
		draw_set_font(fnt_placeholder_pequena);
		draw_text(mouse_x, mouse_y, "Área da poção.")
		reseta_draw();
	}

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	draw_set_font(fnt_placeholder_pequena);

	draw_text(
		20,
		20,
		"POÇÕES"
	);

	var _y_pocoes = 40;
	var _largura_texto = 128;
	var _espaco = 4;

	for(var i = 0; i < SLOTS_HOTBAR_POCOES; i++)
	{
		var _pocao =global.DadosJogador.hotbar_pocoes[i];
		
		var _texto;

		if(is_undefined(_pocao))
		{
			_texto = string(i + 1) + " = [VAZIO]";
		}
		else
		{
			_texto =
				string(i + 1)
				+ " = "
				+ _pocao.sentenca;
		}

		// desenha a sentença na posição atual
		draw_text_ext(
			20,
			_y_pocoes,
			_texto,
			-1,
			_largura_texto
		);

		// calcula a altura que essa sentença ocupou
		var _altura_texto = string_height_ext(
			_texto,
			-1,
			_largura_texto
		);

		// próxima sentença começa depois da anterior
		_y_pocoes += _altura_texto + _espaco;
	}

	reseta_draw();
}