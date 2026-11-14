
if(global.pause) { exit; }

var _margem = 32;
var _texto = sentenca;
var _x = RES_W / 2;
var _y = 2 * _margem;
var _y_erro = _y + _margem * 2;
var _max_tam = RES_W / 3;//_margem * 3;

//sentença
if(_texto != " ") { _texto = "\" "+_texto+". \""; }

define_align();
//draw_set_colour(cor_sentenca);
var _cor_contorno = c_black;
draw_set_font(fonte);

draw_text_outline(
	_x,
	_y ,
	string_upper(_texto),
	cor_sentenca,
	_cor_contorno,
	1,
	1,
	1,
	0,
	-1,
	_max_tam
);

reseta_draw();

//erros
var _erro = "";

if(!sintaxe_valida)
{
	_erro = erro_sintaxe;
}
else if(!semantica_valida)
{
	_erro = erro_semantica;
}

if(_erro != "")
{
	define_align();
	draw_set_font(fonte);
	draw_text_outline(
		_x,
		_y_erro,
		_erro,
		cor_erro,
		c_black,
		1,
		1,
		1,
		0,
		-1,
		_max_tam
	);
	reseta_draw();
}

//BOTÃO CRIAR POÇÃO
_x = RES_W
	- botao_criar_largura
	- botao_criar_margem;

_y = RES_H
	- botao_criar_altura
	- botao_criar_margem;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _hover = point_in_rectangle(
	_mx,
	_my,
	_x,
	_y,
	_x + botao_criar_largura,
	_y + botao_criar_altura
);

//FUNDO
if(CaldeiraoVazio())
{
	draw_set_color(c_red);
	draw_set_alpha(.5);
}
else if(_hover)
{
	draw_set_color(c_ltgray);
	draw_set_alpha(1);
}
else
{
	draw_set_color(c_dkgray);
	draw_set_alpha(1);
}

draw_rectangle(
	_x,
	_y,
	_x + botao_criar_largura,
	_y + botao_criar_altura,
	false
);

//BORDA
draw_set_color(c_black);

draw_rectangle(
	_x,
	_y,
	_x + botao_criar_largura,
	_y + botao_criar_altura,
	true
);

//TEXTO
draw_set_font(-1);
define_align(0,0);
draw_set_color(c_white);
draw_set_font(fnt_media_black);

//var _texto = ;
var _texto_largura = string_width("CRIAR POÇÃO");
var _offset_y = 6;

draw_text(
	_x + (botao_criar_largura - _texto_largura) / 2,
	_y + _offset_y,
	"CRIAR POÇÃO"
);

reseta_draw();

//MENSAGEM
if(mensagem_timer > 0)
{
	draw_set_font(fnt_media_black);
	define_align();
	//draw_set_colour(c_white);
	
	draw_text_outline(
		RES_W / 2,
		_y - 32,
		string_upper(mensagem),
		c_aqua,
		c_black,
		1
	);
	
	reseta_draw();
}

