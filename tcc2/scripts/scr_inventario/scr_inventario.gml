#macro SLOTS_BOLSA 32
#macro SLOTS_CALDEIRAO 12

function ProcuraInventario(_obj_raiz, _tipo_item, _caldeirao = caldeirao)
{
	var _quantidade = SLOTS_BOLSA;
	
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
	
	//BOLSA
	if(!_caldeirao)
	{
		_obj_raiz.quantidades[_slot]--;
		
		//acabou a pilha
		if(_obj_raiz.quantidades[_slot] <= 0)
		{
			_obj_raiz.inventario[_slot] = -1;
			_obj_raiz.quantidades[_slot] = 0;
		}
		
		return true;
	}
	
	//CALDEIRÃO
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
	//BOLSA
	if(!_caldeirao)
	{
		//procurando se o ingrediente já existe
		var _slot_existente = ProcuraInventario(
			_obj_raiz,
			_tipo_item,
			false
		);
		
		//já existe -> aumenta quantidade
		if(_slot_existente != -1)
		{
			_obj_raiz.quantidades[_slot_existente]++;
			
			return true;
		}
		
		//não existe -> procurando slot vazio
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
	
	//CALDEIRÃO
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
		_obj_raiz.quantidades[_slot] = 1;
		
		//preenchendo o último slot ativo
		if(_slot == _obj_raiz.slots_ativos - 1)
		{
			if(_obj_raiz.slots_ativos < SLOTS_CALDEIRAO)
			{
				_obj_raiz.slots_ativos++;
			}
		}
		
		return true;
	}
}

