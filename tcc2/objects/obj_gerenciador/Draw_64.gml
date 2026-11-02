if(room == rm_inventarios || room == rm_armario)
{
	//BOTÃO ARSENAL
	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _x = botao_armario_margem;
	var _y = display_get_gui_height()
			- botao_armario_altura
			- botao_armario_margem;

	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	var _hover = point_in_rectangle(
		_mx,
		_my,
		_x,
		_y,
		_x + botao_armario_largura,
		_y + botao_armario_altura
	);
	
	//FUNDO
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
		_x + botao_armario_largura,
		_y + botao_armario_altura,
		false
	);
	
	//BORDA
	draw_set_color(c_black);

	draw_rectangle(
		_x,
		_y,
		_x + botao_armario_largura,
		_y + botao_armario_altura,
		true
	);

	//TEXTO
	draw_set_color(c_white);

	var _texto = "ARMARIO DE POCOES";
	if(room == rm_armario) { _texto = "VOLTAR AO CALDEIRAO"; }
	var _texto_largura = string_width(_texto);
	var _offset_y = 6;

	draw_text(
		_x + (botao_armario_largura - _texto_largura) / 2,
		_y + _offset_y,
		_texto
	);

	reseta_draw();
}

if(room == rm_armario)
{
	//BOTÃO MASMORRA
	var _x =
		RES_W
		- botao_masmorra_largura
		- botao_masmorra_margem;

	var _y =
		RES_H
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

	//FUNDO
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

	//BORDA
	draw_set_color(c_black);

	draw_rectangle(
		_x,
		_y,
		_x + botao_masmorra_largura,
		_y + botao_masmorra_altura,
		true
	);
	
	//TEXTO
	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
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

if(room != rm_inventarios)
{
	define_align();
	draw_set_colour(c_black);
	draw_set_font(fnt_placeholder_media);
	draw_text(RES_W/2, 20, "Aperte \"-\" para voltar ao Caldeirão.")
	reseta_draw();
}

if(room == rm_masmorra)
{
	var _bau_num = 0;
	var _inimigo_num = 0;
	
	if(instance_exists(obj_bau))
	{
		_bau_num = instance_number(obj_bau);
	}
	
	if(instance_exists(obj_inimigo_pai))
	{
		_inimigo_num = instance_number(obj_inimigo_pai);
	}
	
	define_align();
	draw_set_font(fnt_placeholder_media);
	
	draw_text_outline(RES_W / 2, 40, "Inimigos restantes: "+string(_inimigo_num),c_white,c_black,1);
	draw_text_outline(RES_W / 2, 60, "Baús restantes: "+string(_bau_num),c_white,c_black,1);
	draw_text_outline(RES_W / 2, 80, "FASE "+string(global.fase),c_white,c_black,1);
	
	reseta_draw();
}

if(global.debug)
{
	//debug
	define_align();
	draw_set_colour(c_blue);
	draw_text(RES_W - 60, 40, "debug");
	reseta_draw();
	
	//poções
	draw_text(RES_W - 96, RES_H / 7 - 24, "ARMARIO:");

	for(var i = 0; i < array_length(global.DadosJogador.armario_pocoes); i++)
	{
	    var _pocao = global.DadosJogador.armario_pocoes[i];

	    if(is_struct(_pocao))
	    {
	        draw_text(
	            RES_W - 96,
	            RES_H / 7 + i * 16,
	            string(_pocao.nome)
	        );
	    }
	    else
	    {
	        draw_text(
	            RES_W - 96,
	            RES_H / 7 + i * 16,
	            "VAZIO"
	        );
	    }
	}


	//hotbar
	draw_text(RES_W - 192, RES_H / 7 - 24, "HOTBAR:");

	for(var i = 0; i < array_length(global.DadosJogador.hotbar_pocoes); i++)
	{
	    var _pocao = global.DadosJogador.hotbar_pocoes[i];

	    if(is_struct(_pocao))
	    {
	        draw_text(
	            RES_W - 192,
	            RES_H / 7 + i * 16,
	            string(_pocao.nome)
	        );
	    }
	    else
	    {
	        draw_text(
	            RES_W - 192,
	            RES_H / 7 + i * 16,
	            "VAZIO"
	        );
	    }
	}
	
	if(room == rm_inventarios)
	{
		//DESENHANDO OS BOTÕES
		var _mx = device_mouse_x_to_gui(0);
		var _my = device_mouse_y_to_gui(0);
	
		for(var i = 0; i < botoes_qtd; i++)
		{
			var _bx = botao_x + i * (botao_largura + botao_espaco);
			var _by = botao_y;

			//mouse sobre o botão?
			var _sobre = point_in_rectangle(
				_mx,
				_my,
				_bx,
				_by,
				_bx + botao_largura,
				_by + botao_altura
			);
			
			//FUNDO
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
			
			//BORDA
			draw_set_color(c_black);

			draw_rectangle(
				_bx,
				_by,
				_bx + botao_largura,
				_by + botao_altura,
				true
			);
			
			//TEXTO
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

	//resetando alinhamentos
	reseta_draw();
}