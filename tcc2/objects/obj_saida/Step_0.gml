if(!instance_exists(obj_player))
{
	exit;
}

var _centro = obj_player.CentroPlayer();

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

if (_player && !instance_exists(obj_transicao) && _espaco)
{
    //transicao_iniciada = true;

    //room_goto(rm_inventarios);
	aplica_transicao(rm_inventarios);
	
	global.fase += 1;
}