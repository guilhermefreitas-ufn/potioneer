if(!instance_exists(obj_player))
{
    exit;
}

var _player = instance_find(
    obj_player,
    0
);

var _centro = _player.Centro();

//var _msg_x = (_player.bbox_left + _player.bbox_right) / 2;
//var _msg_y = _player.bbox_top - 12;

// VERIFICA A SOBREPOSIÇÃO DOS BBOX
// Adiciona uma margem para facilitar a coleta.
var _margem_coleta = 8;

var _fora_do_alcance = (
    bbox_right < _player.bbox_left - _margem_coleta
    || bbox_left > _player.bbox_right + _margem_coleta
    || bbox_bottom < _player.bbox_top - _margem_coleta
    || bbox_top > _player.bbox_bottom + _margem_coleta
);

if(_fora_do_alcance)
{
    exit;
}

// TENTA ADICIONAR À BOLSA
if(
    AdicionaIngredienteBolsaGlobal(
        ingrediente_numero,
        valor
    )
)
{
    var _ing = IngredientePorNumero(
        ingrediente_numero
    );

    // NOME DO INGREDIENTE
	var _nome = _ing.nome;

	// VALOR DA CRINA
	if(
	    _ing.token == "int"
	    && !is_undefined(valor)
	)
	{
	    _nome += " (" + string(valor) + ")";
	}

	// MENSAGEM ACIMA DO PLAYER
	CriaMensagem(
		_centro[0],
		_centro[1],
	    _nome + " adicionado à bolsa!"
	);

	instance_destroy();
}
else if(!avisou_bolsa_cheia)
{
    CriaMensagem(
		_centro[0],
		_centro[1],
        "Bolsa cheia!"
    );

    avisou_bolsa_cheia = true;
}