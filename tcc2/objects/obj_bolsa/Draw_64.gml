if(obj_mouse.MouseSobreItem())
{
	var _item = obj_mouse.inventario_hover.inventario[obj_mouse.slot_hover];
	
	var _ing = global.Ingredientes[_item];
	
	define_align(0,1);
	draw_set_font(fonte);
	draw_set_colour(c_black);
	
	draw_rectangle(
		desc_x,
		desc_y - desc_margem_y,
		desc_x + string_width(_ing.descricao) + desc_margem_x * 2,
		desc_y + (desc_margem_y * 4),
		false
	);
	
	draw_set_colour(desc_cor);
	
	draw_text(desc_x + desc_margem_x, desc_y, _ing.nome + " ("+string(quantidades[obj_mouse.slot_hover])+")");
	draw_text(desc_x + desc_margem_x, desc_y + desc_margem_y * 1.5, _ing.descricao);
	draw_text(desc_x + desc_margem_x, desc_y + desc_margem_y * 3, "\""+_ing.elemento+"\"" + " ("+ _ing.token + ")");
	
	reseta_draw();
}