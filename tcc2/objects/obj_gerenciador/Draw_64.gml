if(global.debug)
{
	//debug
	define_align();
	draw_set_colour(c_blue);
	draw_text(RES_W - 60, 40, "debug");
	reseta_draw();
	
	if(room == rm_inventarios)
	{
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


			// =====================================================
			// TEXTO
			// =====================================================

			draw_set_font(-1);
			draw_set_halign(fa_left);
			draw_set_valign(fa_top);
			draw_set_color(c_white);

			var _texto = botoes_texto[i];

			var _texto_largura = string_width(_texto);
			var _offset_y = 6;

			draw_text(
				_bx + (botao_largura - _texto_largura) / 2,
				_by + _offset_y,
				_texto
			);
		}
	}
	if(room == rm_masmorra)
	{
		define_align();
		draw_set_font(fnt_placeholder_media);
		draw_text(RES_W/2, 40, "Aperte ESPAÇO para voltar a cração de poções.")
	}

	// resetando alinhamentos
	reseta_draw();
}

if(room == rm_inventarios)
{
	// =====================================================
	// BOTÃO MASMORRA
	// =====================================================

	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _x = botao_masmorra_margem;
	var _y = display_get_gui_height()
			- botao_masmorra_altura
			- botao_masmorra_margem;

	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	var _hover = point_in_rectangle(
		_mx,
		_my,
		_x,
		_y,
		_x + botao_masmorra_largura,
		_y + botao_masmorra_altura
	);


	// =====================================================
	// FUNDO
	// =====================================================

	if(_hover)
	{
		draw_set_color(c_ltgray);
	}
	else
	{
		draw_set_color(c_dkgray);
	}

	draw_rectangle(
		_x,
		_y,
		_x + botao_masmorra_largura,
		_y + botao_masmorra_altura,
		false
	);


	// =====================================================
	// BORDA
	// =====================================================

	draw_set_color(c_black);

	draw_rectangle(
		_x,
		_y,
		_x + botao_masmorra_largura,
		_y + botao_masmorra_altura,
		true
	);


	// =====================================================
	// TEXTO
	// =====================================================

	draw_set_color(c_white);

	var _texto = "EXPLORAR MASMORRA";
	var _texto_largura = string_width(_texto);
	var _offset_y = 6;

	draw_text(
		_x + (botao_masmorra_largura - _texto_largura) / 2,
		_y + _offset_y,
		_texto
	);


	reseta_draw();
}
