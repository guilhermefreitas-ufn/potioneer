
//procurando caldeirões
caldeirao = noone;

tokens = [];
sentenca = "";
cor_sentenca = c_white;
fonte = fnt_placeholder_media;

algoritmo = undefined;

sintaxe_valida = false;
semantica_valida = false;

erro_sintaxe = "";
erro_semantica = "";

cor_erro = c_yellow;

slot_erro = -1;


//NOME DA POÇÃO


nomeando_pocao = false;
nome_pocao = "";

nome_pocao_max = 40;

//preparado para a futura personalização
cor_nova_pocao = c_white;
sprite_nova_pocao = spr_pocao;


//BOTÃO CRIAR POÇÃO


botao_criar_largura = 180;
botao_criar_altura = 40;
botao_criar_margem = 24;

mensagem = "";
mensagem_timer = 0;
mensagem_duracao = 120;

//FUNÇÕES LOCAIS

IniciaNomePocao = function()
{
	nomeando_pocao = true;
	
	nome_pocao = "";
	
	keyboard_string = "";
	
	//valores padrão por enquanto
	cor_nova_pocao = c_white;
	sprite_nova_pocao = undefined;
};

CriarPocao = function()
{
	
	//ALGORITMO INVÁLIDO
	
	
	if(!sintaxe_valida || !semantica_valida)
	{
		mensagem = "Poção inválida!";
		mensagem_timer = mensagem_duracao;
		return;
	}
	
	
	
	//POÇÃO JÁ EXISTE
	
	
	if(PocaoExiste(algoritmo))
	{
		mensagem = "Poção já criada!";
		mensagem_timer = mensagem_duracao;
		return;
	}
	
	
	
	//PEDINDO NOME
	
	
	IniciaNomePocao();
};