#macro CELL_T 32

// IDENTIFICA UM INGREDIENTE PELO NOME, TOKEN, NÚMERO OU STRUCT
function IngredientePorReferenciaDrop(_referencia)
{
    // NENHUMA REFERÊNCIA
    if (is_undefined(_referencia))
    {
        return undefined;
    }

    // STRUCT DE INGREDIENTE
    if (is_struct(_referencia))
    {
        if (variable_struct_exists(_referencia, "numero"))
        {
            return IngredientePorNumero(_referencia.numero);
        }

        return undefined;
    }

    // NÚMERO DO INGREDIENTE
    if (is_real(_referencia))
    {
        if (_referencia == noone)
        {
            return undefined;
        }

        return IngredientePorNumero(_referencia);
    }

    // NOME OU TOKEN
    if (is_string(_referencia))
    {
        // TENTA PELO NOME
        var _ing_nome = IngredientePorNome(_referencia);

        if (!is_undefined(_ing_nome))
        {
            return _ing_nome;
        }

        // TENTA PELO TOKEN
        var _ing_token = IngredientePorToken(_referencia);

        if (!is_undefined(_ing_token))
        {
            return _ing_token;
        }

        // TENTA O TOKEN SEM DIFERENCIAR MAIÚSCULAS
        var _token_busca = string_lower(_referencia);

        for (var i = 0; i < array_length(global.Ingredientes); i++)
        {
            var _ing = global.Ingredientes[i];

            if (string_lower(_ing.token) == _token_busca)
            {
                return _ing;
            }
        }
    }

    return undefined;
}

// CONVERTE UMA REFERÊNCIA OU ARRAY DE REFERÊNCIAS EM UM ARRAY DE INGREDIENTES
function NormalizaIngredientesDrop(_referencias)
{
    var _lista = [];

    // NENHUMA REFERÊNCIA
    if (is_undefined(_referencias))
    {
        return _lista;
    }

    if (is_real(_referencias) && _referencias == noone)
    {
        return _lista;
    }

    // VÁRIAS REFERÊNCIAS
    if (is_array(_referencias))
    {
        for (var i = 0; i < array_length(_referencias); i++)
        {
            var _ing = IngredientePorReferenciaDrop(_referencias[i]);

            if (!is_undefined(_ing))
            {
                array_push(_lista, _ing);
            }
        }
    }
    // UMA ÚNICA REFERÊNCIA
    else
    {
        var _ing = IngredientePorReferenciaDrop(_referencias);

        if (!is_undefined(_ing))
        {
            array_push(_lista, _ing);
        }
    }

    return _lista;
}

// VERIFICA SE UM INGREDIENTE ESTÁ EM UMA LISTA
function IngredienteEstaNaListaDrop(_ingrediente, _lista)
{
    for (var i = 0; i < array_length(_lista); i++)
    {
        if (_lista[i].numero == _ingrediente.numero)
        {
            return true;
        }
    }

    return false;
}

// ENCONTRA AS DIREÇÕES LIVRES DE PAREDES
function DirecoesDropDisponiveis(_origem, _tamanho_celula = 32)
{
    var _angulos =
    [
        0, 45, 90, 135,
        180, 225, 270, 315
    ];

    var _livres = [];

    if (!instance_exists(_origem))
    {
        return _livres;
    }

    // CENTRO DA ORIGEM
    var _cx = (_origem.bbox_left + _origem.bbox_right) / 2;
    var _cy = (_origem.bbox_top + _origem.bbox_bottom) / 2;

    // VERIFICA OS OITO BLOCOS VIZINHOS
    for (var i = 0; i < array_length(_angulos); i++)
    {
        var _direcao = _angulos[i];

        var _dx = round(lengthdir_x(1, _direcao))
            * _tamanho_celula;

        var _dy = round(lengthdir_y(1, _direcao))
            * _tamanho_celula;

        var _px = _cx + _dx;
        var _py = _cy + _dy;

        var _parede = collision_point(
            _px,
            _py,
            obj_wall,
            false,
            false
        );

        if (_parede == noone)
        {
            array_push(_livres, _direcao);
        }
    }

    return _livres;
}

// CRIA UM INGREDIENTE QUE SE MOVE RADIALMENTE
function CriaDropAnimado(
    _origem,
    _numero,
    _valor,
    _direcao,
    _distancia,
    _atraso = 0,
    _escala = 0.5
)
{
    var _ing = IngredientePorNumero(_numero);

    if (is_undefined(_ing) || !instance_exists(_origem))
    {
        return noone;
    }

    var _sprite = _ing.sprite;

    // CENTRO DA ORIGEM
    var _cx = (_origem.bbox_left + _origem.bbox_right) / 2;
    var _cy = (_origem.bbox_top + _origem.bbox_bottom) / 2;

    // CRIA O OBJETO TEMPORÁRIO NA MESMA LAYER
    var _drop = instance_create_layer(
        _cx,
        _cy,
        _origem.layer,
        obj_efeito_drop
    );

    // IDENTIFICAÇÃO DO INGREDIENTE
    _drop.ingrediente_numero = _numero;
    _drop.valor = _valor;

    // SPRITE E MÁSCARA
    _drop.sprite_index = _sprite;
    _drop.mask_index = _sprite;

    _drop.image_index = 0;
    _drop.image_speed = 0;

    // ESCALA
    _drop.escala_ingrediente = _escala;
    _drop.image_xscale = _escala;
    _drop.image_yscale = _escala;

    // CENTRALIZA O SPRITE CONSIDERANDO ESCALA E ORIGEM
    _drop.x = _cx
        - sprite_get_width(_sprite) * _escala / 2
        + sprite_get_xoffset(_sprite) * _escala;

    _drop.y = _cy
        - sprite_get_height(_sprite) * _escala / 2
        + sprite_get_yoffset(_sprite) * _escala;

    // DIREÇÃO E DISTÂNCIA
    _drop.direcao = _direcao;
    _drop.distancia_total = _distancia;
    _drop.distancia_percorrida = 0;

    // MOVIMENTO
    _drop.velocidade = 4;
    _drop.atraso = _atraso;

    return _drop;
}

