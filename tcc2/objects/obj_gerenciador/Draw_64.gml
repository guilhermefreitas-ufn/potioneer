if(global.debug)
{
	define_align(0,1);
	draw_set_colour(c_blue);
	draw_text(20, RES_H - 20, "debug");
	reseta_draw();
	
	// =====================================================
	// DESENHANDO OS BOTÕES
	// =====================================================

	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	for(var i = 0; i < botoes_qtd; i++)
	{
		var _bx = botao_x + i * (botao_largura + botao_espaco);
		var _by = botao_y;

		// mouse sobre o botão?
		var _sobre = point_in_rectangle(
			_mx,
			_my,
			_bx,
			_by,
			_bx + botao_largura,
			_by + botao_altura
		);


		// =================================================
		// FUNDO
		// =================================================

		if(_sobre)
		{
			draw_set_color(c_ltgray);
		}
		else
		{
			draw_set_color(c_dkgray);
		}

		draw_rectangle(
			_bx,
			_by,
			_bx + botao_largura,
			_by + botao_altura,
			false
		);


		// =================================================
		// BORDA
		// =================================================

		draw_set_color(c_black);

		draw_rectangle(
			_bx,
			_by,
			_bx + botao_largura,
			_by + botao_altura,
			true
		);


		// =================================================
		// TEXTO
		// =================================================

		draw_set_color(c_white);
		//draw_set_halign(fa_center);
		var _texto = botoes_texto[i];

		var _texto_largura = string_width(_texto);
		var _texto_altura = string_height(_texto);
		
		draw_text(
			_bx + (botao_largura - _texto_largura) / 2,
			_by + (botao_altura - _texto_altura) / 2,
			_texto
		);
	}


	// resetando alinhamentos
	reseta_draw();
}