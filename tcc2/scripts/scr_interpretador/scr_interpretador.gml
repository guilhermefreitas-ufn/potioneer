enum TipoExpressao
{
	VARIAVEL,
	VALOR
}

//diferenciando "int" de "variavel + alvo"
enum TipoValor
{
	INT,
	VARIAVEL
}

function LerCaldeirao(_caldeirao)
{
	var _tokens = [];
	
	//percorrendo o caldeirão
	for(var i = 0; i < _caldeirao.slots_ativos; i++)
	{
		var _numero = _caldeirao.inventario[i];
		
		//slot vazio
		if(_numero == -1)
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
			ingrediente: _ing,
			valor: _caldeirao.valores[i]
		});
	}
	
	return _tokens;
}

//transformar um token em texto
function TextoToken(_token)
{
	//INT -> usa o valor armazenado no token
	if(_token.numero == INGREDIENTE_INT)
	{
		return string(_token.valor);
	}
	
	//demais ingredientes -> usa o elemento
	return _token.ingrediente.elemento;
}

//criando a "frase" da poção
function MontaSentenca(_tokens)
{
	var _texto = "";
	var _qtd_tokens = array_length(_tokens);
	
	//caldeirão vazio
	if(_qtd_tokens == 0)
	{
		return " ";
	}
	
	//PRIMEIRO INGREDIENTE
	var _primeiro = _tokens[0];
	
	_texto += TextoToken(_primeiro);
	
	//"ENTÃO" SÓ EXISTE SE HOUVER "if"
	if(_primeiro.ingrediente.token != "if")
	{
		//não é if -> simplesmente monta a sentença normalmente
		for(var i = 1; i < _qtd_tokens; i++)
		{
			_texto += " ";
			_texto += TextoToken(_tokens[i]);
		}
		
		return _texto;
	}
	
	//PROCURANDO ONDE A CONDIÇÃO TERMINA
	var _inicio_efeito = -1;
	
	if(_qtd_tokens > 1)
	{
		var _condicao = AnalisaCondicao(_tokens, 1);
		
		if(_condicao.sucesso)
		{
			_inicio_efeito = _condicao.proximo_indice;
		}
	}
	
	//ADICIONANDO OS INGREDIENTES
	for(var i = 1; i < _qtd_tokens; i++)
	{
		
		//AINDA ESTAMOS NA CONDIÇÃO
		if(_inicio_efeito == -1 || i < _inicio_efeito)
		{
			_texto += " ";
			_texto += TextoToken(_tokens[i]);
		}
		
		//COMEÇO DO EFEITO
		else
		{
			//adiciona "então" uma única vez
			if(i == _inicio_efeito)
			{
				_texto += ", então";
			}
			
			_texto += " ";
			_texto += TextoToken(_tokens[i]);
		}
	}
	
	//CONDIÇÃO AINDA INCOMPLETA
	if(_inicio_efeito == -1)
	{
		_texto += ", então";
	}
	
	//CONDIÇÃO COMPLETA, MAS SEM EFEITO
	else if(_inicio_efeito == _qtd_tokens)
	{
		_texto += ", então";
	}
	
	return _texto;
}

//garantindo que "variavel + alvo" é igual a "alvo + variavel"
function CriarExpressaoVariavel(_variavel_numero, _alvo_numero, _slot_variavel, _slot_alvo)
{
	return {
		tipo: TipoExpressao.VARIAVEL,
		
		variavel: _variavel_numero,
		alvo: _alvo_numero,
		
		slot_variavel: _slot_variavel,
		slot_alvo: _slot_alvo
	};
}

