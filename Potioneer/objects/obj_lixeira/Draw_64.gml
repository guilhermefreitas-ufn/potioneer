//POSIÇÃO DO TEXTO NO MUNDO
var _pos = MundoParaGUI(
	mouse_x,
	mouse_y
);

//var _mouse = MundoParaGUI()

var _hover = MouseSobre(mouse_x, mouse_y);

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _mouse_press = mouse_check_button(mb_left);

if(_hover && !_mouse_press)
{
	define_align();
	draw_set_font(fnt_media_black);
	//draw_set_colour(c_red);
	draw_text_outline(_mx, _my - 20,"Forno de Descarte",c_orange,c_black,2);
	reseta_draw();
}

if(!is_undefined(_pos))
{
	//TEXTO
	define_align();
	draw_set_font(fnt_media_black);
	draw_set_colour(c_white);
	
	//draw_text(
	//	_pos.x,
	//	_pos.y,
	//	"DESCARTE"
	//);
	
	reseta_draw();
}

