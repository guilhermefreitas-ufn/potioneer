#macro SLOTS_ARMARIO_POCOES 32
#macro SLOTS_HOTBAR_POCOES 5
#macro SEGUNDOS_COOLDOWN_POCAO 5

// EFEITOS VISUAIS DAS POÇÕES
#macro SEGUNDOS_AREA_EFEITO_POCAO 0.75
#macro VELOCIDADE_ARREMESSO_POCAO 480 //pixels por segundo
#macro ALPHA_AREA_EFEITO_POCAO 0.35 //de 0 a 1

// RESETA OS COOLDOWNS DE UM ARRAY DE POÇÕES
function ResetarCooldownsArrayPocoes(_pocoes)
{
    if (!is_array(_pocoes))
    {
        return;
    }

    for (var i = 0; i < array_length(_pocoes); i++)
    {
        var _pocao = _pocoes[i];

        if (is_struct(_pocao))
        {
            _pocao.cooldown = 0;
        }
    }
}

// RESETA OS COOLDOWNS DE TODAS AS POÇÕES
function ResetarCooldownsPocoes()
{
    if (!variable_global_exists("DadosJogador"))
    {
        return;
    }

    var _dados = global.DadosJogador;

    if (!is_struct(_dados))
    {
        return;
    }

    // POÇÕES DA HOTBAR
    if (variable_struct_exists(_dados, "hotbar_pocoes"))
    {
        ResetarCooldownsArrayPocoes(
            _dados.hotbar_pocoes
        );
    }

    // POÇÕES DO ARMÁRIO
    if (variable_struct_exists(_dados, "armario_pocoes"))
    {
        ResetarCooldownsArrayPocoes(
            _dados.armario_pocoes
        );
    }

    show_debug_message("Cooldowns de todas as poções resetados.");
}

