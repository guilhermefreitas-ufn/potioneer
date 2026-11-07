
// COORDENADAS DO MOUSE NA GUI


var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);



// ESCALA DA CÂMERA PARA A GUI


var _escala_x = 1;
var _escala_y = 1;

if(view_enabled && view_camera[0] != -1)
{
    var _camera = view_camera[0];

    _escala_x = display_get_gui_width()
        / camera_get_view_width(_camera);

    _escala_y = display_get_gui_height()
        / camera_get_view_height(_camera);
}



// SPRITE DO INGREDIENTE SENDO ARRASTADO


if(item_drag != -1)
{
    draw_set_alpha(0.5);

    draw_sprite_ext(
        global.Ingredientes[item_drag].sprite,
        0,
        _mx,
        _my,
        _escala_x,
        _escala_y,
        0,
        c_white,
        1
    );

    draw_set_alpha(1);
}


// SPRITE DA POÇÃO SENDO ARRASTADA
if(!is_undefined(pocao_drag))
{
    var _alpha_drag = 0.5;

    if(!is_undefined(pocao_drag.sprite))
    {
        draw_sprite_ext(
            pocao_drag.sprite,
            0,
            _mx,
            _my,
            _escala_x,
            _escala_y,
            0,
            pocao_drag.cor,
            _alpha_drag
        );
    }
    else
    {
        draw_set_alpha(_alpha_drag);

        draw_set_colour(pocao_drag.cor);

        var _raio = slot_tam / 4;

        draw_ellipse(
            _mx - _raio * _escala_x,
            _my - _raio * _escala_y,
            _mx + _raio * _escala_x,
            _my + _raio * _escala_y,
            true
        );

        draw_set_alpha(1);
        draw_set_colour(c_white);
    }
}

reseta_draw();