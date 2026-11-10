// Etapa visual atual:
// "nao_configurado", "voando" ou "area"
etapa = "nao_configurado";

// Dados da poção
algoritmo = undefined;
sprite_pocao = spr_pocao_quadrada;
cor_pocao = c_white;
raio_efeito = 64;

escala_x = .5;
escala_y = .5;
rotacao = 360;

// Posição inicial e destino
x_inicio = x;
y_inicio = y;

x_destino = x;
y_destino = y;


// Movimento
tempo_voo = 0;
duracao_voo = 1;
velocidade_voo = VELOCIDADE_ARREMESSO_POCAO;

// Área de efeito
tempo_area = 0;

duracao_area = max(
    1,
    round(GAME_SPEED * SEGUNDOS_AREA_EFEITO_POCAO)
);

// Controle para aplicar o algoritmo somente uma vez
aplicou_efeito = false;

// CONFIGURAR A POÇÃO
Configurar = function(
    _algoritmo,
    _sprite,
    _cor,
    _raio,
    _x_inicio,
    _y_inicio,
    _x_destino,
    _y_destino,
    _tipo
)
{
    algoritmo = _algoritmo;

    // Sprite de fallback
    sprite_pocao = spr_pocao_quadrada;

    if (!is_undefined(_sprite))
    {
        sprite_pocao = _sprite;
    }

    // Cor de fallback
    cor_pocao = c_white;

    if (!is_undefined(_cor))
    {
        cor_pocao = _cor;
    }

    raio_efeito = max(1, _raio);

    x_inicio = _x_inicio;
    y_inicio = _y_inicio;

    x_destino = _x_destino;
    y_destino = _y_destino;

    x = x_inicio;
    y = y_inicio;

    aplicou_efeito = false;

    // ARREMESSO
    if (_tipo == "arremesso")
    {
        var _distancia = point_distance(
            x_inicio,
            y_inicio,
            x_destino,
            y_destino
        );

        duracao_voo = max(
            1,
            ceil(
                _distancia
                / velocidade_voo
                * GAME_SPEED
            )
        );

        tempo_voo = 0;

        etapa = "voando";
    }
	
    // QUEBRA IMEDIATA NO LOCAL
    else if (_tipo == "impacto")
    {
        x = x_destino;
        y = y_destino;

        AplicarImpacto();
    }

    // TIPO INVÁLIDO
    else
    {
        instance_destroy();
    }
};

// QUEBRA DA POÇÃO E APLICAÇÃO DO ALGORITMO
AplicarImpacto = function()
{
    // Impede a aplicação repetida do algoritmo
    if (aplicou_efeito)
    {
        return;
    }

    aplicou_efeito = true;

    // A partir deste momento, a poção deixa de aparecer
    // e passa a desenhar a área de efeito.
    etapa = "area";

    tempo_area = duracao_area;

    // Procura entidades no ponto de impacto
    var _contexto = CriaContextoAreaPocao(
        x,
        y,
        raio_efeito
    );

    // Executa o algoritmo da poção
    var _resultado = ExecutaAlgoritmo(
        algoritmo,
        _contexto
    );
	
	#region DEBUG
    show_debug_message(
        "SUCESSO: " + string(_resultado.sucesso)
    );

    show_debug_message(
        "CONDIÇÃO: " + string(_resultado.condicao)
    );

    show_debug_message(
        "EFEITO: " + string(_resultado.efeito_aplicado)
    );

    show_debug_message(
        "ENTIDADES AFETADAS: "
        + string(
            array_length(
                _resultado.entidades_afetadas
            )
        )
    );

    show_debug_message(
        "MENSAGEM: " + _resultado.mensagem
    );
	#endregion
	
	//pop-up de mensagem
	if(!instance_exists(obj_player))
	{
	    return;
	}

	var _player = instance_find(
	    obj_player,
	    0
	);

	var _centro = _player.Centro();
	
	if(_resultado.mensagem != "")
	{
		CriaMensagem(
			x_destino,
			y_destino,
			_resultado.mensagem
		);
	}
	else
	{
		//Retorna quantos/quais entidades foram afetas
		CriaMensagem(
			x_destino,
			y_destino,
			string(array_length(_resultado.entidades_afetadas)) + " entidade(s) afetada(s) pela poção!"
		);
	}
};