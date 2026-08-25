#macro SLOTS_INVENTARIO 15

function ProcuraInventario(_obj_raiz, _tipo_item)
{
	for(var i = 0; i < SLOTS_INVENTARIO; i++)
	{
		if(_obj_raiz.inventario[i] == _tipo_item)
		{
			return(i);
		}
	}
	
	return(-1);
}

function RemoveInventario(_obj_raiz, _tipo_item)
{
	var _slot = ProcuraInventario(_obj_raiz, _tipo_item);
	
	if(_slot != -1)
	{
		with(_obj_raiz) { inventario[_slot] = -1; }
		
		return true;
	}
	else
	{
		return false;
	}
}

function AdicionaInventario(_obj_raiz, _tipo_item)
{
	var _slot = ProcuraInventario(_obj_raiz, -1)
	
	if(_slot != -1)
	{
		with(_obj_raiz) { inventario[_slot] = _tipo_item; }
		
		return true;
	}
	else
	{
		return false;
	}
}

function TrocaInventario(_obj_origem, _slot_origem, _obj_destino, _slot_destino)
{
	var _item_origem = _obj_origem.inventario[_slot_origem];
	
	_obj_origem.inventario[_slot_origem] = _obj_destino.inventario[_slot_destino];
	_obj_destino.inventario[_slot_destino] = _item_origem;
}