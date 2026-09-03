//numero de colunas
colunas = 4;

//usando macro para número de slots
inventario = array_create(SLOTS_INVENTARIO, -1); //deixando os slots vazios (-1) 

//quantidade de cada item em cada slot
quantidades = array_create(SLOTS_INVENTARIO, 0);

//bolsa sempre possui todos os slots
slots_ativos = SLOTS_INVENTARIO;

//é caldeirão?
caldeirao = false;

//sprites
meu_sprite = spr_bolsa_ph;
sprite_meu_slot = spr_slot_bolsa_ph;

//tamanhos
slot_tam = sprite_get_width(sprite_meu_slot);
espaco_borda = 6; //margem entre borda e slots
entre_slots = 4; //margem entre slots

