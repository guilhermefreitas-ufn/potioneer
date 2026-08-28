var _slot_tam = sprite_get_width(spr_slot_bolsa_ph);
var _margem_1 = sprite_get_width(spr_slot_bolsa_ph) * 2;
var _margem_2 = 4;

// ==========================================
// TAMANHO TOTAL DO CALDEIRÃO
// ==========================================

var _colunas_max = min(colunas, SLOTS_INVENTARIO);
var _linhas_max = ((SLOTS_INVENTARIO - 1) div colunas) + 1;


// ==========================================
// TAMANHO DOS SLOTS ÚTEIS
// ==========================================

var _colunas_ativas = min(colunas, slots_ativos);
var _linhas_ativas = ((slots_ativos - 1) div colunas) + 1;


// ==========================================
// DESENHANDO O FUNDO DO CALDEIRÃO
// SEMPRE NO TAMANHO MÁXIMO
// ==========================================

draw_sprite_stretched(
	spr_caldeirao_ph,
	0,
	x - _margem_1,
	y - _margem_1,
	(2 * _margem_1) + _colunas_max * (_slot_tam + _margem_2),
	(2 * _margem_1) + _linhas_max * (_slot_tam + _margem_2)
);


// ==========================================
// DESENHANDO SOMENTE OS SLOTS ATIVOS
// ==========================================

for(var i = 0; i < slots_ativos; i++)
{
	var _xx = x + (i mod colunas) * (_slot_tam + _margem_2) + 2;
	var _yy = y + (i div colunas) * (_slot_tam + _margem_2) + 2;
	
	var _hover = (obj_mouse.inventario_hover == id) 
		&& (obj_mouse.slot_hover == i);
	
	// desenhando o slot
	draw_sprite(spr_slot_caldeirao_ph, _hover, _xx, _yy);
	
	// desenhando o item
	if(inventario[i] != -1)
	{
		var _alpha = 1;
		
		if(obj_mouse.inventario_drag == id 
			&& obj_mouse.slot_drag == i)
		{
			_alpha = 0.5;
		}
		
		draw_set_alpha(_alpha);
		draw_sprite(SpriteIng(inventario[i]), 0, _xx, _yy);
		draw_set_alpha(1);
	}
}