
inventario_hover = -1;
slot_hover = -1;
inventario_drag = -1;
slot_drag = -1;
item_drag = -1;

mouse_over = function()
{
	//iniciando variaveis
	var _slot_tam = sprite_get_width(spr_slot_ph);
	var _margem_1 = 6;
	var _margem_2 = 4; //espaço entre slots

	//limpando variaveis hover
	slot_hover = -1;
	inventario_hover= - 1;
	
	//coordenadas do mouse
	var _mx = mouse_x;
	var _my = mouse_y;
	
	//checando se tem hover em slot do inventario
	with(obj_inventario)
	{
		if(point_in_rectangle
		(
			_mx,
			_my,
			x-_margem_1,
			y-_margem_1,
			x-_margem_1 + (_margem_1 * 2) * (_slot_tam + _margem_2),
			y-_margem_1 + (_margem_1 * 2) + (((SLOTS_INVENTARIO-1) div colunas)+1)*(_slot_tam + _margem_2)
		))
		{
			//checando o mouse em cada slot
			for(var i = 0; i < SLOTS_INVENTARIO; i++)
			{
				var _xx = x + (i mod colunas) * (_slot_tam + _margem_2) + 2;
				var _yy = y + (i div colunas) * (_slot_tam + _margem_2) + 2;
				
				if(point_in_rectangle(_mx, _my, _xx, _yy, _xx + _slot_tam, _yy+_slot_tam))
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
		//trocando com o slot que estou em cima
		if(slot_hover != -1)
		{
			TrocaInventario(inventario_drag, slot_drag, inventario_hover, slot_hover);
		}
		
		//retornando pro estado livre
		estado = estado_livre;
		item_drag = -1;
		inventario_drag = -1;
		slot_drag = -1;
	}
}

estado = estado_livre;