//Inherit the parent event
event_inherited();

nome = "Player";
cor = c_black;

hp = 20;
spd = 3;
atk = 5;

//testes
sprite_index = spr_placeholder_32;
image_speed = 0;
image_index = 0;

//movimentação
estado = "parado";
velh = 0;
velv = 0;

direita = 0;
esquerda = 0;
cima = 0;
baixo = 0;

PegaControles = function()
{
	direita = keyboard_check(ord("D")); 
	esquerda = keyboard_check(ord("A")); 
	cima = keyboard_check(ord("W")); 
	baixo = keyboard_check(ord("S"));
	
	//removar daqui se quiser desabilitar os controles em algum estado
	//"paralisado", por exemplo
	
	var _dir = point_direction(0, 0, direita - esquerda, baixo - cima);
	
	if(direita xor esquerda or baixo xor cima)
	{
		velh = lengthdir_x(spd, _dir);
		velv = lengthdir_y(spd, _dir);
	}
	else
	{
		velh = 0;
		velv = 0;
	}
}

//invencibilidade
invencivel = false;
invencivel_timer = GAME_SPEED * 3;
tempo_invencivel = invencivel_timer;

//CENTRO DO PLAYER
CentroPlayer = function()
{
    return [
        x + sprite_get_width(sprite_index) * abs(image_xscale) / 2,
        y + sprite_get_height(sprite_index) * abs(image_yscale) / 2
    ];
};

//POÇÕES
raio_teste = 64;
mostrar_area = true;

//ALCANCE DE USO DAS POÇÕES
alcance_por_atk = 32;

//Calcula o alcance máximo com base no ataque
AlcancePocao = function()
{
    return max(0, atk * alcance_por_atk);
};

//Calcula a posição permitida para a área da poção
PosicaoAlvoPocao = function(_mx, _my)
{
    var _centro = CentroPlayer();

    var _px = _centro[0];
    var _py = _centro[1];

    var _alcance = AlcancePocao();

    var _distancia = point_distance(
        _px,
        _py,
        _mx,
        _my
    );

    if(_distancia > _alcance)
    {
        var _direcao = point_direction(
            _px,
            _py,
            _mx,
            _my
        );

        return [
            _px + lengthdir_x(_alcance, _direcao),
            _py + lengthdir_y(_alcance, _direcao)
        ];
    }

    return [_mx, _my];
};

function ExecutaPocao(_numero)
{
	var _indice = _numero - 1;
	
	if(
		_indice < 0
		|| _indice >= SLOTS_HOTBAR_POCOES
	)
	{
		return;
	}
	
	var _pocao =
		global.DadosJogador.hotbar_pocoes[_indice];
	
	
	if(is_undefined(_pocao))
	{
		show_debug_message(
			"Não existe uma poção nesse slot da hotbar."
		);
		
		return;
	}
	
	
	//Calcula a posição permitida para a poção
	var _alvo = PosicaoAlvoPocao(
	    mouse_x,
	    mouse_y
	);

	//Cria a área da poção na posição calculada
	var _contexto =
	    CriaContextoAreaPocao(
	        _alvo[0],
	        _alvo[1],
	        raio_teste
	    );
	
	
	var _resultado =
		ExecutaAlgoritmo(
			_pocao.algoritmo,
			_contexto
		);
	
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
		+ string(array_length(_resultado.entidades_afetadas))
	);

	show_debug_message(
		"MENSAGEM: " + _resultado.mensagem
	);
}