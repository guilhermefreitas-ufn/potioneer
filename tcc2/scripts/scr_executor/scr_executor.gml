function CriarContextoPocao(_entidades_target, _entidades_ally, _entidades_enemy)
{
	return
	{
		entidades_target: _entidades_target,
		entidades_ally: _entidades_ally,
		entidades_enemy: _entidades_enemy
	};
}

function EntidadesDoAlvo(_alvo_numero, _contexto)
{
	var _ing = IngredientePorNumero(_alvo_numero);
	
	if(is_undefined(_ing))
	{
		return [];
	}
	
	switch(_ing.token)
	{
		case "target":
			return _contexto.entidades_target;
			
		case "ally":
			return _contexto.entidades_ally;
			
		case "enemy":
			return _contexto.entidades_enemy;
	}
	
	return [];
}

function ResolveVariavel(_expressao, _entidade)
{
	if(is_undefined(_expressao))
	{
		return undefined;
	}
	
	if(_entidade == noone || !instance_exists(_entidade))
	{
		return undefined;
	}
	
	var _ing_variavel = IngredientePorNumero(
		_expressao.variavel
	);
	
	if(is_undefined(_ing_variavel))
	{
		return undefined;
	}
	
	switch(_ing_variavel.token)
	{
		case "hp":
			return _entidade.hp;
			
		case "spd":
			return _entidade.spd;
			
		case "atk":
			return _entidade.atk;
	}
	
	return undefined;
}

function ResolveValor(_expressao, _entidade)
{
	if(is_undefined(_expressao))
	{
		return undefined;
	}
	
	
	//INT
	
	if(
		_expressao.tipo == TipoExpressao.VALOR
		&& _expressao.subtipo == TipoValor.INT
	)
	{
		return _expressao.valor;
	}
	
	
	//VARIÁVEL
	
	if(_expressao.tipo == TipoExpressao.VARIAVEL)
	{
		return ResolveVariavel(
			_expressao,
			_entidade
		);
	}
	
	return undefined;
}

function VerificaComparacao(_operador_numero, _esquerda, _direita)
{
	var _ing_operador = IngredientePorNumero(
		_operador_numero
	);
	
	if(is_undefined(_ing_operador))
	{
		return false;
	}
	
	switch(_ing_operador.token)
	{
		case "greater":
			return _esquerda > _direita;
			
		case "lower":
			return _esquerda < _direita;
			
		case "equal":
			return _esquerda == _direita;
	}
	
	return false;
}

function ExecutaCondicao(_condicao, _contexto)
{
	var _resultado =
	{
		verdadeira: false,
		mensagem: "",
		
		entidade_esquerda: noone,
		entidade_direita: noone
	};
	
	
	
	//TIPO DE CADA LADO
	
	
	var _esquerda_variavel =
		_condicao.esquerda.tipo == TipoExpressao.VARIAVEL;
		
	var _direita_variavel =
		_condicao.direita.tipo == TipoExpressao.VARIAVEL;
	
	
	
	//ENTIDADES DO LADO ESQUERDO
	
	
	var _esquerdas = [];
	
	if(_esquerda_variavel)
	{
		_esquerdas = EntidadesDoAlvo(
			_condicao.esquerda.alvo,
			_contexto
		);
		
		if(array_length(_esquerdas) == 0)
		{
			var _ing_alvo = IngredientePorNumero(
				_condicao.esquerda.alvo
			);
			
			if(!is_undefined(_ing_alvo))
			{
				_resultado.mensagem =
					"Nenhum " + _ing_alvo.elemento +
					" atingido.";
			}
			
			return _resultado;
		}
	}
	else
	{
		//INT não depende de nenhuma entidade
		_esquerdas = [noone];
	}
	
	
	
	//ENTIDADES DO LADO DIREITO
	
	
	var _direitas = [];
	
	if(_direita_variavel)
	{
		_direitas = EntidadesDoAlvo(
			_condicao.direita.alvo,
			_contexto
		);
		
		if(array_length(_direitas) == 0)
		{
			var _ing_alvo = IngredientePorNumero(
				_condicao.direita.alvo
			);
			
			if(!is_undefined(_ing_alvo))
			{
				_resultado.mensagem =
					"Nenhum " + _ing_alvo.elemento +
					" atingido.";
			}
			
			return _resultado;
		}
	}
	else
	{
		//INT não depende de nenhuma entidade
		_direitas = [noone];
	}
	
	
	
	//TESTANDO TODAS AS COMBINAÇÕES
	
	
	for(var i = 0; i < array_length(_esquerdas); i++)
	{
		var _entidade_esquerda = _esquerdas[i];
		
		var _valor_esquerda = ResolveValor(
			_condicao.esquerda,
			_entidade_esquerda
		);
		
		if(is_undefined(_valor_esquerda))
		{
			continue;
		}
		
		
		for(var j = 0; j < array_length(_direitas); j++)
		{
			var _entidade_direita = _direitas[j];
			
			var _valor_direita = ResolveValor(
				_condicao.direita,
				_entidade_direita
			);
			
			if(is_undefined(_valor_direita))
			{
				continue;
			}
			
			
			if(
				VerificaComparacao(
					_condicao.operador,
					_valor_esquerda,
					_valor_direita
				)
			)
			{
				
				//PRIMEIRO TRUE
				
				
				_resultado.verdadeira = true;
				
				_resultado.entidade_esquerda =
					_entidade_esquerda;
					
				_resultado.entidade_direita =
					_entidade_direita;
				
				return _resultado;
			}
		}
	}
	
	
	
	//NENHUMA COMBINAÇÃO FOI VERDADEIRA
	
	
	_resultado.mensagem =
		"A condição não foi satisfeita.";
	
	return _resultado;
}

