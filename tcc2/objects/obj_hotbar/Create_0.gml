//CONFIGURAÇÃO
sprite_meu_slot = spr_slot_hotbar;

alpha_player_em_mim = 0.25;

slot_tam = sprite_get_width(sprite_meu_slot);

escala_slot = 2;

entre_slots = 8;
espaco_borda = 6;
espaco_nome = 20;
margem_inferior = 32;

fonte = fnt_placeholder_pequena;

//DIMENSÕES REAIS DO SLOT
largura_slot = slot_tam * escala_slot;
altura_slot = sprite_get_height(sprite_meu_slot) * escala_slot;

//DIMENSÕES DA HOTBAR
largura_hotbar =
    espaco_borda * 2
    + SLOTS_HOTBAR_POCOES * largura_slot
    + (SLOTS_HOTBAR_POCOES - 1) * entre_slots;

altura_hotbar =
    espaco_borda * 2
    + altura_slot
    + espaco_nome;

//POSIÇÃO DO SLOT NA GUI
PosicaoSlot = function(_slot)
{
    var _x = (RES_W - largura_hotbar) / 2;
    var _y = RES_H - altura_hotbar - margem_inferior;

    return [
        _x + espaco_borda
            + _slot * (largura_slot + entre_slots),

        _y + espaco_borda
    ];
};

//SLOT SOB O MOUSE
SlotSobreMouse = function(_mx, _my)
{
    for(var i = 0; i < SLOTS_HOTBAR_POCOES; i++)
    {
        var _pos = PosicaoSlot(i);

        if(point_in_rectangle(
            _mx, _my,
            _pos[0], _pos[1],
            _pos[0] + largura_slot,
            _pos[1] + altura_slot
        ))
        {
            return i;
        }
    }

    return -1;
};