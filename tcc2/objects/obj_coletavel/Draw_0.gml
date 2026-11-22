DesenhaSombra();

draw_self();

var _ing = IngredientePorNumero(
	ingrediente_numero
);

//MOSTRA O VALOR DO INT
if(
	_ing.token == "int"
	&& !is_undefined(valor)
)
{
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	
	draw_text(
		x + sprite_width / 2 * image_xscale,
		y - 8 * image_yscale,
		string(valor)
	);
	
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}