// ==================================================
// ATUALIZA O ESTADO APÓS UMA ALTERAÇÃO DE HP
// ==================================================

function AtualizaEstadoAposDano(_alvo, _hp_anterior)
{
    if (
        _alvo == noone
        || !instance_exists(_alvo)
    )
    {
        return;
    }

    if (!variable_instance_exists(_alvo, "hp"))
    {
        return;
    }

    // Só reage se a vida realmente diminuiu
    if (_alvo.hp >= _hp_anterior)
    {
        return;
    }

    // A morte tem prioridade sobre o estado sofrendo
    //if (_alvo.hp <= 0)
    //{
    //    if (variable_instance_exists(_alvo, "MudaEstado"))
    //    {
    //        _alvo.MudaEstado("morto");
    //    }
	//
    //    return;
    //}

    // Comunica que o alvo sofreu dano
    if (variable_instance_exists(_alvo, "MudaEstado"))
    {
        _alvo.MudaEstado("sofrendo");
    }
}

// ==================================================
// APLICA DANO DIRETO A UMA ENTIDADE
// ==================================================

function AplicaDanoEntidade(_alvo, _dano)
{
    if (
        _alvo == noone
        || !instance_exists(_alvo)
        || _dano <= 0
    )
    {
        return false;
    }

    if (!variable_instance_exists(_alvo, "hp"))
    {
        return false;
    }

    var _hp_anterior = _alvo.hp;

    _alvo.hp = max(
        0,
        _alvo.hp - _dano
    );

    AtualizaEstadoAposDano(
        _alvo,
        _hp_anterior
    );

    return _alvo.hp < _hp_anterior;
}

function AplicaOperacao(_entidade, _variavel, _operador_numero, _valor)
{
	if(_entidade == noone || !instance_exists(_entidade))
	{
		return false;
	}

	var _ing_variavel = IngredientePorNumero(
		_variavel.variavel
	);

	var _ing_operador = IngredientePorNumero(
		_operador_numero
	);

	if(
		is_undefined(_ing_variavel)
		|| is_undefined(_ing_operador)
	)
	{
		return false;
	}

	switch(_ing_variavel.token)
	{
		// HP
		case "hp":
		{
		    var _hp_anterior = _entidade.hp;

		    switch (_ing_operador.token)
		    {
		        case "decreases":
		            _entidade.hp -= _valor;
		            break;

		        case "increases":
		            _entidade.hp += _valor;
		            break;

		        case "becomes":
		            _entidade.hp = _valor;
		            break;

		        default:
		            return false;
		    }

		    // Limite de vida entre 0 e 20
		    if (_entidade.hp > 20)
		    {
		        show_debug_message(
		            "LIMITE DE HP: a poção tentou ultrapassar "
		            + "a vida máxima de 20. Valor ajustado para 20."
		        );
		    }

		    _entidade.hp = clamp(
		        _entidade.hp,
		        0,
		        20
		    );

		    // Atualiza o estado se houve perda de vida
		    AtualizaEstadoAposDano(
		        _entidade,
		        _hp_anterior
		    );

		    return true;
		}

		//SPD
		case "spd":
		{
			switch(_ing_operador.token)
			{
				case "decreases":
					_entidade.spd -= _valor;
					break;

				case "increases":
					_entidade.spd += _valor;
					break;

				case "becomes":
					_entidade.spd = _valor;
					break;

				default:
					return false;
			}

			//Velocidade entre 0 e 10
			if(_entidade.spd > 10)
			{
			    show_debug_message(
			        "LIMITE DE SPD: a poção tentou ultrapassar a velocidade máxima de 10. Valor ajustado para 10."
			    );
			}
			_entidade.spd = clamp(
				_entidade.spd,
				0,
				10
			);

			return true;
		}

		//ATK
		case "atk":
		{
			switch(_ing_operador.token)
			{
				case "decreases":
					_entidade.atk -= _valor;
					break;

				case "increases":
					_entidade.atk += _valor;
					break;

				case "becomes":
					_entidade.atk = _valor;
					break;

				default:
					return false;
			}
			
			//Ataque >= 0
			_entidade.atk = max(
				_entidade.atk,
				0,
			);

			return true;
		}
	}

	return false;
}

