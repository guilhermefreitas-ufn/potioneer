#macro SLOTS_POCOES 5

function InicializaDadosJogador()
{
	if(variable_global_exists("DadosJogador"))
	{
		return;
	}
	
	global.DadosJogador =
	{
		// ==========================================
		// POÇÕES
		// ==========================================
		pocoes: array_create(
			SLOTS_POCOES,
			undefined
		),
		
		// ==========================================
		// BOLSA
		// ==========================================
		bolsa_inventario: array_create(
			SLOTS_BOLSA,
			-1
		),
		
		bolsa_quantidades: array_create(
			SLOTS_BOLSA,
			0
		),
		
		bolsa_valores: array_create(
			SLOTS_BOLSA,
			undefined
		)
	};
}

function AdicionaPocao(_algoritmo, _sentenca)
{
	for(var i = 0; i < SLOTS_POCOES; i++)
	{
		if(is_undefined(global.DadosJogador.pocoes[i]))
		{
			global.DadosJogador.pocoes[i] =
			{
				algoritmo: _algoritmo,
				sentenca: _sentenca
			};
			
			return i;
		}
	}
	
	return -1;
}

function SincronizaBolsaGlobal(_bolsa)
{
	if(_bolsa == noone)
	{
		return;
	}
	
	global.DadosJogador.bolsa_inventario = _bolsa.inventario;
	
	global.DadosJogador.bolsa_quantidades = _bolsa.quantidades;
	
	global.DadosJogador.bolsa_valores = _bolsa.valores;
}

function CarregaBolsaGlobal(_bolsa)
{
	_bolsa.inventario = global.DadosJogador.bolsa_inventario;
	
	_bolsa.quantidades = global.DadosJogador.bolsa_quantidades;
	
	_bolsa.valores = global.DadosJogador.bolsa_valores;
}

function AdicionaIngredienteGlobal(_tipo_item, _valor = undefined)
{
	// ==========================================
	// PROCURANDO UMA PILHA COMPATÍVEL
	// ==========================================
	
	for(var i = 0; i < SLOTS_BOLSA; i++)
	{
		// slot vazio
		if(global.DadosJogador.bolsa_inventario[i] == -1)
		{
			continue;
		}
		
		// ingrediente diferente
		if(global.DadosJogador.bolsa_inventario[i] != _tipo_item)
		{
			continue;
		}
		
		// INT: o valor também precisa ser igual
		if(_tipo_item == INGREDIENTE_INT
		&& global.DadosJogador.bolsa_valores[i] != _valor)
		{
			continue;
		}
		
		// encontrou a pilha
		global.DadosJogador.bolsa_quantidades[i]++;
		
		return true;
	}
	
	
	// ==========================================
	// NÃO EXISTE PILHA COMPATÍVEL
	// ==========================================
	
	for(var i = 0; i < SLOTS_BOLSA; i++)
	{
		if(global.DadosJogador.bolsa_inventario[i] == -1)
		{
			global.DadosJogador.bolsa_inventario[i] = _tipo_item;
			global.DadosJogador.bolsa_quantidades[i] = 1;
			global.DadosJogador.bolsa_valores[i] = _valor;
			
			return true;
		}
	}
	
	return false;
}