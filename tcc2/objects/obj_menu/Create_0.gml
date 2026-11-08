texto_fnt = fnt_placeholder_media;

//opções do menu
options = [
	"Novo Jogo"
	,"Continuar"
	,"Como Jogar"
	,"Sair"
]

//tamanho do meu menu
options_tam = array_length(options);

//posição das minhas opções
options_x = RES_W / 2;
//options_y = RES_H / 1.40;
options_y = RES_H / 1.85;

//distancia entre opções
options_dist = 56;

//fonte das minhas opções
options_fnt = fnt_placeholder_media;

//opção selecionada
index = -1;

//título
//title_fnt = fnt_title;
title_fnt = fnt_media_black;

//primeira fase (Novo Jogo)
primeira_room = rm_inventarios;

//timer sem save
timer_sem_save = GAME_SPEED * 3;
salva_timer_sem_save = timer_sem_save;

draw_sem_save = false;

//creditos
creditos = ["Guilherme Freitas"];
creditos_tam = array_length(creditos);
creditos_margem = RES_W / (creditos_tam + 1);
creditos_x = RES_W / (creditos_tam + 1);
creditos_y = RES_H - 48;
creditos_fnt = fnt_placeholder_media;