//garantindo que Variável precisa de Alvo e vice-versa
function LerVariavel(_tokens, _indice)
{
	var _resultado =
	{
		sucesso: false,
		proximo_indice: _indice,
		expressao: undefined,
		erro: "",
		slot_erro: -1
	};
	
	if(_indice >= array_length(_tokens))
	{
		_resultado.erro = "Esperado um atributo.";
		return _resultado;
	}
	
	var _a = _tokens[_indice];
	var _tipo_a = _a.ingrediente.tipo;
	
	//ALVO + VARIÁVEL
	//Exemplo: enemy life
	if(_tipo_a == TipoIngrediente.ALVO)
	{
		if(_indice + 1 >= array_length(_tokens))
		{
			_resultado.erro =
				"O alvo \"" + _a.ingrediente.elemento +
				"\" precisa de um atributo: \"saúde\", \"força\" ou \"velocidade\".";
			
			_resultado.slot_erro = _a.slot;
			
			return _resultado;
		}
		
		var _b = _tokens[_indice + 1];
		
		if(_b.ingrediente.tipo != TipoIngrediente.VARIAVEL)
		{
			_resultado.erro =
				"O alvo \"" + _a.ingrediente.elemento +
				"\" precisa ser seguido por um atributo.";
			
			_resultado.slot_erro = _b.slot;
			
			return _resultado;
		}
		
		_resultado.sucesso = true;
		_resultado.proximo_indice = _indice + 2;
		
		_resultado.expressao = CriarExpressaoVariavel(
			_b.numero,
			_a.numero,
			_b.slot,
			_a.slot
		);
		
		return _resultado;
	}
	
	//VARIÁVEL + ALVO
	//Exemplo: life enemy
	if(_tipo_a == TipoIngrediente.VARIAVEL)
	{
		if(_indice + 1 >= array_length(_tokens))
		{
			_resultado.erro =
				"O atributo \"" + _a.ingrediente.elemento +
				"\" precisa de um alvo: \"aliado\", \"inimigo\", \"alvo\".";
			
			_resultado.slot_erro = _a.slot;
			
			return _resultado;
		}
		
		var _b = _tokens[_indice + 1];
		
		if(_b.ingrediente.tipo != TipoIngrediente.ALVO)
		{
			_resultado.erro =
				"A variável '" + _a.ingrediente.elemento +
				"' precisa de um alvo.";
			
			_resultado.slot_erro = _b.slot;
			
			return _resultado;
		}
		
		_resultado.sucesso = true;
		_resultado.proximo_indice = _indice + 2;
		
		_resultado.expressao = CriarExpressaoVariavel(
			_a.numero,
			_b.numero,
			_a.slot,
			_b.slot
		);
		
		return _resultado;
	}
	
	_resultado.erro = "Esperado um atributo.";
	_resultado.slot_erro = _a.slot;
	
	return _resultado;
}

//criar int
function CriarExpressaoInt(_numero, _slot, _valor)
{
	return
	{
		tipo: TipoExpressao.VALOR,
		subtipo: TipoValor.INT,
		
		ingrediente: _numero,
		slot: _slot,
		valor: _valor
	};
}

//valor = int OU = variavel + alvo OU alvo + variavel
function LerValor(_tokens, _indice)
{
	var _resultado =
	{
		sucesso: false,
		proximo_indice: _indice,
		expressao: undefined,
		erro: "",
		slot_erro: -1
	};
	
	if(_indice >= array_length(_tokens))
	{
		_resultado.erro = "Esperado um valor.";
		return _resultado;
	}
	
	var _token = _tokens[_indice];
	
	//INT
	if(_token.numero == INGREDIENTE_INT)
	{
		_resultado.sucesso = true;
		_resultado.proximo_indice = _indice + 1;
	
		_resultado.expressao =
			CriarExpressaoInt(
				_token.numero,
				_token.slot,
				_token.valor
			);
	
		return _resultado;
	}
	
	//VARIÁVEL + ALVO ou ALVO + VARIÁVEL
	if(
		_token.ingrediente.tipo == TipoIngrediente.VARIAVEL ||
		_token.ingrediente.tipo == TipoIngrediente.ALVO
	)
	{
		var _variavel = LerVariavel(_tokens, _indice);
		
		if(!_variavel.sucesso)
		{
			_resultado.erro = _variavel.erro;
			_resultado.slot_erro = _variavel.slot_erro;
			return _resultado;
		}
		
		_resultado.sucesso = true;
		_resultado.proximo_indice = _variavel.proximo_indice;
		_resultado.expressao = _variavel.expressao;
		
		return _resultado;
	}
	
	_resultado.erro =
		"\"" + _token.ingrediente.elemento +
		"\" não pode ser usado como valor.";
	
	_resultado.slot_erro = _token.slot;
	
	return _resultado;
}

