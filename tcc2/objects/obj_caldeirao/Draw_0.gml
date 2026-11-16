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

////TAMANHO TOTAL DO CALDEIRÃO
//var _colunas_max = min(colunas, SLOTS_CALDEIRAO);
//var _linhas_max = ((SLOTS_CALDEIRAO - 1) div colunas) + 1;

////TAMANHO DOS SLOTS ÚTEIS
//var _colunas_ativas = min(colunas, slots_ativos);
//var _linhas_ativas = ((slots_ativos - 1) div colunas) + 1;


////TAMANHO QUADRADO DO CALDEIRÃO
//var _largura_calculada =
//	(2 * espaco_borda) + _colunas_max * (slot_tam + entre_slots);

//var _altura_calculada =
//	(2 * espaco_borda) + _linhas_max * (slot_tam + entre_slots);

////pega o maior dos dois
//var _tamanho_caldeirao = max(_largura_calculada, _altura_calculada);

////DESENHANDO O FUNDO DO CALDEIRÃO
////draw_sprite_stretched(
////	meu_sprite,
////	0,
////	x - espaco_borda,
////	y - espaco_borda,
////	_tamanho_caldeirao,
////	_tamanho_caldeirao
////);

//draw_self();

////DESENHANDO SOMENTE OS SLOTS ATIVOS
//for(var i = 0; i < slots_ativos; i++)
//{
//	var _xx = x + (i mod colunas) * (slot_tam + entre_slots) + 2;
//	var _yy = y + (i div colunas) * (slot_tam + entre_slots) + 2 + slot_tam / 2;
	
//	var _hover = (obj_mouse.inventario_hover == id) && (obj_mouse.slot_hover == i);
	
//	//desenhando o slot
//	draw_sprite(sprite_meu_slot, _hover, _xx, _yy);
	
//	//desenhando o item
//	if(inventario[i] != -1)
//	{
//		var _alpha = 1;
		
//		if(obj_mouse.inventario_drag == id && obj_mouse.slot_drag == i)
//		{
//			_alpha = 0.5;
//		}
		
//		draw_set_alpha(_alpha);
//		draw_sprite_ext(
//			global.Ingredientes[inventario[i]].sprite,
//			-1,
//			_xx,
//			_yy,
//			ESCALA_BASE,
//			ESCALA_BASE,
//			0,
//			c_white,
//			1
//		);
//		draw_set_alpha(1);
//	}
//}

///*BOLSA ESTÁ CUIDANDO DE DESENHAR AS INFOS DOS INGREDIENTES
// //ESCREVENDO AS INFOS DO ITEM
//for(var i = 0; i < slots_ativos; i++)
//{
//	var _xx =
//		x + (i mod colunas) * (slot_tam + entre_slots) + 2;
	
//	var _yy =
//		y + (i div colunas) * (slot_tam + entre_slots) + 2 + slot_tam / 2;
	
//	if(inventario[i] != -1)
//	{
//		var _ingrediente = global.Ingredientes[inventario[i]];
		
//		var _meio_x_sprite =
//			sprite_get_width(_ingrediente.sprite) / 2;
		
//		var _meio_y_sprite =
//			sprite_get_height(_ingrediente.sprite) / 2;
		
//		var _margem = 0;
		
//		//NOME DO ITEM
//		var _nome = _ingrediente.nome;
		
//		//INT mostra seu valor
//		if(inventario[i] == INGREDIENTE_INT)
//		{
//			_nome += " " + string(valores[i]);
//		}
		
//		define_align();
//		draw_set_font(fonte);
		
		
//		draw_text_outline(
//			_xx + _meio_x_sprite,
//			_yy + (_meio_y_sprite * 2) + _margem,
//			_nome,
//			cor_texto,
//			c_black,
//			1,
//			.33,
//			.33,
//			0,
//			-1,
//			-1
//		);
		
//		reseta_draw();
//	}
//}