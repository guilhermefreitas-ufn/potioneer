var _pos = MundoParaGUI(x, y);

if(!is_undefined(_pos))
{
	//ALPHA DA MENSAGEM
	var _alpha = clamp(
		1 - tempo / duracao,
		0,
		1
	);
	
	//DESLOCAMENTO DA SOMBRA
	var _sombra_x = _pos.escala_x;
	var _sombra_y = _pos.escala_y;
	
	//CONFIGURAÇÕES DO TEXTO
	draw_set_font(fnt_placeholder_pequena);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_alpha(_alpha);
	
	//SOMBRA
	draw_set_colour(c_black);
	
	draw_text_ext_transformed(
		_pos.x + _sombra_x,
		_pos.y + _sombra_y,
		texto,
		-1,
		largura_maxima,
		_pos.escala_x,
		_pos.escala_y,
		0
	);
	
	//TEXTO
	draw_set_colour(cor);
	
	draw_text_ext_transformed(
		_pos.x,
		_pos.y,
		texto,
		-1,
		largura_maxima,
		_pos.escala_x,
		_pos.escala_y,
		0
	);
	
	//RESTAURA O ESTADO DE DESENHO
	reseta_draw();
}