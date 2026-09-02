
var _margem = 32;
var _texto = sentenca;
var _x = room_width/2;
var _y = room_height;
var _max_tam = room_width - _margem;

if(_texto != "") { _texto = "\" "+sentenca+" \""; }

define_align();
draw_set_font(fnt_placeholder_media);

draw_text_ext(_x, _y - 2 * _margem,_texto,-1, _max_tam);

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
	draw_text_ext(_x, _y  - _margem, _erro, -1, _max_tam);
}

reseta_draw();