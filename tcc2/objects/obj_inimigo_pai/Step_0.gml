//Inherit the parent event
event_inherited();

if(hp <= 0)
{
	show_debug_message("Inimigo destruído!");
	instance_destroy();
}

MovimentoAleatorio(spd/2);