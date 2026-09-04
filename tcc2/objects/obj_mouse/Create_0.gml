
inventario_hover = -1;
slot_hover = -1;

inventario_drag = -1;
slot_drag = -1;
item_drag = -1;

//posição inicial do clique
mouse_inicio_x = 0;
mouse_inicio_y = 0;

//distância mínima para transformar clique em drag
distancia_drag = 8;

slot_tam = sprite_get_width(spr_slot_bolsa_ph);
entre_slots = 4;
espaco_borda = 6;

//ANIMAÇÃO DE TRANSFERÊNCIA POR CLICK
click_animando = false;

click_anim_item = -1;

click_anim_x = 0;
click_anim_y = 0;

click_anim_dest_x = 0;
click_anim_dest_y = 0;

click_anim_tempo = 0;
click_anim_duracao = 8;

//funções
get_slot_pos = function(_obj_inventario, _slot)
{
	
	
	return [
		_obj_inventario.x + (_slot mod _obj_inventario.colunas) * (slot_tam + entre_slots) + 2,
		_obj_inventario.y + (_slot div _obj_inventario.colunas) * (slot_tam + entre_slots) + 2
	];
}

mouse_over = function()
{
	//var _slot_tam = sprite_get_width(spr_slot_bolsa_ph);
	//var _espaco_borda = 6;
	//var _entre_slots = 4;
	
	//limpando hover
	slot_hover = -1;
	inventario_hover = -1;
	
	var _mx = mouse_x;
	var _my = mouse_y;
	
	with(obj_inventario_pai)
	{
		//DEFININDO QUANTOS SLOTS DEVEM SER USADOS
		var _slots = SLOTS_INVENTARIO;
		
		if(caldeirao)
		{
			_slots = slots_ativos;
		}
		
		//quantidade de colunas e linhas
		var _colunas_ativas = min(colunas, _slots);
		var _linhas_ativas = ((_slots - 1) div colunas) + 1;
		
		//tamanho da área
		var _largura = (2 * espaco_borda) + _colunas_ativas * (slot_tam + entre_slots);
		
		var _altura = (2 * espaco_borda) + _linhas_ativas * (slot_tam + entre_slots);
		
		//VERIFICANDO MOUSE SOBRE O INVENTÁRIO
		if(point_in_rectangle(
			_mx,
			_my,
			x - espaco_borda,
			y - espaco_borda,
			x - espaco_borda + _largura,
			y - espaco_borda + _altura
		))
		{
			//VERIFICANDO CADA SLOT
			for(var i = 0; i < _slots; i++)
			{
				var _xx = x + (i mod colunas) * (slot_tam + entre_slots) + 2;
				
				var _yy = y + (i div colunas) * (slot_tam + entre_slots) + 2;
				
				if(point_in_rectangle(
					_mx,
					_my,
					_xx,
					_yy,
					_xx + slot_tam,
					_yy + slot_tam
				))
				{
					other.slot_hover = i;
					other.inventario_hover = id;
				}
			}
		}
	}
}

estado_click = function()
{
	mouse_over();
	
	//SOLTOU -> FOI UM CLICK
	if(mouse_check_button_released(mb_left))
	{
		var _outro_inventario = noone;
		
		if(inventario_drag.caldeirao)
		{
			_outro_inventario = instance_find(obj_bolsa, 0);
		}
		else
		{
			_outro_inventario = instance_find(obj_caldeirao, 0);
		}
		
		
		if(_outro_inventario != noone)
		{
			//posição de origem
			var _pos_origem = get_slot_pos(
				inventario_drag,
				slot_drag
			);
			
			//vamos descobrir onde o item realmente irá
			//antes de executar a transferência
			var _item = inventario_drag.inventario[slot_drag];
			
			var _slot_destino = -1;
			
			//BOLSA -> CALDEIRÃO
			if(!inventario_drag.caldeirao && _outro_inventario.caldeirao)
			{
				//procurando o primeiro slot vazio
				for(var i = 0; i < _outro_inventario.slots_ativos; i++)
				{
					if(_outro_inventario.inventario[i] == -1)
					{
						_slot_destino = i;
						break;
					}
				}
			}
			
			//CALDEIRÃO -> BOLSA
			else if(inventario_drag.caldeirao && !_outro_inventario.caldeirao)
			{
				//primeiro procura a pilha existente
				_slot_destino = ProcuraInventario(
					_outro_inventario,
					_item,
					false
				);
				
				//não encontrou -> primeiro slot vazio
				if(_slot_destino == -1)
				{
					_slot_destino = ProcuraInventario(
						_outro_inventario,
						-1,
						false
					);
				}
			}
			
			//TEM DESTINO
			if(_slot_destino != -1)
			{
				var _pos_destino = get_slot_pos(
					_outro_inventario,
					_slot_destino
				);
				
				//iniciando animação
				click_animando = true;
				
				click_anim_item = _item;
				
				click_anim_x = _pos_origem[0];
				click_anim_y = _pos_origem[1];
				
				click_anim_dest_x = _pos_destino[0];
				click_anim_dest_y = _pos_destino[1];
				
				click_anim_tempo = 0;
				
				//executando a transferência imediatamente
				TransfereInventario(
					inventario_drag,
					slot_drag,
					_outro_inventario,
					inventario_drag.caldeirao,
					_outro_inventario.caldeirao
				);
			}
		}
		
		//encerrando clique
		inventario_drag = -1;
		slot_drag = -1;
		
		estado = estado_livre;
		
		return;
	}
	
	//VERIFICANDO SE VIROU DRAG
	var _distancia = point_distance(
		mouse_inicio_x,
		mouse_inicio_y,
		mouse_x,
		mouse_y
	);
	
	if(_distancia >= distancia_drag)
	{
		item_drag = inventario_drag.inventario[slot_drag];
		
		estado = estado_drag;
	}
}

estado_livre = function()
{
	mouse_over();
	
	if(mouse_check_button_pressed(mb_left) && slot_hover != -1 && inventario_hover.inventario[slot_hover] != -1)
	{
		mouse_inicio_x = mouse_x;
		mouse_inicio_y = mouse_y;
		
		inventario_drag = inventario_hover;
		slot_drag = slot_hover;
		
		estado = estado_click;
	}
}

estado_drag = function()
{
	mouse_over();
	
	//continua arrastando
	if(mouse_check_button(mb_left))
	{
		return;
	}
	
	//SOLTOU O ITEM
	if(slot_hover != -1)
	{
		//soltou no próprio slot
		if(inventario_hover == inventario_drag && slot_hover == slot_drag)
		{
			//não faz nada
		}
		else
		{
			TrocaInventario(
				inventario_drag,
				slot_drag,
				inventario_hover,
				slot_hover,
				inventario_drag.caldeirao,
				inventario_hover.caldeirao
			);
		}
	}
	
	//reset
	item_drag = -1;
	inventario_drag = -1;
	slot_drag = -1;
	
	estado = estado_livre;
}

MouseSobreItem = function()
{
	return (
		inventario_hover != -1
		&& slot_hover != -1
		&& inventario_hover.inventario[slot_hover] != -1
	);
}

estado = estado_livre;