// SORTEIA E CRIA OS DROPS
// _quantidade       = quantidade de drops aleatórios adicionais
// _drop_garantido   = ingrediente(s) que sempre devem dropar
// _nao_sortear      = ingrediente(s) excluídos do sorteio
// _origem           = objeto que está soltando os ingredientes
// _escala           = escala visual dos ingredientes
// _tamanho_celula   = tamanho dos blocos do mapa
function DropaIngredientes(
    _quantidade,
    _drop_garantido = undefined,
    _nao_sortear = undefined,
    _origem = id,
    _escala = 0.5,
    _tamanho_celula = 32
)
{
    // VERIFICA A ORIGEM
    if (!instance_exists(_origem))
    {
        show_debug_message(
            "Drops: a origem informada não existe."
        );

        return 0;
    }

    // GARANTIDOS E EXCLUSÕES
    var _garantidos = NormalizaIngredientesDrop(_drop_garantido);
    var _excluidos = NormalizaIngredientesDrop(_nao_sortear);

    // QUANTIDADE DE DROPS ADICIONAIS
    _quantidade = max(0, floor(_quantidade));

    // DIREÇÕES LIVRES
    var _direcoes = DirecoesDropDisponiveis(
        _origem,
        _tamanho_celula
    );

    var _total_direcoes = array_length(_direcoes);

    if (_total_direcoes <= 0)
    {
        show_debug_message(
            "Drops: não há direções livres para soltar ingredientes."
        );

        return 0;
    }

    // CRIA O POOL DE INGREDIENTES SORTEÁVEIS
    var _sorteaveis = [];

    for (var i = 0; i < array_length(global.Ingredientes); i++)
    {
        var _ing = global.Ingredientes[i];

        if (!IngredienteEstaNaListaDrop(_ing, _excluidos))
        {
            array_push(_sorteaveis, _ing);
        }
    }

    // LISTA FINAL DE INGREDIENTES A DROPAR
    var _itens = [];

    // PRIMEIRO, ADICIONA OS GARANTIDOS
    // ELES TÊM PRIORIDADE SE NÃO HOUVER DIREÇÕES SUFICIENTES
    for (var g = 0; g < array_length(_garantidos); g++)
    {
        if (array_length(_itens) >= _total_direcoes)
        {
            break;
        }

        array_push(_itens, _garantidos[g]);
    }

    // DEPOIS, SORTEIA A QUANTIDADE ADICIONAL
    for (var j = 0; j < _quantidade; j++)
    {
        if (array_length(_itens) >= _total_direcoes)
        {
            break;
        }

        if (array_length(_sorteaveis) <= 0)
        {
            break;
        }

        var _indice_ing = irandom(array_length(_sorteaveis) - 1);
        var _ing_sorteado = _sorteaveis[_indice_ing];

        array_push(_itens, _ing_sorteado);
    }

    // AVISA SE A QUANTIDADE SOLICITADA EXCEDER AS DIREÇÕES LIVRES
    var _total_solicitado = array_length(_garantidos) + _quantidade;

    if (_total_solicitado > _total_direcoes)
    {
        show_debug_message(
            "Drops: quantidade limitada pelas direções livres."
        );
    }

    // CALCULA O MAIOR TAMANHO DE SPRITE DOS INGREDIENTES
    var _maior_dim = 0;

    for (var m = 0; m < array_length(global.Ingredientes); m++)
    {
        var _sprite = global.Ingredientes[m].sprite;

        if (!is_undefined(_sprite) && sprite_exists(_sprite))
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

    // DISTÂNCIA PARA MANTER OS DROPS SEPARADOS
    var _distancia_drop = max(
        48,
        ceil((_maior_dim + 8) / 0.765366)
    );

    // CRIA CADA DROP USANDO UMA DIREÇÃO ÚNICA
    var _criados = 0;

    for (var k = 0; k < array_length(_itens); k++)
    {
        var _ing = _itens[k];

        // SORTEIA UMA DIREÇÃO DISPONÍVEL
        var _n = array_length(_direcoes);

        if (_n <= 0)
        {
            break;
        }

        var _indice_direcao = irandom(_n - 1);
        var _direcao = _direcoes[_indice_direcao];

        // REMOVE A DIREÇÃO USADA
        _direcoes[_indice_direcao] = _direcoes[_n - 1];
        array_resize(_direcoes, _n - 1);

        // CRINA RECEBE UM VALOR ENTRE -9 E 9
        var _valor = undefined;

        if (_ing.token == "int")
        {
            _valor = irandom_range(-9, 9);
        }

        // CRIA O OBJETO ANIMADO
        var _drop = CriaDropAnimado(
            _origem,
            _ing.numero,
            _valor,
            _direcao,
            _distancia_drop,
            k * 3,
            _escala
        );

        if (_drop != noone)
        {
            _criados++;
        }
    }

    return _criados;
}