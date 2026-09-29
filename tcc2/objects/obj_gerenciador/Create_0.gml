//aleatorizando
randomize();

//dados do jogador
InicializaDadosJogador();

//debug
global.debug = false;

//botao para armário de poções (arsenal)
botao_armario_largura = 220;
botao_armario_altura = 40;
botao_armario_margem = 24;

//botão para explorar masmorra
botao_masmorra_largura = 220;
botao_masmorra_altura = 40;
botao_masmorra_margem = 24;

//Cadastro de Ingredientes
global.Ingredientes =
[
	CriarIngrediente(0, "Cubo",		"Um objeto de formato impossível."		,spr_ing_cubo,		"se",			"if",		TipoIngrediente.CONDICIONAL),
	CriarIngrediente(1, "Crina",	"Um punhado de crina na cor índigo."	,spr_ing_crina,		"valor inteiro","int",		TipoIngrediente.PRIMITIVO),
	
	CriarIngrediente(2, "Chifre",	"Um chifre longo e bem afiado."			,spr_ing_chifre,	"saúde",		"hp",		TipoIngrediente.VARIAVEL),
	CriarIngrediente(3, "Osso",		"Um osso velho e esquecido."			,spr_ing_osso,		"velocidade",	"spd",		TipoIngrediente.VARIAVEL),
	CriarIngrediente(4, "Fogo",		"Uma labareda de fogo eterno."			,spr_ing_fogo,		"ataque",		"atk",		TipoIngrediente.VARIAVEL),
	
	CriarIngrediente(5, "Folha",	"Uma folha de uma árvore desconhecida."	,spr_ing_folha,		"diminui em",	"decreases",TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(6, "Sol",		"Um mini sol sustentado por magia."		,spr_ing_sol,		"aumenta em",	"increases",TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(7, "Nadadeira","Uma nadadeira de monstro marinho."		,spr_ing_nadadeira,	"torna-se",		"becomes",	TipoIngrediente.OPERADOR_EFEITO),
	
	CriarIngrediente(8, "Lágrima",	"Uma lágrima de monstro do deserto."	,spr_ing_lagrima,	"é maior que",	"greater",	TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(9, "Alma",		"Uma alma perdida e vagante."			,spr_ing_alma,		"é menor que",	"lower",	TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(10,"Olho",		"Um olho de monstro hipnotizador."		,spr_ing_olho,		"é igual à",	"equal",	TipoIngrediente.OPERADOR_COMPARACAO),
	
	CriarIngrediente(11,"Planta",	"Uma raiz cuja forma imita humanoides."	,spr_ing_mandragora,"alvo",			"target",	TipoIngrediente.ALVO),
	CriarIngrediente(12,"Escama",	"Uma escama de monstro blindado."		,spr_ing_escama,	"aliado",		"ally",		TipoIngrediente.ALVO),
	CriarIngrediente(13,"Estrela",	"Uma estrela que caiu anos atrás."		,spr_ing_estrela,	"inimigo",		"enemy",	TipoIngrediente.ALVO)
	
	//,CriarIngrediente(14, "Lua", "Uma mini lua perfeitamente mordida.",spr_ing_lua,	"enquanto",		"while",	TipoIngrediente.CONDICIONAL)
];

//funções para testes
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

function VaiParaMasmorra(_rm_masmorra)
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
	
	room_goto(_rm_masmorra);
}

function VaiParaArmario(_rm_armario)
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
	
	
	var _bolsa =
		instance_find(obj_bolsa, 0);
	
	var _caldeirao =
		instance_find(obj_caldeirao, 0);
	
	
	//devolve ingredientes não utilizados
	LimpaCaldeirao(
		_caldeirao,
		_bolsa
	);
	
	
	//salva o estado atualizado da bolsa
	SincronizaBolsaGlobal(
		_bolsa
	);
	
	
	room_goto(_rm_armario);
}

global.c_prata = make_colour_rgb(170, 169, 173);

function CriaPocoesTeste()
{
	#region MORTE
	//if enemy hp equal enemy hp
	//enemy hp decreases enemy hp
	var _esq =
		CriarExpressaoVariavel(
			2,  //hp
			13, //enemy
			-1,
			-1
		);
	
	var _dir =
		CriarExpressaoVariavel(
			2,  //hp
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
			2,  //hp
			13, //enemy
			-1,
			-1
		);
	
	var _valor =
		CriarExpressaoVariavel(
			2,  //hp
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
	
	if(
		!PocaoExiste(_algoritmo)
		&& !PocaoNomeExiste("Morte")
	)
	{
		AdicionaPocaoArmario(
			"Morte",
			_algoritmo,
			"se inimigo saúde é igual à inimigo saúde, então inimigo saúde diminui em inimigo saúde",
			c_black
		);
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
			c_lime
		);
	}
	#endregion
	
	#region VELOCIDADE
	//if ally spd equal ally spd
	//ally spd becomes 5
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
			7, //becomes
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
			"se aliado velocidade é igual à aliado velocidade, então aliado velocidade torna-se 5",
			global.c_prata
		);
	}
	#endregion
	
	#region LENTIDÃO
	//if enemy spd equal enemy spd
	//enemy spd becomes 1
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
			1 //valor
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
		&& !PocaoNomeExiste("Lentidao")
	)
	{
		AdicionaPocaoArmario(
			"Lentidao",
			_algoritmo,
			"se inimigo velocidade é igual à inimigo velocidade, então inimigo velocidade torna-se 1",
			c_blue
		);
	}
	#endregion
	
	#region FORÇA
	//if ally atk greater 0
	//ally atk increases 3
	_esq =
		CriarExpressaoVariavel(
			4,
			12,
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
			12,
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
		&& !PocaoNomeExiste("Forca")
	)
	{
		AdicionaPocaoArmario(
			"Forca",
			_algoritmo,
			"se aliado ataque é maior que 0, então aliado ataque aumenta em 3",
			c_orange
		);
	}
	#endregion
	
	if(instance_exists(obj_interpretador))
	{
		with(obj_interpretador)
		{
			nomeando_pocao = false;
			nome_pocao = "";
			keyboard_string = "";
			
			mensagem = "Poções de teste criadas com sucesso!";
			mensagem_timer = mensagem_duracao;
		}
	}
	else
	{
		msg_erro("Interpretador");
	}
	
	show_debug_message(
		"Poções de teste criadas com sucesso!"
	);
}

//botões de debug

//CONFIGURAÇÃO DOS BOTÕES
fonte_texto =fnt_placeholder_media;

botao_largura = 220;
botao_altura = 32;

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