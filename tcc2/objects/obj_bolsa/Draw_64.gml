if(obj_mouse.MouseSobreItem())
{
	var _item = obj_mouse.inventario_hover.inventario[obj_mouse.slot_hover];
	
	var _ing = global.Ingredientes[_item];
	
	var _x = 176;
	var _y = 160;
	
	define_align(0,1);
	draw_set_font(fnt_placeholder_media);
	draw_set_colour(c_black);
	
	draw_rectangle(_x, _y-string_height("I"), _x+string_width(_ing.descricao)+string_width("O")*2,_y+(string_height("O")*4),false);
	
	draw_set_colour(c_white);
	
	draw_text(_x+string_width("O"), _y, _ing.nome + " ("+string(quantidades[obj_mouse.slot_hover])+")");
	draw_text(_x+string_width("O"), _y+string_height(_ing.nome)*1.5, _ing.descricao);
	draw_text(_x+string_width("O"), _y+string_height(_ing.nome)*3, "\""+_ing.elemento+"\"" + " ("+ _ing.token + ")");
	
	reseta_draw();
}