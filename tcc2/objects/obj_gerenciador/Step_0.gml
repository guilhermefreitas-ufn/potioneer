//iniciando variáveis
var _b, _r;

_b = keyboard_check_pressed(ord("B"));
_r = keyboard_check_pressed(ord("R"));

//usando teclas
//debug
if(_b) { global.debug = !global.debug; }

//trocando de room
var _nova_room = noone;

switch(room)
{
	case rm_inventario: { _nova_room = rm_teste; break; }
	case rm_teste:		{ _nova_room = rm_inventario; break; }
}

//if(_r) { room_goto(_nova_room); }

//resetando o jogo
if(_r) { game_restart(); }