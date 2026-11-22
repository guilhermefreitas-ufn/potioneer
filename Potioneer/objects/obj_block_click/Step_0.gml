var _ing = IngredientePorToken(nome);
dragged = _ing.obj_drag;
image_index = _ing.sprite;

if(instance_exists(obj_block_drag))
{
	posso_criar = false;
}

if(!instance_exists(obj_block_drag))
{
	posso_criar = true;
}