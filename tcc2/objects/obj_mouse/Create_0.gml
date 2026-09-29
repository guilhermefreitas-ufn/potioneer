
inventario_hover = -1;
slot_hover = -1;

inventario_drag = -1;
slot_drag = -1;
item_drag = -1;


//POÇÕES


pocao_inventario_hover = noone;
pocao_slot_hover = -1;

pocao_inventario_drag = noone;
pocao_slot_drag = -1;

pocao_drag = undefined;

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
		var _slots = SLOTS_BOLSA;
		var _margem_caldeirao = 0;
		
		if(caldeirao)
		{
			_slots = slots_ativos;
			_margem_caldeirao = slot_tam /2;
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
			y - espaco_borda + _altura + _margem_caldeirao 
		))
		{
			//VERIFICANDO CADA SLOT
			for(var i = 0; i < _slots; i++)
			{
				var _xx = x + (i mod colunas) * (slot_tam + entre_slots) + 2;
				
				var _yy = y + (i div colunas) * (slot_tam + entre_slots) + 2 + _margem_caldeirao;
				
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
	
	
	//ARMÁRIO / HOTBAR
	

	pocao_inventario_hover = noone;
	pocao_slot_hover = -1;


	
	//ARMÁRIO
	

	if(instance_exists(obj_armario))
	{
		var _armario =
			instance_find(obj_armario, 0);
	
		var _slot_armario =
			_armario.SlotSobreMouse(
				_mx,
				_my
			);
	
		if(_slot_armario != -1)
		{
			pocao_inventario_hover =
				_armario;
		
			pocao_slot_hover =
				_slot_armario;
		}
	}


	
	//HOTBAR
	

	if(instance_exists(obj_hotbar))
	{
		var _hotbar =
			instance_find(obj_hotbar, 0);
	
		var _slot_hotbar =
			_hotbar.SlotSobreMouse(
				_mx,
				_my
			);
	
		if(_slot_hotbar != -1)
		{
			pocao_inventario_hover =
				_hotbar;
		
			pocao_slot_hover =
				_slot_hotbar;
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

estado_click_pocao = function()
{
	mouse_over();
	
	
	
	//SOLTOU → FOI UM CLIQUE
	
	
	if(mouse_check_button_released(mb_left))
	{
		var _armario =
			instance_find(obj_armario, 0);
		
		var _hotbar =
			instance_find(obj_hotbar, 0);
		
		
		
		//ARMÁRIO → HOTBAR
		
		
		if(
			pocao_inventario_drag == _armario
		)
		{
			var _resultado =
				AdicionaPocaoHotbarPorClique(
					pocao_slot_drag
				);
			
			
			if(!_resultado)
			{
				show_debug_message(
					"Hotbar cheia."
				);
			}
		}
		
		
		
		//HOTBAR → ARMÁRIO
		
		
		else if(
			pocao_inventario_drag == _hotbar
		)
		{
			DevolvePocaoHotbarPorClique(
				pocao_slot_drag
			);
		}
		
		
		
		//RESET
		
		
		pocao_inventario_drag = noone;
		pocao_slot_drag = -1;
		pocao_drag = undefined;
		
		estado = estado_livre;
		
		return;
	}
	
	
	
	//VERIFICANDO SE VIROU DRAG
	
	
	var _distancia =
		point_distance(
			mouse_inicio_x,
			mouse_inicio_y,
			mouse_x,
			mouse_y
		);
	
	
	if(_distancia >= distancia_drag)
	{
		//salva a poção que está sendo arrastada
		if(
			pocao_inventario_drag
			== instance_find(obj_armario, 0)
		)
		{
			pocao_drag =
				global.DadosJogador.armario_pocoes[
					pocao_slot_drag
				];
		}
		else
		{
			pocao_drag =
				global.DadosJogador.hotbar_pocoes[
					pocao_slot_drag
				];
		}
		
		estado = estado_drag_pocao;
	}
};

estado_livre = function()
{
	mouse_over();
	
	if(
		mouse_check_button_pressed(mb_left)
		&& slot_hover != -1
		&& inventario_hover.inventario[slot_hover] != -1
	)
	{
		mouse_inicio_x = mouse_x;
		mouse_inicio_y = mouse_y;
	
		inventario_drag = inventario_hover;
		slot_drag = slot_hover;
	
		estado = estado_click;
	
		return;
	}
	
	
	//POÇÃO
	

	if(
		mouse_check_button_pressed(mb_left)
		&& pocao_slot_hover != -1
		&& pocao_inventario_hover != noone
	)
	{
		var _pocao;
	
	
		//ARMÁRIO
		if(
			pocao_inventario_hover.object_index
			== obj_armario
		)
		{
			_pocao =
				global.DadosJogador.armario_pocoes[
					pocao_slot_hover
				];
		}
	
		//HOTBAR
		else
		{
			_pocao =
				global.DadosJogador.hotbar_pocoes[
					pocao_slot_hover
				];
		}
	
	
		if(!is_undefined(_pocao))
		{
			mouse_inicio_x = mouse_x;
			mouse_inicio_y = mouse_y;
		
			pocao_inventario_drag =
				pocao_inventario_hover;
		
			pocao_slot_drag =
				pocao_slot_hover;
		
			pocao_drag =
				_pocao;
		
			estado = estado_click_pocao;
		
			return;
		}
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

estado_drag_pocao = function()
{
	mouse_over();
	
	
	//continua arrastando
	if(mouse_check_button(mb_left))
	{
		return;
	}
	
	
	
	//SOLTOU
	
	
	if(mouse_check_button_released(mb_left))
	{
		var _armario =
			instance_find(obj_armario, 0);
		
		var _hotbar =
			instance_find(obj_hotbar, 0);
		
		
		
		//ORIGEM = ARMÁRIO
		
		
		if(
			pocao_inventario_drag
			== _armario
		)
		{
			//------------------------------
			//ARMÁRIO → HOTBAR
			//------------------------------
			
			if(
				pocao_inventario_hover
				== _hotbar
			)
			{
				TransferePocaoArmarioParaHotbar(
					pocao_slot_drag,
					pocao_slot_hover
				);
			}
			
			
			//------------------------------
			//ARMÁRIO → ARMÁRIO
			//------------------------------
			
			else if(
				pocao_inventario_hover
				== _armario
			)
			{
				if(
					pocao_slot_hover
					!= pocao_slot_drag
				)
				{
					TrocaPocaoArmario(
						pocao_slot_drag,
						pocao_slot_hover
					);
				}
			}
		}
		
		
		
		//ORIGEM = HOTBAR
		
		
		else if(
			pocao_inventario_drag
			== _hotbar
		)
		{
			//------------------------------
			//HOTBAR → HOTBAR
			//------------------------------
			
			if(
				pocao_inventario_hover
				== _hotbar
			)
			{
				if(
					pocao_slot_hover
					!= pocao_slot_drag
				)
				{
					TrocaPocaoHotbar(
						pocao_slot_drag,
						pocao_slot_hover
					);
				}
			}
			
			
			//------------------------------
			//HOTBAR → ARMÁRIO
			//------------------------------
			
			else if(
				pocao_inventario_hover
				== _armario
			)
			{
				TransferePocaoHotbarParaArmario(
					pocao_slot_drag,
					pocao_slot_hover
				);
			}
			
			//------------------------------
			//HOTBAR → ÁREA VAZIA DO ARMÁRIO
			//------------------------------
			
			else if(
				instance_exists(_armario)
				&& _armario.AreaSobreMouse(
					mouse_x,
					mouse_y
				)
			)
			{
				TransferePocaoHotbarParaFimDoArmario(
					pocao_slot_drag
				);
			}
		}
		
		
		
		//RESET
		
		
		pocao_inventario_drag = noone;
		pocao_slot_drag = -1;
		pocao_drag = undefined;
		
		estado = estado_livre;
	}
};

MouseSobreItem = function()
{
	return (
		inventario_hover != -1
		&& slot_hover != -1
		&& inventario_hover.inventario[slot_hover] != -1
	);
}

estado = estado_livre;