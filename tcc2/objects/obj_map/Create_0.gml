cell_t = 32;
room_width = cell_t * 60; //1920
room_height = room_width div 2;
cell_h = room_width div cell_t;
cell_v = room_height div cell_t;

grid = ds_grid_create(cell_h, cell_v);
ds_grid_clear(grid, 0); //vazio

randomise();
var dir = irandom(3);

var xx = cell_h div 2;
var yy = cell_v div 2;

var chances = 1;

var passos = 1200;

var inimigo_max = 10;

for(var i = 0; i < passos; i++)
{
	if(irandom(chances) == chances)
	{
		dir = irandom(3);
	}
	
	xx += lengthdir_x(1,dir * 90);
	yy += lengthdir_y(1,dir * 90);
	
	xx = clamp(xx,2,cell_h-2);
	yy = clamp(yy,2,cell_v-2);
	
	grid[# xx,yy] = 1;
}

for(var _xx = 0; _xx < cell_h; _xx++)
{
	for(var _yy = 0; _yy < cell_v; _yy++)
	{
		var x1 = _xx * cell_t;
		var y1 = _yy * cell_t;
		
		//PAREDES
		if(grid[# _xx,_yy] == 0)
		{
			//posso colocar uma parede;
			instance_create_layer(x1, y1, "Instances",obj_wall);
		}
		
		//CHÃO
		if(grid[# _xx,_yy] == 1)
		{
			//var x1 = _xx * cell_t + cell_t / 2;
			//var y1 = _yy * cell_t + cell_t / 2;
			
			//posso colocar o player;
			if(!instance_exists(obj_player))
			{
				instance_create_layer(x1, y1, "Player",obj_player);
			}
			
			//INIMIGOS
			if(inimigo_max > 0)
			{
				var _chances = 25;
				
				var inimigo = choose(obj_ini_morcego, obj_ini_sanguessuga);
				//var inimigo = obj_teste;
				
				var dist = 128;
				
				if(irandom(_chances) == _chances and point_distance(x1, y1, obj_player.x, obj_player.y) > dist)
				{
					instance_create_layer(x1, y1, "Instances", inimigo);
					
					inimigo_max -= 1;
				}
			}
		}
		
		
	}
}