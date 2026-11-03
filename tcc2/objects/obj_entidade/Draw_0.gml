//draw_circle_colour(x + sprite_width/2, y + sprite_height, sprite_get_width())
var _margem_condicoes = 12;
var _grossura_barras = 4;
//var _max_hp = 0;
//var _max_spd = 0;
//var _max_atk = 0;

if(!setei_stats)
{
	max_hp = hp;
	max_spd = spd;
	max_atk = atk;
	
	setei_stats = true;
}

DesenhaSombra();

draw_self();

if(alpha > 0)
{
	HitFlash(alpha);
}

define_align();
draw_set_font(fnt_placeholder_pequena);
draw_set_colour(cor);

//draw_text(
//	x+sprite_width/2,
//	y - sprite_get_height(sprite_index) / 2 - 30,
//	"HP: " + string(hp)
//);

//draw_text(
//	x+sprite_width/2,
//	y - sprite_get_height(sprite_index) / 2 - 15,
//	"SPD: " + string(spd)
//);

//draw_text(
//	x+sprite_width/2,
//	y - sprite_get_height(sprite_index) / 2,
//	"ATK: " + string(atk)
//);

draw_text(
	x+sprite_width/2,
	y+sprite_height*1.1,
	nome
);

if(!global.debug)
{
	for(var i = 0; i < array_length(condicao); i++)
	{
		//desenhando meu estado
		draw_text(x + (sprite_width / 2), y + (sprite_height * 1.5) + (i * _margem_condicoes), condicao[i]);
	}
}
else
{
	//desenhando meu estado
	draw_text(x + sprite_width / 2, y + sprite_height * 1.5, estado);
}

reseta_draw();

var _raio = 0;

draw_healthbar(
	x,
	y - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 3),
	x + sprite_get_width(sprite_index),
	y - _grossura_barras - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 3),
	((hp / max_hp) * 100),
	c_dkgray,
	c_red,
	c_red,
	0, //left
	true,
	true
);

_raio = sprite_get_width(spr_ico_hp);
draw_set_colour(c_white);

draw_circle(
	(x - sprite_get_width(spr_ico_hp) * 1.5) + _raio / 2,
	(y - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 4)) + _raio / 2,
	_raio - 2,
	false
);

draw_sprite(
	spr_ico_hp,
	0,
	x - sprite_get_width(spr_ico_hp) * 1.5,
	y - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 4)
);

draw_healthbar(
	x,
	y - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 1.5),
	x + sprite_get_width(sprite_index),
	y - _grossura_barras - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 1.5),
	((spd / max_spd) * 100),
	c_dkgray,
	c_aqua,
	c_aqua,
	0, //left
	true,
	true
);

_raio = sprite_get_width(spr_ico_spd);
draw_set_colour(c_white);

draw_circle(
	(x - sprite_get_width(spr_ico_spd) * 1.5) + _raio / 2,
	(y - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 2.5)) + _raio / 2,
	_raio - 2,
	false
);

draw_sprite(
	spr_ico_spd,
	0,
	x - sprite_get_width(spr_ico_spd) * 1.5,
	y - sprite_get_height(sprite_index) / 6 - (_grossura_barras * 2.5)
);

draw_healthbar(
	x,
	y - sprite_get_height(sprite_index) / 6,
	x + sprite_get_width(sprite_index),
	y - _grossura_barras - sprite_get_height(sprite_index) / 6,
	((atk / max_atk) * 100),
	c_dkgray,
	c_yellow,
	c_yellow,
	0, //left
	true,
	true
);

_raio = sprite_get_width(spr_ico_atk);
draw_set_colour(c_white);

draw_circle(
	(x - sprite_get_width(spr_ico_atk) * 1.5) + _raio / 2,
	(y - sprite_get_height(sprite_index) / 6 - _grossura_barras) + _raio / 2,
	_raio - 2,
	false
);

draw_sprite(
	spr_ico_atk,
	0,
	x - sprite_get_width(spr_ico_atk) * 1.5,
	y - sprite_get_height(sprite_index) / 6 - _grossura_barras
);

reseta_draw();

