//Inherit the parent event
event_inherited();

dir_movimento = irandom(7) * 45;
timer_movimento = irandom_range(30, 90);

function MovimentoAleatorio(_spd, _objetos_colisao)
{
	// Não se move se a velocidade for 0 ou negativa
	if (_spd <= 0) return;

	// Escolhe uma nova direção quando o tempo termina
	if (timer_movimento <= 0)
	{
		dir_movimento = irandom(7) * 45;
		timer_movimento = irandom_range(30, 90);
	}

	timer_movimento--;

	// Calcula o movimento
	var _dx = lengthdir_x(_spd, dir_movimento);
	var _dy = lengthdir_y(_spd, dir_movimento);

	var _colidiu = false;

	// Movimento horizontal: verifica todos os objetos
	var _colisao_x = false;

	for (var i = 0; i < array_length(_objetos_colisao); i++)
	{
		if (place_meeting(x + _dx, y, _objetos_colisao[i]))
		{
			_colisao_x = true;
			break;
		}
	}

	if (!_colisao_x)
	{
		x += _dx;
	}
	else
	{
		_colidiu = true;
	}

	// Movimento vertical: verifica todos os objetos
	var _colisao_y = false;

	for (var i = 0; i < array_length(_objetos_colisao); i++)
	{
		if (place_meeting(x, y + _dy, _objetos_colisao[i]))
		{
			_colisao_y = true;
			break;
		}
	}

	if (!_colisao_y)
	{
		y += _dy;
	}
	else
	{
		_colidiu = true;
	}

	// Mantém dentro dos limites da room
	var _margem_esq = x - bbox_left;
	var _margem_dir = bbox_right - x;
	var _margem_topo = y - bbox_top;
	var _margem_baixo = bbox_bottom - y;

	var _x_ant = x;
	var _y_ant = y;

	x = clamp(x, _margem_esq, room_width - _margem_dir);
	y = clamp(y, _margem_topo, room_height - _margem_baixo);

	// Se encontrou um obstáculo ou borda, troca de direção
	if (_colidiu || x != _x_ant || y != _y_ant)
	{
		timer_movimento = 0;
	}
}


// MÁQUINA DE ESTADOS DO INIMIGO


estado = "movendo";

tempo_estado = 0;

duracao_sofrendo = max(
    1,
    round(GAME_SPEED * 0.25)
);


// Distância para detectar e perseguir o player
raio_perseguicao = 160;



// TRANSIÇÃO ENTRE ESTADOS


MudaEstado = function(_novo_estado)
{
    // Renova o tempo caso sofra dano novamente
    // enquanto já estiver no estado sofrendo.
    if (estado == _novo_estado)
    {
        if (_novo_estado == "sofrendo")
        {
            tempo_estado = duracao_sofrendo;
        }

        return;
    }


    estado = _novo_estado;


    switch (estado)
    {
        case "sofrendo":
            tempo_estado = duracao_sofrendo;
            break;

        default:
            tempo_estado = 0;
            break;
    }
};



// MOVIMENTO DE PERSEGUIÇÃO

PerseguirPlayer = function(_spd, _objetos_colisao)
{
    if (_spd <= 0)
    {
        return;
    }

    if (!instance_exists(obj_player))
    {
        return;
    }

    var _alvo = instance_find(obj_player, 0);

    // Direção do inimigo até o jogador
    var _direcao = point_direction(
        x,
        y,
        _alvo.x,
        _alvo.y
    );

    var _dx = lengthdir_x(_spd, _direcao);
    var _dy = lengthdir_y(_spd, _direcao);

    // MOVIMENTO HORIZONTAL

    var _colisao_x = false;

    for (var i = 0; i < array_length(_objetos_colisao); i++)
    {
        if (place_meeting(x + _dx, y, _objetos_colisao[i]))
        {
            _colisao_x = true;
            break;
        }
    }

    if (!_colisao_x)
    {
        x += _dx;
    }

    // MOVIMENTO VERTICAL

    var _colisao_y = false;

    for (var j = 0; j < array_length(_objetos_colisao); j++)
    {
        if (place_meeting(x, y + _dy, _objetos_colisao[j]))
        {
            _colisao_y = true;
            break;
        }
    }

    if (!_colisao_y)
    {
        y += _dy;
    }

    // LIMITES DA ROOM

    var _margem_esq = x - bbox_left;
    var _margem_dir = bbox_right - x;

    var _margem_topo = y - bbox_top;
    var _margem_baixo = bbox_bottom - y;

    x = clamp(
        x,
        _margem_esq,
        room_width - _margem_dir
    );

    y = clamp(
        y,
        _margem_topo,
        room_height - _margem_baixo
    );
};