// NOMEANDO E PERSONALIZANDO A POÇÃO
if(personalizando_pocao)
{
    // FUNDO ESCURO
    draw_set_colour(c_black);
    draw_set_alpha(.75);

    draw_rectangle(
        0,
        0,
        RES_W,
        RES_H,
        false
    );

    reseta_draw();

    // TÍTULO
    define_align();
    draw_set_font(fnt_placeholder_media);

    draw_text_outline(
        RES_W / 2,
        RES_H / 2 - 105,
        "Nome da poção:",
        c_white,
        c_black,
        1
    );
	
    // NOME DIGITADO
    define_align();
    draw_set_font(fnt_placeholder_media);

    draw_text_outline(
        RES_W / 2,
        RES_H / 2 - 70,
        nome_pocao + "_",
        c_white,
        c_black,
        1
    );

    // TÍTULO DA PALETA
    define_align();
    draw_set_font(fnt_placeholder_media);

    draw_text_outline(
        RES_W / 2,
        RES_H / 2 - 35,
        "Escolha uma cor:",
        c_white,
        c_black,
        1
    );

    // GRID DE CORES
    draw_set_alpha(1);

    for(var i = 0; i < array_length(paleta_cores); i++)
    {
        var _ret = RetanguloCorPocao(i);

        var _x1 = _ret[0];
        var _y1 = _ret[1];
        var _x2 = _ret[2];
        var _y2 = _ret[3];

        // DESTAQUE DA COR SELECIONADA
        if(i == indice_cor_selecionada)
        {
            draw_set_colour(c_white);

            draw_rectangle(
                _x1 - 3,
                _y1 - 3,
                _x2 + 3,
                _y2 + 3,
                false
            );
        }

        // COR DO QUADRADO
        draw_set_colour(paleta_cores[i].valor);

        draw_rectangle(
            _x1,
            _y1,
            _x2,
            _y2,
            false
        );

        // BORDA
        draw_set_colour(c_black);

        draw_rectangle(
            _x1,
            _y1,
            _x2,
            _y2,
            true
        );
    }

    reseta_draw();

    // MOSTRA A COR SELECIONADA
    define_align();
    draw_set_font(fnt_placeholder_media);

    draw_text_outline(
        RES_W / 2,
        RES_H / 2 + 105,
        "Cor selecionada: "
            + paleta_cores[indice_cor_selecionada].nome,
        c_white,
        c_black,
        1
    );

	// SELEÇÃO DE SPRITES
	// SÓ MOSTRA A GRADE SE EXISTIREM DUAS OU MAIS OPÇÕES
	if(array_length(opcoes_sprites_pocao) > 1)
	{
	    // TÍTULO
	    define_align();
	    draw_set_font(fnt_placeholder_media);

	    draw_text_outline(
	        RES_W / 2,
	        RES_H / 2 + 140,
	        "Escolha o frasco:",
	        c_white,
	        c_black,
	        1
	    );

	    reseta_draw();

	    // DESENHA OS CARDS
	    for(var i = 0; i < array_length(opcoes_sprites_pocao); i++)
	    {
	        var _ret = RetanguloSpritePocao(i);

	        var _x1 = _ret[0];
	        var _y1 = _ret[1];
	        var _x2 = _ret[2];
	        var _y2 = _ret[3];

	        var _cx = (_x1 + _x2) / 2;

	        var _sprite = opcoes_sprites_pocao[i].sprite;
	        var _nome = opcoes_sprites_pocao[i].nome;

	        // FUNDO DO CARD
	        draw_set_alpha(0.9);
	        draw_set_colour(c_dkgray);

	        draw_rectangle(
	            _x1,
	            _y1,
	            _x2,
	            _y2,
	            false
	        );

	        draw_set_alpha(1);

	        // DESTAQUE DO SPRITE SELECIONADO
	        if(i == indice_sprite_selecionado)
	        {
	            draw_set_colour(c_white);

	            draw_rectangle(
	                _x1 - 3,
	                _y1 - 3,
	                _x2 + 3,
	                _y2 + 3,
	                true
	            );
	        }

	        // DESENHA O SPRITE
	        if(!is_undefined(_sprite) && sprite_exists(_sprite))
	        {
	            // DIMENSÕES ORIGINAIS
	            var _largura_sprite = sprite_get_width(_sprite);
	            var _altura_sprite = sprite_get_height(_sprite);

	            // ESCALA PARA CABER NO CARD
	            var _escala = min(
	                30 / _largura_sprite,
	                30 / _altura_sprite
	            );

	            // CENTRALIZA E APLICA A COR DA POÇÃO
	            draw_sprite_ext(
	                _sprite,
	                0,
	                _cx,
	                _y1 + 23,
	                _escala,
	                _escala,
	                0,
	                cor_nova_pocao,
	                1
	            );
	        }

	        // NOME DO SPRITE
	        draw_set_colour(c_white);
	        draw_set_font(fnt_placeholder_pequena);

	        draw_set_halign(fa_center);
	        draw_set_valign(fa_middle);

	        draw_text(
	            _cx,
	            _y1 + 53,
	            _nome
	        );

	        reseta_draw();
	    }
	}
	
	// INSTRUÇÕES
	var _total_sprites = array_length(opcoes_sprites_pocao);

	var _y_instrucoes = RES_H / 2 + 140;

	// SE HOUVER MAIS DE UM SPRITE, CALCULA O ESPAÇO DA GRADE
	if(_total_sprites > 1)
	{
	    var _linhas = ceil(_total_sprites / sprites_colunas);

	    var _altura_grade = _linhas * sprite_card_altura
	        + (_linhas - 1) * sprite_espaco;

	    _y_instrucoes = RES_H / 2
	        + 166
	        + _altura_grade
	        + 24;
	}

	define_align();
	draw_set_font(fnt_placeholder_media);

	draw_text_outline(
	    RES_W / 2,
	    _y_instrucoes,
	    "ENTER = confirmar    ESC = cancelar",
	    c_white,
	    c_black,
	    1
	);

    reseta_draw();
}