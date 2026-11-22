
//CONFIGURAÇÃO
colunas = 5;

slot_tam =
	sprite_get_width(
		spr_slot_bolsa_ph
);

entre_slots = 4;

espaco_linha = -16;

espaco_borda = 6;

espaco_nome = 20;

fonte = fnt_placeholder_pequena;

//SPRITES
sprite_meu_slot = spr_slot_bolsa_ph;

//POSIÇÃO DO SLOT
PosicaoSlot = function(_slot)
{
	var _coluna =
		_slot mod colunas;
	
	var _linha =
		_slot div colunas;
	
	return
	[
		x
		+ espaco_borda
		+ _coluna * (
			slot_tam + entre_slots
		),
		
		y
		+ espaco_borda
		+ _linha * (
			slot_tam
			+ espaco_nome
			+ espaco_linha
		)
	];
};

//SLOT SOB O MOUSE
SlotSobreMouse = function(_mx, _my)
{
	for(var i = 0; i < SLOTS_ARMARIO_POCOES; i++)
	{
		var _pos =
			PosicaoSlot(i);
		
		if(
			point_in_rectangle(
				_mx,
				_my,
				_pos[0],
				_pos[1],
				_pos[0] + slot_tam,
				_pos[1] + slot_tam
			)
		)
		{
			return i;
		}
	}
	
	return -1;
};

//ÁREA DO ARMÁRIO
AreaSobreMouse = function(_mx, _my)
{
	var _linhas =
		((SLOTS_ARMARIO_POCOES - 1) div colunas) + 1;
	
	var _largura =
		(2 * espaco_borda)
		+ colunas * (
			slot_tam + entre_slots
		);
	
	var _altura =
		(2 * espaco_borda)
		+ _linhas * (
			slot_tam
			+ espaco_nome
			+ entre_slots
		);
	
	return point_in_rectangle(
		_mx,
		_my,
		x,
		y,
		x + _largura,
		y + _altura
	);
};