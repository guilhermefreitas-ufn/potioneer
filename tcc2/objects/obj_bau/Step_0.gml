
// VERIFICA A DISTÂNCIA DO JOGADOR
var _player = instance_nearest(x, y, obj_player);

if (_player != noone && !aberto)
{
    // CENTRO DO BAÚ
    var _cx = (bbox_left + bbox_right) / 2;
    var _cy = (bbox_top + bbox_bottom) / 2;

    // CENTRO DO JOGADOR
    var _px = (_player.bbox_left + _player.bbox_right) / 2;
    var _py = (_player.bbox_top + _player.bbox_bottom) / 2;

    // DISTÂNCIA ENTRE OS DOIS CENTROS
    var _dist_player = point_distance(
        _cx,
        _cy,
        _px,
        _py
    );

    // ABRE O BAÚ QUANDO O JOGADOR SE APROXIMA
    if (_dist_player <= distancia_abertura)
    {
        aberto = true;

        image_index = 0;
        image_speed = 1;
    }
}

// DROPA OS INGREDIENTES UMA ÚNICA VEZ
if (aberto && !itens_droppados && animation_end())
{
    DropaIngredientes(
        irandom_range(3, 5),
        "Cubo",
        "Cubo",
        id,
        escala_drop,
        tamanho_celula_drop
    );

    itens_droppados = true;
}

// AGUARDA O FIM DA ANIMAÇÃO DE ABERTURA
if (aberto && !sumir)
{
    if (!animation_end())
    {
        image_speed = 1;
    }
    else
    {
        image_speed = 0;
        sumir = true;
    }
}

// FAZ O BAÚ DESAPARECER GRADUALMENTE
if (sumir)
{
    image_alpha = max(0, image_alpha - 0.02);

    if (image_alpha <= 0)
    {
        instance_destroy();
    }
}