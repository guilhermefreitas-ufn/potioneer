
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

// ==========================================
// BOTÃO CRIAR POÇÃO
// ==========================================

botao_criar_largura = 180;
botao_criar_altura = 40;
botao_criar_margem = 24;

mensagem = "";
mensagem_timer = 0;
mensagem_duracao = 120;

CriarPocao = function()
{
	// ------------------------------------------
	// VERIFICANDO SE O ALGORITMO É VÁLIDO
	// ------------------------------------------
	if(!sintaxe_valida || !semantica_valida)
	{
		mensagem = "Poção inválida!";
		mensagem_timer = mensagem_duracao;
		return;
	}
	
	// ------------------------------------------
	// ADICIONANDO A POÇÃO
	// ------------------------------------------
	var _slot_pocao = AdicionaPocao(
		algoritmo,
		sentenca
	);
	
	// Não há espaço para a poção
	if(_slot_pocao == -1)
	{
		mensagem = "Não há espaço para outra poção.";
		mensagem_timer = mensagem_duracao;
		return;
	}
	
	// ------------------------------------------
	// CONSUMINDO INGREDIENTES
	// ------------------------------------------
	ConsomeCaldeirao(caldeirao);
	
	// ------------------------------------------
	// MENSAGEM
	// ------------------------------------------
	mensagem = "Poção criada com sucesso!";
	mensagem_timer = mensagem_duracao;
};