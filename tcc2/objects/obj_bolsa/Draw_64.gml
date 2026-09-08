if(obj_mouse.MouseSobreItem())
{
	var _inventario = obj_mouse.inventario_hover;
	var _slot = obj_mouse.slot_hover;
	
	var _item = _inventario.inventario[_slot];
	var _ing = global.Ingredientes[_item];
	
	define_align(0, 1);
	draw_set_font(fonte);
	
	
	//========================================
	// POSIÇÃO DA BOLSA
	//========================================
	
	var _inventario_esquerda =
		x - espaco_borda;
	
	var _inventario_topo =
		y - espaco_borda;
	
	
	//========================================
	// QUANTIDADE
	//========================================
	
	var _quantidade =
		_inventario.quantidades[_slot];
	
	
	//========================================
	// NOME DO ITEM
	//========================================
	
	var _nome = _ing.nome;
	
	if(_item == INGREDIENTE_INT)
	{
		_nome += " " + string(
			_inventario.valores[_slot]
		);
	}
	
	
	var _texto_nome =
		_nome + " (" + string(_quantidade) + ")";
	
	
	//========================================
	// ELEMENTO / TOKEN
	//========================================
	
	var _texto_elemento =
		"\"" + _ing.elemento + "\"" +
		" (" + _ing.token + ")";
	
	
	//========================================
	// TAMANHO DA DESCRIÇÃO
	//========================================
	
	var _desc_largura =
		max(
			string_width(_texto_nome),
			string_width(_ing.descricao),
			string_width(_texto_elemento)
		)
		+ desc_margem_x * 2;
	
	var _desc_altura =
		desc_margem_y * 5;
	
	
	//========================================
	// POSIÇÃO DA DESCRIÇÃO
	//========================================
	
	var _offset_x = 26;
	var _offset_y = 80;
	
	var _desc_x =
		_inventario_esquerda + _offset_x;
	
	var _desc_y =
		_inventario_topo -
		_desc_altura +
		_offset_y;
	
	
	//========================================
	// FUNDO
	//========================================
	
	draw_set_colour(c_black);
	
	draw_rectangle(
		_desc_x,
		_desc_y,
		_desc_x + _desc_largura,
		_desc_y + _desc_altura,
		false
	);
	
	
	//========================================
	// TEXTO
	//========================================
	
	draw_set_colour(desc_cor);
	
	draw_text(
		_desc_x + desc_margem_x,
		_desc_y + desc_margem_y,
		_texto_nome
	);
	
	draw_text(
		_desc_x + desc_margem_x,
		_desc_y + desc_margem_y * 2.5,
		_ing.descricao
	);
	
	draw_text(
		_desc_x + desc_margem_x,
		_desc_y + desc_margem_y * 4,
		_texto_elemento
	);
	
	reseta_draw();
}