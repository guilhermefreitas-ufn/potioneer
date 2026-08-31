#macro SLOTS_INVENTARIO 15

function ProcuraInventario(_obj_raiz, _tipo_item, _caldeirao=caldeirao)
{
	var _quantidade = SLOTS_INVENTARIO;
	
	if(_caldeirao)
	{
		_quantidade = _obj_raiz.slots_ativos;
	}
	
	for(var i = 0; i < _quantidade; i++)
	{
		if(_obj_raiz.inventario[i] == _tipo_item)
		{
			return i;
		}
	}
	
	return -1;
}

function RemoveInventario(_obj_raiz, _tipo_item, _caldeirao=caldeirao)
{
	var _slot = ProcuraInventario(_obj_raiz, _tipo_item, _caldeirao);
	
	if(_slot != -1)
	{
		with(_obj_raiz)
		{
			inventario[_slot] = -1;
		}
		
		//caldeirao
		if(_caldeirao)
		{
			AtualizaSlotsInventario(_obj_raiz);
		}
		
		return true;
	}
	else
	{
		return false;
	}
}

function AdicionaInventario(_obj_raiz, _tipo_item, _caldeirao=caldeirao)
{
	//bolsa
	if(!_caldeirao)
	{
		var _slot = ProcuraInventario(_obj_raiz, -1, false);
		
		if(_slot != -1)
		{
			with(_obj_raiz)
			{
				inventario[_slot] = _tipo_item;
			}
			
			return true;
		}
		else
		{
			return false;
		}
	}
	
	//caldeirao
	else
	{
		var _slot = -1;
		
		//procurando slot vazio somente entre os ativos
		for(var i = 0; i < _obj_raiz.slots_ativos; i++)
		{
			if(_obj_raiz.inventario[i] == -1)
			{
				_slot = i;
				break;
			}
		}
		
		if(_slot == -1)
		{
			return false;
		}
		
		_obj_raiz.inventario[_slot] = _tipo_item;
		
		//se preencheu o último slot ativo, libera o próximo
		if(_slot == _obj_raiz.slots_ativos - 1)
		{
			if(_obj_raiz.slots_ativos < SLOTS_INVENTARIO)
			{
				_obj_raiz.slots_ativos++;
			}
		}
		
		return true;
	}
}

function TrocaInventario(
	_obj_origem,
	_slot_origem,
	_obj_destino,
	_slot_destino,
	_caldeirao_origem,
	_caldeirao_destino
)
{
	var _item_origem = _obj_origem.inventario[_slot_origem];
	var _item_destino = _obj_destino.inventario[_slot_destino];
	
	//Fazendo a troca
	_obj_origem.inventario[_slot_origem] = _item_destino;
	_obj_destino.inventario[_slot_destino] = _item_origem;
	
	
	//ATUALIZAÇÃO DO INVENTÁRIO DE ORIGEM
	if(_caldeirao_origem)
	{
		AtualizaSlotsInventario(_obj_origem);
	}
	
	//ATUALIZAÇÃO DO INVENTÁRIO DE DESTINO
	if(_caldeirao_destino)
	{
		AtualizaSlotsInventario(_obj_destino);
	}
}

function AtualizaSlotsInventario(_obj_raiz)
{
	var _ultimo_slot = -1;
	
	//Procurando o último slot que possui item
	for(var i = 0; i < SLOTS_INVENTARIO; i++)
	{
		if(_obj_raiz.inventario[i] != -1)
		{
			_ultimo_slot = i;
		}
	}
	
	//Sempre deve existir pelo menos 1 slot
	_obj_raiz.slots_ativos = max(1, _ultimo_slot + 2);
	
	//Nunca ultrapassar o máximo
	_obj_raiz.slots_ativos = min(_obj_raiz.slots_ativos, SLOTS_INVENTARIO);
}