//ETIQUETA DO TIPO DE INGREDIENTE
cor_texto_tag_tipo = c_white;

tag_tipo_padding_x = 7;
tag_tipo_padding_y = 2;
tag_tipo_espaco = 8;
tag_tipo_raio = 5;

raio_borda_desc = 10;

//numero de colunas
colunas = 6;

//bolsa sempre possui todos os slots
slots_ativos = SLOTS_BOLSA;

//descrição dos ingredientes
desc_offset_x = 26;
desc_offset_y = 80;
fonte = fnt_placeholder_media;
desc_cor = c_white;
//desc_x = x + 84;
//desc_y = y + 24;
desc_margem_x = string_width("O");
desc_margem_y = string_height("I");

#region dados jogador
InicializaDadosJogador();

//usando macro para número de slots
inventario = array_create(SLOTS_BOLSA, -1); //deixando os slots vazios (-1) 

//quantidade de cada item em cada slot
quantidades = array_create(SLOTS_BOLSA, 0);

//valores para ingredientes com valor
valores = array_create(SLOTS_BOLSA, undefined);

CarregaBolsaGlobal(id);
#endregion

//é caldeirão?
caldeirao = false;

//sprites
meu_sprite = spr_bolsa_ph;
sprite_meu_slot = spr_slot_bolsa_ph;

//tamanhos
slot_tam = sprite_get_width(sprite_meu_slot);
espaco_borda = 6; //margem entre borda e slots
entre_slots = 4; //margem entre slots