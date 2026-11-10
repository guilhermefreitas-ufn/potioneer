//BAU ESPECIAL
cria_bau_especial = false;

// CARREGANDO AS REGRAS DE PROGRESSÃO
if (!variable_global_exists("regras_progressao"))
{
    global.regras_progressao = RegrasProgressao();
}

// CALCULANDO A FASE ATUAL
global.config_fase = ConfiguracaoFase(
    global.fase,
    global.regras_progressao
);

var _cfg = global.config_fase;

// TAMANHO DO MAPA
cell_h = _cfg.cell_h;
cell_v = _cfg.cell_v;

room_width = CELL_T * cell_h;
room_height = CELL_T * cell_v;

// GRID DE NAVEGAÇÃO
global.grid = mp_grid_create(
    0,
    0,
    cell_h,
    cell_v,
    CELL_T,
    CELL_T
);

enum TipoObj
{
	VAZIO,
	CHAO,
	PAREDE,
	SAIDA,
	PLAYER,
	INIMIGO,
	LOOT
}

grid = ds_grid_create(cell_h, cell_v);
ds_grid_clear(grid, TipoObj.VAZIO);

randomize();
var dir = irandom(3);

var xx = cell_h div 2;
var yy = cell_v div 2;

var chances = 1;

var passos = _cfg.passos;

var inimigo_max = _cfg.inimigo_max;

var loot_max = _cfg.loot_max;

dist_loot = _cfg.dist_loot;

dist_inimigo = _cfg.dist_inimigo;

