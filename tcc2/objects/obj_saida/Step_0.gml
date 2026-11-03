if(!instance_exists(obj_player))
{
	exit;
}

var _centro = obj_player.CentroPlayer();

var _dist = point_distance(x + sprite_width /2, y + sprite_height/2,_centro[0],_centro[1]);

var _player = place_meeting(x,y,obj_player);

if(_dist <= 96)
{
	image_index = 1;
}

if(_player)
{
	room_goto(rm_inventarios); //volto para os inventarios
	
	global.fase += 1; //aumento a fase
}