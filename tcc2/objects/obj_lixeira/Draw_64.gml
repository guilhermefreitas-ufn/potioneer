//POSIÇÃO DO TEXTO NO MUNDO
var _pos = MundoParaGUI(
    x + largura / 2,
    y + altura + 16
);

if(!is_undefined(_pos))
{
    //TEXTO
    define_align();
    draw_set_font(fnt_media_black);
    draw_set_colour(c_white);

    //draw_text(
    //    _pos.x,
    //    _pos.y,
    //    "DESCARTE"
    //);
	
	reseta_draw();
}

