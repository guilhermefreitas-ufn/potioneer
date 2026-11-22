//POSIÇÃO DO TEXTO NO MUNDO
var _pos = MundoParaGUI(
	x + 56,
	y - 8
);

if(!is_undefined(_pos))
{
	//TÍTULO
	define_align();
	draw_set_font(fnt_media_black);
	draw_set_colour(c_white);

	//draw_text(
	//	_pos.x,
	//	_pos.y,
	//	"ARMÁRIO DE POÇÕES"
	//);
	
	reseta_draw();
}