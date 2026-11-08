//draw_circle_colour(x + sprite_width/2, y + sprite_height, sprite_get_width())
var _margem_condicoes = 8;
var _grossura_barras = 4;
//var _max_hp = 0;
//var _max_spd = 0;
//var _max_atk = 0;

//setanto meus atributos máximos
if(!setei_stats)
{
	max_hp = hp;
	max_spd = spd;
	max_atk = atk;
	
	setei_stats = true;
}

//Atualizando meus atributos máximos
if(hp > max_hp)
{
	max_hp = hp;
}
if(spd > max_spd)
{
	max_spd = spd;
}
if(atk > max_atk)
{
	max_atk = atk;
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
//	y+sprite_height*1.1,
//	nome
//);

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

if(!global.debug)
{
	//CONDIÇÕES
	var _alpha = 1;
	
	if(array_length(condicao) > 0)
	{
		_alpha = max(
	        sin(get_timer() / 100000),
	        0.1
	    );
	}
	
	for(var i = 0; i < array_length(condicao); i++)
	{
		var _cor = c_white;
		
		if(condicao[i] == "Revigorado")		{ _cor = c_lime; }
		if(condicao[i] == "Acelerado")		{ _cor = c_aqua; }
		if(condicao[i] == "Enfraquecido")	{ _cor = c_yellow; }
		if(condicao[i] == "Paralisado")		{ _cor = c_white; }
		
		//draw_set_colour(_cor);
		draw_set_alpha(_alpha);
		define_align();
		draw_set_font(fnt_placeholder_pequena);
		
		//desenhando meu estado
		draw_text_outline(
			x + (sprite_width / 2),
			y + (sprite_height * 1.25) + (i * _margem_condicoes),
			condicao[i],
			_cor,
			c_dkgray,
			.5,
			.5,
			.5
		);
		
		reseta_draw();
	}
}
else
{
	//desenhando meu estado
	draw_text(x + sprite_width / 2, y + sprite_height * 1.5, estado);
}

reseta_draw();

//BARRAS DE STATS
var _raio = 0;

if(place_meeting(x,y,obj_entidade) && object_index != obj_player)
{
	draw_set_alpha(.1);
}
else
{
	draw_set_alpha(1);
}

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

