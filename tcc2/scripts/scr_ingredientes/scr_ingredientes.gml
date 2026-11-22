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
	for(var i = 0; i < array_length(global.Ingredientes); i++)
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

function IngredientePorNome(_nome)
{
	if(!is_string(_nome))
	{
		return undefined;
	}
	
	var _nome_busca = string_lower(_nome);
	
	for(var i = 0; i < array_length(global.Ingredientes); i++)
	{
		var _ing = global.Ingredientes[i];
		
		if(string_lower(_ing.nome) == _nome_busca)
		{
			return _ing;
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

function ApresentaDescricaoIngrediente(
	_token_ou_numero,
	_x = 72,
	_y = 48,
	_fonte = fnt_placeholder_media,
	_cor_bg = c_black,
	_cor_fonte = c_white,
	_halign = 0,
	_valign = 1,
	_quantidade = undefined,
	_valor = undefined,
	_margem_x = 8,
	_margem_y = 8,
	_raio_borda = 6,
	_tag_padding_x = 7,
	_tag_padding_y = 2,
	_tag_raio = 5,
	_tag_espaco = 8,
	_cor_texto_tag = c_white
)
{
	//OBTÉM O INGREDIENTE
	var _ing = IngredientePorNumero(_token_ou_numero);
	
	if(is_undefined(_ing))
	{
		_ing = IngredientePorToken(_token_ou_numero);
	}
	
	if(is_undefined(_ing))
	{
		return undefined;
	}
	
	//CONFIGURAÇÕES DE DESENHO
	define_align(_halign, _valign);
	draw_set_font(_fonte);
	
	//NOME DO INGREDIENTE
	var _nome = _ing.nome;
	
	//INGREDIENTE INT MOSTRA SEU VALOR
	if(
		_ing.numero == INGREDIENTE_INT
		&& !is_undefined(_valor)
	)
	{
		_nome += " " + string(_valor);
	}
	
	//NOME + QUANTIDADE
	var _texto_nome = _nome;
	
	if(!is_undefined(_quantidade))
	{
		_texto_nome += " (" + string(_quantidade) + ")";
	}
	
	//ELEMENTO / TOKEN
	var _texto_elemento =
		"\"" + _ing.elemento + "\"" +
		" (" + _ing.token + ")";
	
	//TIPO DO INGREDIENTE
	var _texto_tipo = TextoTipoIngrediente(_ing.tipo);
	
	//DIMENSÕES DA ETIQUETA
	var _tag_largura =
		string_width(_texto_tipo) +
		_tag_padding_x * 2;
	
	var _tag_altura =
		string_height(_texto_tipo) +
		_tag_padding_y * 2;
	
	//LARGURA DA DESCRIÇÃO
	var _desc_largura =
		max(
			string_width(_texto_nome) + _tag_largura + _tag_espaco,
			string_width(_ing.descricao),
			string_width(_texto_elemento)
		)
		+ _margem_x * 2;
	
	//POSIÇÃO VERTICAL DOS TEXTOS
	var _linha_nome_y = _margem_y;
	
	var _linha_desc_y = _margem_y * 2.5;
	
	var _linha_elemento_y = _margem_y * 4;
	
	//ALTURA DA DESCRIÇÃO
	var _desc_altura = _margem_y * 5;
	
	//FUNDO DA DESCRIÇÃO
	draw_set_colour(_cor_bg);
	
	draw_roundrect_ext(
		_x,
		_y,
		_x + _desc_largura,
		_y + _desc_altura,
		_raio_borda,
		_raio_borda,
		false
	);
	
	//TEXTOS
	draw_set_colour(_cor_fonte);
	
	draw_text(
		_x + _margem_x,
		_y + _linha_nome_y,
		_texto_nome
	);
	
	draw_text(
		_x + _margem_x,
		_y + _linha_desc_y,
		_ing.descricao
	);
	
	draw_text(
		_x + _margem_x,
		_y + _linha_elemento_y,
		_texto_elemento
	);
	
	//ETIQUETA DO TIPO
	var _tag_x =
		_x + _desc_largura -
		_margem_x -
		_tag_largura;
	
	var _tag_y =
		_y + _linha_nome_y -
		_tag_altura / 2;
	
	//COR CONFORME O TIPO
	var _cor_tag_tipo = CorTipoIngrediente(_ing.tipo);
	
	//FUNDO ARREDONDADO DA ETIQUETA
	draw_roundrect_colour_ext(
		_tag_x,
		_tag_y,
		_tag_x + _tag_largura,
		_tag_y + _tag_altura,
		_tag_raio,
		_tag_raio,
		_cor_tag_tipo,
		_cor_tag_tipo,
		false
	);
	
	//TEXTO DA ETIQUETA
	draw_set_colour(_cor_texto_tag);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	
	draw_text(
		_tag_x + _tag_largura / 2,
		_tag_y + _tag_altura / 2,
		_texto_tipo
	);
	
	//RESTAURA CONFIGURAÇÕES
	reseta_draw();
}

function ItensIguais(_obj_a, _slot_a, _obj_b, _slot_b)
{
	var _item_a = _obj_a.inventario[_slot_a];
	var _item_b = _obj_b.inventario[_slot_b];
	
	if(_item_a != _item_b)
	{
		return false;
	}
	
	//apenas int precisa comparar valor
	if(_item_a == INGREDIENTE_INT)
	{
		return _obj_a.valores[_slot_a] == _obj_b.valores[_slot_b];
	}
	
	return true;
}