//POSICIONAMENTO DA HOTBAR EM RELAÇÃO À CÂMERA
if (view_enabled && view_camera[0] != -1)
{
    var _camera = view_camera[0];

    var _view_x = camera_get_view_x(_camera);
    var _view_y = camera_get_view_y(_camera);

    var _view_w = camera_get_view_width(_camera);
    var _view_h = camera_get_view_height(_camera);

    //CENTRALIZA HORIZONTALMENTE
    x = _view_x
        + (_view_w - largura_hotbar) / 2;

    //POSICIONA NA PARTE INFERIOR
    y = _view_y
        + _view_h
        - altura_hotbar
        - margem_inferior;
}