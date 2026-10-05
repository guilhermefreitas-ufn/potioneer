
//CONFIGURAÇÃO
sprite_meu_slot = spr_slot_bolsa_ph;

slot_tam =
	sprite_get_width(sprite_meu_slot);

entre_slots = 4;

espaco_borda = 6;

espaco_nome = 20;

fonte = fnt_placeholder_pequena;

//POSIÇÃO DO SLOT
PosicaoSlot = function(_slot)
{
	return
	[
		x
		+ espaco_borda
		+ _slot * (
			slot_tam + entre_slots
		),
		
		y
		+ espaco_borda
	];
};

//SLOT SOB O MOUSE
SlotSobreMouse = function(_mx, _my)
{
	for(
		var i = 0;
		i < SLOTS_HOTBAR_POCOES;
		i++
	)
	{
		var _pos =
			PosicaoSlot(i);
		
		if(point_in_rectangle(
			_mx,
			_my,
			_pos[0],
			_pos[1],
			_pos[0] + slot_tam,
			_pos[1] + slot_tam
		))
		{
			return i;
		}
	}
	
	return -1;
};