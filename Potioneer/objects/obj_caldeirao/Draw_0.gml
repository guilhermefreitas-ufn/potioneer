//TAMANHO TOTAL DO CALDEIRÃO
var _colunas_max = min(colunas, SLOTS_CALDEIRAO);
var _linhas_max = ceil(SLOTS_CALDEIRAO / _colunas_max);


//DIMENSÕES DO SPRITE DO CALDEIRÃO
var _sprite_caldeirao = sprite_index;

var _largura_caldeirao = sprite_get_width(_sprite_caldeirao);
var _altura_caldeirao = sprite_get_height(_sprite_caldeirao);

var _origem_x_caldeirao = sprite_get_xoffset(_sprite_caldeirao);
var _origem_y_caldeirao = sprite_get_yoffset(_sprite_caldeirao);

//Posição do canto superior esquerdo do sprite
var _esquerda_caldeirao = x - _origem_x_caldeirao;
var _topo_caldeirao = y - _origem_y_caldeirao;


//DIMENSÕES DOS SLOTS
var _largura_slot = sprite_get_width(sprite_meu_slot);
var _altura_slot = sprite_get_height(sprite_meu_slot);

var _passo_x = _largura_slot + entre_slots;
var _passo_y = _altura_slot + entre_slots;


//DIMENSÕES TOTAIS DA GRADE
var _largura_grade =
	_colunas_max * _largura_slot +
	(_colunas_max - 1) * entre_slots;

var _altura_grade =
	_linhas_max * _altura_slot +
	(_linhas_max - 1) * entre_slots;


//CENTRALIZANDO A GRADE NO CALDEIRÃO
var _inicio_x =
	_esquerda_caldeirao + (_largura_caldeirao - _largura_grade) / 2;

var _inicio_y =
	_topo_caldeirao + (_altura_caldeirao - _altura_grade) / 2;


//DESENHANDO O FUNDO DO CALDEIRÃO
draw_self();


//DESENHANDO SOMENTE OS SLOTS ATIVOS
for(var i = 0; i < slots_ativos; i++)
{
	//Posição do canto superior esquerdo do slot
	var _slot_x = _inicio_x + (i mod colunas) * _passo_x;
	var _slot_y = _inicio_y + (i div colunas) * _passo_y;

	//Considerando a origem do sprite do slot
	var _xx = _slot_x + sprite_get_xoffset(sprite_meu_slot);
	var _yy = _slot_y + sprite_get_yoffset(sprite_meu_slot);

	var _hover = (obj_mouse.inventario_hover == id)
		&& (obj_mouse.slot_hover == i);

	//DESENHANDO O SLOT
	draw_sprite(sprite_meu_slot, _hover, _xx, _yy);


	//DESENHANDO O ITEM
	if(inventario[i] != -1)
	{
		var _alpha = 1;

		if(obj_mouse.inventario_drag == id && obj_mouse.slot_drag == i)
		{
			_alpha = 0.5;
		}

		var _sprite_item = global.Ingredientes[inventario[i]].sprite;
		var _escala_item = ESCALA_BASE;

		//Centraliza o item dentro do slot, considerando
		//as dimensões e a origem do sprite do ingrediente
		var _item_x =
			_slot_x + _largura_slot / 2
			- sprite_get_width(_sprite_item) * _escala_item / 2
			+ sprite_get_xoffset(_sprite_item) * _escala_item;

		var _item_y =
			_slot_y + _altura_slot / 2
			- sprite_get_height(_sprite_item) * _escala_item / 2
			+ sprite_get_yoffset(_sprite_item) * _escala_item;

		draw_sprite_ext(
			_sprite_item,
			-1,
			_item_x,
			_item_y,
			_escala_item,
			_escala_item,
			0,
			c_white,
			_alpha
		);
	}
}