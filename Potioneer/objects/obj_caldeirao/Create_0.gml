//numero de colunas
colunas = 4;

//usando macro para número de slots
inventario = array_create(SLOTS_CALDEIRAO, -1); //deixando os slots vazios (-1) 

//quantidade de cada item em cada slot
quantidades = array_create(SLOTS_CALDEIRAO, 0);

//valores para ingredientes com valor
valores = array_create(SLOTS_CALDEIRAO, undefined);

//Quantidade de slots atualmente visíveis
slots_ativos = 1;

//é caldeirão?
caldeirao = true;

//sprites
meu_sprite = spr_caldeirao_ph;
sprite_meu_slot = spr_slot_caldeirao_ph;

//tamanhos
slot_tam = sprite_get_width(sprite_meu_slot);
espaco_borda = slot_tam * 2;
entre_slots = 4;

//texto
fonte = fnt_placeholder_media;
cor_texto = c_white;

var _cor_fogo = make_colour_rgb(252,37,0);

//1. Fogo do fogão embaixo e centrado (contínuo)
fx_fogo = criar_efeito(x,y, "fogo_fogao", [c_yellow, c_orange, c_red], {
    bicos: 24,
    raio_anel: 128 //Ajuste conforme a largura da base do caldeirão
});

var _cor_bolhas = make_colour_rgb(122, 205, 200);

//2. Bolhas dentro/em cima da boca do caldeirão (contínuo)
fx_bolhas = criar_efeito(x, y, "bolhas_panela", _cor_bolhas, {
    raio: ((sprite_width) / 2) - 64,      //Ajuste conforme o raio interno do líquido
    intervalo: 10
});