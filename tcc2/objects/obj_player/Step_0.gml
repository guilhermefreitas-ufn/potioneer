//Inherit the parent event
event_inherited();

//se nao tenho vida
if(hp <= 0)
{
	//me destruo
	instance_destroy();
	//não executo mais nada
	exit;
}

PegaControles();

move_and_collide(velh, velv, all);

//poções
if(room == rm_masmorra)
{
	//pegando as teclas
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

//cooldown poções
if(room == rm_masmorra)
{
	for(
		var i = 0;
		i < SLOTS_HOTBAR_POCOES;
		i++
	)
	{
		var _pocao =
			global.DadosJogador.hotbar_pocoes[i];

		if(is_undefined(_pocao))
		{
			continue;
		}

		if(_pocao.cooldown > 0)
		{
			_pocao.cooldown--;
		}
	}
}

//dano e invencibilidade
var inimigo = instance_place(x,y,obj_inimigo_pai);

//se colidi com o inimigo
//se não estou invencivel
//se o ataque do inimigo é > que 0
if(inimigo && !invencivel && inimigo.atk > 0)
{
	hp -= inimigo.atk; //tomo dano
	invencivel = true; //fico invencivel
	tempo_invencivel = invencivel_timer; //aciono meu timer de invencibilidade
}

//se estou invencível e o timer de invencibilidade foi acionado
if(invencivel && tempo_invencivel > 0)
{
	tempo_invencivel--; //diminuo a duração da invencibilidade
	image_alpha = max(sin(get_timer()/100000), 0.2); //pisco
}
//se não
else
{
	invencivel = false; //deixo de ficar invencível
	image_alpha = 1; //paro de piscar
}