//DESCRIÇÃO DOS INGREDIENTES
if(obj_mouse.MouseSobreItem())
{
	var _inventario = obj_mouse.inventario_hover;
	var _slot = obj_mouse.slot_hover;
	
	var _item = _inventario.inventario[_slot];
	
	if(_item != -1)
	{
		//POSIÇÃO DA BOLSA
		var _inventario_esquerda = x - espaco_borda;
		var _inventario_topo = y - espaco_borda;
		
		//DIMENSÕES DA DESCRIÇÃO
		var _desc_altura = desc_margem_y * 5;
		
		//POSIÇÃO DA DESCRIÇÃO
		var _desc_x = _inventario_esquerda + desc_offset_x;
		var _desc_y =_inventario_topo - _desc_altura + desc_offset_y;
		
		//APRESENTA INGREDIENTE
		ApresentaDescricaoIngrediente(
			_item,
			_desc_x,
			_desc_y,
			fonte,
			c_black,
			desc_cor,
			0,
			1,
			_inventario.quantidades[_slot],
			_inventario.valores[_slot],
			desc_margem_x,
			desc_margem_y,
			raio_borda_desc,
			tag_tipo_padding_x,
			tag_tipo_padding_y,
			tag_tipo_raio,
			tag_tipo_espaco,
			cor_texto_tag_tipo
		);
	}
}