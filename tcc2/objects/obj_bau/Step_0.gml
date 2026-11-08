// VERIFICA A DISTÂNCIA DO JOGADOR
var _player = instance_nearest(x, y, obj_player);

// CENTRO DO JOGADOR
var _px = (_player.bbox_left + _player.bbox_right) / 2;
var _py = (_player.bbox_top + _player.bbox_bottom) / 2;

// PLAYER TA ME VENDO
var _visao = !collision_line(cx, cy, _px, _py,obj_wall,false,true);

// DISTÂNCIA ENTRE OS DOIS CENTROS
var _dist_player = point_distance(cx, cy, _px, _py);

if (_player != noone && !aberto)
{
    // ABRE O BAÚ QUANDO O JOGADOR SE APROXIMA
    if (_dist_player <= distancia_abertura && _visao)
    {
        aberto = true;

        image_index = 0;
        image_speed = 1;
    }
}

// DROPA OS INGREDIENTES UMA ÚNICA VEZ
if (aberto && !itens_droppados && animation_end())
{
    Dropar();

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