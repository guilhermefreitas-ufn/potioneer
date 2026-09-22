// Inherit the parent event
event_inherited();

nome = "Player";
cor = c_black;

hp = 20;
spd = 5;
atk = 3;

//testes
sprite_index = spr_placeholder_32;
image_speed = 0;
image_index = 0;

//movimentação
estado = "parado";
velh = 0;
velv = 0;

direita = 0;
esquerda = 0;
cima = 0;
baixo = 0;

PegaControles = function()
{
	direita = keyboard_check(ord("D")); 
	esquerda = keyboard_check(ord("A")); 
	cima = keyboard_check(ord("W")); 
	baixo = keyboard_check(ord("S"));
	
	//removar daqui se quiser desabilitar os controles em algum estado
	//"paralisado", por exemplo
	
	var _dir = point_direction(0, 0, direita - esquerda, baixo - cima);
	
	if(direita xor esquerda or baixo xor cima)
	{
		velh = lengthdir_x(spd, _dir);
		velv = lengthdir_y(spd, _dir);
	}
	else
	{
		velh = 0;
		velv = 0;
	}
}