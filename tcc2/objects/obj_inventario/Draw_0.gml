
var _slot_tam = sprite_get_width(spr_slot_ph);
var _margem_1 = 6;
var _margem_2 = 4; //espaço entre slots

//desenhando o fundo do inventario
draw_sprite_stretched(
	spr_bag_ph,
	0,
	x-_margem_1,
	y-_margem_1,
	(2*_margem_1)+comp_linhas*(_slot_tam + _margem_2),
	(2*_margem_1)+(((SLOTS_INVENTARIO-1) div comp_linhas)+1)*(_slot_tam + _margem_2)
);

//desenhando os slots e os itens
for(var i = 0; i < SLOTS_INVENTARIO; i++)
{
	var _xx = x + (i mod comp_linhas) * (_slot_tam + _margem_2 + 2);
	var _yy = y + (i div comp_linhas) * (_slot_tam + _margem_2 + 2);
	
	//desenhando os slots
	draw_sprite(spr_slot_ph, 0, _xx, _yy);
	
	//desenhando os itens
	if(inventario[i] != -1)
	{
		draw_sprite(SpriteItens(inventario[i]), 0, _xx, _yy);
	}
}