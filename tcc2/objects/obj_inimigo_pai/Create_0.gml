//Inherit the parent event
event_inherited();

dir_movimento = random(360);
timer_movimento = irandom_range(30, 90);

function MovimentoAleatorio(_spd)
{
	//Não se move se a velocidade for 0 ou negativa
	if (_spd <= 0) return;
	
	//Escolhe uma nova direção quando o tempo termina
	if (timer_movimento <= 0)
	{
		dir_movimento = random(360);
		timer_movimento = irandom_range(30, 90);
	}
	
	timer_movimento--;

	//Movimento baseado na velocidade
	x += lengthdir_x(_spd, dir_movimento);
	y += lengthdir_y(_spd, dir_movimento);

	//Mantém dentro dos limites da room
	var _margem_esq = x - bbox_left;
	var _margem_dir = bbox_right - x;
	var _margem_topo = y - bbox_top;
	var _margem_baixo = bbox_bottom - y;

	x = clamp(x, _margem_esq, room_width - _margem_dir);
	y = clamp(y, _margem_topo, room_height - _margem_baixo);

	//Se bateu em alguma borda, força uma nova direção
	if (x <= _margem_esq || x >= room_width - _margem_dir
	|| y <= _margem_topo || y >= room_height - _margem_baixo)
	{
		timer_movimento = 0;
	}
}