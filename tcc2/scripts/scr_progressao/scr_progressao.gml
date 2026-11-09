function IniciaNovoJogo()
{
    // REINICIALIZA OS DADOS DO JOGADOR
    InicializaDadosJogador(true);

    // PROGRESSÃO
    global.fase = 0;

    // INGREDIENTES FINAIS
    global.ing_finais_coletados = 0;

    // VERIFICAÇÃO DA SAÍDA
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

    // STRUCT DE SAVE
    global.stat_data = {};

    // ATUALIZA A BOLSA, CASO EXISTA
    var _bolsa = instance_find(obj_bolsa, 0);

    if (_bolsa != noone)
    {
        CarregaBolsaGlobal(_bolsa);
    }

    // EXCLUI O SAVE ANTERIOR
    if (file_exists("savedata.sav"))
    {
        file_delete("savedata.sav");
    }

    show_debug_message("Novo jogo iniciado!");
    CriaMensagem(RES_W/4,RES_H/4,"Novo jogo iniciado!");

    return true;
}

function EventosProgressao()
{
    return [

        // RECORRENTE
		// Acontece de vez em vez comecando em "inicio" a cada "intervalo"
        {
            id: "bau_especial",
            tipo: "recorrente",
            inicio: 1,
            intervalo: 1
        },

        // ÚNICO
		//Acontece uma unica vez na "fase"
        {
            id: "exemplo",
            tipo: "unico",
            fase: 20
        },

        // INTERVALO
		// Acontece em todas as fases do intervalo, comecando em "inicio" e parando em "fim"
        {
            id: "exemplo 2",
            tipo: "intervalo",
            inicio: 20,
            fim: 100
        }

    ];
}

function ProcessarEventosFase(_fase)
{
    var _eventos = global.eventos_progressao;

    for (var i = 0; i < array_length(_eventos); i++)
    {
        var _evento = _eventos[i];

        // Verifica se o evento está ativo
        if (!EventoAtivoNaFase(_evento, _fase))
        {
            continue;
        }
		
		// IDENTIFICADOR DE EXECUÇÃO

		var _chave = _evento.id;

		// Eventos recorrentes e intervalos podem executar
		// novamente em outras fases, mas não duas vezes na mesma.
		if (_evento.tipo != "unico")
		{
		    _chave += "_" + string(_fase);
		}

		// Verifica se já foi executado
		if (ds_map_exists(global.eventos_processados, _chave))
		{
		    continue;
		}

        // Executa a ação correspondente
        switch (_evento.id)
        {
            case "exemplo":
			{
                // Aplica funcionamento do exemplo
                break;
			}

            case "exemplo 2":
			{
                // Executa exemplo 2
                break;
			}

            case "bau_especial":
			{
				if(instance_exists(obj_map))
				{
					var _tem_especial = false;
					
					if(instance_exists(obj_bau))
					{
						with(obj_bau)
						{
							if(especial)
							{
								_tem_especial = true;
								
								show_debug_message("já tem baú especial");
							}
						}
					}
					
					if(!_tem_especial)
					{
						show_debug_message("avisando mapa que precisa de bau especial");
						obj_map.cria_bau_especial = true;
					}
				}
				
                break;
			}
        }
		
		ds_map_add(global.eventos_processados, _chave, true);
    }
}

function RegrasProgressao()
{
    return {
        // CONFIGURAÇÕES DO MAPA
        mapa:
        {
            colunas_iniciais: 30,
            linhas_iniciais: 15,

            intervalo_aumento: 3,

            aumento_colunas: 2,
            aumento_linhas: 4,

            colunas_max: 30,
            linhas_max: 60,

            passos_por_celula: 0.25,

            chance_mudar_direcao: 0.50
        },

        // CONFIGURAÇÕES DOS INIMIGOS
        inimigos:
        {
            max_inicial: 3,

            intervalo_aumento: 2,
            aumento: 1,

            maximo: 18,

            chance_pct: 2.0,

            distancia_relativa: 0.35,

            mult_hp_por_fase: 0.05,
            mult_hp_max: 3.0,

            mult_atk_por_fase: 0.04,
            mult_atk_max: 2.5,

            mult_spd_por_fase: 0.010,
            mult_spd_max: 1.5,
			
			// PROGRESSÃO DOS TIPOS DE INIMIGOS
			fase_inicio_morcego: 10,

			fase_morcego_garantido: 20,

			chance_morcego_inicio_pct: 10,

			chance_morcego_fim_pct: 50,

			min_inimigos_fase20: 3
        },

        // CONFIGURAÇÕES DOS LOOTS
        loot:
        {
            max_inicial: 1,

            intervalo_aumento: 4,
            aumento: 1,

            maximo: 6,

            chance_pct: 1.3,

            distancia_relativa: 0.25
        }
    };
}