function ExecutaEfeito(_efeito, _contexto)
{
	var _resultado =
	{
		aplicado: false,
		entidades_afetadas: [],
		mensagem: ""
	};
	
	
	//QUEM RECEBE O EFEITO?
	
	var _entidades = EntidadesDoAlvo(
		_efeito.variavel.alvo,
		_contexto
	);
	
	if(array_length(_entidades) == 0)
	{
		var _ing_alvo = IngredientePorNumero(
			_efeito.variavel.alvo
		);
		
		if(!is_undefined(_ing_alvo))
		{
			_resultado.mensagem =
				"Nenhum " + _ing_alvo.elemento +
				" atingido.";
		}
		
		return _resultado;
	}
	
	
	//VALOR DO EFEITO
	
	var _valor = ResolveValorEfeito(
		_efeito.valor,
		_contexto
	);
	
	if(is_undefined(_valor))
	{
		_resultado.mensagem =
			"Não foi possível determinar o valor do efeito.";
		
		return _resultado;
	}
	
	
	//APLICANDO UMA VEZ POR ENTIDADE
	
	for(var i = 0; i < array_length(_entidades); i++)
	{
		var _entidade = _entidades[i];
		
		if(_entidade == noone
		|| !instance_exists(_entidade))
		{
			continue;
		}
		
		if(AplicaOperacao(
			_entidade,
			_efeito.variavel,
			_efeito.operador,
			_valor
		))
		{
			array_push(
				_resultado.entidades_afetadas,
				_entidade
			);
		}
	}
	
	if(array_length(_resultado.entidades_afetadas) > 0)
	{
		_resultado.aplicado = true;
	}
	else
	{
		_resultado.mensagem =
			"Nenhum efeito pôde ser aplicado.";
	}
	
	return _resultado;
}

function ExecutaAlgoritmo(_algoritmo, _contexto)
{
	var _resultado =
	{
		sucesso: false,
		
		condicao: false,
		efeito_aplicado: false,
		
		entidades_afetadas: [],
		
		mensagem: ""
	};
	
	
	//ALGORITMO INVÁLIDO
	
	if(is_undefined(_algoritmo))
	{
		_resultado.mensagem =
			"Algoritmo inválido.";
		
		return _resultado;
	}
	
	
	//CONDIÇÃO
	
	var _condicao = ExecutaCondicao(
		_algoritmo.condicao,
		_contexto
	);
	
	if(!_condicao.verdadeira)
	{
		_resultado.mensagem =
			_condicao.mensagem;
		
		return _resultado;
	}
	
	_resultado.condicao = true;
	
	
	//EFEITO
	
	var _efeito = ExecutaEfeito(
		_algoritmo.efeito,
		_contexto
	);
	
	_resultado.entidades_afetadas =
		_efeito.entidades_afetadas;
	
	if(!_efeito.aplicado)
	{
		_resultado.mensagem =
			_efeito.mensagem;
		
		return _resultado;
	}
	
	_resultado.efeito_aplicado = true;
	_resultado.sucesso = true;
	
	return _resultado;
}

function ResolveValorEfeito(_expressao, _contexto)
{
	if(is_undefined(_expressao))
	{
		return undefined;
	}
	
	
	//INT
	
	if(
		_expressao.tipo == TipoExpressao.VALOR
		&& _expressao.subtipo == TipoValor.INT
	)
	{
		return _expressao.valor;
	}
	
	
	//VARIÁVEL
	
	if(_expressao.tipo == TipoExpressao.VARIAVEL)
	{
		var _entidades = EntidadesDoAlvo(
			_expressao.alvo,
			_contexto
		);
		
		if(array_length(_entidades) == 0)
		{
			return undefined;
		}
		
		var _maior = undefined;
		
		for(var i = 0; i < array_length(_entidades); i++)
		{
			var _valor = ResolveVariavel(
				_expressao,
				_entidades[i]
			);
			
			if(is_undefined(_valor))
			{
				continue;
			}
			
			if(is_undefined(_maior)
			|| _valor > _maior)
			{
				_maior = _valor;
			}
		}
		
		return _maior;
	}
	
	return undefined;
}

//teste
function CriaContextoAreaPocao(_x, _y, _raio)
{
	var _targets = [];
	var _allies = [];
	var _enemies = [];
	
	var _lista = ds_list_create();
	
	collision_circle_list(
		_x,
		_y,
		_raio,
		obj_entidade,
		false,
		false,
		_lista,
		false
	);
	
	for(var i = 0; i < ds_list_size(_lista); i++)
	{
		var _entidade = _lista[| i];
		
		array_push(
			_targets,
			_entidade
		);
		
		
		//ALIADOS
		
		
		if(
			_entidade.object_index == obj_aliado_pai
			|| object_is_ancestor(
				_entidade.object_index,
				obj_aliado_pai
			)
		)
		{
			array_push(
				_allies,
				_entidade
			);
		}
		
		
		
		//INIMIGOS
		
		
		if(
			_entidade.object_index == obj_inimigo_pai
			|| object_is_ancestor(
				_entidade.object_index,
				obj_inimigo_pai
			)
		)
		{
			array_push(
				_enemies,
				_entidade
			);
		}
	}
	
	ds_list_destroy(_lista);
	
	return CriarContextoPocao(
		_targets,
		_allies,
		_enemies
	);
}