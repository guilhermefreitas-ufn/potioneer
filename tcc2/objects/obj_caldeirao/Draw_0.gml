var _slot_tam = sprite_get_width(spr_slot_bolsa_ph);
var _espaco_borda = sprite_get_width(spr_slot_bolsa_ph) * 2;
var _entre_slots = 4;

//TAMANHO TOTAL DO CALDEIRÃO
var _colunas_max = min(colunas, SLOTS_INVENTARIO);
var _linhas_max = ((SLOTS_INVENTARIO - 1) div colunas) + 1;

//TAMANHO DOS SLOTS ÚTEIS
var _colunas_ativas = min(colunas, slots_ativos);
var _linhas_ativas = ((slots_ativos - 1) div colunas) + 1;

//DESENHANDO O FUNDO DO CALDEIRÃO
draw_sprite_stretched(
	spr_caldeirao_ph,
	0,
	x - _espaco_borda,
	y - _espaco_borda,
	(2 * _espaco_borda) + _colunas_max * (_slot_tam + _entre_slots),
	(2 * _espaco_borda) + _linhas_max * (_slot_tam + _entre_slots)
);

//DESENHANDO SOMENTE OS SLOTS ATIVOS
for(var i = 0; i < slots_ativos; i++)
{
	var _xx = x + (i mod colunas) * (_slot_tam + _entre_slots) + 2;
	var _yy = y + (i div colunas) * (_slot_tam + _entre_slots) + 2;
	
	var _hover = (obj_mouse.inventario_hover == id) && (obj_mouse.slot_hover == i);
	
	//desenhando o slot
	draw_sprite(spr_slot_caldeirao_ph, _hover, _xx, _yy);
	
	//desenhando o item
	if(inventario[i] != -1)
	{
		var _alpha = 1;
		
		if(obj_mouse.inventario_drag == id && obj_mouse.slot_drag == i)
		{
			_alpha = 0.5;
		}
		
		draw_set_alpha(_alpha);
		//draw_sprite(SpriteIng(inventario[i]), 0, _xx, _yy);
		draw_sprite(global.Ingredientes[inventario[i]].sprite, 0, _xx, _yy);
		draw_set_alpha(1);
	}
}

//escrevendo as infos do item depois para ficarem por cima
for(var i = 0; i < slots_ativos; i++)
{
	var _xx = x + (i mod colunas) * (_slot_tam + _entre_slots) + 2;
	var _yy = y + (i div colunas) * (_slot_tam + _entre_slots) + 2;
	
	var _hover = (obj_mouse.inventario_hover == id) && (obj_mouse.slot_hover == i);
	
	//escrevendo as infos do item
	if(inventario[i] != -1)
	{
		var _meio_x_sprite = sprite_get_width(global.Ingredientes[inventario[i]].sprite) / 2;
		var _meio_y_sprite = sprite_get_height(global.Ingredientes[inventario[i]].sprite) / 2;
		var _margem = 0;
		
		define_align();
		draw_set_font(fnt_placeholder_media);
		draw_text_outline(_xx + _meio_x_sprite, _yy + (_meio_y_sprite * 2) + _margem, global.Ingredientes[inventario[i]].nome,c_white,c_black,1,.33,.33,0,-1,-1);
		reseta_draw();
	}
}