function EventoAtivoNaFase(_evento, _fase)
{
    switch (_evento.tipo)
    {
        // A cada N fases
        case "recorrente":

            return (
                _fase >= _evento.inicio
                && ((_fase - _evento.inicio) mod _evento.intervalo) == 0
            );


        // Em uma fase específica
        case "unico":

            return _fase == _evento.fase;


        // Durante um intervalo de fases
        case "intervalo":

            return (
                _fase >= _evento.inicio
                && _fase <= _evento.fim
            );
    }

    return false;
}

function ConfiguracaoFase(_fase, _regras)
{
    var _nivel = max(0, floor(_fase) - 1);

    var _mapa = _regras.mapa;
    var _ini = _regras.inimigos;
    var _loot = _regras.loot;
	
    // TAMANHO DO MAPA
    var _aumentos_mapa = floor(
        _nivel / _mapa.intervalo_aumento
    );

    var _cell_h = min(
        _mapa.colunas_max,
        _mapa.colunas_iniciais + _aumentos_mapa * _mapa.aumento_colunas
    );

    var _cell_v = min(
        _mapa.linhas_max,
        _mapa.linhas_iniciais + _aumentos_mapa * _mapa.aumento_linhas
    );
	
    // PASSOS DA GERAÇÃO
    var _area = _cell_h * _cell_v;

    var _passos = round(
        _area * _mapa.passos_por_celula
    );

    // QUANTIDADE DE INIMIGOS
    var _aumentos_ini = floor(
        _nivel / _ini.intervalo_aumento
    );

    var _inimigo_max = min(
        _ini.maximo,
        _ini.max_inicial + _aumentos_ini * _ini.aumento
    );
	
	// GARANTE INIMIGOS SUFICIENTES NA FASE 20+
	if (_fase >= _ini.fase_morcego_garantido)
	{
	    _inimigo_max = max(
	        _inimigo_max,
	        _ini.min_inimigos_fase20
	    );
	}

	
	// CHANCE DE APARECER MORCEGO
	

	var _chance_morcego = 0;

	if (
	    _fase >= _ini.fase_inicio_morcego
	    && _fase < _ini.fase_morcego_garantido
	)
	{
	    var _progresso = (
	        _fase - _ini.fase_inicio_morcego
	    ) / (
	        _ini.fase_morcego_garantido
	        - _ini.fase_inicio_morcego - 1
	    );

	    _chance_morcego = lerp(
	        _ini.chance_morcego_inicio_pct,
	        _ini.chance_morcego_fim_pct,
	        _progresso
	    );
	}

    // QUANTIDADE DE LOOTS
    var _aumentos_loot = floor(
        _nivel / _loot.intervalo_aumento
    );

    var _loot_max = min(
        _loot.maximo,
        _loot.max_inicial + _aumentos_loot * _loot.aumento
    );
	
    // DISTÂNCIAS MÍNIMAS
    var _dist_base = min(_cell_h, _cell_v) * CELL_T;

    var _dist_inimigo = _dist_base * _ini.distancia_relativa;

    var _dist_loot = _dist_base * _loot.distancia_relativa;

    // MULTIPLICADORES DOS INIMIGOS
    var _mult_hp = min(
        _ini.mult_hp_max,
        1 + _nivel * _ini.mult_hp_por_fase
    );

    var _mult_atk = min(
        _ini.mult_atk_max,
        1 + _nivel * _ini.mult_atk_por_fase
    );

    var _mult_spd = min(
        _ini.mult_spd_max,
        1 + _nivel * _ini.mult_spd_por_fase
    );

    // RETORNO DAS CONFIGURAÇÕES
    return {
        cell_h: _cell_h,
        cell_v: _cell_v,

        passos: _passos,

        chance_mudar_direcao: _mapa.chance_mudar_direcao,

        inimigo_max: _inimigo_max,
        chance_inimigo: _ini.chance_pct,
		
		fase_inicio_morcego: _ini.fase_inicio_morcego,
		fase_morcego_garantido: _ini.fase_morcego_garantido,
		chance_morcego_pct: _chance_morcego,
		min_inimigos_fase20: _ini.min_inimigos_fase20,

        loot_max: _loot_max,
        chance_loot: _loot.chance_pct,

        dist_inimigo: _dist_inimigo,
        dist_loot: _dist_loot,

        mult_hp: _mult_hp,
        mult_atk: _mult_atk,
        mult_spd: _mult_spd
    };
}