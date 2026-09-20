
var _margem = 32;
var _texto = sentenca;
var _x = RES_W/2;
var _y = RES_H;
var _max_tam = RES_H - _margem;

//sentença
if(_texto != " ") { _texto = "\" "+_texto+" \""; }

define_align();
//draw_set_colour(cor_sentenca);
var _cor_contorno = c_black;
draw_set_font(fonte);

draw_text_outline(_x, _y - 2 * _margem,_texto,cor_sentenca,_cor_contorno,1,1,1,0,-1, _max_tam);

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
	draw_text_outline(_x, _y  - _margem, _erro, cor_erro, c_black, 1, 1, 1, 0, -1, _max_tam);
	reseta_draw();
}

// ==========================================
// BOTÃO
// ==========================================

_x = display_get_gui_width()
	- botao_criar_largura
	- botao_criar_margem;

_y = display_get_gui_height()
		- botao_criar_altura
		- botao_criar_margem;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _hover =
	point_in_rectangle(
		_mx,
		_my,
		_x,
		_y,
		_x + botao_criar_largura,
		_y + botao_criar_altura
	);



draw_set_colour(_hover ? c_gray : c_white);


draw_rectangle(
	_x,
	_y,
	_x + botao_criar_largura,
	_y + botao_criar_altura,
	false
);

draw_set_colour(c_black);
draw_set_font(fnt_placeholder_media);
define_align();

draw_text(
	_x + botao_criar_largura / 2,
	_y + botao_criar_altura / 2,
	"CRIAR POÇÃO"
);

draw_set_colour(c_white);

reseta_draw();


// ==========================================
// MENSAGEM
// ==========================================

if(mensagem_timer > 0)
{
	draw_set_colour(c_white);
	
	draw_text(
		display_get_gui_width() / 2,
		_y - 32,
		mensagem
	);
	
	draw_set_colour(c_white);
}

reseta_draw();