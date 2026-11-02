// TEXTO
texto = "";

// COR DA MENSAGEM
cor = c_white;

// CONFIGURAÇÃO DO TEXTO
largura_maxima = 160;
altura_texto = 0;

// POSIÇÃO ORIGINAL DA MENSAGEM
origem_x = x;
origem_y = y;

// ANIMAÇÃO
tempo = 0;

duracao = max(
    1,
    round(GAME_SPEED * 1.5)
);

vel_y = -0.4;