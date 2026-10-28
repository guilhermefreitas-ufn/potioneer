DesenhaSombra();

var _ing = IngredientePorNumero(
    ingrediente_numero
);

if(!is_undefined(_ing))
{
    // ESCALA DO INGREDIENTE
    var _escala = escala_ingrediente;

    // DESENHA JÁ NO TAMANHO CORRETO
    draw_sprite_ext(
        _ing.sprite,
        0,
        x,
        y,
        _escala,
        _escala,
        0,
        c_white,
        1
    );

    // MOSTRA O VALOR DA CRINA
    if(
        _ing.token == "int"
        && !is_undefined(valor)
    )
    {
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);

        draw_text(
            x,
            y - 8 * _escala,
            string(valor)
        );

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}