
//set = RealIng(nome);
var _ing = IngredientePorNome(nome);
set = _ing.obj_real;

if(!place_meeting(x,y,obj_block_real))
{
	posso_criar = true;
}

if(place_meeting(x,y,obj_block_real))
{
	posso_criar = false;
}

//configurando minha posição
var grid = 64;
var spr_w = sprite_width;
var spr_h = sprite_height;

//Alinhamento padrão: canto inferior esquerdo na célula
x = (mouse_x div grid) * grid;
y = ((mouse_y + spr_h) div grid) * grid;

//Se o sprite NÃO for múltiplo de 32, centraliza dentro da célula
if(spr_w mod grid != 0 || spr_h mod grid != 0) {
    x += (grid - spr_w) / 2;
    y -= (grid - spr_h) / 2;
}

if(posso_criar)
{
	if(mouse_check_button_pressed(mb_left))
	{
		var _real = instance_create_layer(x,y,"Instances",set);
		_real.pai = id;
		_real.nome = nome;
		_real.sprite_index = sprite_index;
		_real.image_index = image_index;
		
		instance_destroy();
	}
}

if(mouse_check_button_pressed(mb_right))
{
	instance_destroy();
}