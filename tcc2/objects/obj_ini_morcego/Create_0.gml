//Inherit the parent event
event_inherited();

nome = "Morcego";
cor = c_red;

hp	= 3 + global.fase;
spd = 3 + floor(global.fase / 3);
atk = 2 + floor(global.fase / 2);

//testes
sprite_index = spr_morcego_ph;
//image_speed = 0;
//image_index = 1;