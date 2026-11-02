if(tempo_vida > 0)
{
	tempo_vida--;
}
else
{
	instance_destroy();
	exit;
}

if(instance_exists(pai))
{
	var _pos_x = pai.x + sprite_get_width(pai.sprite_index) * abs(pai.image_xscale) / 2;
	var _pos_y = pai.y + sprite_get_height(pai.sprite_index) * abs(pai.image_yscale) / 2;
	
	x = _pos_x;
	y = _pos_y;
}

if(irandom_range(1, 100) <= chance)
{
    instance_create_layer(x, y, layer, obj_efeito_bolha,
    {
        cor : cor,
        pai : id
    });
}