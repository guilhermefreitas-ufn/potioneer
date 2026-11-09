//desenhando meu título
define_align();
draw_set_font(fnt_grande_titulo);
draw_text_outline(
	RES_W / 2,
	RES_H / 4,
	"Potioneer",
	c_orange,
	c_red,
	1
);

reseta_draw();

//pegando a posicao do mouse
var _m_x = device_mouse_x_to_gui(0);
var _m_y = device_mouse_y_to_gui(0);

//pegando o input do mouse
var _left_click = mouse_check_button_released(mb_left);

//desenhando meu menu
for(var i = 0; i < options_tam; i++)
{
	var _options_y_2 = options_y + options_dist * i;
	
	//definindo fonte, alinhamento e cor
	draw_set_font(options_fnt);
	define_align();
	var _cor = c_white;
	var _cor_contorno = c_gray;
	
	//definindo a caixa de colisão das opções
	var _string_w = string_width(options[i]);
	var _string_h = string_height(options[i]);
	
	var hover = point_in_rectangle(
		_m_x, _m_y,
		options_x - _string_w / 2,
		_options_y_2 - _string_h / 2,
		options_x + _string_w / 2,
		_options_y_2 + _string_h / 2
	);
	
	//checando a colisão
	if(hover && !global.overlay_ativo && options[i] != "Como Jogar")
	{
		//mudando a cor
		//_cor = global.dourado_highlight;
		//_cor_contorno = global.dourado_claro;
		//_cor_contorno = global.dourado_médio;
		
		//_cor = global.dourado_claro;
		//_cor_contorno = global.dourado_escuro;
		_cor = c_yellow;
		_cor_contorno = c_olive;
		
		//pegando o índice da opção e tocando som
		if(index != i)
		{
			
			index = i;
			//obj_sfx.mouse_hover_snd = true;
		}
		
		//configurando minhas opções
		if(_left_click)
		{
			//toca meu som
			//obj_sfx.mouse_click_snd = true;
			
			//verificando se tem save
			var _filename = "savedata.sav";
			
			//novo jogo
			if(index == 0)
			{
				//if(file_exists(_filename))
				//{
				//	show_debug_message("tentei new game com save");
				//	//controla_overlay("loss save", true);
				//}
				//else
				//{
					//reseta tudo
					IniciaNovoJogo();

					// EXCLUI O SAVE ANTERIOR
					if (file_exists("savedata.sav"))
					{
					    file_delete("savedata.sav");
					}
					
					//aplica_transicao(rm_cutscenes);
					aplica_transicao(primeira_room, noone, 0, noone, 2);
				//}

			}
			//continuar
			else if(index == 1)
			{
				if(carrega_jogo())
				{
				aplica_transicao(primeira_room);
				}
				//if(file_exists(_filename))
				//{
				//	carrega_jogo();
				//	
				//	var _foco = noone;
				//	
				//	//switch(global.ultima_fase)
				//	//{
				//	//	case 1: { _foco = obj_botao_fase_1; break; }
				//	//	case 2: { _foco = obj_botao_fase_2; break; }
				//	//	case 3: { _foco = obj_botao_fase_3; break; }
				//	//	case 4: { _foco = obj_botao_fase_4; break; }
				//	//	default: { _foco = obj_botao_fase_5; break; }
				//	//}
				//	
				//	aplica_transicao(primeira_room, noone, 0, _foco, 2);
				//	
				//}
				//else
				//{
				//	
				//	draw_sem_save = true;
				//}
			}
			//como jogar
			else if(index == 2)
			{
				//show_message("\nMouse\nW, A, S, D\nReset: R\nPause: P\nESC");
				//controla_overlay("tutorial",true);
			}
			//sair
			else if(index == 3)
			{
				game_end();
			}
		}
	}
	
	if(options[i] == "Como Jogar")
	{
		draw_set_alpha(.33);
	}
	else
	{
		draw_set_alpha(1);
	}
	
	//desenhando as opções
	draw_text_outline(options_x, _options_y_2, options[i], _cor, _cor_contorno, 1);
}

reseta_draw();

//desenhando o aviso de "sem save"
if(draw_sem_save && timer_sem_save > 0)
{
	timer_sem_save--;
	
	draw_set_font(texto_fnt);
	draw_set_colour(c_black);
	draw_set_alpha(.5);
	
	var _margem = 24;
	var _texto = "Arquivo de salvamento não encontrado!"
	
	draw_rectangle(
		RES_W / 2 - string_width(_texto) / 2 - _margem,
		RES_H / 2 - string_height(_texto) / 2 - _margem,
		RES_W / 2 + string_width(_texto) / 2 + _margem,
		RES_H / 2 + string_height(_texto) / 2 + _margem,
		false
	);
	
	draw_set_colour(c_white);
	draw_set_alpha(1);
	define_align();
	
	draw_text(RES_W / 2, RES_H / 2, _texto);
}

if(timer_sem_save <= 0)
{
	draw_sem_save = false;
	timer_sem_save = salva_timer_sem_save;
}

//desenhando os créditos
for(var i = 0; i < creditos_tam; i++)
{
	var _creditos_x2 = creditos_x + creditos_margem * i;
	var _cor = make_colour_rgb(61, 255, 68);
	
	draw_set_font(creditos_fnt);
	//draw_set_colour(_cor);
	define_align();
	
	//draw_text(_creditos_x2, creditos_y, creditos[i]);
	draw_text_outline(_creditos_x2, creditos_y, creditos[i], c_teal, c_navy, 1);
}

reseta_draw();