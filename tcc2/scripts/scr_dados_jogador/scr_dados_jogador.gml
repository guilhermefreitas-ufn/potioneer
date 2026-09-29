function InicializaDadosJogador()
{
	if(variable_global_exists("DadosJogador"))
	{
		return;
	}
	
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