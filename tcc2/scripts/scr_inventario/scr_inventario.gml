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

function RemoveInventario(_obj_raiz,_tipo_item,_caldeirao = caldeirao)
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
		
		if(_obj_raiz.quantidades[_slot] <= 0)
		{
			_obj_raiz.inventario[_slot] = -1;
			_obj_raiz.quantidades[_slot] = 0;
			_obj_raiz.valores[_slot] = undefined;
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
		_obj_raiz.valores[_slot] = undefined;
		
		AtualizaSlotsInventario(_obj_raiz);
		
		return true;
	}
}

function AdicionaInventario(_obj_raiz,_tipo_item,_valor = undefined,_caldeirao = caldeirao)
{
	// ==========================================
	// BOLSA
	// ==========================================
	
	if(!_caldeirao)
	{
		// procurando uma pilha compatível
		for(var i = 0; i < SLOTS_BOLSA; i++)
		{
			// slot vazio
			if(_obj_raiz.inventario[i] == -1)
			{
				continue;
			}
			
			// ingrediente diferente
			if(_obj_raiz.inventario[i] != _tipo_item)
			{
				continue;
			}
			
			// se for int, o valor também precisa ser igual
			if(_tipo_item == INGREDIENTE_INT
			&& _obj_raiz.valores[i] != _valor)
			{
				continue;
			}
			
			// encontrou a pilha
			_obj_raiz.quantidades[i]++;
			
			return true;
		}
		
		
		// ==========================================
		// NÃO EXISTE PILHA COMPATÍVEL
		// ==========================================
		
		var _slot = ProcuraInventario(
			_obj_raiz,
			-1,
			false
		);
		
		if(_slot != -1)
		{
			_obj_raiz.inventario[_slot] = _tipo_item;
			_obj_raiz.quantidades[_slot] = 1;
			_obj_raiz.valores[_slot] = _valor;
			
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
		_obj_raiz.valores[_slot] = _valor;
		
		// preenchendo o último slot ativo
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

function TrocaInventario(_obj_origem,_slot_origem,_obj_destino,_slot_destino,_caldeirao_origem,_caldeirao_destino)
{
	// ==========================================
	// MESMO SLOT
	// ==========================================
	
	if(_obj_origem == _obj_destino
	&& _slot_origem == _slot_destino)
	{
		return;
	}
	
	
	// ==========================================
	// DADOS DA ORIGEM
	// ==========================================
	
	var _item_origem =
		_obj_origem.inventario[_slot_origem];
	
	var _valor_origem =
		_obj_origem.valores[_slot_origem];
	
	
	// ==========================================
	// DADOS DO DESTINO
	// ==========================================
	
	var _item_destino =
		_obj_destino.inventario[_slot_destino];
	
	var _valor_destino =
		_obj_destino.valores[_slot_destino];
	
	
	// ==========================================
	// BOLSA -> BOLSA
	// ==========================================
	
	if(!_caldeirao_origem && !_caldeirao_destino)
	{
		// ------------------------------------------
		// MESMO ITEM / MESMO VALOR
		// -> JUNTA AS PILHAS
		// ------------------------------------------
		
		if(ItensIguais(
			_obj_origem,
			_slot_origem,
			_obj_destino,
			_slot_destino
		))
		{
			_obj_destino.quantidades[_slot_destino] +=
				_obj_origem.quantidades[_slot_origem];
			
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
			_obj_origem.valores[_slot_origem] = undefined;
			
			return;
		}
		
		
		// ------------------------------------------
		// ITENS DIFERENTES
		// -> TROCA AS PILHAS
		// ------------------------------------------
		
		var _quantidade_origem =
			_obj_origem.quantidades[_slot_origem];
		
		var _quantidade_destino =
			_obj_destino.quantidades[_slot_destino];
		
		
		_obj_origem.inventario[_slot_origem] =
			_item_destino;
		
		_obj_origem.quantidades[_slot_origem] =
			_quantidade_destino;
		
		_obj_origem.valores[_slot_origem] =
			_valor_destino;
		
		
		_obj_destino.inventario[_slot_destino] =
			_item_origem;
		
		_obj_destino.quantidades[_slot_destino] =
			_quantidade_origem;
		
		_obj_destino.valores[_slot_destino] =
			_valor_origem;
		
		return;
	}
	
	
	// ==========================================
	// BOLSA -> CALDEIRÃO
	// ==========================================

	if(!_caldeirao_origem && _caldeirao_destino)
	{
		// ------------------------------------------
		// 1. DESTINO VAZIO
		// ------------------------------------------
	
		if(_item_destino == -1)
		{
			_obj_destino.inventario[_slot_destino] =
				_item_origem;
		
			_obj_destino.quantidades[_slot_destino] = 1;
		
			_obj_destino.valores[_slot_destino] =
				_valor_origem;
		
		
			// remove UMA unidade da bolsa
			_obj_origem.quantidades[_slot_origem]--;
		
			if(_obj_origem.quantidades[_slot_origem] <= 0)
			{
				_obj_origem.inventario[_slot_origem] = -1;
				_obj_origem.quantidades[_slot_origem] = 0;
				_obj_origem.valores[_slot_origem] = undefined;
			}
		
			AtualizaSlotsInventario(_obj_destino);
		
			return;
		}
	
	
		// ------------------------------------------
		// 2. MESMO ITEM / MESMO VALOR
		// ------------------------------------------
	
		if(ItensIguais(
			_obj_origem,
			_slot_origem,
			_obj_destino,
			_slot_destino
		))
		{
			return;
		}
	
	
		// ------------------------------------------
		// 3. O CALDEIRÃO ESTÁ OCUPADO
		//
		// O item do caldeirão precisa voltar
		// para a bolsa.
		// ------------------------------------------
	
		var _item_retorno = _item_destino;
		var _valor_retorno = _valor_destino;
	
	
		// ------------------------------------------
		// 4. PROCURANDO PILHA DO ITEM DE RETORNO
		// ------------------------------------------
	
		var _slot_pilha = -1;
	
		for(var i = 0; i < SLOTS_BOLSA; i++)
		{
			// não considerar o próprio slot de origem
			if(i == _slot_origem)
			{
				continue;
			}
		
			if(_obj_origem.inventario[i] == -1)
			{
				continue;
			}
		
			// ingrediente diferente
			if(_obj_origem.inventario[i] != _item_retorno)
			{
				continue;
			}
		
			// se for INT, precisa ter o mesmo valor
			if(_item_retorno == INGREDIENTE_INT
			&& _obj_origem.valores[i] != _valor_retorno)
			{
				continue;
			}
		
			_slot_pilha = i;
			break;
		}
	
	
		// ------------------------------------------
		// 5. SE NÃO EXISTE PILHA, PRECISAMOS
		// DE UM SLOT VAZIO
		// ------------------------------------------
	
		if(_slot_pilha == -1)
		{
			_slot_pilha = ProcuraInventario(
				_obj_origem,
				-1,
				false
			);
		
			if(_slot_pilha == -1)
			{
				// Não temos como guardar o item
				// que está no caldeirão.
				return;
			}
		
			// criando nova pilha
			_obj_origem.inventario[_slot_pilha] =
				_item_retorno;
		
			_obj_origem.quantidades[_slot_pilha] = 1;
		
			_obj_origem.valores[_slot_pilha] =
				_valor_retorno;
		}
	
		// ------------------------------------------
		// 6. JÁ EXISTE UMA PILHA
		// ------------------------------------------
	
		else
		{
			_obj_origem.quantidades[_slot_pilha]++;
		}
	
	
		// ------------------------------------------
		// 7. ITEM DA BOLSA VAI PARA O CALDEIRÃO
		// ------------------------------------------
	
		_obj_destino.inventario[_slot_destino] =
			_item_origem;
	
		_obj_destino.quantidades[_slot_destino] = 1;
	
		_obj_destino.valores[_slot_destino] =
			_valor_origem;
	
	
		// ------------------------------------------
		// 8. REMOVE UMA UNIDADE DA BOLSA
		// ------------------------------------------
	
		_obj_origem.quantidades[_slot_origem]--;
	
		if(_obj_origem.quantidades[_slot_origem] <= 0)
		{
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
			_obj_origem.valores[_slot_origem] = undefined;
		}
	
	
		// ------------------------------------------
		// 9. ATUALIZA CALDEIRÃO
		// ------------------------------------------
	
		AtualizaSlotsInventario(_obj_destino);
	
		return;
	}
	
	
	// ==========================================
	// CALDEIRÃO -> BOLSA
	// ==========================================

	if(_caldeirao_origem && !_caldeirao_destino)
	{
		// ==========================================
		// 1. DESTINO VAZIO
		// ==========================================
	
		if(_item_destino == -1)
		{
			// procura pilha compatível do item
			// que veio do caldeirão
			var _slot_pilha = -1;
		
			for(var i = 0; i < SLOTS_BOLSA; i++)
			{
				if(_obj_destino.inventario[i] == -1)
				{
					continue;
				}
			
				if(ItensIguais(
					_obj_origem,
					_slot_origem,
					_obj_destino,
					i
				))
				{
					_slot_pilha = i;
					break;
				}
			}
		
		
			// já existe pilha -> soma 1
			if(_slot_pilha != -1)
			{
				_obj_destino.quantidades[_slot_pilha]++;
			}
		
			// não existe -> coloca no slot escolhido
			else
			{
				_obj_destino.inventario[_slot_destino] =
					_item_origem;
			
				_obj_destino.quantidades[_slot_destino] = 1;
			
				_obj_destino.valores[_slot_destino] =
					_valor_origem;
			}
		
		
			// remove do caldeirão
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
			_obj_origem.valores[_slot_origem] = undefined;
		
			AtualizaSlotsInventario(_obj_origem);
		
			return;
		}
	
	
		// ==========================================
		// 2. DESTINO OCUPADO
		// ==========================================
	
		var _quantidade_destino =
			_obj_destino.quantidades[_slot_destino];
	
	
		// ------------------------------------------
		// procurando uma pilha do item que veio
		// do caldeirão
		// ------------------------------------------
	
		var _slot_pilha = -1;
	
		for(var i = 0; i < SLOTS_BOLSA; i++)
		{
			// não considerar o próprio slot de destino
			if(i == _slot_destino)
			{
				continue;
			}
		
			if(_obj_destino.inventario[i] == -1)
			{
				continue;
			}
		
			if(ItensIguais(
				_obj_origem,
				_slot_origem,
				_obj_destino,
				i
			))
			{
				_slot_pilha = i;
				break;
			}
		}
	
	
		// ==========================================
		// 2A. JÁ EXISTE PILHA DO ITEM DO CALDEIRÃO
		// ==========================================
	
		if(_slot_pilha != -1)
		{
			// adiciona 1 à pilha
			_obj_destino.quantidades[_slot_pilha]++;
		
		
			// tira 1 da pilha que estava no
			// slot onde o jogador soltou
			_obj_destino.quantidades[_slot_destino]--;
		
		
			// item da bolsa vai para o caldeirão
			_obj_origem.inventario[_slot_origem] =
				_item_destino;
		
			_obj_origem.quantidades[_slot_origem] = 1;
		
			_obj_origem.valores[_slot_origem] =
				_valor_destino;
		
		
			// pilha acabou
			if(_obj_destino.quantidades[_slot_destino] <= 0)
			{
				_obj_destino.inventario[_slot_destino] = -1;
				_obj_destino.quantidades[_slot_destino] = 0;
				_obj_destino.valores[_slot_destino] = undefined;
			}
		
			AtualizaSlotsInventario(_obj_origem);
		
			return;
		}
	
	
		// ==========================================
		// 2B. NÃO EXISTE PILHA DO ITEM DO CALDEIRÃO
		// ==========================================
	
	
		// ------------------------------------------
		// PILHA DO DESTINO TEM MAIS DE 1
		// ------------------------------------------
	
		if(_quantidade_destino > 1)
		{
			// primeiro slot vazio da bolsa
			var _slot_vazio = ProcuraInventario(
				_obj_destino,
				-1,
				false
			);
		
			if(_slot_vazio == -1)
			{
				return;
			}
		
		
			// item do caldeirão vai para o
			// primeiro slot vazio
			_obj_destino.inventario[_slot_vazio] =
				_item_origem;
		
			_obj_destino.quantidades[_slot_vazio] = 1;
		
			_obj_destino.valores[_slot_vazio] =
				_valor_origem;
		
		
			// tira UMA unidade da pilha original
			_obj_destino.quantidades[_slot_destino]--;
		
		
			// item que estava na bolsa vai para
			// o caldeirão
			_obj_origem.inventario[_slot_origem] =
				_item_destino;
		
			_obj_origem.quantidades[_slot_origem] = 1;
		
			_obj_origem.valores[_slot_origem] =
				_valor_destino;
		
		
			AtualizaSlotsInventario(_obj_origem);
		
			return;
		}
	
	
		// ------------------------------------------
		// PILHA DO DESTINO TEM EXATAMENTE 1
		// ------------------------------------------
	
		_obj_destino.inventario[_slot_destino] =
			_item_origem;
	
		_obj_destino.quantidades[_slot_destino] = 1;
	
		_obj_destino.valores[_slot_destino] =
			_valor_origem;
	
	
		_obj_origem.inventario[_slot_origem] =
			_item_destino;
	
		_obj_origem.quantidades[_slot_origem] = 1;
	
		_obj_origem.valores[_slot_origem] =
			_valor_destino;
	
	
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
		
		
		_obj_origem.inventario[_slot_origem] =
			_item_destino;
		
		_obj_origem.quantidades[_slot_origem] =
			_quantidade_destino;
		
		_obj_origem.valores[_slot_origem] =
			_valor_destino;
		
		
		_obj_destino.inventario[_slot_destino] =
			_item_origem;
		
		_obj_destino.quantidades[_slot_destino] =
			_quantidade_origem;
		
		_obj_destino.valores[_slot_destino] =
			_valor_origem;
		
		
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

function TransfereInventario(_obj_origem,_slot_origem,_obj_destino,_caldeirao_origem,_caldeirao_destino)
{
	var _item = _obj_origem.inventario[_slot_origem];
	var _valor = _obj_origem.valores[_slot_origem];
	
	// Nenhum item
	if(_item == -1)
	{
		return false;
	}
	
	
	// ==========================================
	// BOLSA -> CALDEIRÃO
	// ==========================================
	
	if(!_caldeirao_origem && _caldeirao_destino)
	{
		// Adiciona 1 unidade ao caldeirão,
		// levando junto o valor do int.
		var _adicionou = AdicionaInventario(
			_obj_destino,
			_item,
			_valor,
			true
		);
		
		if(!_adicionou)
		{
			return false;
		}
		
		
		// Remove UMA unidade da bolsa
		_obj_origem.quantidades[_slot_origem]--;
		
		// A pilha acabou
		if(_obj_origem.quantidades[_slot_origem] <= 0)
		{
			_obj_origem.inventario[_slot_origem] = -1;
			_obj_origem.quantidades[_slot_origem] = 0;
			_obj_origem.valores[_slot_origem] = undefined;
		}
		
		return true;
	}
	
	
	// ==========================================
	// CALDEIRÃO -> BOLSA
	// ==========================================
	
	if(_caldeirao_origem && !_caldeirao_destino)
	{
		// Adiciona 1 unidade à bolsa,
		// levando junto o valor do int.
		var _adicionou = AdicionaInventario(
			_obj_destino,
			_item,
			_valor,
			false
		);
		
		if(!_adicionou)
		{
			return false;
		}
		
		
		// Remove do caldeirão
		_obj_origem.inventario[_slot_origem] = -1;
		_obj_origem.quantidades[_slot_origem] = 0;
		_obj_origem.valores[_slot_origem] = undefined;
		
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
	
	
	// percorrendo somente os slots do caldeirão
	for(var i = 0; i < SLOTS_CALDEIRAO; i++)
	{
		var _item = _obj_caldeirao.inventario[i];
		var _valor = _obj_caldeirao.valores[i];
		
		// slot vazio
		if(_item == -1)
		{
			continue;
		}
		
		
		// tentando devolver o ingrediente para a bolsa
		var _adicionou = AdicionaInventario(
			_obj_bolsa,
			_item,
			_valor,
			false
		);
		
		
		// só remove do caldeirão se conseguiu
		// colocar na bolsa
		if(_adicionou)
		{
			_obj_caldeirao.inventario[i] = -1;
			_obj_caldeirao.quantidades[i] = 0;
			_obj_caldeirao.valores[i] = undefined;
		}
	}
	
	
	// atualiza quantidade de slots ativos
	AtualizaSlotsInventario(_obj_caldeirao);
}