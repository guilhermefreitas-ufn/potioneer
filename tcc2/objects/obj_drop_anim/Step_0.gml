// ESPERA ANTES DE COMEÇAR A SE MOVER
if(atraso > 0)
{
    atraso--;
    exit;
}

// VERIFICA SE AINDA HÁ DISTÂNCIA A PERCORRER
var _restante = distancia_total
    - distancia_percorrida;

if(_restante <= 0)
{
    FinalizaDrop();
    instance_destroy();
    exit;
}

// CALCULA O PRÓXIMO MOVIMENTO
var _passo = min(
    velocidade,
    _restante
);

var _proximo_x = x
    + lengthdir_x(_passo, direcao);

var _proximo_y = y
    + lengthdir_y(_passo, direcao);


// VERIFICA A COLISÃO COM A PAREDE
if(
    place_meeting(
        _proximo_x,
        _proximo_y,
        obj_wall
    )
)
{
    // NÃO AVANÇA PARA DENTRO DA PAREDE
    FinalizaDrop();
    instance_destroy();
    exit;
}


// MOVIMENTO SEGURO
x = _proximo_x;
y = _proximo_y;

distancia_percorrida += _passo;


// CHEGOU AO DESTINO
if(distancia_percorrida >= distancia_total)
{
    FinalizaDrop();
    instance_destroy();
}