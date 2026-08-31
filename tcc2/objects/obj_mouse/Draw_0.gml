if(item_drag != -1)
{
	draw_set_alpha(.5);
	//draw_sprite(SpriteIng(item_drag), 0, mouse_x, mouse_y);
	draw_sprite(global.Ingredientes[item_drag].sprite, 0, mouse_x, mouse_y);
	draw_set_alpha(1);
}