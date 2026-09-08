//numero de colunas
colunas = 6;

//usando macro para número de slots
inventario = array_create(SLOTS_BOLSA, -1); //deixando os slots vazios (-1) 

//quantidade de cada item em cada slot
quantidades = array_create(SLOTS_BOLSA, 0);

//valores para ingredientes com valor
valores = array_create(SLOTS_BOLSA, undefined);

//bolsa sempre possui todos os slots
slots_ativos = SLOTS_BOLSA;

//é caldeirão?
caldeirao = false;

//sprites
meu_sprite = spr_bolsa_ph;
sprite_meu_slot = spr_slot_bolsa_ph;

//tamanhos
slot_tam = sprite_get_width(sprite_meu_slot);
espaco_borda = 6; //margem entre borda e slots
entre_slots = 4; //margem entre slots

//texto
fonte = fnt_placeholder_media;
desc_cor = c_white;
//desc_x = x + 84;
//desc_y = y + 24;
desc_margem_x = string_width("O");
desc_margem_y = string_height("I");