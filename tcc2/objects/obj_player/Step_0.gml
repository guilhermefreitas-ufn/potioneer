event_inherited();

// VERIFICAÇÃO DA VIDA
if (hp <= 0 && estado != "sofrendo" && estado != "morto")
{
    MudaEstado("morto");
}

// MÁQUINA DE ESTADOS
switch (estado)
{
    case "parado":
	{
        AtualizaMovimento();

        break;
	}
    case "movendo":
    {
        AtualizaMovimento();

        break;
	}
    case "atacando":
    {
        tempo_estado--;

        if (tempo_estado <= 0)
        {
            MudaEstado("parado");
        }

        break;
	}
    case "sofrendo":
	{
        tempo_estado--;

        if (tempo_estado <= 0)
        {
			if(hp <= 0)
			{
				MudaEstado("morto");
			}
			else
			{
				MudaEstado("parado");
			}
        }

        break;
	}
    case "bebendo":
    {

        tempo_estado--;

        if (tempo_estado <= 0)
        {
            MudaEstado("parado");
        }

        break;


	}
    case "morto":
    {

        instance_destroy();

        exit;


	}
    default:
    {

        MudaEstado("parado");

        break;
	}
}


if (room == rm_masmorra)
{
	// COOLDOWN DAS POÇÕES
    for (
        var i = 0;
        i < SLOTS_HOTBAR_POCOES;
        i++
    )
    {
        var _pocao =
            global.DadosJogador.hotbar_pocoes[i];

        if (is_undefined(_pocao))
        {
            continue;
        }

        if (_pocao.cooldown > 0)
        {
            _pocao.cooldown--;
        }
    }

	#region SELEÇÃO E USO DE POÇÕES
	// SELEÇÃO POR TECLADO
    var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));
    var _2 = keyboard_check_pressed(vk_numpad2) || keyboard_check_pressed(ord("2"));
    var _3 = keyboard_check_pressed(vk_numpad3) || keyboard_check_pressed(ord("3"));
    var _4 = keyboard_check_pressed(vk_numpad4) || keyboard_check_pressed(ord("4"));
    var _5 = keyboard_check_pressed(vk_numpad5) || keyboard_check_pressed(ord("5"));

    if (_1) { pocao_selecionada = 0; }
    if (_2) { pocao_selecionada = 1; }
    if (_3) { pocao_selecionada = 2; }
    if (_4) { pocao_selecionada = 3; }
    if (_5) { pocao_selecionada = 4; }

    // SELEÇÃO PELO SCROLL
    if (mouse_wheel_up())
    {
        pocao_selecionada =
            (
                pocao_selecionada
                - 1
                + SLOTS_HOTBAR_POCOES
            )
            mod SLOTS_HOTBAR_POCOES;
    }
    else if (mouse_wheel_down())
    {
        pocao_selecionada =
            (
                pocao_selecionada
                + 1
            )
            mod SLOTS_HOTBAR_POCOES;
    }
	
    // USO DAS POÇÕES
    // Só permite iniciar uma ação enquanto
    // parado ou movendo.
    if (
        estado == "parado"
        || estado == "movendo"
    )
    {
        var _mouse_na_hotbar =
            MouseSobreSlotHotbar();

        // CLIQUE ESQUERDO: arremessar
        if (
            mouse_check_button_pressed(mb_left)
            && !_mouse_na_hotbar
        )
        {
            if (ExecutaPocao("mouse"))
            {
                // Um efeito imediato pode ter causado
                // dano ao próprio jogador. Não devemos
                // substituir esse estado por atacando.
                if (
                    hp > 0
                    && estado != "sofrendo"
                    && estado != "morto"
                )
                {
                    MudaEstado("atacando");
                }
            }
        }

        // CLIQUE DIREITO: quebrar aos pés
        else if (
            mouse_check_button_pressed(mb_right)
            && !_mouse_na_hotbar
        )
        {
            if (ExecutaPocao("player_area"))
            {
                if (
                    hp > 0
                    && estado != "sofrendo"
                    && estado != "morto"
                )
                {
                    MudaEstado("atacando");
                }
            }
        }

        // ESPAÇO: beber
        else if (keyboard_check_pressed(vk_space))
        {
            if (ExecutaPocao("player_only"))
            {
                if (
                    hp > 0
                    && estado != "sofrendo"
                    && estado != "morto"
                )
                {
                    MudaEstado("bebendo");
                }
            }
        }
    }
	#endregion
	
	#region ILUMINAÇÃO
	
	var _cp = CentroPlayer();
	
	if(luz == noone)
	{
		//var _luz_tam = 256;
		
		luz = cria_luz(_cp[0], _cp[1], luz_tam, luz_tam);
	}
	else
	{
		luz.pos_x = _cp[0];
		luz.pos_y = _cp[1];
	}
	
	#endregion
}


if (room == rm_masmorra)
{
    
    
}

// DANO DE CONTATO DOS INIMIGOS
var inimigo = instance_place(
    x,
    y,
    obj_inimigo_pai
);

// Só recebe dano de um inimigo que esteja atacando
if (
    inimigo != noone
    && instance_exists(inimigo)
    && inimigo.estado == "atacando"
    && !invencivel
    && inimigo.atk > 0
)
{
    // Aplica o dano e atualiza o estado
    AplicaDanoEntidade(
        id,
        inimigo.atk
    );

    // Ativa a invencibilidade
    invencivel = true;

    tempo_invencivel = invencivel_timer;
}

// INVENCIBILIDADE E PISCAR DO SPRITE
if (invencivel && tempo_invencivel > 0)
{
    tempo_invencivel--;

    image_alpha = max(
        sin(get_timer() / 100000),
        0.2
    );
}
else
{
    invencivel = false;

    image_alpha = 1;
}