event_inherited();

// 1. VERIFICAÇÃO DA VIDA
if (hp <= 0 && estado != "sofrendo" && estado != "morto")
{
    MudaEstado("morto");
}

// 2. DETECÇÃO DO JOGADOR
// Durante os estados morto e sofrendo,
// não iniciamos uma nova perseguição.
if (
    estado != "morto"
    && estado != "sofrendo"
)
{
    if (instance_exists(obj_player))
    {
        var _player = instance_find(
            obj_player,
            0
        );

        var _distancia = point_distance(
            x,
            y,
            _player.x,
            _player.y
        );


        // Prioridade 1: contato com o jogador
        if (place_meeting(x, y, obj_player))
        {
            MudaEstado("atacando");
        }


        // Prioridade 2: jogador dentro do alcance
        else if (_distancia <= raio_perseguicao)
        {
            MudaEstado("perseguindo");
        }


        // Prioridade 3: jogador distante
        else if (
            estado == "perseguindo"
            || estado == "atacando"
        )
        {
            MudaEstado("movendo");
        }
    }
    else
    {
        // Sem jogador, não continua perseguindo
        if (
            estado == "perseguindo"
            || estado == "atacando"
        )
        {
            MudaEstado("movendo");
        }
    }
}



// 3. MÁQUINA DE ESTADOS
switch (estado)
{
    
    case "parado":
    

        if (spd > 0)
        {
            MudaEstado("movendo");
        }

        break;


    
    case "movendo":
    

        if (spd > 0)
        {
            MovimentoAleatorio(spd / 2, [obj_wall, obj_bau]);
        }
        else
        {
            MudaEstado("parado");
        }

        break;


    
    case "perseguindo":
    

        if (spd > 0)
        {
            PerseguirPlayer(spd / 2, [obj_wall, obj_bau]);
        }

        break;


    
    case "atacando":
    

        // O inimigo permanece parado enquanto
        // está em contato com o jogador.
        //
        // O dano é processado no Step do player.

        break;


    
    case "sofrendo":
    

        tempo_estado--;

        if (tempo_estado <= 0)
        {
			if(hp <= 0)
			{
				MudaEstado("morto");
			}
			else
			{
				if (instance_exists(obj_player))
	            {
	                var _alvo = instance_find(
	                    obj_player,
	                    0
	                );

	                var _distancia_alvo = point_distance(
	                    x,
	                    y,
	                    _alvo.x,
	                    _alvo.y
	                );

	                if (
	                    _distancia_alvo
	                    <= raio_perseguicao
	                )
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


    
    case "morto":
    

        show_debug_message(
            "Inimigo destruído!"
        );

        instance_destroy();

        exit;


    
    default:
    

        MudaEstado("parado");

        break;
}