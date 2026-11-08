draw_self();

var _espaco = keyboard_check(vk_space);

if(image_index == 1 && instance_exists(obj_player))
{
    // Voltamos a adicionar metade da largura e altura para pegar o centro
    var _start_x = x;
    var _start_y = y;
    
    var _end_x = obj_player.CentroPlayer()[0];
    var _end_y = obj_player.CentroPlayer()[1];

    var _achou_caminho = mp_grid_path(
        global.grid,
        caminho, 
        _start_x,
        _start_y,
        _end_x,
        _end_y,
        true
    );
    
	var _dist = point_distance(x,y,_end_x,_end_y);
	
    if (_achou_caminho && _dist > 128 && _espaco)
    {
        draw_set_color(c_lime); 
        // O caminho continuará sendo desenhado nas coordenadas absolutas (true)
        draw_path(caminho, 0, 0, true); 
        draw_set_color(c_white); 
    }
}