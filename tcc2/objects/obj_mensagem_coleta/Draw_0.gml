var _alpha = clamp(
    1 - tempo / duracao,
    0,
    1
);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_alpha(_alpha);

// Sombra
draw_set_colour(c_black);

draw_text(
    x + 1,
    y + 1,
    texto
);

// Texto
draw_set_colour(c_white);

draw_text(
    x,
    y,
    texto
);

// Restaura o estado de desenho
draw_set_alpha(1);
draw_set_colour(c_white);

draw_set_halign(fa_left);
draw_set_valign(fa_top);