
function LerCaldeirao(_caldeirao)
{
	var _tokens = [];
	
	for (var i = 0; i < _caldeirao.slots_ativos; i++)
	{
		var _numero = _caldeirao.inventario[i];
		
		//Slot vazio: ignorar
		if (_numero == -1)
		{
			continue;
		}
		
		var _ing = IngredientePorNumero(_numero);
		
		if(is_undefined(_ing))
		{
			continue;
		}
		
		array_push(_tokens,
		{
			numero: _numero,
			slot: i,
			ingrediente: _ing
		});
	}
	
	return _tokens;
}

function CriarExpressaoVariavel(_variavel, _alvo)
{
	return
	{
		tipo: TipoExpressao.VARIAVEL,
		variavel: _variavel,
		alvo: _alvo
	};
}

function CriarExpressaoInt()
{
	return
	{
		tipo: TipoExpressao.VALOR,
		subtipo: "int"
	};
}

function LerExpressaoVariavel(_tokens, _indice)
{
	var _resultado =
	{
		sucesso: false,
		proximo_indice: _indice,
		expressao: undefined,
		erro: ""
	};
	
	if(_indice >= array_length(_tokens))
	{
		_resultado.erro = "Esperada uma variável.";
		return _resultado;
	}
	
	var _token_a = _tokens[_indice];
	var _tipo_a = _token_a.ingrediente.tipo;
	
	//ALVO + VARIÁVEL
	if(_tipo_a == TipoIngrediente.ALVO)
	{
		if (_indice + 1 >= array_length(_tokens))
		{
			_resultado.erro = "O alvo precisa de uma variável.";
			return _resultado;
		}
		
		var _token_b = _tokens[_indice + 1];
		
		if (_token_b.ingrediente.tipo != TipoIngrediente.VARIAVEL)
		{
			_resultado.erro =
				"Esperada uma variável depois de " + _token_a.ingrediente.nome + ".";
			
			return _resultado;
		}
		
		_resultado.sucesso = true;
		_resultado.proximo_indice = _indice + 2;
		_resultado.expressao = CriarExpressaoVariavel(
			_token_a.ingrediente.nome,
			_token_b.ingrediente.nome
		);
		
		return _resultado;
	}
	
	//VARIÁVEL + ALVO
	if(_tipo_a == TipoIngrediente.VARIAVEL)
	{
		if(_indice + 1 >= array_length(_tokens))
		{
			_resultado.erro = "A variável precisa de um alvo: target, ally ou enemy.";
			
			return _resultado;
		}
		
		var _token_b = _tokens[_indice + 1];
		
		if(_token_b.ingrediente.tipo != TipoIngrediente.ALVO)
		{
			_resultado.erro = "A variável " + _token_a.ingrediente.nome + " precisa de um alvo.";
			
			return _resultado;
		}
		
		_resultado.sucesso = true;
		_resultado.proximo_indice = _indice + 2;
		_resultado.expressao = CriarExpressaoVariavel(
			_token_b.ingrediente.nome,
			_token_a.ingrediente.nome
		);
		
		return _resultado;
	}
	
	_resultado.erro = "Esperada uma variável.";
	
	return _resultado;
}

function CriarExpressaoValor(_tipo)
{
	return
	{
		tipo: "valor",
		subtipo: _tipo.nome
	};
}

function LerExpressaoValor(_tokens, _indice)
{
	var _resultado =
	{
		sucesso: false,
		proximo_indice: _indice,
		expressao: undefined,
		erro: ""
	};
	
	if (_indice >= array_length(_tokens))
	{
		_resultado.erro = "Esperado um valor.";
		return _resultado;
	}
	
	var _token = _tokens[_indice];
	
	if (_token.ingrediente.tipo != TipoIngrediente.PRIMITIVO)
	{
		_resultado.erro = "Esperado um valor.";
		return _resultado;
	}
	
	_resultado.sucesso = true;
	_resultado.proximo_indice = _indice + 1;
	_resultado.expressao = CriarExpressaoValor(_token.ingrediente);
	
	return _resultado;
}