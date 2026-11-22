atk = 1;
hp = 1;
spd = 1;

max_hp = 0;
max_spd = 0;
max_atk = 0;

velv = 0;
velh = 0;

nome = "";
cor = c_white;

alpha = 0;

condicao = [];

setei_stats = false;

direcao = 0;

//CENTRO DA ENTIDADE
Centro = function()
{
	//DIMENSÕES DA SPRITE
	var _largura = sprite_get_width(sprite_index);
	var _altura = sprite_get_height(sprite_index);
	
	//LIMITES VISUAIS CONSIDERANDO A ORIGEM E A ESCALA
	var _x0 = x - sprite_get_xoffset(sprite_index) * image_xscale;
	var _y0 = y - sprite_get_yoffset(sprite_index) * image_yscale;
	
	var _x1 = _x0 + _largura * image_xscale;
	var _y1 = _y0 + _altura * image_yscale;
	
	//CENTRO VISUAL
	var _centro_x = (min(_x0, _x1) + max(_x0, _x1)) / 2;
	var _centro_y = (min(_y0, _y1) + max(_y0, _y1)) / 2;
	
	return [
		_centro_x,
		_centro_y
	];
};