if(state == 0) exit;

switch(state)
{
	case 1: //FECHANDO (Iris Out para foco)
	{
		//show_debug_message("Estado: " + string(state) + " rodando.");
		
		//O raio diminui até o raio mínimo de saída
		radius = max(radius_min_out, radius - radius_speed);
		
		if(radius <= radius_min_out)
		{
			if(radius_min_out > 0 && focus_time_out_frames > 0)
			{
				state = 2; //FOCO_SAIDA
			}
			else
			{
				state = 3; //FECHAMENTO_TOTAL (se não tem foco, fecha totalmente)
			}
		}
		break;
	}
	
	case 2: //FOCO_SAIDA (Pausa)
	{
		//show_debug_message("Estado: " + string(state) + " rodando.");
		focus_time_out_frames--;
		
		if(focus_time_out_frames <= 0)
		{
			state = 3; //FECHAMENTO_TOTAL
		}
		break;
	}
	
	case 3: //FECHAMENTO_TOTAL
	{
		//show_debug_message("Estado: " + string(state) + " rodando.");
		
		//O raio diminui até zero
		radius = max(0, radius - radius_speed);
		
		if(radius <= 0)
		{
			state = 4; //TROCA_ROOM
		}
		break;
	}
	
	case 4: //GOTO_ROOM
	{
		//show_debug_message("Estado: " + string(state) + " rodando.");
		
		//1. Troca de room
		room_goto(target_room);
		
		//2. Reseta a flag de setup
		setup_done = false;
		
		//3. Avança para o estado de abertura
		state = 5;
		
		break;
	}
	
	case 5: //ABERTURA_INICIAL (Setup na nova room e Inicia o crescimento do foco)
	{
		//1. SETUP (RODA APENAS UMA VEZ AO ENTRAR NA ROOM)
		if(!setup_done)
		{
			var _view_w = camera_get_view_width(view_camera[0]);
			var _view_h = camera_get_view_height(view_camera[0]);
			
			//Garantia extra caso a câmera do GM ainda não tenha carregado o tamanho
			if(_view_w == 0 || _view_h == 0) { _view_w = RES_W; _view_h = RES_H; }
			
			radius_max = ceil(point_distance(0, 0, _view_w, _view_h));
			radius = 0; //Começa fechado (tudo preto)
			
			var _target_instance = noone;
			
			if(alvo_in_id != noone)
			{
				_target_instance = instance_find(alvo_in_id, 0);
			}
			
			if(instance_exists(_target_instance))
			{
				//Alvo Encontrado
				alvo_in_id = _target_instance;
				
				var _spr_in = alvo_in_id.sprite_index;
				
				//Proteção anti-crash: Garante que o alvo tem um sprite
				if(_spr_in != -1)
				{
					var _spr_w_in = sprite_get_width(_spr_in);
					var _spr_h_in = sprite_get_height(_spr_in);
					
					radius_min_in = max(_spr_w_in, _spr_h_in) / 2;
					
					var _spr_xoff_in = sprite_get_xoffset(_spr_in);
					var _spr_yoff_in = sprite_get_yoffset(_spr_in);
					
					center_x = (alvo_in_id.x - _spr_xoff_in) + (_spr_w_in / 2);
					center_y = (alvo_in_id.y - _spr_yoff_in) + (_spr_h_in / 2);
				}
				else
				{
					radius_min_in = 16;
					center_x = alvo_in_id.x;
					center_y = alvo_in_id.y;
				}
			
				//SNAP DA CÂMERA NATIVA
				//Forçamos a view nativa do GameMaker a ir para o alvo 
				//para que o círculo apareça na tela e não fique tudo preto!
				var _cam_x = center_x - (_view_w / 2);
				var _cam_y = center_y - (_view_h / 2);
				
				//Impede que a câmera vaze para fora dos limites da room
				_cam_x = clamp(_cam_x, 0, max(0, room_width - _view_w));
				_cam_y = clamp(_cam_y, 0, max(0, room_height - _view_h));
				
				//Move a view do GameMaker imediatamente antes de desenhar
				camera_set_view_pos(view_camera[0], _cam_x, _cam_y);
			}
			else
			{
				//Alvo Não Encontrado: Foco no centro da tela
				alvo_in_id = noone;
				focus_time_in_frames = 0;
				radius_min_in = 0;
				
				center_x = camera_get_view_x(view_camera[0]) + (RES_W / 2);
				center_y = camera_get_view_y(view_camera[0]) + (RES_H / 2);
			}
			
			setup_done = true;
		}
		
		//2. ANIMAÇÃO 
		if(alvo_in_id != noone && instance_exists(alvo_in_id))
		{
			var _spr = alvo_in_id.sprite_index;
			
			if(_spr != -1)
			{
				center_x = (alvo_in_id.x - sprite_get_xoffset(_spr)) + (sprite_get_width(_spr) / 2);
				center_y = (alvo_in_id.y - sprite_get_yoffset(_spr)) + (sprite_get_height(_spr) / 2);
			}
			
			radius = min(radius_min_in, radius + radius_speed);
			
			if(radius >= radius_min_in)
			{
				if(focus_time_in_frames > 0)
				{
					state = 6; //Vai para o Foco (Pausa)
				}
				else
				{
					state = 7; //Pula o Foco e abre total
				} 
			}
		}
		else 
		{
			state = 7; //Pula direto para a abertura total
		}
		
		break;
	}
	
	case 6: //FOCO (Pause)
	{
		focus_time_in_frames--;
		
		if(instance_exists(alvo_in_id))
		{
			var _spr = alvo_in_id.sprite_index;
			
			if(_spr != -1)
			{
				center_x = (alvo_in_id.x - sprite_get_xoffset(_spr)) + (sprite_get_width(_spr) / 2);
				center_y = (alvo_in_id.y - sprite_get_yoffset(_spr)) + (sprite_get_height(_spr) / 2);
			}
		}
		
		if(focus_time_in_frames <= 0)
		{
			state = 7; 
		}
		
		break;
	}
	
	case 7: //ABRINDO (Total)
	{
		if(instance_exists(alvo_in_id))
		{
			var _spr = alvo_in_id.sprite_index;
			
			if(_spr != -1)
			{
				center_x = (alvo_in_id.x - sprite_get_xoffset(_spr)) + (sprite_get_width(_spr) / 2);
				center_y = (alvo_in_id.y - sprite_get_yoffset(_spr)) + (sprite_get_height(_spr) / 2);
			}
		}
		
		radius = min(radius_max, radius + radius_speed);
		
		if(radius >= radius_max)
		{
			state = 0; //NONE
			
			if(global.overlay_pendente != "")
			{
				var _tipo_pendente = global.overlay_pendente;
				global.overlay_pendente = "";
				controla_overlay(_tipo_pendente, true);
			} 
			else 
			{
				if(global.pause) { global.pause = false; }
			}
			
			instance_destroy(); 
		}
		
		break;
	}
}