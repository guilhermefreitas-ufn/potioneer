draw_self();

define_align();
draw_set_colour(cor);

draw_text(
	x,
	y - sprite_get_height(sprite_index) / 2 - 30,
	"HP: " + string(hp)
);

draw_text(
	x,
	y - sprite_get_height(sprite_index) / 2 - 15,
	"SPD: " + string(spd)
);

draw_text(
	x,
	y - sprite_get_height(sprite_index) / 2,
	"ATK: " + string(atk)
);

draw_text(
	x,
	y+sprite_height*1.5,
	nome
);

reseta_draw();