//criando condição
function CriarCondicao(_esquerda, _operador, _direita)
{
	return
	{
		tipo: "condicao",
		
		esquerda: _esquerda,
		operador: _operador,
		direita: _direita
	};
}

//CONDIÇÃO = VALOR + OPERADOR_COMPARAÇÃO + VALOR
function AnalisaCondicao(_tokens, _indice)
{
	var _resultado =
	{
		sucesso: false,
		proximo_indice: _indice,
		condicao: undefined,
		erro: "",
		slot_erro: -1
	};
	
	//LADO ESQUERDO
	var _esquerda = LerValor(_tokens, _indice);
	
	if(!_esquerda.sucesso)
	{
		_resultado.erro = _esquerda.erro;
		_resultado.slot_erro = _esquerda.slot_erro;
		return _resultado;
	}
	
	_indice = _esquerda.proximo_indice;
	
	//OPERADOR
	if(_indice >= array_length(_tokens))
	{
		_resultado.erro =
			"Esperado um comparador.";
		
		return _resultado;
	}
	
	var _operador = _tokens[_indice];
	
	if(_operador.ingrediente.tipo != TipoIngrediente.OPERADOR_COMPARACAO)
	{
		_resultado.erro =
			"Esperado um comparador.";
		
		_resultado.slot_erro = _operador.slot;
		
		return _resultado;
	}
	
	_indice++;
	
	//LADO DIREITO
	var _direita = LerValor(_tokens, _indice);
	
	if(!_direita.sucesso)
	{
		_resultado.erro = _direita.erro;
		_resultado.slot_erro = _direita.slot_erro;
		return _resultado;
	}
	
	_indice = _direita.proximo_indice;
	
	//SUCESSO
	_resultado.sucesso = true;
	_resultado.proximo_indice = _indice;
	
	_resultado.condicao = CriarCondicao(
		_esquerda.expressao,
		_operador.numero,
		_direita.expressao
	);
	
	return _resultado;
}

//criando efeito
function CriarEfeito(_variavel, _operador, _valor)
{
	return
	{
		tipo: "efeito",
		
		variavel: _variavel,
		operador: _operador,
		valor: _valor
	};
}

//EFEITO = VARIÁVEL + OPERADOR_EFEITO + VALOR
//o lado esquerdo NÃO pode ser "int"
function AnalisaEfeito(_tokens, _indice)
{
	var _resultado =
	{
		sucesso: false,
		proximo_indice: _indice,
		efeito: undefined,
		erro: "",
		slot_erro: -1
	};
	
	//VARIÁVEL DO EFEITO
	var _variavel = LerVariavel(_tokens, _indice);
	
	if(!_variavel.sucesso)
	{
		_resultado.erro =
			"Esperado um atributo para o efeito. " +
			_variavel.erro;
		
		_resultado.slot_erro = _variavel.slot_erro;
		
		return _resultado;
	}
	
	_indice = _variavel.proximo_indice;
	
	//OPERADOR DO EFEITO
	if(_indice >= array_length(_tokens))
	{
		_resultado.erro =
			"Esperado um operador.";
		
		return _resultado;
	}
	
	var _operador = _tokens[_indice];
	
	if(_operador.ingrediente.tipo != TipoIngrediente.OPERADOR_EFEITO)
	{
		_resultado.erro =
			"Esperado um operador.";
		
		_resultado.slot_erro = _operador.slot;
		
		return _resultado;
	}
	
	_indice++;

	//VALOR DO EFEITO
	var _valor = LerValor(_tokens, _indice);
	
	if(!_valor.sucesso)
	{
		_resultado.erro = _valor.erro;
		_resultado.slot_erro = _valor.slot_erro;
		return _resultado;
	}
	
	_indice = _valor.proximo_indice;
	
	//SUCESSO
	_resultado.sucesso = true;
	_resultado.proximo_indice = _indice;
	
	_resultado.efeito = CriarEfeito(
		_variavel.expressao,
		_operador.numero,
		_valor.expressao
	);
	
	return _resultado;
}

