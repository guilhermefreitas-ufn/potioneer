if(!instance_exists(pai)) { instance_destroy(); exit; }

//DIMENSÕES DA SPRITE
var _largura_sprite = sprite_get_width(sprite);
var _altura_sprite = sprite_get_height(sprite);

//POSIÇÃO CONSIDERANDO A ORIGEM E A ESCALA
var _x0 = pai.x - sprite_get_xoffset(sprite) * escala_x;
var _y0 = pai.y - sprite_get_yoffset(sprite) * escala_y;

var _x1 = _x0 + _largura_sprite * escala_x;
var _y1 = _y0 + _altura_sprite	* escala_y;

//LIMITES VISUAIS
var _esquerda = min(_x0, _x1);
var _direita = max(_x0, _x1);

var _topo = min(_y0, _y1);
var _baixo = max(_y0, _y1);

//DIMENSÕES VISUAIS
var _largura = _direita - _esquerda;
var _altura = _baixo - _topo;

//DESENHANDO SOMBRA
draw_set_colour(c_dkgray);
draw_set_alpha(.5);

draw_ellipse(
	_esquerda + offset_x,
	_topo + (_altura * 0.75) + offset_y,
	_direita + offset_x,
	_topo + (_altura * 1.25) + offset_y,
	false
);

reseta_draw();