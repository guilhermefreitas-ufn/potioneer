//draw_circle_colour(x + sprite_width/2, y + sprite_height, sprite_get_width())

draw_set_colour(c_dkgray);
draw_set_alpha(.5);
draw_ellipse(
	x,
	y + sprite_height * 0.75,
	x + sprite_width,
	y + sprite_height * 1.25,
	false
);
reseta_draw();

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