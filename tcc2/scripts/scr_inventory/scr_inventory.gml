#macro SLOTS_INVENTARIO 15

function SpriteItens(_numero)
{
	var _sprite = noone;
	
	switch(_numero)
	{
		case 0:		{ _sprite = spr_ing_estrela; break; }
		case 1:		{  _sprite = spr_ing_lagrima; break;  }
		case 2:		{  _sprite = spr_placeholder; break;  }
		case 3:		{  _sprite = spr_placeholder; break;  }
		case 4:		{  _sprite = spr_placeholder; break;  }
		case 5:		{  _sprite = spr_placeholder; break;  }
		case 6:		{  _sprite = spr_placeholder; break;  }
		case 7:		{  _sprite = spr_placeholder; break;  }
		case 8:		{  _sprite = spr_placeholder; break;  }
		case 9:		{  _sprite = spr_placeholder; break;  }
		case 10:	{  _sprite = spr_placeholder; break;  }
		case 11:	{  _sprite = spr_placeholder; break;  }
		case 12:	{  _sprite = spr_placeholder; break;  }
		case 13:	{  _sprite = spr_placeholder; break;  }
		case 14:	{  _sprite = spr_placeholder; break;  }
		case 15:	{  _sprite = spr_placeholder; break;  }
	}
	
	return _sprite;
}

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