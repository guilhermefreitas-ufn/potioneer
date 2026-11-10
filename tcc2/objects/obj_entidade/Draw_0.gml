// ========================================
// CONFIGURAÇÕES DA INTERFACE
// ========================================

var _margem_condicoes = 8;
var _grossura_barras = 4;


// ========================================
// DEFININDO ATRIBUTOS MÁXIMOS
// ========================================

if(!setei_stats)
{
	max_hp = hp;
	max_spd = spd;
	max_atk = atk;

	setei_stats = true;
}


// ========================================
// ATUALIZANDO ATRIBUTOS MÁXIMOS
// ========================================

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


// ========================================
// DESENHANDO ENTIDADE
// ========================================

DesenhaSombra();

draw_self();

if(alpha > 0)
{
	HitFlash(alpha);
}


// ========================================
// REFERÊNCIA VISUAL DA SPRITE
// INDEPENDENTE DA ORIGEM
// ========================================

var _largura_sprite = sprite_get_width(sprite_index);
var _altura_sprite = sprite_get_height(sprite_index);

// POSIÇÃO SUPERIOR ESQUERDA
// CONSIDERANDO A ORIGEM E A ESCALA

var _x0 = x - sprite_get_xoffset(sprite_index) * image_xscale;
var _y0 = y - sprite_get_yoffset(sprite_index) * image_yscale;

// POSIÇÃO INFERIOR DIREITA

var _x1 = _x0 + _largura_sprite * image_xscale;
var _y1 = _y0 + _altura_sprite * image_yscale;

// LIMITES VISUAIS

var _esquerda = min(_x0, _x1);
var _direita = max(_x0, _x1);

var _topo = min(_y0, _y1);
var _baixo = max(_y0, _y1);

// DIMENSÕES VISUAIS

var _largura = _direita - _esquerda;
var _altura = _baixo - _topo;

// CENTRO VISUAL

var _centro_x = (_esquerda + _direita) / 2;
var _centro_y = (_topo + _baixo) / 2;


// ========================================
// CONFIGURAÇÕES DE TEXTO
// ========================================

define_align();
draw_set_font(fnt_placeholder_pequena);
draw_set_colour(cor);


// ========================================
// CONDIÇÕES E ESTADO
// ========================================

if(!global.debug)
{
	// CONDIÇÕES

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

		if(condicao[i] == "Revigorado")  { _cor = c_lime; }
		if(condicao[i] == "Acelerado")   { _cor = c_aqua; }
		if(condicao[i] == "Enfraquecido"){ _cor = c_yellow; }
		if(condicao[i] == "Paralisado")  { _cor = c_white; }

		draw_set_alpha(_alpha);

		define_align();
		draw_set_font(fnt_placeholder_pequena);

		// DESENHANDO CONDIÇÃO

		draw_text_outline(
			_centro_x,
			_topo + (_altura * 1.25) + (i * _margem_condicoes),
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
	// DESENHANDO ESTADO

	draw_text(
		_centro_x,
		_topo + (_altura * 1.5),
		estado
	);
}

reseta_draw();


// ========================================
// BARRAS DE ATRIBUTOS
// ========================================

// TRANSPARÊNCIA QUANDO SOBREPOSTO

if(place_meeting(x, y, obj_entidade) && object_index != obj_player)
{
	draw_set_alpha(.1);
}
else
{
	draw_set_alpha(1);
}


// ========================================
// HP
// ========================================

// POSIÇÃO DA BARRA

var _hp_y = _topo - (_altura / 6) - (_grossura_barras * 3);

draw_healthbar(
	_esquerda,
	_hp_y - _grossura_barras,
	_direita,
	_hp_y,
	((hp / max_hp) * 100),
	c_dkgray,
	c_red,
	c_red,
	0, // LEFT
	true,
	true
);


// ÍCONE HP

var _ico_hp_x = _esquerda - sprite_get_width(spr_ico_hp) * 1.5;
var _ico_hp_y = _topo - (_altura / 6) - (_grossura_barras * 4);

var _raio = sprite_get_width(spr_ico_hp);

draw_set_colour(c_white);

// CÍRCULO

draw_circle(
	_ico_hp_x + sprite_get_width(spr_ico_hp) / 2,
	_ico_hp_y + sprite_get_height(spr_ico_hp) / 2,
	_raio - 2,
	false
);

// SPRITE

draw_sprite(
	spr_ico_hp,
	0,
	_ico_hp_x + sprite_get_xoffset(spr_ico_hp),
	_ico_hp_y + sprite_get_yoffset(spr_ico_hp)
);


// ========================================
// SPD
// ========================================

// POSIÇÃO DA BARRA

var _spd_y = _topo - (_altura / 6) - (_grossura_barras * 1.5);

draw_healthbar(
	_esquerda,
	_spd_y - _grossura_barras,
	_direita,
	_spd_y,
	((spd / max_spd) * 100),
	c_dkgray,
	c_aqua,
	c_aqua,
	0, // LEFT
	true,
	true
);


// ÍCONE SPD

var _ico_spd_x = _esquerda - sprite_get_width(spr_ico_spd) * 1.5;
var _ico_spd_y = _topo - (_altura / 6) - (_grossura_barras * 2.5);

_raio = sprite_get_width(spr_ico_spd);

draw_set_colour(c_white);

// CÍRCULO

draw_circle(
	_ico_spd_x + sprite_get_width(spr_ico_spd) / 2,
	_ico_spd_y + sprite_get_height(spr_ico_spd) / 2,
	_raio - 2,
	false
);

// SPRITE

draw_sprite(
	spr_ico_spd,
	0,
	_ico_spd_x + sprite_get_xoffset(spr_ico_spd),
	_ico_spd_y + sprite_get_yoffset(spr_ico_spd)
);


// ========================================
// ATK
// ========================================

// POSIÇÃO DA BARRA

var _atk_y = _topo - (_altura / 6);

draw_healthbar(
	_esquerda,
	_atk_y - _grossura_barras,
	_direita,
	_atk_y,
	((atk / max_atk) * 100),
	c_dkgray,
	c_yellow,
	c_yellow,
	0, // LEFT
	true,
	true
);


// ÍCONE ATK

var _ico_atk_x = _esquerda - sprite_get_width(spr_ico_atk) * 1.5;
var _ico_atk_y = _topo - (_altura / 6) - _grossura_barras;

_raio = sprite_get_width(spr_ico_atk);

draw_set_colour(c_white);

// CÍRCULO

draw_circle(
	_ico_atk_x + sprite_get_width(spr_ico_atk) / 2,
	_ico_atk_y + sprite_get_height(spr_ico_atk) / 2,
	_raio - 2,
	false
);

// SPRITE

draw_sprite(
	spr_ico_atk,
	0,
	_ico_atk_x + sprite_get_xoffset(spr_ico_atk),
	_ico_atk_y + sprite_get_yoffset(spr_ico_atk)
);


// ========================================
// RESETANDO CONFIGURAÇÕES DE DRAW
// ========================================

reseta_draw();