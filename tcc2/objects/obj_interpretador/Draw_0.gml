
define_align();

draw_text(x,y,sentenca);

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
	draw_text(x, y + 32, _erro);
}

reseta_draw();