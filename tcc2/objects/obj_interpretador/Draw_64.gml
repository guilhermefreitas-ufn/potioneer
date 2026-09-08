
var _margem = 32;
var _texto = sentenca;
var _x = RES_W/2;
var _y = RES_H;
var _max_tam = RES_H - _margem;

//sentença
if(_texto != "") { _texto = "\" "+sentenca+" \""; }

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

