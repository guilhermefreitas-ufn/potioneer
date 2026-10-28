ingrediente_numero = -1;
valor = undefined;

avisou_bolsa_cheia = false;

image_speed = 0;
image_index = 0;

// CRIA UMA MENSAGEM SEM SOBREPOR AS ANTERIORES
CriarMensagem = function(_texto, _player)
{
    // CENTRO HORIZONTAL E TOPO DO PLAYER
    var _msg_x = (
        _player.bbox_left
        + _player.bbox_right
    ) / 2;

    var _msg_y = _player.bbox_top - 12;

    // CONTA MENSAGENS PRÓXIMAS
    var _mensagens_proximas = 0;

    var _total = instance_number(
        obj_mensagem_coleta
    );

    for(var i = 0; i < _total; i++)
    {
        var _existente = instance_find(
            obj_mensagem_coleta,
            i
        );

        if(_existente == noone)
        {
            continue;
        }

        if(
            abs(_existente.x - _msg_x) < 100
            && abs(_existente.y - _msg_y) < 120
        )
        {
            _mensagens_proximas++;
        }
    }

    // CADA MENSAGEM OCUPA UMA LINHA
    var _nova_y = _msg_y
        - _mensagens_proximas * 18;

    var _mensagem = instance_create_layer(
        _msg_x,
        _nova_y,
        "UI",
        obj_mensagem_coleta
    );

    _mensagem.texto = _texto;
};