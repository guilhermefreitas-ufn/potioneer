// ESTADO DO BAÚ
aberto = false;
sumir = false;
itens_droppados = false;

// ESCALA DOS INGREDIENTES DROPPADOS
escala_drop = 0.5;

// DISTÂNCIA NECESSÁRIA PARA ABRIR O BAÚ
distancia_abertura = 64;

image_speed = 0;
image_index = 0;
image_alpha = 1;

// TAMANHO DE CADA BLOCO DO MAPA
tamanho_celula_drop = 32;

// ENCONTRA DIREÇÕES COM O BLOCO VIZINHO LIVRE
DirecoesDropDisponiveis = function()
{
    var _angulos = [
        0, 45, 90, 135,
        180, 225, 270, 315
    ];

    var _livres = [];

    // CENTRO DO BAÚ
    var _cx = (bbox_left + bbox_right) / 2;
    var _cy = (bbox_top + bbox_bottom) / 2;

    // VERIFICA OS OITO BLOCOS VIZINHOS
    for(var i = 0; i < array_length(_angulos); i++)
    {
        var _direcao = _angulos[i];

        // DESLOCAMENTO PARA O CENTRO DO BLOCO VIZINHO
        var _dx = round(
            lengthdir_x(1, _direcao)
        ) * tamanho_celula_drop;

        var _dy = round(
            lengthdir_y(1, _direcao)
        ) * tamanho_celula_drop;

        var _px = _cx + _dx;
        var _py = _cy + _dy;

        // TESTA SOMENTE O CENTRO DO BLOCO VIZINHO
        var _parede = collision_point(
            _px,
            _py,
            obj_wall,
            false,
            false
        );

        // A DIREÇÃO É PERMITIDA SE O VIZINHO ESTIVER LIVRE
        if(_parede == noone)
        {
            array_push(
                _livres,
                _direcao
            );
        }
    }

    return _livres;
};

// CRIA UM INGREDIENTE QUE SE MOVE RADIALMENTE
CriaDropAnimado = function(
    _numero,
    _valor,
    _direcao,
    _distancia,
    _atraso = 0
)
{
    // INGREDIENTE
    var _ing = IngredientePorNumero(_numero);

    if(is_undefined(_ing))
    {
        return noone;
    }

    var _sprite = _ing.sprite;

    // CENTRO DO BAÚ
    var _cx = (bbox_left + bbox_right) / 2;
    var _cy = (bbox_top + bbox_bottom) / 2;

    // CRIA O OBJETO TEMPORÁRIO
    var _drop = instance_create_layer(
        _cx,
        _cy,
        layer,
        obj_drop_anim
    );

    // IDENTIFICAÇÃO DO INGREDIENTE
    _drop.ingrediente_numero = _numero;
    _drop.valor = _valor;

    // SPRITE E MÁSCARA
	_drop.sprite_index = _sprite;
	_drop.mask_index = _sprite;

	_drop.image_index = 0;
	_drop.image_speed = 0;

	// ESCALA DO INGREDIENTE
	_drop.escala_ingrediente = escala_drop;

	_drop.image_xscale = escala_drop;
	_drop.image_yscale = escala_drop;

	// CENTRALIZA O SPRITE NO BAÚ,
	// CONSIDERANDO A ESCALA E A ORIGEM
	_drop.x = _cx
	    - sprite_get_width(_sprite)
	    * escala_drop / 2
	    + sprite_get_xoffset(_sprite)
	    * escala_drop;

	_drop.y = _cy
	    - sprite_get_height(_sprite)
	    * escala_drop / 2
	    + sprite_get_yoffset(_sprite)
	    * escala_drop;

    // DIREÇÃO E DISTÂNCIA
    _drop.direcao = _direcao;
    _drop.distancia_total = _distancia;
    _drop.distancia_percorrida = 0;

    // MOVIMENTO
    _drop.velocidade = 4;
    _drop.atraso = _atraso;

    return _drop;
};

// DROP DOS INGREDIENTES
DropaItens = function(_quantidade)
{
    // CALCULA O MAIOR TAMANHO DE SPRITE
    var _maior_dim = 0;

    for(
        var i = 0;
        i < array_length(global.Ingredientes);
        i++
    )
    {
        var _sprite = global.Ingredientes[i].sprite;

        if(
            !is_undefined(_sprite)
            && sprite_exists(_sprite)
        )
        {
            _maior_dim = max(
                _maior_dim,
                max(
                    sprite_get_width(_sprite),
                    sprite_get_height(_sprite)
                )
            );
        }
    }


    // DISTÂNCIA PARA MANTER OS ITENS SEPARADOS
    var _distancia_drop = max(
        48,
        ceil((_maior_dim + 8) / 0.765366)
    );


    // DIREÇÕES LIVRES DE PAREDES
    var _direcoes = DirecoesDropDisponiveis();

    var _quantidade_direcoes = array_length(
        _direcoes
    );

    // NENHUMA DIREÇÃO DISPONÍVEL
    if(_quantidade_direcoes <= 0)
    {
        show_debug_message(
            "Baú cercado por paredes: não foi possível dropar itens."
        );

        return;
    }


    // INGREDIENTES SORTEÁVEIS
    // Exclui o IF (Cubo), pois ele já é garantido.
    var _ingredientes_sorteaveis = [];

    for(
        var j = 0;
        j < array_length(global.Ingredientes);
        j++
    )
    {
        var _ing = global.Ingredientes[j];

        if(_ing.token == "if")
        {
            continue;
        }

        array_push(
            _ingredientes_sorteaveis,
            _ing
        );
    }

    var _total_sorteaveis = array_length(
        _ingredientes_sorteaveis
    );


    // CUBO GARANTIDO + INGREDIENTES ALEATÓRIOS
    var _total_desejado = _quantidade + 1;

    // A quantidade é limitada pelas direções disponíveis
    var _total_drops = min(
        _total_desejado,
        _quantidade_direcoes
    );

    if(_total_drops < _total_desejado)
    {
        show_debug_message(
            "Alguns itens não foram dropados por falta de direções livres."
        );
    }


    // CRIA OS DROPS
    for(var k = 0; k < _total_drops; k++)
    {
        // SORTEIA UMA DIREÇÃO DISPONÍVEL
        var _n = array_length(_direcoes);

        var _indice_direcao = irandom(_n - 1);

        var _direcao = _direcoes[
            _indice_direcao
        ];

        // REMOVE A DIREÇÃO ESCOLHIDA
        // Assim, nenhum outro item usará o mesmo ângulo.
        _direcoes[_indice_direcao] =
            _direcoes[_n - 1];

        array_resize(
            _direcoes,
            _n - 1
        );


        var _numero;
        var _valor = undefined;


        // PRIMEIRO ITEM: CUBO GARANTIDO
        if(k == 0)
        {
            _numero = 0;
        }
        else
        {
            // SORTEIA APENAS INGREDIENTES PERMITIDOS
            if(_total_sorteaveis <= 0)
            {
                continue;
            }

            var _ing_sorteado =
                _ingredientes_sorteaveis[
                    irandom(_total_sorteaveis - 1)
                ];

            _numero = _ing_sorteado.numero;

            // CRINA: VALOR INTEIRO ENTRE -9 E 9
            if(_ing_sorteado.token == "int")
            {
                _valor = irandom_range(-9, 9);
            }
        }


        // CRIA O ITEM COM SUA DIREÇÃO ÚNICA
        CriaDropAnimado(
            _numero,
            _valor,
            _direcao,
            _distancia_drop,
            k * 3
        );
    }
};