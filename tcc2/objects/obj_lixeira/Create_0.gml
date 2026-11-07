largura = sprite_width * image_xscale;
altura = sprite_height * image_yscale;

MouseSobre = function(_mx, _my)
{
    return point_in_rectangle(
        _mx,
        _my,
        x,
        y,
        x + largura,
        y + altura
    );
};

timer_sprite = GAME_SPEED * 1;
tempo_sprite = timer_sprite;