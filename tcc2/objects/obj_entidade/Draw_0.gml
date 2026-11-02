//draw_circle_colour(x + sprite_width/2, y + sprite_height, sprite_get_width())

DesenhaSombra();

draw_self();

if(alpha > 0)
{
	HitFlash(alpha);
}

define_align();
draw_set_font(fnt_placeholder_pequena);
draw_set_colour(cor);

draw_text(
	x+sprite_width/2,
	y - sprite_get_height(sprite_index) / 2 - 30,
	"HP: " + string(hp)
);

draw_text(
	x+sprite_width/2,
	y - sprite_get_height(sprite_index) / 2 - 15,
	"SPD: " + string(spd)
);

draw_text(
	x+sprite_width/2,
	y - sprite_get_height(sprite_index) / 2,
	"ATK: " + string(atk)
);

draw_text(
	x+sprite_width/2,
	y+sprite_height*1.1,
	nome
);

//desenhando meu estado
draw_text(x + sprite_width / 2, y + sprite_height * 1.5, estado);

reseta_draw();