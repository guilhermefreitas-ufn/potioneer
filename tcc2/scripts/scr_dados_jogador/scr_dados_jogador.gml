#macro SLOTS_HOTBAR_POCOES 5

function InicializaDadosJogador()
{
	if(variable_global_exists("DadosJogador"))
	{
		return;
	}
	
	global.DadosJogador =
	{
		// ==========================================
		// ARMÁRIO DE POÇÕES
		// ==========================================
		armario_pocoes: [],
		
		
		// ==========================================
		// HOTBAR DE POÇÕES
		// ==========================================
		hotbar_pocoes: array_create(
			SLOTS_HOTBAR_POCOES,
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

function PocaoNomeExisteNoArmario(_nome)
{
	var _nome_comparacao =
		string_lower(
			string_trim(_nome)
		);
	
	for(
		var i = 0;
		i < array_length(global.DadosJogador.armario_pocoes);
		i++
	)
	{
		var _pocao =
			global.DadosJogador.armario_pocoes[i];
		
		if(
			string_lower(
				string_trim(_pocao.nome)
			)
			== _nome_comparacao
		)
		{
			return true;
		}
	}
	
	return false;
}

// ==========================================
// VERIFICA SE A POÇÃO JÁ EXISTE
// ==========================================

function PocaoExisteNoArmario(_algoritmo)
{
	var _assinatura =
		AssinaturaAlgoritmo(_algoritmo);
	
	for(
		var i = 0;
		i < array_length(global.DadosJogador.armario_pocoes);
		i++
	)
	{
		var _pocao =
			global.DadosJogador.armario_pocoes[i];
		
		if(
			AssinaturaAlgoritmo(_pocao.algoritmo)
			== _assinatura
		)
		{
			return true;
		}
	}
	
	return false;
}

// ==========================================
// ADICIONA POÇÃO AO ARMÁRIO
// ==========================================

function AdicionaPocaoArmario(_nome,_algoritmo,_sentenca)
{
	var _pocao =
	{
		// ==========================================
		// IDENTIDADE
		// ==========================================
		
		nome: _nome,
		sentenca: _sentenca,
		
		// ==========================================
		// EXECUÇÃO
		// ==========================================
		
		algoritmo: _algoritmo,
		
		// ==========================================
		// VISUAL
		// ==========================================
		
		cor: c_white,
		sprite: undefined
	};
	
	array_push(
		global.DadosJogador.armario_pocoes,
		_pocao
	);
	
	return array_length(
		global.DadosJogador.armario_pocoes
	) - 1;
}

// ==========================================
// ASSINATURA DE UMA VARIÁVEL
// ==========================================

function AssinaturaVariavel(_expressao)
{
	if(is_undefined(_expressao))
	{
		return "undefined";
	}
	
	var _ing_variavel = IngredientePorNumero(
		_expressao.variavel
	);
	
	var _ing_alvo = IngredientePorNumero(
		_expressao.alvo
	);
	
	if(
		is_undefined(_ing_variavel)
		|| is_undefined(_ing_alvo)
	)
	{
		return "invalid";
	}
	
	// A ordem é sempre VARIAVEL + ALVO.
	// Portanto:
	// enemy hp == hp enemy
	return "VAR:"
		+ _ing_variavel.token
		+ ":ALVO:"
		+ _ing_alvo.token;
}

// ==========================================
// ASSINATURA DE UM VALOR
// ==========================================

function AssinaturaValor(_expressao)
{
	if(is_undefined(_expressao))
	{
		return "undefined";
	}
	
	// ==========================================
	// INT
	// ==========================================
	
	if(
		_expressao.tipo == TipoExpressao.VALOR
		&& _expressao.subtipo == TipoValor.INT
	)
	{
		return "INT:"
			+ string(_expressao.valor);
	}
	
	
	// ==========================================
	// VARIÁVEL
	// ==========================================
	
	if(_expressao.tipo == TipoExpressao.VARIAVEL)
	{
		return AssinaturaVariavel(
			_expressao
		);
	}
	
	return "invalid";
}

// ==========================================
// ASSINATURA DE UMA CONDIÇÃO
// ==========================================

function AssinaturaCondicao(_condicao)
{
	if(is_undefined(_condicao))
	{
		return "undefined";
	}
	
	var _ing_operador = IngredientePorNumero(
		_condicao.operador
	);
	
	if(is_undefined(_ing_operador))
	{
		return "invalid";
	}
	
	return "COND:"
		+ AssinaturaValor(_condicao.esquerda)
		+ ":OP:"
		+ _ing_operador.token
		+ ":"
		+ AssinaturaValor(_condicao.direita);
}

// ==========================================
// ASSINATURA DE UM EFEITO
// ==========================================

function AssinaturaEfeito(_efeito)
{
	if(is_undefined(_efeito))
	{
		return "undefined";
	}
	
	var _ing_operador = IngredientePorNumero(
		_efeito.operador
	);
	
	if(is_undefined(_ing_operador))
	{
		return "invalid";
	}
	
	return "EFEITO:"
		+ AssinaturaVariavel(_efeito.variavel)
		+ ":OP:"
		+ _ing_operador.token
		+ ":"
		+ AssinaturaValor(_efeito.valor);
}

// ==========================================
// ASSINATURA COMPLETA DA POÇÃO
// ==========================================

function AssinaturaAlgoritmo(_algoritmo)
{
	if(is_undefined(_algoritmo))
	{
		return "undefined";
	}
	
	var _ing_condicional = IngredientePorNumero(
		_algoritmo.condicional
	);
	
	if(is_undefined(_ing_condicional))
	{
		return "invalid";
	}
	
	return "ALGORITMO:"
		+ _ing_condicional.token
		+ ":"
		+ AssinaturaCondicao(_algoritmo.condicao)
		+ ":"
		+ AssinaturaEfeito(_algoritmo.efeito);
}