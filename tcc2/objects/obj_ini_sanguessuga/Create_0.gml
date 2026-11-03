//Inherit the parent event
event_inherited();

nome = "Sanguessuga";
cor = c_green;

hp	= 1 + global.fase;
spd = 2 + floor(global.fase / 3);
atk = 1 + floor(global.fase / 2);

//testes
sprite_index = spr_sanguessuga_ph;
//image_speed = 0;
//image_index = 2;