room_width = CELL_T * 60; //1920
room_height = room_width div 2;
cell_h = room_width div CELL_T; //horizontal
cell_v = room_height div CELL_T; //vertical

mp_grid = mp_grid_create(0, 0, cell_h, cell_v, CELL_T, CELL_T);

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

var passos = 1200;

var inimigo_max = 10;

var loot_max = 3;

dist_loot = 512;

dist_inimigo = 512;

//percorro o grid
for(var i = 0; i < passos; i++)
{
	//mudando de direção
	if(irandom(chances) == chances)
	{
		dir = irandom(3);
	}
	
	xx += lengthdir_x(1,dir * 90);
	yy += lengthdir_y(1,dir * 90);
	
	xx = clamp(xx,2,cell_h-2);
	yy = clamp(yy,2,cell_v-2);
	
	//definindo paredes
	grid[# xx,yy] = TipoObj.CHAO;
}

var player_inicio_x = -1;
var player_inicio_y = -1;

//percorro o mapa
for(var _xx = 0; _xx < cell_h; _xx++)
{
	for(var _yy = 0; _yy < cell_v; _yy++)
	{
		var x1 = _xx * CELL_T;
		var y1 = _yy * CELL_T;
		
		//PAREDES
		if(grid[# _xx,_yy] == TipoObj.VAZIO)
		{
			//posso colocar uma parede;
			instance_create_layer(x1, y1, "Colisores",obj_wall);
		}
		
		//CHÃO
		if(grid[# _xx,_yy] == TipoObj.CHAO)
		{
			// POSICIONAMENTO DO PLAYER
			if(!instance_exists(obj_player))
			{
			    instance_create_layer(x1, y1, "Player", obj_player);

			    // Guardando a posição inicial na grid
			    player_inicio_x = _xx;
			    player_inicio_y = _yy;

			    grid[# _xx,_yy] = TipoObj.PLAYER;

			    continue;
			}
			
			//INIMIGOS
			if(inimigo_max > 0)
			{
				var _chances = 50;
				
				var inimigo = choose(obj_ini_morcego, obj_ini_sanguessuga);
				//var inimigo = obj_teste;
				
				//var dist = 256;
				
				if(irandom(_chances) == _chances and point_distance(x1, y1, obj_player.x, obj_player.y) > dist_inimigo)
				{
					instance_create_layer(x1, y1, "Instances", inimigo);
					
					grid[# _xx,_yy] = TipoObj.INIMIGO;
					
					inimigo_max -= 1;
					
					continue;
				}
			}
			
			//LOOT
			if(loot_max > 0)
			{
				var _chances = 75;
				
				//var dist = 512;
				
				if(irandom(_chances) == _chances and point_distance(x1, y1, obj_player.x, obj_player.y) > dist_loot)
				{
					instance_create_layer(x1, y1, "Loot", obj_bau);
					
					grid[# _xx,_yy] = TipoObj.LOOT;
					
					loot_max -= 1;
				}
			}
		}
	}
}

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

//ADICIONANDO OBSTÁCULOS PARA OS INIMIGOS
var _ini_obstaculos = [
	obj_wall
];

for(var i = 0; i < array_length(_ini_obstaculos); i++)
{
	mp_grid_add_instances(mp_grid,_ini_obstaculos[i],false);
}
