
var _cor_fogo = make_colour_rgb(252,37,0);

criar_efeito(x - 24, y + 40, "fogo_tocha", [c_white, c_yellow, c_red], {
	raio: 16,
	qtd: 25
});

largura = sprite_width * image_xscale;
altura = sprite_height * image_yscale;

MouseSobre = function(_mx, _my)
{
    return point_in_rectangle(
        _mx,
        _my,
        bbox_left,
		bbox_top,
		bbox_right,
		bbox_bottom
    );
};

timer_sprite = GAME_SPEED * 1;
tempo_sprite = timer_sprite;