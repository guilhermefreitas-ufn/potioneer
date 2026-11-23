event_inherited();

#region ILUMINAÇÃO

var _cp = Centro();

if(luz == noone)
{
	luz = cria_luz(_cp[0], _cp[1], luz_tam, luz_tam);
}
else
{
	luz.pos_x = _cp[0];
	luz.pos_y = _cp[1];
}

#endregion

if(global.pause) { exit; }

rastro_fx.pausado = (estado != "movendo");

//Iniciando Variáveis
var _mouse_na_hotbar = false;
//var _mouse_na_hotbar = MouseSobreSlotHotbar();
		
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

//Botão de "Como Jogar"
var _botao_raio = 16;
var _margem = 32;

var _x = RES_W - _margem;
var _y = _margem;

var _hover_como_jogar = point_in_circle(_mx, _my, _x, _y, _botao_raio);

//VERIFICAÇÃO DA VIDA
if(hp <= 0 && estado != "sofrendo" && estado != "morto")
{
	MudaEstado("morto");
}

switch (estado) //MÁQUINA DE ESTADOS
{
	case "parado":
	{
		AtualizaMovimento();
		
		muda_sprite(
			DefineSprite(
				direcao,
				spr_player_idle_frente,
				spr_player_idle_lado,
				spr_player_idle_costas
			)
		);
		
		break;
	}
	case "movendo":
	{
		AtualizaMovimento();
				
		//direcao = point_direction(0, 0, direita - esquerda, baixo - cima);
		
		//show_debug_message(direcao);
		
		muda_sprite(
			DefineSprite(
				direcao,
				spr_player_walk_frente,
				spr_player_walk_lado,
				spr_player_walk_costas
			)
		);
		
		break;
	}
	case "atacando":
	{
		tempo_estado--;
		
		if(tempo_estado <= 0)
		{
			MudaEstado("parado");
		}
		
		break;
	}
	case "sofrendo":
	{
		if(!sofrendo_fx_feito)
        {
            criar_efeito(x, y, "screenshake", c_white, { shake: 10, shake_dec_spd: 0.85 });
            sofrendo_fx_feito = true;
        }
		
		tempo_estado--;
		
		if(tempo_estado <= 0)
		{
			if(hp <= 0)
			{
				CriaMensagem(Centro()[0],Centro()[1],"Derrota!");
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
		
		if(tempo_estado <= 0)
		{
			MudaEstado("parado");
		}
		
		break;
	}
	case "morto":
	{		
		//Verificando se a Mensagem de Derrota já acabou
		
		//se não existe mensagem
		if(!instance_exists(obj_mensagem))
		{
			//me destruo
			instance_destroy();
		}
		
		//se existe mensagem
		else
		{
			//inicio dizendo que não nenhuma mensagem é a de Derrota
			var _tem = false;
			
			//cada mensagem...
			with(obj_mensagem)
			{
				//...verifica se seu texto é "Derrota"
				if(texto == "Derrota!")
				{
					//se for, gravo que tem Mensagem de Derrota
					_tem = true;
				}
			}
			
			//se nenhuma mensagem é a mensagem de Derrota
			if(!_tem)
			{
				//me destruo
				instance_destroy();
			}
		}
		
		//tô morto, não faço mais nada
		exit;
	}
	default:
	{
		MudaEstado("parado");
	
		break;
	}
}
//COOLDOWN DAS POÇÕES
for(var i = 0; i < SLOTS_HOTBAR_POCOES; i++)
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

#region SELEÇÃO E USO DE POÇÕES
//SELEÇÃO POR TECLADO
var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));
var _2 = keyboard_check_pressed(vk_numpad2) || keyboard_check_pressed(ord("2"));
var _3 = keyboard_check_pressed(vk_numpad3) || keyboard_check_pressed(ord("3"));
var _4 = keyboard_check_pressed(vk_numpad4) || keyboard_check_pressed(ord("4"));
var _5 = keyboard_check_pressed(vk_numpad5) || keyboard_check_pressed(ord("5"));
var _click_esq = mouse_check_button_pressed(mb_left);
var _click_dir = mouse_check_button_pressed(mb_right);

if(_1) { pocao_selecionada = 0; }
if(_2) { pocao_selecionada = 1; }
if(_3) { pocao_selecionada = 2; }
if(_4) { pocao_selecionada = 3; }
if(_5) { pocao_selecionada = 4; }

//SELEÇÃO PELO SCROLL
if(mouse_wheel_up())
{
	pocao_selecionada =
	(
		pocao_selecionada
		- 1
		+ SLOTS_HOTBAR_POCOES
	)
	mod SLOTS_HOTBAR_POCOES;
}
else if(mouse_wheel_down())
{
	pocao_selecionada =
	(
		pocao_selecionada
		+ 1
	)
	mod SLOTS_HOTBAR_POCOES;
}

//USO DAS POÇÕES
//Só permite iniciar uma ação enquanto parado ou movendo.
if(estado == "parado" || estado == "movendo")
{
	//CLIQUE ESQUERDO: arremessar
	if(_click_esq && !_mouse_na_hotbar && !_hover_como_jogar)
	{
		if(ExecutaPocao("mouse"))
		{
			if(hp > 0 && estado != "sofrendo" && estado != "morto")
			{
				MudaEstado("atacando");
			}
		}
	}
	
	//CLIQUE DIREITO: quebrar aos pés
	else if(_click_dir)
	{
		if(ExecutaPocao("player_area"))
		{
			if(hp > 0 && estado != "sofrendo" && estado != "morto")
			{
				MudaEstado("atacando");
			}
		}
	}
}
#endregion

//DANO DE CONTATO DOS INIMIGOS
var inimigo = instance_place(
	x,
	y,
	obj_inimigo_pai
);

//Só recebe dano de um inimigo que esteja atacando
if(
	inimigo != noone
	&& instance_exists(inimigo)
	&& inimigo.estado == "atacando"
	&& !invencivel
	&& inimigo.atk > 0
)
{
	//Aplica o dano e atualiza o estado
	AplicaDanoEntidade(
		id,
		inimigo.atk
	);
	
	//Ativa a invencibilidade
	invencivel = true;
	
	tempo_invencivel = invencivel_timer;
}

//INVENCIBILIDADE E PISCAR DO SPRITE
if(invencivel && tempo_invencivel > 0)
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