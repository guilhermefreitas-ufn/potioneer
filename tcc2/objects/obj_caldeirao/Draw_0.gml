//TAMANHO TOTAL DO CALDEIRÃO
var _colunas_max = min(colunas, SLOTS_CALDEIRAO);
var _linhas_max = ((SLOTS_CALDEIRAO - 1) div colunas) + 1;

//TAMANHO DOS SLOTS ÚTEIS
var _colunas_ativas = min(colunas, slots_ativos);
var _linhas_ativas = ((slots_ativos - 1) div colunas) + 1;


//TAMANHO QUADRADO DO CALDEIRÃO
var _largura_calculada =
	(2 * espaco_borda) + _colunas_max * (slot_tam + entre_slots);

var _altura_calculada =
	(2 * espaco_borda) + _linhas_max * (slot_tam + entre_slots);

//pega o maior dos dois
var _tamanho_caldeirao = max(_largura_calculada, _altura_calculada);

//DESENHANDO O FUNDO DO CALDEIRÃO
draw_sprite_stretched(
	meu_sprite,
	0,
	x - espaco_borda,
	y - espaco_borda,
	_tamanho_caldeirao,
	_tamanho_caldeirao
);

//DESENHANDO SOMENTE OS SLOTS ATIVOS
for(var i = 0; i < slots_ativos; i++)
{
	var _xx = x + (i mod colunas) * (slot_tam + entre_slots) + 2;
	var _yy = y + (i div colunas) * (slot_tam + entre_slots) + 2 + slot_tam / 2;
	
	var _hover = (obj_mouse.inventario_hover == id) && (obj_mouse.slot_hover == i);
	
	//desenhando o slot
	draw_sprite(sprite_meu_slot, _hover, _xx, _yy);
	
	//desenhando o item
	if(inventario[i] != -1)
	{
		var _alpha = 1;
		
		if(obj_mouse.inventario_drag == id && obj_mouse.slot_drag == i)
		{
			_alpha = 0.5;
		}
		
		draw_set_alpha(_alpha);
		draw_sprite(global.Ingredientes[inventario[i]].sprite, 0, _xx, _yy);
		draw_set_alpha(1);
	}
}

/*BOLSA ESTÁ CUIDANDO DE DESENHAR AS INFOS DOS INGREDIENTES
 //ESCREVENDO AS INFOS DO ITEM
for(var i = 0; i < slots_ativos; i++)
{
	var _xx =
		x + (i mod colunas) * (slot_tam + entre_slots) + 2;
	
	var _yy =
		y + (i div colunas) * (slot_tam + entre_slots) + 2 + slot_tam / 2;
	
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
			cor_texto,
			c_black,
			1,
			.33,
			.33,
			0,
			-1,
			-1
		);
		
		reseta_draw();
	}
}