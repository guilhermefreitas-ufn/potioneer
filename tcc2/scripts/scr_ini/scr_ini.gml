function DragBlock(_nome)
{
	var _block = noone;
	
	switch(_nome)
	{
		case "if":			{ _block = obj_block_drag; break; }
		case "greater":		{ _block = obj_block_drag; break; }
		case "life":		{ _block = obj_block_drag; break; }
		case "decreases":	{ _block = obj_block_drag; break; }
		case "enemy":		{ _block = obj_block_drag; break; }
		case "int":			{ _block = obj_block_drag; break; }
		case "while":		{ _block = obj_block_drag; break; }
	}
	
	return _block;
}

function RealBlock(_nome)
{
	var _block = noone;
	
	switch(_nome)
	{
		case "if":			{ _block = obj_block_real; break; }
		case "greater":		{ _block = obj_block_real; break; }
		case "life":		{ _block = obj_block_real; break; }
		case "decreases":	{ _block = obj_block_real; break; }
		case "enemy":		{ _block = obj_block_real; break; }
		case "int":			{ _block = obj_block_real; break; }
		case "while":		{ _block = obj_block_real; break; }
	}
	
	return _block;
}

function SprIng(_nome)
{
	var _sprite = noone;
	
	switch(_nome)
	{
		case "if":			{ _sprite = 0; break; }
		case "greater":		{ _sprite = 1; break; }
		case "life":		{ _sprite = 2; break; }
		case "decreases":	{ _sprite = 3; break; }
		case "enemy":		{ _sprite = 4; break; }
		case "int":			{ _sprite = 5; break; }
		case "while":		{ _sprite = 6; break; }
	}
	
	return _sprite;
}