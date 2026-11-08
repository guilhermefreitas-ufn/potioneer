transicao_iniciada = false;
distancia_player = 64;
caminho = path_add();

x += sprite_width / 2;
y += sprite_width / 2;

tempo_saida = GAME_SPEED * 5;
timer_saida = tempo_saida;
mostra_mensagem = true;