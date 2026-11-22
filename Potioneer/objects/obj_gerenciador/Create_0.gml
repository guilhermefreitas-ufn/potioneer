//aleatorizando
randomize();

//dados do jogador
InicializaDadosJogador();

//tela cheia
global.fullscreen = false;

//sistema de save e load
global.stat_data = {};

//overlay
global.overlay_ativo = false;
global.overlay_tipo = "";
global.overlay_pendente = "";

//pausa
global.pause = false;

//progressão
global.fase = 0;

//debug
global.debug = false;

//eventos de progressão
global.eventos_progressao = EventosProgressao();
global.eventos_processados = ds_map_create();

//Cadastro de Ingredientes
global.Ingredientes =
[
	CriarIngrediente(0, "Cubo",		"Um objeto de formato impossível."			,spr_cubo_hd,			"se",			"if",		TipoIngrediente.CONDICIONAL),
	CriarIngrediente(1, "Escama",	"Uma placa coberta por várias escamas."		,spr_escama_azul_hd,	"valor inteiro","int",		TipoIngrediente.PRIMITIVO),
	
	CriarIngrediente(2, "Fruta",	"Uma fruta que lembra um coração."			,spr_fruta_hd,			"saúde",		"hp",		TipoIngrediente.VARIAVEL),
	CriarIngrediente(3, "Asa",		"Uma asa de ave rara eveloz."				,spr_asa_hd,			"velocidade",	"spd",		TipoIngrediente.VARIAVEL),
	CriarIngrediente(4, "Músculo",	"Um forte músculo sem pele."				,spr_musculo_hd,		"força",		"atk",		TipoIngrediente.VARIAVEL),
	
	CriarIngrediente(5, "Dente",	"Um dente perfeito para triturar."			,spr_dente_hd,			"diminui em",	"decreases",TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(6, "Cogumelo",	"Um cogumelo de proliferação rápida."		,spr_cogumelo_hd,		"aumenta em",	"increases",TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(7, "Lágrima",	"Uma lágrima capaz de queimar e confortar."	,spr_lagrima_hd,		"torna-se",		"becomes",	TipoIngrediente.OPERADOR_EFEITO),
	
	CriarIngrediente(8, "Olho",		"Um olho útil e de tamanho nobre."			,spr_olho_hd,			"é maior que",	"greater",	TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(9, "Mão",		"Uma mão bizarra e peluda."					,spr_mao_hd,			"é menor que",	"lower",	TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(10,"Prata",	"Um lingote de prata que caiu da lua."		,spr_prata_hd,			"é igual à",	"equal",	TipoIngrediente.OPERADOR_COMPARACAO),
	
	CriarIngrediente(11,"Raiz",		"Uma raiz de planta muito barulhenta."		,spr_raiz_hd,			"alvo",			"target",	TipoIngrediente.ALVO),
	CriarIngrediente(12,"Crina",	"Um punhado de crina de unicórnio."			,spr_crina_hd,			"aliado",		"ally",		TipoIngrediente.ALVO),
	CriarIngrediente(13,"Acônito",	"Um belo ramo de acônito venenoso."			,spr_aconito_hd,		"inimigo",		"enemy",	TipoIngrediente.ALVO)
];

global.ingredientes_finais = [
	{
		nome : "Âmbar",
		sprite : spr_ing_ambar
		//Por 1 minuto, diminui o cooldown das poções para 1 segundo (funciona entre níveis)
	},
	{
		nome : "Cogumelo",
		sprite : spr_ing_cogumelo
		//Por 1 minuto, dá visão no escuro (funciona entre níveis)
	},
	{
		nome : "Pena",
		sprite : spr_ing_pena
		//Por 1 minuto, aumenta para 10 os slots da hotbar (funcina entre níveis)
	},
	{
		nome : "Dente",
		sprite : spr_ing_dente
		//Por 1 minuto, permite atravessar paredes (funciona entre níveis)
		//Se tiver dentro de uma parede quando o efeito terminar
		//teleporta para o último lugar que esteve fora das paredes
	},
	{
		nome : "Cinzas",
		sprite : spr_ing_cinzas
		//Por 1 minuto, deixa invencível (funciona entre níveis)
	}
];

global.ing_finais_coletados = 0;

//sprites HD
gpu_set_tex_mip_enable(mip_on);

texture_debug_messages(true);

surface_resize(application_surface, 1280, 720);

//funções locais
function VerificaIngrediente(_numero = 1)
{
	if(instance_exists(obj_bolsa))
	{
		with(obj_bolsa)
		{
			var _item = global.Ingredientes[_numero].nome;
			var _resultado = (ProcuraInventario(id,_numero) != -1) ? "tem "+_item : "não tem "+_item
			
			show_debug_message("Bolsa "+_resultado);
		}
	}
	else
	{
		msg_erro("Bolsa");
	}
	if(instance_exists(obj_caldeirao))
	{
		with(obj_caldeirao)
		{
			var _item = global.Ingredientes[_numero].nome;
			var _resultado = (ProcuraInventario(id,_numero) != -1) ? "tem "+_item : "não tem "+_item
			
			show_debug_message("Caldeirão "+_resultado);
		}
	}
	else
	{
		msg_erro("Caldeirão");
	}
}

function PreencheBolsa(_quantidade = 10)
{
	if(instance_exists(obj_bolsa))
	{
		with(obj_bolsa)
		{
			//adicionando itens 0 e 13 no inventario
			//AdicionaInventario(id,irandom(13));
			for(var i = 0; i <= 13; i++)
			{
				for(var j = 0; j < _quantidade; j++)
				{
					if(i == INGREDIENTE_INT)
					{
						AdicionaInventario(id, INGREDIENTE_INT, irandom_range(-9,9));
					}
					else
					{
						AdicionaInventario(id,i);
					}
				}
			}
		}
	}
	else
	{
		msg_erro("Bolsa");
	}
}

function DevolveItens()
{
	if(!instance_exists(obj_bolsa))
	{
		msg_erro("Bolsa");
		return;
	}
	
	if(!instance_exists(obj_caldeirao))
	{
		msg_erro("Caldeirão");
		return;
	}
	
	var _bolsa = instance_find(obj_bolsa, 0);
	var _caldeirao = instance_find(obj_caldeirao, 0);
	
	//devolve tudo que não foi usado
	if(_caldeirao != noone && _bolsa != noone)
	{
		LimpaCaldeirao(
			_caldeirao,
			_bolsa
		);
		
		//atualiza os dados persistentes
		SincronizaBolsaGlobal(_bolsa);
	}
	
	show_debug_message("Itens do caldeirão devolvidos para bolsa");
}

function CriaPocoesTeste()
{
	var _dispara_msg = true;
	
	#region MORTE
	//if enemy hp equal enemy hp
	//enemy hp decreases enemy hp
	var _esq =
		CriarExpressaoVariavel(
			2, //hp
			13, //enemy
			-1,
			-1
		);
	
	var _dir =
		CriarExpressaoVariavel(
			2, //hp
			13, //enemy
			-1,
			-1
		);
	
	var _condicao =
		CriarCondicao(
			_esq,
			10, //equal
			_dir
		);
	
	var _variavel =
		CriarExpressaoVariavel(
			2, //hp
			13, //enemy
			-1,
			-1
		);
	
	var _valor =
		CriarExpressaoVariavel(
			2, //hp
			13, //enemy
			-1,
			-1
		);
	
	var _efeito =
		CriarEfeito(
			_variavel,
			5, //decreases
			_valor
		);
	
	var _algoritmo =
		CriarAlgoritmo(
			0, //if
			_condicao,
			_efeito
		);
	
	if(!PocaoExiste(_algoritmo) && !PocaoNomeExiste("Morte"))
	{
		AdicionaPocaoArmario(
			"Morte",
			_algoritmo,
			"se inimigo saúde é igual à inimigo saúde, então inimigo saúde diminui em inimigo saúde",
			c_black,
			spr_pocao_quadrada
		);
	}
	else
	{
		_dispara_msg = false;
	}
	#endregion
	
	#region CURA
	//if ally hp equal ally hp
	//ally hp increases 9
	_esq =
		CriarExpressaoVariavel(
			2,
			12,
			-1,
			-1
		);
	
	_dir =
		CriarExpressaoVariavel(
			2,
			12,
			-1,
			-1
		);
	
	_condicao =
		CriarCondicao(
			_esq,
			10,
			_dir
		);
	
	_variavel =
		CriarExpressaoVariavel(
			2,
			12,
			-1,
			-1
		);
	
	_valor =
		CriarExpressaoInt(
			1, //int
			-1, //slot
			9 //valor
		);
	
	_efeito =
		CriarEfeito(
			_variavel,
			6, //increases
			_valor
		);
	
	_algoritmo =
		CriarAlgoritmo(
			0,
			_condicao,
			_efeito
		);
	
	if(
		!PocaoExiste(_algoritmo)
		&& !PocaoNomeExiste("Cura")
	)
	{
		AdicionaPocaoArmario(
			"Cura",
			_algoritmo,
			"se aliado saúde é igual à aliado saúde, então aliado saúde aumenta em 9",
			c_lime,
			spr_pocao
		);
	}
	else
	{
		_dispara_msg = false;
	}
	#endregion
	
	#region VELOCIDADE
	//if ally spd equal ally spd
	//ally spd increases 5
	_esq =
		CriarExpressaoVariavel(
			3,
			12,
			-1,
			-1
		);
	
	_dir =
		CriarExpressaoVariavel(
			3,
			12,
			-1,
			-1
		);
	
	_condicao =
		CriarCondicao(
			_esq,
			10,
			_dir
		);
	
	_variavel =
		CriarExpressaoVariavel(
			3,
			12,
			-1,
			-1
		);
	
	_valor =
		CriarExpressaoInt(
			1, //int
			-1, //slot
			5 //valor
		);
	
	_efeito =
		CriarEfeito(
			_variavel,
			6, //increases
			_valor
		);
	
	_algoritmo =
		CriarAlgoritmo(
			0,
			_condicao,
			_efeito
		);
	
	
	
	if(
		!PocaoExiste(_algoritmo)
		&& !PocaoNomeExiste("Velocidade")
	)
	{
		AdicionaPocaoArmario(
			"Velocidade",
			_algoritmo,
			"se aliado velocidade é igual à aliado velocidade, então aliado velocidade aumenta em 5",
			c_aqua,
			spr_pocao
		);
	}
	else
	{
		_dispara_msg = false;
	}
	#endregion
	
	#region PARALISIA
	//if enemy spd equal enemy spd
	//enemy spd becomes 0
	_esq =
		CriarExpressaoVariavel(
			3,
			13,
			-1,
			-1
		);
	
	_dir =
		CriarExpressaoVariavel(
			3,
			13,
			-1,
			-1
		);
	
	_condicao =
		CriarCondicao(
			_esq,
			10,
			_dir
		);
	
	_variavel =
		CriarExpressaoVariavel(
			3,
			13,
			-1,
			-1
		);
	
	_valor =
		CriarExpressaoInt(
			1, //int
			-1, //slot
			0 //valor
		);
	
	_efeito =
		CriarEfeito(
			_variavel,
			7,
			_valor
		);
	
	_algoritmo =
		CriarAlgoritmo(
			0,
			_condicao,
			_efeito
		);
	
	if(
		!PocaoExiste(_algoritmo)
		&& !PocaoNomeExiste("Paralisia")
	)
	{
		AdicionaPocaoArmario(
			"Paralisia",
			_algoritmo,
			"se inimigo velocidade é igual à inimigo velocidade, então inimigo velocidade torna-se 0",
			c_dkgray,
			spr_pocao_quadrada
		);
	}
	else
	{
		_dispara_msg = false;
	}
	#endregion
	
	#region FRAQUEZA
	//if enemy atk greater 0
	//enemy atk decreases 3
	_esq =
		CriarExpressaoVariavel(
			4,
			13,
			-1,
			-1
		);
	
	_dir =
		CriarExpressaoInt(
			1, //int
			-1, //slot
			0 //valor
		);
	
	_condicao =
		CriarCondicao(
			_esq,
			8, //greater
			_dir
		);
	
	_variavel =
		CriarExpressaoVariavel(
			4,
			13,
			-1,
			-1
		);
	
	_valor =
		CriarExpressaoInt(
			1,
			-1,
			3
		);
	
	_efeito =
		CriarEfeito(
			_variavel,
			5, //decreases
			_valor
		);
	
	_algoritmo =
		CriarAlgoritmo(
			0,
			_condicao,
			_efeito
		);
	
	if(
		!PocaoExiste(_algoritmo)
		&& !PocaoNomeExiste("Fraqueza")
	)
	{
		AdicionaPocaoArmario(
			"Fraqueza",
			_algoritmo,
			"se inimigo força é maior que 0, então inimigo força diminui em 3",
			c_olive,
			spr_pocao_quadrada
		);
	}
	else
	{
		_dispara_msg = false;
	}
	#endregion
	
	if(instance_exists(obj_interpretador) && _dispara_msg)
	{
		with(obj_interpretador)
		{
			personalizando_pocao = false;
			nome_pocao = "";
			keyboard_string = "";
			
			mensagem = "Poções de teste criadas com sucesso!";
			mensagem_timer = mensagem_duracao;
		}
		
		show_debug_message(
			"Poções de teste criadas com sucesso!"
		);
	}
	else
	{
		show_debug_message("Poções de teste já criadas! OU Interpretador não encontrado!");
	}
}

//botões
//CONFIGURAÇÃO DOS BOTÕES
fonte_texto = fnt_placeholder_media;

botao_margem = 24;

botao_largura = 220;
botao_altura = 40;

botao_espaco = 10;

botao_x = 30;
botao_y = 30;

//Textos dos botões
botoes_texto = [
	"RESETAR JOGO",
	"1x INT +4 / 1x INT +4",
	"1x INT +4 / 1x INT -3",
	"ADD ITENS BOLSA",
	"LIMPAR CALDEIRAO"
];

//Quantidade de botões
botoes_qtd = array_length(botoes_texto);