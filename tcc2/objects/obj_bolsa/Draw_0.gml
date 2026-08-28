
var _slot_tam = sprite_get_width(spr_slot_bolsa_ph);
var _margem_1 = 6;
var _margem_2 = 4; //espaço entre slots

//desenhando o fundo do inventario
draw_sprite_stretched(
	spr_bolsa_ph,
	0,
	x-_margem_1,
	y-_margem_1,
	(2*_margem_1)+colunas*(_slot_tam + _margem_2),
	(2*_margem_1)+(((SLOTS_INVENTARIO-1) div colunas)+1)*(_slot_tam + _margem_2)
);

//desenhando os slots e os itens
for(var i = 0; i < SLOTS_INVENTARIO; i++)
{
	var _xx = x + (i mod colunas) * (_slot_tam + _margem_2) + 2;
	var _yy = y + (i div colunas) * (_slot_tam + _margem_2) + 2;
	
	var _hover = (obj_mouse.inventario_hover == id) && (obj_mouse.slot_hover == i);
	
	//desenhando os slots
	draw_sprite(spr_slot_bolsa_ph, +_hover, _xx, _yy);
	
	//desenhando os itens
	if(inventario[i] != -1)
	{
		var _alpha = 1;
		if(obj_mouse.inventario_drag == id) && (obj_mouse.slot_drag == i) { _alpha = .5; }
		draw_set_alpha(_alpha);
		draw_sprite(SpriteIng(inventario[i]), 0, _xx, _yy);
		draw_set_alpha(1);
	}
}