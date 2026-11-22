var _hover = MouseSobre(mouse_x, mouse_y);

draw_self();

if(image_index == 1 && tempo_sprite > 0)
{
	tempo_sprite--;
}
else
{
	tempo_sprite = timer_sprite;
	image_index = 0;
}