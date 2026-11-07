var _hover = MouseSobre(mouse_x, mouse_y);

draw_self();

// TEXTO
define_align(1, 1);
draw_set_font(fnt_placeholder_pequena);
draw_set_colour(c_white);

draw_text(
    x + largura / 2,
    y + altura + 16,
    "DESCARTE"
);

reseta_draw();

if(image_index == 1 && tempo_sprite > 0)
{
	tempo_sprite--;
}
else
{
	tempo_sprite = timer_sprite;
	image_index = 0;
}