function PocaoNomeExiste(_nome)
{
	var _nome_comparacao =
		string_lower(
			string_trim(_nome)
		);
	
	//ARMÁRIO
	for(
		var i = 0;
		i < SLOTS_ARMARIO_POCOES;
		i++
	)
	{
		var _pocao =
			global.DadosJogador.armario_pocoes[i];
		
		if(is_undefined(_pocao))
		{
			continue;
		}
		
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
	
	//HOTBAR
	for(
		var i = 0;
		i < SLOTS_HOTBAR_POCOES;
		i++
	)
	{
		var _pocao =
			global.DadosJogador.hotbar_pocoes[i];
		
		if(is_undefined(_pocao))
		{
			continue;
		}
		
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

function PocaoExiste(_algoritmo)
{
	var _assinatura =
		AssinaturaAlgoritmo(_algoritmo);
	
	//ARMÁRIO
	for(
		var i = 0;
		i < SLOTS_ARMARIO_POCOES;
		i++
	)
	{
		var _pocao =
			global.DadosJogador.armario_pocoes[i];
		
		if(is_undefined(_pocao))
		{
			continue;
		}
		
		if(
			AssinaturaAlgoritmo(_pocao.algoritmo)
			== _assinatura
		)
		{
			return true;
		}
	}
	
	
	
	//HOTBAR
	for(
		var i = 0;
		i < SLOTS_HOTBAR_POCOES;
		i++
	)
	{
		var _pocao =
			global.DadosJogador.hotbar_pocoes[i];
		
		if(is_undefined(_pocao))
		{
			continue;
		}
		
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

//ADICIONA POÇÃO AO ARMÁRIO
function AdicionaPocaoArmario(_nome,_algoritmo,_sentenca,_cor = c_white,_sprite = spr_pocao)
{
	var _slot = -1;
	
	//procurando slot vazio
	for(var i = 0; i < SLOTS_ARMARIO_POCOES; i++)
	{
		if(is_undefined(
			global.DadosJogador.armario_pocoes[i]
		))
		{
			_slot = i;
			break;
		}
	}
	
	if(_slot == -1)
	{
		return -1;
	}
	
	
	var _id =
		global.DadosJogador.proximo_id_pocao;
	
	global.DadosJogador.proximo_id_pocao++;
	
	
	global.DadosJogador.armario_pocoes[_slot] =
	{
		id: _id,

		nome: _nome,
		algoritmo: _algoritmo,
		sentenca: _sentenca,

		cor: _cor,
		sprite: _sprite,

		cooldown: 0
	};
	
	
	return _slot;
}

//ASSINATURA DE UMA VARIÁVEL
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
	
	//A ordem é sempre VARIAVEL + ALVO.
	//Portanto:
	//enemy hp == hp enemy
	return "VAR:"
		+ _ing_variavel.token
		+ ":ALVO:"
		+ _ing_alvo.token;
}

//ASSINATURA DE UM VALOR
function AssinaturaValor(_expressao)
{
	if(is_undefined(_expressao))
	{
		return "undefined";
	}
	
	
	//INT
	
	
	if(
		_expressao.tipo == TipoExpressao.VALOR
		&& _expressao.subtipo == TipoValor.INT
	)
	{
		return "INT:"
			+ string(_expressao.valor);
	}
	
	
	
	//VARIÁVEL
	
	
	if(_expressao.tipo == TipoExpressao.VARIAVEL)
	{
		return AssinaturaVariavel(
			_expressao
		);
	}
	
	return "invalid";
}

//ASSINATURA DE UMA CONDIÇÃO
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

//ASSINATURA DE UM EFEITO
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

//ASSINATURA COMPLETA DA POÇÃO
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

function PocaoArmarioNoSlot(_slot)
{
	if(
		_slot < 0
		|| _slot >= SLOTS_ARMARIO_POCOES
	)
	{
		return undefined;
	}
	
	return global.DadosJogador.armario_pocoes[_slot];
}

function RemovePocaoArmario(_slot)
{
	if(
		_slot < 0
		|| _slot >= SLOTS_ARMARIO_POCOES
	)
	{
		return undefined;
	}
	
	var _pocao =
		global.DadosJogador.armario_pocoes[_slot];
	
	if(is_undefined(_pocao))
	{
		return undefined;
	}
	
	global.DadosJogador.armario_pocoes[_slot] =
		undefined;
	
	return _pocao;
}

function TrocaPocaoArmario(_slot_a, _slot_b)
{
	if(
		_slot_a < 0
		|| _slot_a >= SLOTS_ARMARIO_POCOES
		|| _slot_b < 0
		|| _slot_b >= SLOTS_ARMARIO_POCOES
	)
	{
		return false;
	}
	
	if(_slot_a == _slot_b)
	{
		return false;
	}
	
	
	var _temp =
		global.DadosJogador.armario_pocoes[_slot_a];
	
	global.DadosJogador.armario_pocoes[_slot_a] =
		global.DadosJogador.armario_pocoes[_slot_b];
	
	global.DadosJogador.armario_pocoes[_slot_b] =
		_temp;
	
	return true;
}

function PrimeiroSlotArmarioLivre()
{
	for(var i = 0; i < SLOTS_ARMARIO_POCOES; i++)
	{
		if(is_undefined(
			global.DadosJogador.armario_pocoes[i]
		))
		{
			return i;
		}
	}
	
	return -1;
}

function PrimeiroSlotHotbarLivre()
{
	for(var i = 0; i < SLOTS_HOTBAR_POCOES; i++)
	{
		if(is_undefined(
			global.DadosJogador.hotbar_pocoes[i]
		))
		{
			return i;
		}
	}
	
	return -1;
}

function TrocaPocaoHotbar(_slot_a, _slot_b)
{
	if(
		_slot_a < 0
		|| _slot_a >= SLOTS_HOTBAR_POCOES
		|| _slot_b < 0
		|| _slot_b >= SLOTS_HOTBAR_POCOES
	)
	{
		return false;
	}
	
	if(_slot_a == _slot_b)
	{
		return false;
	}
	
	
	var _temp =
		global.DadosJogador.hotbar_pocoes[_slot_a];
	
	global.DadosJogador.hotbar_pocoes[_slot_a] =
		global.DadosJogador.hotbar_pocoes[_slot_b];
	
	global.DadosJogador.hotbar_pocoes[_slot_b] =
		_temp;
	
	return true;
}

function TransferePocaoArmarioParaHotbar(_slot_armario,_slot_hotbar)
{
	if(
		_slot_armario < 0
		|| _slot_armario >= SLOTS_ARMARIO_POCOES
	)
	{
		return false;
	}
	
	if(
		_slot_hotbar < 0
		|| _slot_hotbar >= SLOTS_HOTBAR_POCOES
	)
	{
		return false;
	}
	
	
	var _pocao_armario =
		global.DadosJogador.armario_pocoes[
			_slot_armario
		];
	
	if(is_undefined(_pocao_armario))
	{
		return false;
	}
	
	
	var _pocao_hotbar =
		global.DadosJogador.hotbar_pocoes[
			_slot_hotbar
		];
	
	
	
	//HOTBAR VAZIA
	
	
	if(is_undefined(_pocao_hotbar))
	{
		global.DadosJogador.hotbar_pocoes[
			_slot_hotbar
		] =
			_pocao_armario;
		
		global.DadosJogador.armario_pocoes[
			_slot_armario
		] =
			undefined;
		
		return true;
	}
	
	
	
	//HOTBAR OCUPADA
	//→ TROCA
	
	
	global.DadosJogador.hotbar_pocoes[
		_slot_hotbar
	] =
		_pocao_armario;
	
	global.DadosJogador.armario_pocoes[
		_slot_armario
	] =
		_pocao_hotbar;
	
	return true;
}

function AdicionaPocaoHotbarPorClique(_slot_armario)
{
	var _slot_hotbar =
		PrimeiroSlotHotbarLivre();
	
	if(_slot_hotbar == -1)
	{
		return false;
	}
	
	return TransferePocaoArmarioParaHotbar(
		_slot_armario,
		_slot_hotbar
	);
}

function DevolvePocaoHotbarPorClique(_slot_hotbar)
{
	var _pocao =
		global.DadosJogador.hotbar_pocoes[
			_slot_hotbar
		];
	
	if(is_undefined(_pocao))
	{
		return false;
	}
	
	
	var _slot_armario =
		PrimeiroSlotArmarioLivre();
	
	if(_slot_armario == -1)
	{
		return false;
	}
	
	
	global.DadosJogador.armario_pocoes[
		_slot_armario
	] =
		_pocao;
	
	
	global.DadosJogador.hotbar_pocoes[
		_slot_hotbar
	] =
		undefined;
	
	
	return true;
}

function TransferePocaoHotbarParaArmario(_slot_hotbar,_slot_armario)
{
	if(
		_slot_hotbar < 0
		|| _slot_hotbar >= SLOTS_HOTBAR_POCOES
	)
	{
		return false;
	}
	
	if(
		_slot_armario < 0
		|| _slot_armario >= SLOTS_ARMARIO_POCOES
	)
	{
		return false;
	}
	
	
	var _pocao_hotbar =
		global.DadosJogador.hotbar_pocoes[
			_slot_hotbar
		];
	
	if(is_undefined(_pocao_hotbar))
	{
		return false;
	}
	
	
	var _pocao_armario =
		global.DadosJogador.armario_pocoes[
			_slot_armario
		];
	
	
	
	//DESTINO VAZIO
	
	
	if(is_undefined(_pocao_armario))
	{
		global.DadosJogador.armario_pocoes[
			_slot_armario
		] =
			_pocao_hotbar;
		
		global.DadosJogador.hotbar_pocoes[
			_slot_hotbar
		] =
			undefined;
		
		return true;
	}
	
	
	
	//DESTINO OCUPADO
	//→ TROCA
	
	
	global.DadosJogador.armario_pocoes[
		_slot_armario
	] =
		_pocao_hotbar;
	
	global.DadosJogador.hotbar_pocoes[
		_slot_hotbar
	] =
		_pocao_armario;
	
	return true;
}

function TransferePocaoHotbarParaFimDoArmario(_slot_hotbar)
{
	var _pocao =
		global.DadosJogador.hotbar_pocoes[
			_slot_hotbar
		];
	
	if(is_undefined(_pocao))
	{
		return false;
	}
	
	
	var _slot_armario =
		PrimeiroSlotArmarioLivre();
	
	
	if(_slot_armario == -1)
	{
		return false;
	}
	
	
	global.DadosJogador.armario_pocoes[
		_slot_armario
	] =
		_pocao;
	
	global.DadosJogador.hotbar_pocoes[
		_slot_hotbar
	] =
		undefined;
	
	return true;
}