
inventario_hover = -1;
slot_hover = -1;
inventario_drag = -1;
slot_drag = -1;
item_drag = -1;

mouse_over = function()
{
	var _slot_tam = sprite_get_width(spr_slot_bolsa_ph);
	var _espaco_borda = 6;
	var _entre_slots = 4;
	
	// limpando hover
	slot_hover = -1;
	inventario_hover = -1;
	
	var _mx = mouse_x;
	var _my = mouse_y;
	
	with(obj_inventario_pai)
	{
		// ==========================================
		// DEFININDO QUANTOS SLOTS DEVEM SER USADOS
		// ==========================================
		
		var _slots = SLOTS_INVENTARIO;
		
		if(caldeirao)
		{
			_slots = slots_ativos;
		}
		
		
		// quantidade de colunas e linhas
		var _colunas_ativas = min(colunas, _slots);
		var _linhas_ativas = ((_slots - 1) div colunas) + 1;
		
		
		// tamanho da área
		var _largura =
			(2 * _espaco_borda) +
			_colunas_ativas * (_slot_tam + _entre_slots);
		
		var _altura =
			(2 * _espaco_borda) +
			_linhas_ativas * (_slot_tam + _entre_slots);
		
		
		// ==========================================
		// VERIFICANDO MOUSE SOBRE O INVENTÁRIO
		// ==========================================
		
		if(point_in_rectangle(
			_mx,
			_my,
			x - _espaco_borda,
			y - _espaco_borda,
			x - _espaco_borda + _largura,
			y - _espaco_borda + _altura
		))
		{
			// ==========================================
			// VERIFICANDO CADA SLOT
			// ==========================================
			
			for(var i = 0; i < _slots; i++)
			{
				var _xx =
					x +
					(i mod colunas) *
					(_slot_tam + _entre_slots) +
					2;
				
				var _yy =
					y +
					(i div colunas) *
					(_slot_tam + _entre_slots) +
					2;
				
				if(point_in_rectangle(
					_mx,
					_my,
					_xx,
					_yy,
					_xx + _slot_tam,
					_yy + _slot_tam
				))
				{
					other.slot_hover = i;
					other.inventario_hover = id;
				}
			}
		}
	}
}

estado_livre = function()
{
	mouse_over();
	
	//pegando o item se o slot não ta vazio
	if(mouse_check_button(mb_left)) && (slot_hover != -1) && (inventario_hover.inventario[slot_hover] != -1)
	{
		//entrando no estado drag
		estado = estado_drag;
		item_drag = inventario_hover.inventario[slot_hover];
		inventario_drag = inventario_hover;
		slot_drag = slot_hover;
	}
}

estado_drag = function()
{
	mouse_over();
	
	if(!mouse_check_button(mb_left))
	{
		// soltou o item sobre algum slot
		if(slot_hover != -1)
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
		
		// retornando para o estado livre
		estado = estado_livre;
		
		item_drag = -1;
		inventario_drag = -1;
		slot_drag = -1;
	}
}

estado = estado_livre;