function TrocaInventario(_obj_origem, _slot_origem, _obj_destino, _slot_destino, _caldeirao_origem, _caldeirao_destino)
{
	// ==========================================
	// MESMO SLOT
	// ==========================================
	
	if(_obj_origem == _obj_destino
	&& _slot_origem == _slot_destino)
	{
		return;
	}
	
	
	var _item_origem = _obj_origem.inventario[_slot_origem];
	var _item_destino = _obj_destino.inventario[_slot_destino];
	
	
	// ==========================================
	// BOLSA -> BOLSA
	// ==========================================
	
	if(!_caldeirao_origem && !_caldeirao_destino)
	{
		// Mesmo ingrediente -> junta as pilhas
		if(_item_origem == _item_destino)
		{
			_obj_destino.quantidades[_slot_destino] +=
				_obj_origem.quantidades[_slot_origem];
			
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
		}
		else
		{
			// Ingredientes diferentes -> troca as pilhas
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
		// ------------------------------------------
		// DESTINO VAZIO
		// ------------------------------------------
		
		if(_item_destino == -1)
		{
			_obj_destino.inventario[_slot_destino] = _item_origem;
			_obj_destino.quantidades[_slot_destino] = 1;
			
			// remove UMA unidade da bolsa
			_obj_origem.quantidades[_slot_origem]--;
			
			if(_obj_origem.quantidades[_slot_origem] <= 0)
			{
				_obj_origem.inventario[_slot_origem] = -1;
				_obj_origem.quantidades[_slot_origem] = 0;
			}
			
			AtualizaSlotsInventario(_obj_destino);
			
			return;
		}
		
		
		// ------------------------------------------
		// MESMO ITEM
		// ------------------------------------------
		
		if(_item_origem == _item_destino)
		{
			// Não há o que trocar: o item já está
			// presente no slot do caldeirão.
			return;
		}
		
		
		// ------------------------------------------
		// DESTINO OCUPADO
		// Vamos mandar UMA unidade do item
		// do caldeirão para a bolsa.
		// ------------------------------------------
		
		var _slot_bolsa = ProcuraInventario(
			_obj_origem,
			_item_destino,
			false
		);
		
		
		// ------------------------------------------
		// O ITEM DO CALDEIRÃO JÁ EXISTE NA BOLSA
		// ------------------------------------------
		
		if(_slot_bolsa != -1)
		{
			_obj_origem.quantidades[_slot_bolsa]++;
		}
		
		
		// ------------------------------------------
		// NÃO EXISTE -> PRIMEIRO SLOT VAZIO
		// ------------------------------------------
		
		else
		{
			_slot_bolsa = ProcuraInventario(
				_obj_origem,
				-1,
				false
			);
			
			if(_slot_bolsa == -1)
			{
				// Não temos onde guardar o item
				return;
			}
			
			_obj_origem.inventario[_slot_bolsa] = _item_destino;
			_obj_origem.quantidades[_slot_bolsa] = 1;
		}
		
		
		// ------------------------------------------
		// COLOCA O ITEM DA BOLSA NO CALDEIRÃO
		// ------------------------------------------
		
		_obj_destino.inventario[_slot_destino] = _item_origem;
		_obj_destino.quantidades[_slot_destino] = 1;
		
		
		// remove UMA unidade da pilha da bolsa
		_obj_origem.quantidades[_slot_origem]--;
		
		if(_obj_origem.quantidades[_slot_origem] <= 0)
		{
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
		}
		
		AtualizaSlotsInventario(_obj_destino);
		
		return;
	}
	
	
	// ==========================================
	// CALDEIRÃO -> BOLSA
	// ==========================================

	if(_caldeirao_origem && !_caldeirao_destino)
	{
		// ------------------------------------------
		// 1. JÁ EXISTE UMA PILHA DESSE ITEM
		// ------------------------------------------
	
		var _slot_bolsa = ProcuraInventario(
			_obj_destino,
			_item_origem,
			false
		);
	
		if(_slot_bolsa != -1)
		{
			// adiciona UMA unidade na pilha existente
			_obj_destino.quantidades[_slot_bolsa]++;
		
			// remove do caldeirão
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
		
			AtualizaSlotsInventario(_obj_origem);
		
			return;
		}
	
	
		// ------------------------------------------
		// 2. NÃO EXISTE A PILHA
		// ------------------------------------------
	
		// destino vazio -> coloca o item ali
		if(_item_destino == -1)
		{
			_obj_destino.inventario[_slot_destino] = _item_origem;
			_obj_destino.quantidades[_slot_destino] = 1;
		
			// remove do caldeirão
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
		
			AtualizaSlotsInventario(_obj_origem);
		
			return;
		}
	
	
		// ------------------------------------------
		// 3. DESTINO OCUPADO
		// ------------------------------------------
	
		var _quantidade_destino =
			_obj_destino.quantidades[_slot_destino];
	
	
		// ------------------------------------------
		// 3A. PILHA COM MAIS DE 1
		// ------------------------------------------
	
		if(_quantidade_destino > 1)
		{
			// Procurando primeiro slot vazio da bolsa
			var _slot_vazio = ProcuraInventario(
				_obj_destino,
				-1,
				false
			);
		
			if(_slot_vazio == -1)
			{
				return;
			}
		
		
			// Item que veio do caldeirão
			// vai para o primeiro slot vazio
			_obj_destino.inventario[_slot_vazio] = _item_origem;
			_obj_destino.quantidades[_slot_vazio] = 1;
		
		
			// Retira UMA unidade da pilha original
			_obj_destino.quantidades[_slot_destino]--;
		
		
			// A unidade retirada vai para o caldeirão
			_obj_origem.inventario[_slot_origem] = _item_destino;
			_obj_origem.quantidades[_slot_origem] = 1;
		
		
			AtualizaSlotsInventario(_obj_origem);
		
			return;
		}
	
	
		// ------------------------------------------
		// 3B. PILHA TEM EXATAMENTE 1
		// ------------------------------------------
	
		_obj_destino.inventario[_slot_destino] = _item_origem;
		_obj_destino.quantidades[_slot_destino] = 1;
	
		_obj_origem.inventario[_slot_origem] = _item_destino;
		_obj_origem.quantidades[_slot_origem] = 1;
	
		AtualizaSlotsInventario(_obj_origem);
	
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
		
		return;
	}
}

function AtualizaSlotsInventario(_obj_raiz)
{
	var _ultimo_slot = -1;
	var _limite = _obj_raiz.caldeirao
		? SLOTS_CALDEIRAO
		: SLOTS_BOLSA;
	
	// Procurando o último slot que possui item
	for(var i = 0; i < _limite; i++)
	{
		if(_obj_raiz.inventario[i] != -1)
		{
			_ultimo_slot = i;
		}
	}
	
	// Sempre deve existir pelo menos 1 slot
	_obj_raiz.slots_ativos = max(1, _ultimo_slot + 2);
	
	// Nunca ultrapassar o máximo do inventário
	_obj_raiz.slots_ativos = min(
		_obj_raiz.slots_ativos,
		_limite
	);
}

function TransfereInventario(_obj_origem, _slot_origem, _obj_destino, _caldeirao_origem, _caldeirao_destino)
{
	var _item = _obj_origem.inventario[_slot_origem];
	
	//Nenhum item
	if(_item == -1)
	{
		return false;
	}
	
	//BOLSA -> CALDEIRÃO
	if(!_caldeirao_origem && _caldeirao_destino)
	{
		//Tenta adicionar UMA unidade ao caldeirão.
		//AdicionaInventario procura o primeiro slot vazio
		//entre os slots ativos.
		var _adicionou = AdicionaInventario(
			_obj_destino,
			_item,
			true
		);
		
		if(!_adicionou)
		{
			return false;
		}
		
		//Remove uma unidade da bolsa
		_obj_origem.quantidades[_slot_origem]--;
		
		if(_obj_origem.quantidades[_slot_origem] <= 0)
		{
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
		}
		
		return true;
	}
	
	//CALDEIRÃO -> BOLSA
	if(_caldeirao_origem && !_caldeirao_destino)
	{
		//A própria AdicionaInventario da bolsa
		//cuida de procurar uma pilha existente
		//ou criar uma nova no primeiro slot vazio.
		var _adicionou = AdicionaInventario(
			_obj_destino,
			_item,
			false
		);
		
		if(!_adicionou)
		{
			return false;
		}
		
		//Remove o ingrediente do caldeirão
		_obj_origem.inventario[_slot_origem] = -1;
		_obj_origem.quantidades[_slot_origem] = 0;
		
		AtualizaSlotsInventario(_obj_origem);
		
		return true;
	}
	
	return false;
}

function LimpaCaldeirao(_obj_caldeirao = noone, _obj_bolsa = noone)
{
	if(_obj_caldeirao == noone && instance_exists(obj_caldeirao))
	{
		_obj_caldeirao = obj_caldeirao;
	}
	
	if(_obj_bolsa == noone && instance_exists(obj_bolsa))
	{
		_obj_bolsa = obj_bolsa;
	}
	
	for(var i = 0; i < SLOTS_BOLSA; i++)
	{
		var _item = _obj_caldeirao.inventario[i];
		
		// slot vazio
		if(_item == -1)
		{
			continue;
		}
		
		// tentando devolver o ingrediente para a bolsa
		var _adicionou = AdicionaInventario(
			_obj_bolsa,
			_item,
			false
		);
		
		// só remove do caldeirão se conseguiu colocar na bolsa
		if(_adicionou)
		{
			_obj_caldeirao.inventario[i] = -1;
			_obj_caldeirao.quantidades[i] = 0;
		}
	}
	
	// atualiza a quantidade de slots ativos
	AtualizaSlotsInventario(_obj_caldeirao);
}