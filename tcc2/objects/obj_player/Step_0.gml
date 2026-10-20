//Inherit the parent event
event_inherited();

if(hp <= 0)
{
	instance_destroy();
	exit;
}

PegaControles();

move_and_collide(velh, velv, all);

//poções
if(room == rm_masmorra)
{
	var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));
	var _2 = keyboard_check_pressed(vk_numpad2) || keyboard_check_pressed(ord("2"));
	var _3 = keyboard_check_pressed(vk_numpad3) || keyboard_check_pressed(ord("3"));
	var _4 = keyboard_check_pressed(vk_numpad4) || keyboard_check_pressed(ord("4"));
	var _5 = keyboard_check_pressed(vk_numpad5) || keyboard_check_pressed(ord("5"));

	//usando poções
	if(_1) { ExecutaPocao(1); }
	if(_2) { ExecutaPocao(2); }
	if(_3) { ExecutaPocao(3); }
	if(_4) { ExecutaPocao(4); }
	if(_5) { ExecutaPocao(5); }
}

//dano e invencibilidade
var inimigo = instance_place(x,y,obj_inimigo_pai);

if(inimigo && !invencivel)
{
	hp -= inimigo.atk;
	invencivel = true;
	tempo_invencivel = invencivel_timer;
}

if(invencivel && tempo_invencivel > 0)
{
	tempo_invencivel--;
	image_alpha = max(sin(get_timer()/100000), 0.2);
}
else
{
	invencivel = false;
	image_alpha = 1;
}