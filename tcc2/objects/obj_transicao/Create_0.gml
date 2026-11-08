//show_message("obj transicao criado");

// Variáveis de controle de ESTADO
// 0: NENHUM
// 1: FECHANDO (Iris Out para foco)
// 2: FOCO_SAIDA (Pausa no alvo de saída)
// 3: FECHAMENTO_TOTAL (Iris Out total)
// 4: TROCA_ROOM (room_goto)
// 5: ABERTURA_INICIAL (Iris In do centro para foco)
// 6: FOCO_ENTRADA (Pausa no alvo de entrada)
// 7: ABRINDO (Iris In total)

global.pause = true;

state = 0; //Inicia em NENHUM
target_room = noone;

//Variáveis de Saída (Out)
alvo_out_id = noone;
focus_time_out_frames = 0;
radius_min_out = 0;

//Variáveis de Entrada (In)
alvo_in_id = noone;
focus_time_in_frames = 0;
radius_min_in = 0;

//Variáveis de Animação e Controle
global.iris_surface = -1; //Surface da transição
radius = 0;
radius_max = 0;
radius_speed = 25;
center_x = 0;
center_y = 0;

//Variável de controle para o setup da nova room
setup_done = false;