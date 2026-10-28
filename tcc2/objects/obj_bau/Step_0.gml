// ABERTURA DO BAÚ
if(!aberto)
{
    if(!instance_exists(obj_player))
    {
        exit;
    }

	var _player = instance_find(obj_player, 0);

	// CENTRO DO PLAYER
	var _centro_player = _player.CentroPlayer();

	// CENTRO DO BAÚ
	var _centro_bau_x = x
	    + sprite_get_width(sprite_index)
	    * abs(image_xscale) / 2;

	var _centro_bau_y = y
	    + sprite_get_height(sprite_index)
	    * abs(image_yscale) / 2;

	// DISTÂNCIA ENTRE OS CENTROS
	var _dist_player = point_distance(
	    _centro_bau_x,
	    _centro_bau_y,
	    _centro_player[0],
	    _centro_player[1]
	);

	// ABRE QUANDO ESTIVER PERTO O SUFICIENTE
	if(_dist_player <= distancia_abertura)
	{
	    aberto = true;

	    image_index = 0;
	    image_speed = 1;
	}
}


// ANIMAÇÃO DE ABERTURA TERMINOU
if(
    aberto
    && !itens_droppados
    && animation_end()
)
{
    image_speed = 0;

    // Impede que os itens sejam sorteados
    // novamente em passos posteriores
    itens_droppados = true;

    // Um Cubo garantido + 3 a 5 itens
    DropaItens(
        irandom_range(3, 5)
    );

    sumir = true;
}


// DESAPARECIMENTO DO BAÚ
if(sumir)
{
    image_alpha = max(
        0,
        image_alpha - 0.05
    );

    if(image_alpha <= 0)
    {
        instance_destroy();
    }
}