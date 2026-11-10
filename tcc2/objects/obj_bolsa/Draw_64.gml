if(obj_mouse.MouseSobreItem())
{
	var _inventario = obj_mouse.inventario_hover;
	var _slot = obj_mouse.slot_hover;
	
	var _item = _inventario.inventario[_slot];
	var _ing = global.Ingredientes[_item];
	
	define_align(0, 1);
	draw_set_font(fonte);
	
	//POSIÇÃO DA BOLSA
	var _inventario_esquerda = x - espaco_borda;
	
	var _inventario_topo = y - espaco_borda;
	
	//QUANTIDADE
	var _quantidade = _inventario.quantidades[_slot];
	
	//NOME DO ITEM
	var _nome = _ing.nome;

	if(_item == INGREDIENTE_INT)
	{
	    _nome += " " + string(_inventario.valores[_slot]);
	}

	var _texto_nome = _nome + " (" + string(_quantidade) + ")";


	//ELEMENTO / TOKEN
	var _texto_elemento =
	    "\"" + _ing.elemento + "\"" +
	    " (" + _ing.token + ")";


	//TIPO DO INGREDIENTE
	var _texto_tipo = TextoTipoIngrediente(_ing.tipo);


	//DIMENSÕES DA ETIQUETA
	var _tag_largura =
	    string_width(_texto_tipo) +
	    tag_tipo_padding_x * 2;

	var _tag_altura =
	    string_height(_texto_tipo) +
	    tag_tipo_padding_y * 2;


	//TAMANHO DA DESCRIÇÃO
	var _desc_largura =
	    max(
	        string_width(_texto_nome) + _tag_largura + tag_tipo_espaco,
	        string_width(_ing.descricao),
	        string_width(_texto_elemento)
	    )
	    + desc_margem_x * 2;


	//POSIÇÃO VERTICAL DOS TEXTOS
	var _linha_nome_y = desc_margem_y;

	var _linha_desc_y = desc_margem_y * 2.5;

	var _linha_elemento_y = desc_margem_y * 4;


	//ALTURA DA DESCRIÇÃO
	var _desc_altura = desc_margem_y * 5;


	//POSIÇÃO DA DESCRIÇÃO
	var _offset_x = 26;
	var _offset_y = 80;

	var _desc_x = _inventario_esquerda + _offset_x;

	var _desc_y =
	    _inventario_topo -
	    _desc_altura +
	    _offset_y;


	//FUNDO DA DESCRIÇÃO
	draw_set_colour(c_black);

	draw_roundrect_ext(
	    _desc_x,
	    _desc_y,
	    _desc_x + _desc_largura,
	    _desc_y + _desc_altura,
		raio_borda_desc,
		raio_borda_desc,
	    false
	);


	//TEXTOS
	draw_set_colour(desc_cor);

	draw_text(
	    _desc_x + desc_margem_x,
	    _desc_y + _linha_nome_y,
	    _texto_nome
	);

	draw_text(
	    _desc_x + desc_margem_x,
	    _desc_y + _linha_desc_y,
	    _ing.descricao
	);

	draw_text(
	    _desc_x + desc_margem_x,
	    _desc_y + _linha_elemento_y,
	    _texto_elemento
	);


	//ETIQUETA DO TIPO
	var _tag_x =
	    _desc_x + _desc_largura -
	    desc_margem_x -
	    _tag_largura;

	var _tag_y = _desc_y + _linha_nome_y
		- _tag_altura / 2;
	
	//COR DA ETIQUETA CONFORME O TIPO
	var _cor_tag_tipo = CorTipoIngrediente(_ing.tipo);


	//FUNDO ARREDONDADO
	draw_roundrect_colour_ext(
	    _tag_x,
	    _tag_y,
	    _tag_x + _tag_largura,
	    _tag_y + _tag_altura,
	    tag_tipo_raio,
	    tag_tipo_raio,
	    _cor_tag_tipo,
	    _cor_tag_tipo,
	    false
	);


	//TEXTO DA ETIQUETA
	draw_set_colour(cor_texto_tag_tipo);

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	draw_text(
	    _tag_x + _tag_largura / 2,
	    _tag_y + _tag_altura / 2,
	    _texto_tipo
	);

	reseta_draw();
}