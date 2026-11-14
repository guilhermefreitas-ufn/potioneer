//desenhando o fundo do inventario
draw_sprite_stretched(
	meu_sprite,
	0,
	x-espaco_borda,
	y-espaco_borda,
	(2*espaco_borda)+colunas*(slot_tam + entre_slots),
	(2*espaco_borda)+(((SLOTS_BOLSA-1) div colunas)+1)*(slot_tam + entre_slots)
);

//desenhando os slots e os itens
for(var i = 0; i < SLOTS_BOLSA; i++)
{
	var _xx = x + (i mod colunas) * (slot_tam + entre_slots) + 2;
	var _yy = y + (i div colunas) * (slot_tam + entre_slots) + 2;
	
	var _hover = (obj_mouse.inventario_hover == id) && (obj_mouse.slot_hover == i);
	
	//desenhando os slots
	draw_sprite(sprite_meu_slot, _hover, _xx, _yy);
	
	//desenhando os itens
	if(inventario[i] != -1)
	{
		var _alpha = 1;
		if(obj_mouse.inventario_drag == id) && (obj_mouse.slot_drag == i) { _alpha = .5; }
		draw_set_alpha(_alpha);
		//draw_sprite(SpriteIng(inventario[i]), 0, _xx, _yy);
		draw_sprite(global.Ingredientes[inventario[i]].sprite, 0, _xx, _yy);
		draw_set_alpha(1);
	}
}

//escrevendo NOME e VALOR do item depois para ficarem por cima
for(var i = 0; i < SLOTS_BOLSA; i++)
{
	var _xx = x + (i mod colunas) * (slot_tam + entre_slots) + 2;
	var _yy = y + (i div colunas) * (slot_tam + entre_slots) + 2;
	
	if(inventario[i] != -1)
	{
		var _ingrediente = global.Ingredientes[inventario[i]];
		
		var _meio_x_sprite =
			sprite_get_width(_ingrediente.sprite) / 2;
		
		var _meio_y_sprite =
			sprite_get_height(_ingrediente.sprite) / 2;
		
		var _margem = 0;
		
		//NOME DO ITEM
		var _nome = _ingrediente.nome;
		
		//INT mostra seu valor
		if(inventario[i] == INGREDIENTE_INT)
		{
			_nome += " " + string(valores[i]);
		}
		
		
		define_align();
		draw_set_font(fonte);
		
		
		draw_text_outline(
			_xx + _meio_x_sprite,
			_yy + (_meio_y_sprite * 2) + _margem,
			_nome,
			desc_cor,
			c_black,
			1,
			.33,
			.33,
			0,
			-1,
			-1
		);
		
		reseta_draw();
		
		//QUANTIDADE
		draw_text_outline(
			_xx - entre_slots,
			_yy + slot_tam - espaco_borda,
			string(quantidades[i]) + "x",
			desc_cor,
			c_black,
			1,
			.5,
			.5,
			0,
			-1,
			-1
		);
		
		reseta_draw();
	}
}