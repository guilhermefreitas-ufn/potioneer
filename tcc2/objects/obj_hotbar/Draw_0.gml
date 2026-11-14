if(global.pause || !instance_exists(obj_armario)) { exit; }

draw_set_font(fonte);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

//MOUSE EM COORDENADAS GUI
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _slot_hover = SlotSobreMouse(_mx, _my);

//DESCRIÇÃO
draw_set_font(fonte);
define_align(0, 0);

if(_slot_hover != -1)
{
    var _pocao = global.DadosJogador.hotbar_pocoes[_slot_hover];

    if(!is_undefined(_pocao))
    {
        var _x_desc = obj_armario.x + obj_armario.colunas * (obj_armario.slot_tam + obj_armario.entre_slots) + 30;
		
		var _y_desc =  obj_armario.y;
		
		var _largura_desc = 260;
		
		var _altura_desc =
			string_height_ext(
				_pocao.sentenca,
				-1,
				_largura_desc
			) + 50;

        //FUNDO
        draw_set_colour(c_black);

        draw_roundrect(
            _x_desc - 10,
            _y_desc - 10,
            _x_desc + _largura_desc + 10,
            _y_desc + _altura_desc,
            false
        );

        //NOME
        draw_set_colour(c_white);

        draw_text(
            _x_desc,
            _y_desc,
            _pocao.nome
        );

        //DESCRIÇÃO
        draw_text_ext(
            _x_desc,
            _y_desc + 24,
            _pocao.sentenca,
            -1,
            _largura_desc
        );
    }
}

reseta_draw();