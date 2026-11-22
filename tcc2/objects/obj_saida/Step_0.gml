if(!instance_exists(obj_player))
{
	exit;
}

var _centro = obj_player.Centro();

var _dist = point_distance(x, y,_centro[0],_centro[1]);

var _player = place_meeting(x,y,obj_player);

var _espaco = keyboard_check_pressed(vk_space);

if(_dist <= distancia_player)
{
	image_index = 1;
}

if(_player)
{
	if(mostra_mensagem)
	{
		CriaMensagem(x, y, "ESPAÇO para descer.");
		
		mostra_mensagem = false;
	}
	else if(timer_saida > 0)
	{
		timer_saida--;
	}
	else
	{
		mostra_mensagem = true;
		timer_saida = tempo_saida;
	}
}

if(_player && !instance_exists(obj_transicao) && _espaco)
{
	//transicao_iniciada = true;
	
	//room_goto(rm_inventarios);
	if(global.ing_finais_coletados < 5)
	{
		global.fase += 1;
		
		if(global.qtd_ing_finais < global.ing_finais_coletados)
		{
			global.qtd_ing_finais = global.ing_finais_coletados;
			
			salva_jogo();
		}
		
		aplica_transicao(rm_inventarios);
	}
	else
	{
		//NIVEL 
		global.fase = 0;
		
		//EVENTOS
		global.eventos_progressao = EventosProgressao();
		global.eventos_processados = ds_map_create();
		
		//INGREDIENTES FINAIS
		global.ing_finais_coletados = 0;
		
		//VERIFICAÇÃO DA SAÍDA
		global.qtd_ing_finais = 0;
	
		//LISTA DE INGREDIENTES FINAIS
		global.ingredientes_finais = [
			{
				nome : "Âmbar",
				sprite : spr_ing_ambar
				//Por 1 minuto, diminui o cooldown das poções para 1 segundo (funciona entre níveis)
			},
			{
				nome : "Cogumelo",
				sprite : spr_ing_cogumelo
				//Por 1 minuto, dá visão no escuro (funciona entre níveis)
			},
			{
				nome : "Pena",
				sprite : spr_ing_pena
				//Por 1 minuto, aumenta para 10 os slots da hotbar (funcina entre níveis)
			},
			{
				nome : "Dente",
				sprite : spr_ing_dente
				//Por 1 minuto, permite atravessar paredes (funciona entre níveis)
				//Se tiver dentro de uma parede quando o efeito terminar
				//teleporta para o último lugar que esteve fora das paredes
			},
			{
				nome : "Cinzas",
				sprite : spr_ing_cinzas
				//Por 1 minuto, deixa invencível (funciona entre níveis)
			}
		];
		
		salva_jogo();
		
		CriaMensagem(x,y,"OBRIGADO POR JOGAR!", c_red);
		
		aplica_transicao(rm_menu);
	}
}