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
    // SELEÇÃO POR TECLADO
    if(_1) { pocao_selecionada = 0; }
	if(_2) { pocao_selecionada = 1; }
    if(_3) { pocao_selecionada = 2; }
	if(_4) { pocao_selecionada = 3; }
	if(_5) { pocao_selecionada = 4; }

    // SELEÇÃO PELO SCROLL
    if(mouse_wheel_up())
    {
        pocao_selecionada = (pocao_selecionada - 1 + SLOTS_HOTBAR_POCOES) mod SLOTS_HOTBAR_POCOES;
    }
    else if(mouse_wheel_down())
    {
        pocao_selecionada = (pocao_selecionada + 1) mod SLOTS_HOTBAR_POCOES;
    }

    // USO DA POÇÃO SELECIONADA

    // Botão esquerdo: cursor
    if(mouse_check_button_pressed(mb_left))
    {
        ExecutaPocao("mouse");
    }

    // Botão direito: área ao redor do jogador
    if(mouse_check_button_pressed(mb_right))
    {
        ExecutaPocao("player_area");
    }

    // Espaço: somente o jogador
    if(keyboard_check_pressed(vk_space))
    {
        ExecutaPocao("player_only");
    }
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