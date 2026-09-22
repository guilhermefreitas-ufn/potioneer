// Inherit the parent event
event_inherited();

if(hp <= 0)
{
	show_message("Inimigo destruído!");
	instance_destroy();
}

MovimentoAleatorio(spd);