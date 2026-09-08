#macro INGREDIENTE_INT 1

enum TipoIngrediente
{
	CONDICIONAL,
	VARIAVEL,
	OPERADOR_COMPARACAO,
	OPERADOR_EFEITO,
	PRIMITIVO,
	ALVO
}

function CriarIngrediente(_numero, _nome, _descricao, _sprite, _elemento, _token, _tipo)
{
	return
	{
		numero: _numero,
		nome: _nome,
		descricao: _descricao,
		sprite: _sprite,
		elemento: _elemento,
		token: _token,
		tipo: _tipo
	};
}

function IngredientePorNumero(_numero)
{
	for (var i = 0; i < array_length(global.Ingredientes); i++)
	{
		if(global.Ingredientes[i].numero == _numero)
		{
			return global.Ingredientes[i];
		}
	}
	
	return undefined;
}

function IngredientePorToken(_token)
{
	for(var i = 0; i < array_length(global.Ingredientes); i++)
	{
		if(global.Ingredientes[i].token == _token)
		{
			return global.Ingredientes[i];
		}
	}
	
	return undefined;
}

function IngredienteEhTipo(_numero, _tipo)
{
	var _ing = IngredientePorNumero(_numero);
	
	if(is_undefined(_ing))
	{
		return false;
	}
	
	return _ing.tipo == _tipo;
}

function ApresentaDescricaoIngrediente(_token_ou_numero, _x=72, _y=48, _fonte=fnt_placeholder_media, _cor_bg = c_black, _cor_fonte = c_white, _halign = 1, _valign = 1)
{
	var _ing = (is_undefined(IngredientePorNumero(_token_ou_numero))) ? IngredientePorToken(_token_ou_numero) : IngredientePorNumero(_token_ou_numero);
	
	if(is_undefined(_ing))
	{
		return undefined;
	}
	
	define_align(_halign, _valign);
	draw_set_font(_fonte);
	draw_set_colour(_cor_bg);
	
	draw_rectangle(_x, _y, _x+128,_y+64,false);
	
	draw_set_colour(_cor_fonte);
	
	draw_text(_x, _y, _ing.nome + "("+ _ing.token + ")");
	draw_text(_x, _y+string_height(_ing.nome), "\""+_ing.elemento+"\"");
	draw_text(_x, _y+string_height(_ing.nome)*2, _ing.descricao);
	
	reseta_draw();
}

function ItensIguais(_obj_a, _slot_a, _obj_b, _slot_b)
{
	var _item_a = _obj_a.inventario[_slot_a];
	var _item_b = _obj_b.inventario[_slot_b];
	
	// ingredientes diferentes
	if(_item_a != _item_b)
	{
		return false;
	}
	
	// se não for int, só o ingrediente importa
	if(_item_a != INGREDIENTE_INT)
	{
		return true;
	}
	
	// int precisa ter o mesmo valor
	return _obj_a.valores[_slot_a] == _obj_b.valores[_slot_b];
}