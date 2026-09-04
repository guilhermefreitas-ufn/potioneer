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

//=========================================================
//ANTIGO
//=========================================================
//function SpriteIng(_numero)
//{
//	var _sprite = noone;
	
//	switch(_numero)
//	{
//		case 0:		{ _sprite = spr_ing_estrela;	break; }
//		case 1:		{ _sprite = spr_ing_lagrima;	break; }
//		case 2:		{ _sprite = spr_ing_fogo;		break; }
//		case 3:		{ _sprite = spr_ing_folha;		break; }
//		case 4:		{ _sprite = spr_ing_lua;		break; }
//		case 5:		{ _sprite = spr_ing_osso;		break; }
//		case 6:		{ _sprite = spr_ing_sol;		break; }
		
//		case 7:		{ _sprite = spr_placeholder_32	break; }
//		case 8:		{ _sprite = spr_placeholder_32	break; }
//		case 9:		{ _sprite = spr_placeholder_32; break; }
//		case 10:	{ _sprite = spr_placeholder_32; break; }
//		case 11:	{ _sprite = spr_placeholder_32; break; }
//		case 12:	{ _sprite = spr_placeholder_32; break; }
//		case 13:	{ _sprite = spr_placeholder_32; break; }
//		case 14:	{ _sprite = spr_placeholder_32; break; }
//		case 15:	{ _sprite = spr_placeholder_32; break; }
//	}
	
//	return _sprite;
//}

//function NomeNumIng(_nome)
//{
//	var _numero = -1;
	
//	switch(_nome)
//	{
//		case "if":			{ _numero = 0; break; }
//		case "greater":		{ _numero = 1; break; }
//		case "life":		{ _numero = 2; break; }
//		case "decreases":	{ _numero = 3; break; }
//		case "enemy":		{ _numero = 4; break; }
//		case "int":			{ _numero = 5; break; }
//		case "while":		{ _numero = 6; break; }
//	}
	
//	return _numero;
//}

//function NumNomeIng(_numero)
//{
//	var _nome = "";
	
//	switch(_nome)
//	{
//		case 0:	{ _numero = "if";			break; }
//		case 1:	{ _numero = "greater";		break; }
//		case 2:	{ _numero = "life";			break; }
//		case 3:	{ _numero = "decreases";	break; }
//		case 4:	{ _numero = "enemy";		break; }
//		case 5:	{ _numero = "int";			break; }
//		case 6:	{ _numero = "while";		break; }
//	}
	
//	return _numero;
//}

//function DragIng(_nome)
//{
//	var _block = noone;
	
//	switch(_nome)
//	{
//		case "if":			{ _block = obj_block_drag; break; }
//		case "greater":		{ _block = obj_block_drag; break; }
//		case "life":		{ _block = obj_block_drag; break; }
//		case "decreases":	{ _block = obj_block_drag; break; }
//		case "enemy":		{ _block = obj_block_drag; break; }
//		case "int":			{ _block = obj_block_drag; break; }
//		case "while":		{ _block = obj_block_drag; break; }
//	}
	
//	return _block;
//}

//function RealIng(_nome)
//{
//	var _block = noone;
	
//	switch(_nome)
//	{
//		case "if":			{ _block = obj_block_real; break; }
//		case "greater":		{ _block = obj_block_real; break; }
//		case "life":		{ _block = obj_block_real; break; }
//		case "decreases":	{ _block = obj_block_real; break; }
//		case "enemy":		{ _block = obj_block_real; break; }
//		case "int":			{ _block = obj_block_real; break; }
//		case "while":		{ _block = obj_block_real; break; }
//	}
	
//	return _block;
//}

//antigo
//function SprIng(_nome)
//{
//	var _sprite = noone;
	
//	switch(_nome)
//	{
//		case "if":			{ _sprite = 0; break; }
//		case "greater":		{ _sprite = 1; break; }
//		case "life":		{ _sprite = 2; break; }
//		case "decreases":	{ _sprite = 3; break; }
//		case "enemy":		{ _sprite = 4; break; }
//		case "int":			{ _sprite = 5; break; }
//		case "while":		{ _sprite = 6; break; }
//	}
	
//	return _sprite;
//}