//criando algoritmo
function CriarAlgoritmo(_condicional, _condicao, _efeito)
{
	return
	{
		tipo: "algoritmo",
		
		condicional: _condicional,
		condicao: _condicao,
		efeito: _efeito
	};
}

//criando algoritmo VÁLIDO
function AnalisaSintaxe(_tokens)
{
	var _resultado =
	{
		valido: false,
		algoritmo: undefined,
		erro: "",
		slot_erro: -1
	};
	
	//ALGORITMO VAZIO
	if(array_length(_tokens) == 0)
	{
		_resultado.erro = "O caldeirão está vazio.";
		return _resultado;
	}
	
	var _indice = 0;
	
	//CONDICIONAL
	var _primeiro = _tokens[_indice];
	
	if(_primeiro.ingrediente.tipo != TipoIngrediente.CONDICIONAL)
	{
		_resultado.erro =
			"Um algoritmo deve começar com uma condicional.";
		
		_resultado.slot_erro = _primeiro.slot;
		
		return _resultado;
	}
	
	var _condicional = _primeiro.numero;
	
	_indice++;
	
	//CONDIÇÃO
	var _condicao = AnalisaCondicao(_tokens, _indice);
	
	if(!_condicao.sucesso)
	{
		_resultado.erro = _condicao.erro;
		_resultado.slot_erro = _condicao.slot_erro;
		
		return _resultado;
	}
	
	_indice = _condicao.proximo_indice;
	
	//EFEITO
	var _efeito = AnalisaEfeito(_tokens, _indice);
	
	if(!_efeito.sucesso)
	{
		_resultado.erro = _efeito.erro;
		_resultado.slot_erro = _efeito.slot_erro;
		
		return _resultado;
	}
	
	_indice = _efeito.proximo_indice;
	
	//NÃO PODEM SOBRAR TOKENS
	if(_indice < array_length(_tokens))
	{
		var _extra = _tokens[_indice];
		
		_resultado.erro =
			"O algoritmo possui ingredientes extras após o efeito.";
		
		_resultado.slot_erro = _extra.slot;
		
		return _resultado;
	}

	//SUCESSO
	_resultado.valido = true;
	
	_resultado.algoritmo = CriarAlgoritmo(
		_condicional,
		_condicao.condicao,
		_efeito.efeito
	);
	
	return _resultado;
}

//principal função
function InterpretarCaldeirao(_caldeirao)
{
	var _resultado =
	{
		sucesso: false,
		
		tokens: [],
		sentenca: "",
		algoritmo: undefined,
		
		sintaxe_valida: false,
		semantica_valida: false,
		
		erro_sintaxe: "",
		erro_semantica: "",
		
		slot_erro: -1
	};
	
	//1. LER
	_resultado.tokens = LerCaldeirao(_caldeirao);
	
	//2. SENTENÇA
	_resultado.sentenca = MontaSentenca(_resultado.tokens);
	
	//3. SINTAXE
	var _sintaxe = AnalisaSintaxe(_resultado.tokens);
	
	if(!_sintaxe.valido)
	{
		_resultado.erro_sintaxe =
			_sintaxe.erro;
		
		_resultado.slot_erro =
			_sintaxe.slot_erro;
		
		return _resultado;
	}
	
	_resultado.sintaxe_valida = true;
	_resultado.algoritmo = _sintaxe.algoritmo;
	
	//4. SEMÂNTICA
	var _semantica = AnalisaSemantica(_resultado.algoritmo);
	
	if(!_semantica.valido)
	{
		_resultado.erro_semantica =
			_semantica.erro;
		
		_resultado.slot_erro =
			_semantica.slot_erro;
		
		return _resultado;
	}
	
	_resultado.semantica_valida = true;
	_resultado.sucesso = true;
	
	return _resultado;
}

//ainda sem as regras do jogo
function AnalisaSemantica(_algoritmo)
{
	return
	{
		valido: true,
		erro: "",
		slot_erro: -1
	};
	
	/*
	Mais tarde, adicionar coisas como:
	> "[enemy][life]" é um VARIAVEL válida?
	> "[greater]" aceita esses dois valores?
	> "[becomes]" pode receber uma variável?
	> "[hp]" pode ser comparada com "[atk]"?
	*/
}