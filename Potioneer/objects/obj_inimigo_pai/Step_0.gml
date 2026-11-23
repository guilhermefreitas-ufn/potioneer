event_inherited();

//VERIFICAÇÃO DA VIDA
if(hp <= 0 && estado != "sofrendo" && estado != "morto")
{
	MudaEstado("morto");
}

//DETECÇÃO DO JOGADOR
var pcentro_x = 0;
var pcentro_y = 0;

//Durante os estados morto e sofrendo,
//não iniciamos uma nova perseguição.
if(estado != "morto" && estado != "sofrendo")
{
	if(instance_exists(obj_player))
	{
		var _player = instance_find(
			obj_player,
			0
		);
				
		pcentro_x = _player.Centro()[0];
		pcentro_y = _player.Centro()[1];
		
		var _parede = collision_line(
			x+sprite_width/2,
			y+sprite_height/2,
			pcentro_x,
			pcentro_y,
			obj_wall,
			false,
			true
		);
				
		var _distancia = point_distance(
			x,
			y,
			pcentro_x,
			pcentro_y
		);
		
		//Prioridade 1: contato com o jogador
		if(place_meeting(x, y, obj_player))
		{
			MudaEstado("atacando");
		}
		//Prioridade 2: jogador dentro do alcance
		else if(_distancia <= raio_perseguicao && !_parede)
		{
			MudaEstado("perseguindo");
		}
		//Prioridade 3: jogador distante
		else if(estado == "perseguindo" || estado == "atacando")
		{
			MudaEstado("movendo");
		}
	}
	else
	{
		//Sem jogador, não continua perseguindo
		if(estado == "perseguindo" || estado == "atacando")
		{
			MudaEstado("movendo");
		}
	}
}

//3. MÁQUINA DE ESTADOS
switch (estado)
{ 
	case "parado":
	{
		if(spd > 0)
		{
			MudaEstado("movendo");
		}
		
		break;
	}
	case "movendo":
	{
		if(spd > 0)
		{
			MovimentoAleatorio(spd / 2);
		}
		else
		{
			MudaEstado("parado");
		}
				
		//Verifica a distância entre a posição atual e a do frame anterior
		//Se moveu menos que 0.5 pixels, consideramos que está travado
		if(point_distance(x, y, xprevious, yprevious) < 0.5)
		{
			stuck_timer++;
			
			//Se o tempo travado ultrapassou os 3 segundos
			if(stuck_timer >= tempo_limite_stuck)
			{
				//1. Encontra a posição múltipla de 32 mais próxima
				x = round(x / CELL_T) * CELL_T;
				y = round(y / CELL_T) * CELL_T;
				
				//2. Para o path atual para ele não tentar voltar pra rota bugada
				path_end();
				
				//3. Zera o timer
				stuck_timer = 0; 
				
				//Força a atualização imediata da rota
				calc_timer = 0; 
			}
		}
		else
		{
			//Se ele está se movendo normalmente, zera o timer de travamento
			stuck_timer = 0;
		}
		
		break;
	}
	case "perseguindo":
	{
		
		if(spd > 0)
		{
			calc_timer--;
			
			if(calc_timer <= 0)
			{
				//Passamos o centro do inimigo e do player para o grid achar a célula correta
				var centro_x = x + (sprite_width / 2);
				var centro_y = y + (sprite_height / 2);
				//var player_centro_x = obj_player.Centro()[0];
				//var player_centro_y = obj_player.Centro()[1];
				
				var encontrou_caminho = mp_grid_path(
					global.grid,
					caminho,
					centro_x,
					centro_y,
					pcentro_x,
					pcentro_y,
					true
				);
				
				if(encontrou_caminho)
				{
					//Desloca o caminho inteiro metade do tamanho do sprite para trás
					path_shift(caminho, -(sprite_width / 2), -(sprite_height / 2));
					
					path_start(caminho, spd / 2, path_action_stop, false);
				}
				
				calc_timer = calc_delay;
			}
		}
		else
		{
			//Interrompe o movimento do path no exato momento em que a velocidade zera
			path_end();
			
			MudaEstado("parado");
		}
		
		break;
	}
	case "atacando":
	{
		//O inimigo permanece parado enquanto está em contato com o jogador.
		//O dano é processado no Step do player.
		break;
	}
	case "sofrendo":
	{
		if(!sofrendo_fx_feito)
        {
            criar_efeito(x, y, "screenshake", c_white, { shake: 3.5, shake_dec_spd: 0.85 });
            sofrendo_fx_feito = true;
        }
		
		tempo_estado--;
		
		if(tempo_estado <= 0)
		{
			if(hp <= 0)
			{
				MudaEstado("morto");
			}
			else
			{
				if(instance_exists(obj_player))
				{
					var _alvo = instance_find(
						obj_player,
						0
					);
					
					var _distancia_alvo = point_distance(
						x,
						y,
						_alvo.Centro()[0],
						_alvo.Centro()[1]
					);
					
					if(_distancia_alvo <= raio_perseguicao)
					{
						MudaEstado("perseguindo");
					}
					else
					{
						MudaEstado("movendo");
					}
				}
				else
				{
					MudaEstado("movendo");
				}
			}
		}
		
		break;
	}
	case "morto":
	{
		//show_debug_message("Inimigo destruído!");
		
		instance_destroy();
		
		exit;
	}
	default:
	{
		MudaEstado("parado");
	
		break;
	}
}