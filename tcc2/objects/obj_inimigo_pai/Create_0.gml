//Inherit the parent event
event_inherited();

//MOVIMENTO NORMAL
dir_movimento = irandom(7) * 45;
timer_movimento = irandom_range(30, 90);

MovimentoAleatorio = function(_spd, _objetos_colisao = [obj_wall, obj_bau])
{
	// Não se move se a velocidade for 0 ou negativa
	if (_spd <= 0) return;

	// Escolhe uma nova direção quando o tempo termina
	if (timer_movimento <= 0)
	{
		var _direcoes = [0, 45, 90, 135, 180, 225, 270, 315];
		var _direcoes_livres = [];

		// Verifica quais direções estão livres
		for (var i = 0; i < array_length(_direcoes); i++)
		{
			var _dir = _direcoes[i];

			var _dx_teste = lengthdir_x(_spd, _dir);
			var _dy_teste = lengthdir_y(_spd, _dir);

			var _livre = true;

			for (var j = 0; j < array_length(_objetos_colisao); j++)
			{
				var _obj = _objetos_colisao[j];

				// Simula o movimento horizontal e depois o vertical
				if (place_meeting(x + _dx_teste, y, _obj)
				|| place_meeting(x + _dx_teste, y + _dy_teste, _obj))
				{
					_livre = false;
					break;
				}
			}

			// Adiciona a direção se não encontrou obstáculos
			if (_livre)
			{
				array_push(_direcoes_livres, _dir);
			}
		}

		// Escolhe aleatoriamente entre as direções livres
		if (array_length(_direcoes_livres) > 0)
		{
			dir_movimento = _direcoes_livres[
				irandom(array_length(_direcoes_livres) - 1)
			];
		}
		else
		{
			// Nenhuma direção disponível: tenta novamente depois
			timer_movimento = 15;
			return;
		}

		timer_movimento = irandom_range(30, 90);
	}

	timer_movimento--;

	// Calcula o movimento
	var _dx = lengthdir_x(_spd, dir_movimento);
	var _dy = lengthdir_y(_spd, dir_movimento);

	var _colidiu = false;

	// Movimento horizontal
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

	// Movimento vertical
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

//PERSEGUIÇÃO
// Distância para detectar e perseguir o player
raio_perseguicao = 160;

caminho = path_add();

// CONTROLE DO PATH
tempo_recalculo_path = 0;

celula_alvo_x = -1;
celula_alvo_y = -1;

PerseguirObj = function(
    _spd = spd / 2,
    _caminho = caminho,
    _cell_t = 32,
    _alvo = obj_player,
    _diagonais = false
)
{
    // Verificações iniciais
    if (_spd <= 0 || _cell_t <= 0) return;

    var _inst_alvo = instance_find(_alvo, 0);
    var _mapa = instance_find(obj_map, 0);

    if (_inst_alvo == noone || _mapa == noone) return;

    // Célula atual do inimigo
    var _ix = floor(x / _cell_t);
    var _iy = floor(y / _cell_t);

    // Célula atual do jogador
    var _cx = floor(_inst_alvo.x / _cell_t);
    var _cy = floor(_inst_alvo.y / _cell_t);

    // Atualiza o temporizador
    if (tempo_recalculo_path > 0)
    {
        tempo_recalculo_path--;
    }

    // Verifica se o jogador mudou de célula
    var _alvo_mudou = (
        _cx != celula_alvo_x ||
        _cy != celula_alvo_y
    );

    // Aguarda caso não seja necessário recalcular
    if (tempo_recalculo_path > 0 && !_alvo_mudou)
    {
        return;
    }

    // Centro da célula inicial (inimigo)
    var _x1 = (_ix * _cell_t) + _cell_t / 2;
    var _y1 = (_iy * _cell_t) + _cell_t / 2;

    // Centro da célula de destino (jogador)
    var _x2 = (_cx * _cell_t) + _cell_t / 2;
    var _y2 = (_cy * _cell_t) + _cell_t / 2;

    // Calcula o novo caminho
    var _encontrou = mp_grid_path(
        _mapa.mp_grid,
        _caminho,
        _x1,
        _y1,
        _x2,
        _y2,
        _diagonais
    );

    // Guarda a célula atual do jogador
    celula_alvo_x = _cx;
    celula_alvo_y = _cy;

    // Aguarda 10 Steps antes de recalcular
    tempo_recalculo_path = 10;

    if (_encontrou)
    {
        // Inicia o caminho
        path_start(
            _caminho,
            _spd,
            path_action_stop,
            false
        );
    }
    else
    {
        // Encerra o caminho anterior
        if (path_index != -1)
        {
            path_end();
        }

        // DEBUG: verifica as células inicial e final
        var _inicio = mp_grid_get_cell(
            _mapa.mp_grid,
            _ix,
            _iy
        );

        var _destino = mp_grid_get_cell(
            _mapa.mp_grid,
            _cx,
            _cy
        );

        show_debug_message(
            "Path não encontrado | " +
            "Início: " + string(_inicio) +
            " | Destino: " + string(_destino)
        );
    }
};

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

    //// Encerra o path ao sair da perseguição
    //if (estado == "perseguindo" && _novo_estado != "perseguindo")
    //{
    //    if (path_index != -1)
    //    {
    //        path_end();
    //    }
    //}
	//
    //// Prepara uma nova perseguição
    //if (_novo_estado == "perseguindo")
    //{
    //    tempo_recalculo_path = 0;
	//
    //    celula_alvo_x = -1;
    //    celula_alvo_y = -1;
    //}

    // Atualiza o estado
    estado = _novo_estado;

    // Configurações específicas de cada estado
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