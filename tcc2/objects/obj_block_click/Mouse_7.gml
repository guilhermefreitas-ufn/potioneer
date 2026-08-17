if(posso_criar)
{
	var _dragged = instance_create_layer(x,y,"Instances",dragged);
	_dragged.pai = id;
	_dragged.nome = nome;
	_dragged.sprite_index = sprite_index;
	_dragged.image_index = image_index;
}