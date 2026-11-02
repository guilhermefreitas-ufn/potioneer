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
personalizando_pocao = false;
nome_pocao = "";

nome_pocao_max = 40;

// PERSONALIZAÇÃO DA POÇÃO
cor_nova_pocao = c_white;
sprite_nova_pocao = spr_pocao_quadrada;

// PALETA DE CORES
paleta_cores =
[
    {nome: "Ciano",			valor: c_aqua},
    {nome: "Preto",			valor: c_black},
    {nome: "Azul",			valor: c_blue},
    {nome: "Cinza Escuro",  valor: c_dkgray},
    {nome: "Magenta",		valor: c_fuchsia},

    {nome: "Cinza",			valor: c_gray},
    {nome: "Verde",			valor: c_green},
    {nome: "Limão",			valor: c_lime},
    {nome: "Cinza Claro",	valor: c_ltgray},
    {nome: "Vinho",			valor: c_maroon},

    {nome: "Marinho",		valor: c_navy},
    {nome: "Oliva",			valor: c_olive},
    {nome: "Laranja",		valor: c_orange},
    {nome: "Roxo",			valor: c_purple},
    {nome: "Vermelho",		valor: c_red},

    {nome: "Prata",			valor: c_silver},
    {nome: "Petróleo",		valor: c_teal},
    {nome: "Branco",		valor: c_white},
    {nome: "Amarelo",		valor: c_yellow}
];


// OPÇÕES DE SPRITES DAS POÇÕES
opcoes_sprites_pocao =
[
    {
        nome: "Redonda",
        sprite: spr_pocao
    },
	{
        nome: "Quadrada",
        sprite: spr_pocao_quadrada
    }
];

// CONFIGURAÇÃO DA GRID DE SPRITES
sprites_colunas = 5;
sprite_card_largura = 72;
sprite_card_altura = 68;
sprite_espaco = 8;

// ÍNDICE DO SPRITE SELECIONADO
indice_sprite_selecionado = 0;

// CONFIGURAÇÃO DA GRID DE CORES
paleta_colunas = 5;
paleta_tamanho = 24;
paleta_espaco = 6;

// ÍNDICE DA COR SELECIONADA
// White está na posição 17
indice_cor_selecionada = 17;

//BOTÃO CRIAR POÇÃO
botao_criar_largura = 180;
botao_criar_altura = 40;
botao_criar_margem = 24;

mensagem = "";
mensagem_timer = 0;
mensagem_duracao = 120;

//FUNÇÕES LOCAIS
IniciaPersonalizacaoPocao = function()
{
    personalizando_pocao = true;

    nome_pocao = "";

    keyboard_string = "";

    // COR PADRÃO
    indice_cor_selecionada = 17;
    cor_nova_pocao = c_white;

    // SPRITE PADRÃO
    if(array_length(opcoes_sprites_pocao) > 0)
    {
        indice_sprite_selecionado = 0;

        sprite_nova_pocao =
            opcoes_sprites_pocao[0].sprite;
    }
    else
    {
        // FALLBACK CASO NÃO HAJA SPRITES CADASTRADOS
        indice_sprite_selecionado = -1;
        sprite_nova_pocao = spr_pocao_quadrada;
    }
};

CriarPocao = function()
{
	//CALDEIRÃO VAZIO
	if(CaldeiraoVazio())
	{
		mensagem = "Caldeirão vazio!";
		mensagem_timer = mensagem_duracao;
		return;
	}
	
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
	IniciaPersonalizacaoPocao();
};

// RETORNA O RETÂNGULO DE UMA COR DA PALETA
RetanguloCorPocao = function(_indice)
{
    var _coluna = _indice % paleta_colunas;
    var _linha = floor(_indice / paleta_colunas);

    // DIMENSÕES DA PALETA
    var _largura = paleta_colunas * paleta_tamanho
        + (paleta_colunas - 1) * paleta_espaco;

    // POSIÇÃO INICIAL
    var _inicio_x = (RES_W - _largura) / 2;
    var _inicio_y = RES_H / 2 - 20;

    // POSIÇÃO DO QUADRADO
    var _x1 = _inicio_x
        + _coluna * (paleta_tamanho + paleta_espaco);

    var _y1 = _inicio_y
        + _linha * (paleta_tamanho + paleta_espaco);

    return [
        _x1,
        _y1,
        _x1 + paleta_tamanho,
        _y1 + paleta_tamanho
    ];
};


// RETORNA O RETÂNGULO DE UM SPRITE NA PALETA
// CENTRALIZANDO CADA LINHA INDEPENDENTEMENTE
RetanguloSpritePocao = function(_indice)
{
    var _total = array_length(opcoes_sprites_pocao);

    var _coluna = _indice % sprites_colunas;
    var _linha = floor(_indice / sprites_colunas);

    // QUANTIDADE DE SPRITES NESTA LINHA
    var _itens_linha = min(
        sprites_colunas,
        _total - _linha * sprites_colunas
    );

    // LARGURA REAL DA LINHA
    var _largura_linha =
        _itens_linha * sprite_card_largura
        + (_itens_linha - 1) * sprite_espaco;

    // CENTRALIZA A LINHA
    var _inicio_x = (RES_W - _largura_linha) / 2;

    // POSIÇÃO VERTICAL
    var _inicio_y = RES_H / 2 + 166;

    // POSIÇÃO DO CARD
    var _x1 = _inicio_x
        + _coluna * (sprite_card_largura + sprite_espaco);

    var _y1 = _inicio_y
        + _linha * (sprite_card_altura + sprite_espaco);

    return
    [
        _x1,
        _y1,
        _x1 + sprite_card_largura,
        _y1 + sprite_card_altura
    ];
};