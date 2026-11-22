//show_message("Derrota!");

//Resetando o jogo
//ARMARIO
for(var i = 0; i < array_length(global.DadosJogador.armario_pocoes); i++)
{
	global.DadosJogador.armario_pocoes[i] = undefined;
}
//HOTBAR
for(var i = 0; i < array_length(global.DadosJogador.hotbar_pocoes); i++)
{
	global.DadosJogador.hotbar_pocoes[i] = undefined;
}

global.fase = 0;

game_restart();