ingrediente_numero = -1;
valor = undefined;

direcao = 0;

distancia_total = 40;
distancia_percorrida = 0;

velocidade = 4;

escala_ingrediente = 1;

image_xscale = escala_ingrediente;
image_yscale = escala_ingrediente;

// TRANSFORMA O DROP EM COLETÁVEL
FinalizaDrop = function()
{
    var _ing = IngredientePorNumero(
        ingrediente_numero
    );

    if(is_undefined(_ing))
    {
        return false;
    }

    var _coletavel = instance_create_layer(
        x,
        y,
        layer,
        obj_coletavel
    );

    _coletavel.ingrediente_numero =
        ingrediente_numero;

    _coletavel.valor = valor;

    _coletavel.sprite_index = _ing.sprite;
	_coletavel.mask_index = _ing.sprite;

	_coletavel.image_index = 0;
	_coletavel.image_speed = 0;

	// ESCALA DO COLETÁVEL
	_coletavel.image_xscale = escala_ingrediente;
	_coletavel.image_yscale = escala_ingrediente;

    return true;
};