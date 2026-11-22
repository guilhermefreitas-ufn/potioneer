function InicializaDadosJogador(_novo_jogo = false)
{
	//JÁ EXISTEM DADOS DO JOGADOR?
	if(
		!_novo_jogo
		&& variable_global_exists("DadosJogador")
		&& is_struct(global.DadosJogador)
	)
	{
		var _dados = global.DadosJogador;
		
		//ARMÁRIO DE POÇÕES
		if(!variable_struct_exists(_dados, "armario_pocoes"))
		{
			_dados.armario_pocoes = array_create(
				SLOTS_ARMARIO_POCOES,
				undefined
			);
		}
			
		//HOTBAR
		if(!variable_struct_exists(_dados, "hotbar_pocoes"))
		{
			_dados.hotbar_pocoes = array_create(
				SLOTS_HOTBAR_POCOES,
				undefined
			);
		}
		
		//ID DAS POÇÕES
		if(!variable_struct_exists(_dados, "proximo_id_pocao"))
		{
			_dados.proximo_id_pocao = 0;
		}
		
		//BOLSA
		if(!variable_struct_exists(_dados, "bolsa_inventario"))
		{
			_dados.bolsa_inventario = array_create(
				SLOTS_BOLSA,
				-1
			);
		}
		
		if(!variable_struct_exists(_dados, "bolsa_quantidades"))
		{
			_dados.bolsa_quantidades = array_create(
				SLOTS_BOLSA,
				0
			);
		}
		
		if(!variable_struct_exists(_dados, "bolsa_valores"))
		{
			_dados.bolsa_valores = array_create(
				SLOTS_BOLSA,
				undefined
			);
		}
		
		return;
	}
	
	//CRIA OU REINICIALIZA TODOS OS DADOS
	global.DadosJogador =
	{
		//ARMÁRIO DE POÇÕES
		armario_pocoes: array_create(
			SLOTS_ARMARIO_POCOES,
			undefined
		),
		
		//HOTBAR
		hotbar_pocoes: array_create(
			SLOTS_HOTBAR_POCOES,
			undefined
		),
		
		//ID DAS POÇÕES
		proximo_id_pocao: 0,
		
		//BOLSA
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
	//PROCURANDO UMA PILHA COMPATÍVEL
	for(var i = 0; i < SLOTS_BOLSA; i++)
	{
		//slot vazio
		if(global.DadosJogador.bolsa_inventario[i] == -1)
		{
			continue;
		}
		
		//ingrediente diferente
		if(global.DadosJogador.bolsa_inventario[i] != _tipo_item)
		{
			continue;
		}
		
		//INT: o valor também precisa ser igual
		if(_tipo_item == INGREDIENTE_INT
		&& global.DadosJogador.bolsa_valores[i] != _valor)
		{
			continue;
		}
		
		//encontrou a pilha
		global.DadosJogador.bolsa_quantidades[i]++;
		
		return true;
	}
	
	//NÃO EXISTE PILHA COMPATÍVEL
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