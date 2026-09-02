#macro SLOTS_INVENTARIO 15

function ProcuraInventario(_obj_raiz, _tipo_item, _caldeirao = caldeirao)
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

function RemoveInventario(_obj_raiz, _tipo_item, _caldeirao = caldeirao)
{
	var _slot = ProcuraInventario(
		_obj_raiz,
		_tipo_item,
		_caldeirao
	);
	
	if(_slot == -1)
	{
		return false;
	}
	
	
	// ==========================================
	// BOLSA
	// ==========================================
	
	if(!_caldeirao)
	{
		_obj_raiz.quantidades[_slot]--;
		
		// acabou a pilha
		if(_obj_raiz.quantidades[_slot] <= 0)
		{
			_obj_raiz.inventario[_slot] = -1;
			_obj_raiz.quantidades[_slot] = 0;
		}
		
		return true;
	}
	
	
	// ==========================================
	// CALDEIRÃO
	// ==========================================
	
	else
	{
		_obj_raiz.inventario[_slot] = -1;
		_obj_raiz.quantidades[_slot] = 0;
		
		AtualizaSlotsInventario(_obj_raiz);
		
		return true;
	}
}

function AdicionaInventario(_obj_raiz, _tipo_item, _caldeirao = caldeirao)
{
	// ==========================================
	// BOLSA
	// ==========================================
	
	if(!_caldeirao)
	{
		// procurando se o ingrediente já existe
		var _slot_existente = ProcuraInventario(
			_obj_raiz,
			_tipo_item,
			false
		);
		
		// já existe -> aumenta quantidade
		if(_slot_existente != -1)
		{
			_obj_raiz.quantidades[_slot_existente]++;
			
			return true;
		}
		
		
		// não existe -> procurando slot vazio
		var _slot = ProcuraInventario(
			_obj_raiz,
			-1,
			false
		);
		
		if(_slot != -1)
		{
			_obj_raiz.inventario[_slot] = _tipo_item;
			_obj_raiz.quantidades[_slot] = 1;
			
			return true;
		}
		
		return false;
	}
	
	
	// ==========================================
	// CALDEIRÃO
	// ==========================================
	
	else
	{
		var _slot = -1;
		
		// procurando slot vazio somente entre os ativos
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
		_obj_raiz.quantidades[_slot] = 1;
		
		// preenchendo o último slot ativo
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
	
	
	// ==========================================
	// BOLSA -> BOLSA
	// ==========================================
	
	if(!_caldeirao_origem && !_caldeirao_destino)
	{
		// mesmo ingrediente -> junta as pilhas
		if(_item_origem == _item_destino)
		{
			_obj_destino.quantidades[_slot_destino] +=
				_obj_origem.quantidades[_slot_origem];
			
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
		}
		else
		{
			// ingredientes diferentes -> troca
			var _quantidade_origem =
				_obj_origem.quantidades[_slot_origem];
			
			var _quantidade_destino =
				_obj_destino.quantidades[_slot_destino];
			
			
			_obj_origem.inventario[_slot_origem] = _item_destino;
			_obj_origem.quantidades[_slot_origem] = _quantidade_destino;
			
			_obj_destino.inventario[_slot_destino] = _item_origem;
			_obj_destino.quantidades[_slot_destino] = _quantidade_origem;
		}
		
		return;
	}
	
	
	// ==========================================
	// BOLSA -> CALDEIRÃO
	// ==========================================
	
	if(!_caldeirao_origem && _caldeirao_destino)
	{
		// só pode colocar se destino estiver vazio
		if(_item_destino == -1)
		{
			_obj_destino.inventario[_slot_destino] = _item_origem;
			_obj_destino.quantidades[_slot_destino] = 1;
			
			_obj_origem.quantidades[_slot_origem]--;
			
			if(_obj_origem.quantidades[_slot_origem] <= 0)
			{
				_obj_origem.inventario[_slot_origem] = -1;
				_obj_origem.quantidades[_slot_origem] = 0;
			}
			
			AtualizaSlotsInventario(_obj_destino);
		}
		
		return;
	}
	
	
	// ==========================================
	// CALDEIRÃO -> BOLSA
	// ==========================================
	
	if(_caldeirao_origem && !_caldeirao_destino)
	{
		// Procurando se a bolsa já possui esse ingrediente
		var _slot_bolsa = ProcuraInventario(
			_obj_destino,
			_item_origem,
			false
		);
		
		// ==========================================
		// JÁ EXISTE UMA PILHA
		// ==========================================
		
		if(_slot_bolsa != -1)
		{
			_obj_destino.quantidades[_slot_bolsa] += 1;
			
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
			
			AtualizaSlotsInventario(_obj_origem);
			
			return;
		}
		
		
		// ==========================================
		// NÃO EXISTE -> USA O SLOT ONDE FOI SOLTO
		// ==========================================
		
		if(_item_destino == -1)
		{
			_obj_destino.inventario[_slot_destino] = _item_origem;
			_obj_destino.quantidades[_slot_destino] = 1;
			
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
			
			AtualizaSlotsInventario(_obj_origem);
			
			return;
		}
		
		return;
	}
	
	
	// ==========================================
	// CALDEIRÃO -> CALDEIRÃO
	// ==========================================
	
	if(_caldeirao_origem && _caldeirao_destino)
	{
		var _quantidade_origem =
			_obj_origem.quantidades[_slot_origem];
		
		var _quantidade_destino =
			_obj_destino.quantidades[_slot_destino];
		
		
		_obj_origem.inventario[_slot_origem] = _item_destino;
		_obj_origem.quantidades[_slot_origem] = _quantidade_destino;
		
		_obj_destino.inventario[_slot_destino] = _item_origem;
		_obj_destino.quantidades[_slot_destino] = _quantidade_origem;
		
		AtualizaSlotsInventario(_obj_origem);
		
		if(_obj_destino != _obj_origem)
		{
			AtualizaSlotsInventario(_obj_destino);
		}
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