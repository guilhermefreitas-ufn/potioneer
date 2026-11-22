//debug
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
	else
	{
		define_align();
		draw_set_colour(c_black);
		draw_set_font(fnt_placeholder_media);
		draw_text(RES_W/2, 20, "Aperte \"-\" para voltar ao Caldeirão.")
		reseta_draw();
	}

	//resetando alinhamentos
	reseta_draw();
}

//desenhando botão de "Como Jogar"
//nas rooms: armário, inventários e masmorra
if(room == rm_inventarios || room == rm_armario || room == rm_masmorra)
{
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	
	var _botao_raio = 16;
	var _margem = 32;
	
	var _x = RES_W - _margem;
	var _y = _margem;

	var _hover = point_in_circle(
		_mx,
		_my,
		_x,
		_y,
		_botao_raio
	);
	
	if(_hover)
	{
		draw_set_colour(c_ltgray);
	}
	else
	{
		draw_set_colour(c_dkgray);
	}
	
	draw_circle(
		_x,
		_y,
		_botao_raio,
		false
	);
	
	draw_set_colour(c_black);
	
	draw_circle(
		_x,
		_y,
		_botao_raio,
		true
	);
	
	draw_set_colour(c_white);
	draw_set_font(fnt_media_black);
	define_align();
	
	draw_text(
		RES_W - 32,
		32,
		"?"
	);
	
	reseta_draw();
}

if(global.pause) { exit; }

//botões
if(room == rm_inventarios || room == rm_armario)
{
	//BOTÃO ARSENAL
	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	var _x = botao_margem;
	var _y = RES_H
			- botao_altura
			- botao_margem;

	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	var _hover = point_in_rectangle(
		_mx,
		_my,
		_x,
		_y,
		_x + botao_largura,
		_y + botao_altura
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
		_x + botao_largura,
		_y + botao_altura,
		false
	);
	
	//BORDA
	draw_set_color(c_black);

	draw_rectangle(
		_x,
		_y,
		_x + botao_largura,
		_y + botao_altura,
		true
	);

	//TEXTO
	draw_set_color(c_white);
	draw_set_font(fnt_media_black);

	var _texto = "ARMÁRIO DE POÇÕES";
	if(room == rm_armario) { _texto = "VOLTAR AO CALDEIRÃO"; }
	var _texto_largura = string_width(_texto);
	var _offset_y = 6;

	draw_text(
		_x + (botao_largura - _texto_largura) / 2,
		_y + _offset_y,
		_texto
	);

	reseta_draw();
	
	//BOTÃO MASMORRA
	var _x2 =
		RES_W
		- botao_largura
		- botao_margem;

	var _y2 =
		RES_H
		- botao_altura
		- botao_margem;

	var _mx2 = device_mouse_x_to_gui(0);
	var _my2 = device_mouse_y_to_gui(0);
	
	if(room == rm_inventarios)
	{
		_x2 = 2 * botao_margem + botao_largura;
		_y2 = RES_H
			- botao_altura
			- botao_margem;

		_mx2 = device_mouse_x_to_gui(0);
		_my2 = device_mouse_y_to_gui(0);
	}
	
	var _hover2 = point_in_rectangle(
		_mx2,
		_my2,
		_x2,
		_y2,
		_x2 + botao_largura,
		_y2 + botao_altura
	);

	//FUNDO
	if(_hover2)
	{
		draw_set_color(c_yellow);
	}
	else
	{
		draw_set_color(c_olive);
	}

	draw_rectangle(
		_x2,
		_y2,
		_x2 + botao_largura,
		_y2 + botao_altura,
		false
	);

	//BORDA
	draw_set_color(c_black);

	draw_rectangle(
		_x2,
		_y2,
		_x2 + botao_largura,
		_y2 + botao_altura,
		true
	);

	//TEXTO
	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_font(fnt_media_black);

	var _texto2 = "EXPLORAR MASMORRA";
	var _texto_largura2 = string_width(_texto2);
	var _offset_y2 = 6;

	draw_text(
		_x2 + (botao_largura - _texto_largura2) / 2,
		_y2 + _offset_y2,
		_texto2
	);
	
	reseta_draw();
	
	//BOTÃO SAIR
	var _x3 = 3 * botao_margem + botao_largura * 2;
	var _y3 = RES_H - botao_altura - botao_margem;

	var _mx3 = device_mouse_x_to_gui(0);
	var _my3 = device_mouse_y_to_gui(0);
	
	if(room == rm_armario)
	{
		_x3 =
			RES_W
			- botao_largura * 2
			- botao_margem * 2;

		_y3 =
			RES_H
			- botao_altura
			- botao_margem;
	}
	
	var _hover3 = point_in_rectangle(
		_mx3,
		_my3,
		_x3,
		_y3,
		_x3 + botao_largura,
		_y3 + botao_altura
	);

	//FUNDO
	if(_hover3)
	{
		draw_set_color(c_ltgrey);
	}
	else
	{
		draw_set_color(c_dkgray);
	}

	draw_rectangle(
		_x3,
		_y3,
		_x3 + botao_largura,
		_y3 + botao_altura,
		false
	);

	//BORDA
	draw_set_color(c_black);

	draw_rectangle(
		_x3,
		_y3,
		_x3 + botao_largura,
		_y3 + botao_altura,
		true
	);

	//TEXTO
	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_color(c_white);
	draw_set_font(fnt_media_black);

	var _texto3 = "MENU";
	var _texto_largura3 = string_width(_texto3);
	var _offset_y3 = 6;

	draw_text(
		_x3 + (botao_largura - _texto_largura3) / 2,
		_y3 + _offset_y3,
		_texto3
	);
	
	reseta_draw();
}

//masmorra
if(room == rm_masmorra)
{
	var _bau_num = 0;
	var _inimigo_num = 0;
	var _texto = "Subsolo "+string(global.fase);
	var _bau_especial = 0;
	
	if(instance_exists(obj_bau))
	{
		with(obj_bau)
		{
			if(especial)
			{
				_bau_especial += 1;
			}
		}
		
		_bau_num = (instance_number(obj_bau) - _bau_especial > 0)
		? instance_number(obj_bau) - _bau_especial
		: 0;
	}
	
	if(instance_exists(obj_inimigo_pai))
	{
		_inimigo_num = instance_number(obj_inimigo_pai);
	}
	
	if(global.fase == 0)
	{
		_texto = "Térreo";
	}
	
	var _yy = 0;
	
	define_align();
	draw_set_font(fnt_placeholder_media);
	
	draw_text_outline(RES_W / 2, 40, "Inimigos restantes: "+string(_inimigo_num), c_white, c_black,2);
	draw_text_outline(RES_W / 2, 60, "Baús restantes: "+string(_bau_num), c_white, c_black,2);
	draw_text_outline(RES_W / 2, 80, "Ingredientes finais: "+string(global.ing_finais_coletados)+"/5", c_white, c_black,2);
	
	if(_bau_especial > 0)
	{
		_yy = 20;
		
		draw_text_outline(RES_W / 2, 100, "Baús especiais: "+string(_bau_especial), c_aqua, c_teal,2);
	}
	
	draw_text_outline(RES_W / 2, 100 + _yy, _texto, c_white, c_black,2);
	
	reseta_draw();
}