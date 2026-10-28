//Inherit the parent event
event_inherited();

dir_movimento = irandom(7) * 45;
timer_movimento = irandom_range(30, 90);

function MovimentoAleatorio(_spd)
{
	//Não se move se a velocidade for 0 ou negativa
	if (_spd <= 0) return;

	//Escolhe uma nova direção quando o tempo termina
	if (timer_movimento <= 0)
	{
		dir_movimento = irandom(7) * 45;
		timer_movimento = irandom_range(30, 90);
	}

	timer_movimento--;

	//Calcula o movimento
	var _dx = lengthdir_x(_spd, dir_movimento);
	var _dy = lengthdir_y(_spd, dir_movimento);

	var _colidiu = false;

	//Movimento horizontal: verifica paredes
	if (!place_meeting(x + _dx, y, obj_wall))
	{
		x += _dx;
	}
	else
	{
		_colidiu = true;
	}

	//Movimento vertical: verifica paredes
	if (!place_meeting(x, y + _dy, obj_wall))
	{
		y += _dy;
	}
	else
	{
		_colidiu = true;
	}

	//Mantém dentro dos limites da room
	var _margem_esq = x - bbox_left;
	var _margem_dir = bbox_right - x;
	var _margem_topo = y - bbox_top;
	var _margem_baixo = bbox_bottom - y;

	var _x_ant = x;
	var _y_ant = y;

	x = clamp(x, _margem_esq, room_width - _margem_dir);
	y = clamp(y, _margem_topo, room_height - _margem_baixo);

	//Se encontrou uma parede ou borda, troca de direção
	if (_colidiu || x != _x_ant || y != _y_ant)
	{
		timer_movimento = 0;
	}
}