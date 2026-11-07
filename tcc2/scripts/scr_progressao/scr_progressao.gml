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

            passos_por_celula: 0.33,

            chance_mudar_direcao: 0.33
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

            mult_hp_por_fase: 0.10,
            mult_hp_max: 3.0,

            mult_atk_por_fase: 0.08,
            mult_atk_max: 2.5,

            mult_spd_por_fase: 0.015,
            mult_spd_max: 1.5
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

        loot_max: _loot_max,
        chance_loot: _loot.chance_pct,

        dist_inimigo: _dist_inimigo,
        dist_loot: _dist_loot,

        mult_hp: _mult_hp,
        mult_atk: _mult_atk,
        mult_spd: _mult_spd
    };
}