//percorro o grid
for(var i = 0; i < passos; i++)
{
	//mudando de direção
	if (random(1) < _cfg.chance_mudar_direcao)
	{
	    // Escolhe uma das duas direções perpendiculares
	    var _direcoes = [
	        (dir + 1) mod 4,
	        (dir + 3) mod 4
	    ];

	    dir = _direcoes[irandom(1)];
	}
	
	xx += lengthdir_x(1,dir * 90);
	yy += lengthdir_y(1,dir * 90);
	
	xx = clamp(xx,2,cell_h-2);
	yy = clamp(yy,2,cell_v-2);
	
	//definindo paredes
	grid[# xx,yy] = TipoObj.CHAO;
}

#region DEBUG: CALCULANDO A OCUPAÇÃO DO MAPA
var _celulas_chao = 0;

for (var _x = 0; _x < cell_h; _x++)
{
    for (var _y = 0; _y < cell_v; _y++)
    {
        if (grid[# _x, _y] == TipoObj.CHAO)
        {
            _celulas_chao++;
        }
    }
}

var _ocupacao = (
    _celulas_chao / (cell_h * cell_v)
) * 100;

show_debug_message(
    "Ocupação do mapa: " + string(_ocupacao) + "%"
);
#endregion

//posição do player
var player_inicio_x = -1;
var player_inicio_y = -1;

// CONTROLE DOS INIMIGOS GERADOS
var inimigos_criados = 0;

var morcegos_criados = 0;

var sanguessugas_criadas = 0;

// PROCESSAMENTO DOS EVENTOS DA FASE
ProcessarEventosFase(global.fase);

//percorro o mapa
for(var _xx = 0; _xx < cell_h; _xx++)
{
	for(var _yy = 0; _yy < cell_v; _yy++)
	{
		var x1 = _xx * CELL_T;
		var y1 = _yy * CELL_T;
		
		//CRIANDO PAREDES
		if(grid[# _xx,_yy] == TipoObj.VAZIO)
		{
			//posso colocar uma parede;
			instance_create_layer(x1, y1, "Colisores",obj_wall);
		}
		
		//SE É CHÃO...
		if(grid[# _xx,_yy] == TipoObj.CHAO)
		{
			// POSICIONAMENTO DO PLAYER
			if(!instance_exists(obj_player))
			{
			    var _player = instance_create_layer(
			        x1 + 16,
			        y1 + 32,
			        "Player",
			        obj_player
			    );

			    // Guardando a posição inicial na grid
			    player_inicio_x = _xx;
			    player_inicio_y = _yy;

			    grid[# _xx,_yy] = TipoObj.PLAYER;

			    // BAÚ ESPECIAL
			    if(cria_bau_especial)
			    {
			        var _slot_x = -1;
			        var _slot_y = -1;

			        var _distancia_maxima = -1;

			        // Procura o chão mais distante do jogador
			        for(var _gx = 0; _gx < cell_h; _gx++)
			        {
			            for(var _gy = 0; _gy < cell_v; _gy++)
			            {
			                if(grid[# _gx,_gy] == TipoObj.CHAO)
			                {
			                    var _px = _gx * CELL_T + CELL_T / 2;
			                    var _py = _gy * CELL_T + CELL_T / 2;

			                    var _distancia = point_distance(
			                        _player.x,
			                        _player.y,
			                        _px,
			                        _py
			                    );

			                    if(_distancia > _distancia_maxima)
			                    {
			                        _distancia_maxima = _distancia;

			                        _slot_x = _gx;
			                        _slot_y = _gy;
			                    }
			                }
			            }
			        }

			        // Cria o baú na posição reservada
			        if(_slot_x != -1)
			        {
			            var _bau = instance_create_layer(
						    _slot_x * CELL_T,
						    _slot_y * CELL_T,
						    "Loot",
						    obj_bau,
						    {
						        especial: true
						    }
						);

			            grid[# _slot_x,_slot_y] = TipoObj.LOOT;

			            cria_bau_especial = false;

			            show_debug_message(
			                "BAÚ ESPECIAL CRIADO! Posição: " +
			                string(_slot_x) + ", " +
			                string(_slot_y)
			            );
			        }
			        else
			        {
			            show_debug_message(
			                "ERRO: Não foi encontrada uma célula livre para o baú especial!"
			            );
			        }
			    }

			    continue;
			}
			
			// INIMIGOS
			if (
			    inimigo_max > 0
			    && point_distance(x1, y1, obj_player.x, obj_player.y) > dist_inimigo
				&& global.fase != 0 //não cria inimigos na fase 0 (térreo)
			)
			{
			    var _fase = global.fase;

			    // Nas fases 20+, força a criação dos
			    // primeiros 3 inimigos.
			    var _forcar_spawn = (
			        _fase >= _cfg.fase_morcego_garantido
			        && inimigos_criados < _cfg.min_inimigos_fase20
			    );

			    // Verifica se deve gerar um inimigo nesta célula
			    var _tentar_spawn = (
			        _forcar_spawn
			        || random(100) < _cfg.chance_inimigo
			    );

			    if (_tentar_spawn)
			    {
			        // Por padrão, utiliza a sanguessuga
			        var _inimigo = obj_ini_sanguessuga;


			        
			        // FASE 20+: MORCEGOS EM MAIORIA
			        

			        if (_fase >= _cfg.fase_morcego_garantido)
			        {
			            // Composição inicial: 2 morcegos e 1 sanguessuga
			            if (
			                inimigos_criados == 0
			                || inimigos_criados == 2
			            )
			            {
			                _inimigo = obj_ini_morcego;
			            }
			            else if (inimigos_criados == 1)
			            {
			                _inimigo = obj_ini_sanguessuga;
			            }
			            else
			            {
			                // Mantém os morcegos em maioria
			                if (morcegos_criados <= sanguessugas_criadas + 1)
			                {
			                    _inimigo = obj_ini_morcego;
			                }
			                else
			                {
			                    _inimigo = obj_ini_sanguessuga;
			                }
			            }
			        }
					
					// FASE 10-19: CHANCE DE MORCEGO
			        else if (
			            _fase >= _cfg.fase_inicio_morcego
			            && inimigos_criados > 0
			        )
			        {
			            if (random(100) < _cfg.chance_morcego_pct)
			            {
			                _inimigo = obj_ini_morcego;
			            }
			        }

					// CRIAÇÃO DO INIMIGO
			        instance_create_layer(
			            x1,
			            y1,
			            "Instances",
			            _inimigo
			        );

			        // Atualiza os contadores
			        inimigos_criados++;

			        if (_inimigo == obj_ini_morcego)
			        {
			            morcegos_criados++;
			        }
			        else
			        {
			            sanguessugas_criadas++;
			        }

			        // Atualiza a grid
			        grid[# _xx, _yy] = TipoObj.INIMIGO;

			        inimigo_max--;

			        continue;
			    }
			}
			
			//LOOT
			if(grid[# _xx,_yy] == TipoObj.CHAO && loot_max > 0)
			{
				var _chances = 75;
				
				//var dist = 512;
				
				// LOOT
				if(
					point_distance(x1, y1, obj_player.x, obj_player.y) > dist_loot
					&& random(100) < _cfg.chance_loot
				)
				{
					instance_create_layer(x1, y1, "Loot", obj_bau);
					
					grid[# _xx,_yy] = TipoObj.LOOT;
					
					loot_max -= 1;
					
					continue;
				}
			}
			
			// BAÚ ESPECIAL
			//if(cria_bau_especial && grid[# _xx,_yy] == TipoObj.CHAO)
			//{
			//    if(
			//        point_distance(x1, y1, obj_player.x, obj_player.y) > dist_loot
			//    )
			//    {
			//        var _bau = instance_create_layer(
			//            x1,
			//            y1,
			//            "Loot",
			//            obj_bau
			//        );
			//
			//        _bau.especial = true;
			//
			//        grid[# _xx,_yy] = TipoObj.LOOT;
			//
			//        cria_bau_especial = false;
			//
			//        show_debug_message("Baú especial criado!");
			//
			//        continue;
			//    }
			//}
		}
	}
}

//show_debug_message(cria_bau_especial);

// PROCURANDO A POSIÇÃO DA SAÍDA
var distancia_maxima = -1;

var saida_x = -1;
var saida_y = -1;

// Percorro novamente a grid
for(var _gx = 0; _gx < cell_h; _gx++)
{
    for(var _gy = 0; _gy < cell_v; _gy++)
    {
        // Procuro somente posições de chão disponíveis
        if(grid[# _gx,_gy] == TipoObj.CHAO)
        {
            var _dist = point_distance(
                player_inicio_x,
                player_inicio_y,
                _gx,
                _gy
            );

            // Verifico se encontrei uma posição mais distante
            if(_dist > distancia_maxima)
            {
                distancia_maxima = _dist;

                saida_x = _gx;
                saida_y = _gy;
            }
        }
    }
}

// Criando a saída
if(saida_x != -1)
{
    instance_create_layer(
        saida_x * CELL_T,
        saida_y * CELL_T,
        "Saida",
        obj_saida
    );

    grid[# saida_x,saida_y] = TipoObj.SAIDA;
}

//ADICIONANDO OBSTÁCULOS PATHFINDER
var _ini_obstaculos = [
	obj_wall
];

for(var i = 0; i < array_length(_ini_obstaculos); i++)
{
	mp_grid_add_instances(global.grid,_ini_obstaculos[i],false);
}

//Eventos de progressão
ProcessarEventosFase(global.fase);