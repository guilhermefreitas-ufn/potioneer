//Inherit the parent event
event_inherited();

//testes
//sprite_index = spr_placeholder_32;
//image_speed = 0;
//image_index = 0;

//var _cor_poeira = make_colour_rgb(153,116,73);
var _cor_poeira = make_colour_rgb(121,119,134);

rastro_fx = criar_efeito(x, y, "rastro_poeira", _cor_poeira, {
    target: id,
    offset_y: 0,
    duracao: -1,
    intervalo: 5,
    pausado: true
});

nome = "Player";
cor = c_black;

hp = 10;
spd = 2;
atk = 6;

//invencibilidade
invencivel = false;
invencivel_timer = GAME_SPEED * 3;
tempo_invencivel = invencivel_timer;

//POÇÕES
raio_pocao = 32;
mostrar_area = true;
alpha_alcance = 0.1;
alpha_descricao_area = 0.2;
alpha_area = 0.5;
alcance_por_atk = 16;
cor_alcance = c_yellow;

//Slot selecionado: 0 até 4
pocao_selecionada = 0;

//minha iluminação
luz = noone;
luz_tam = 256;

//movimentação
estado = "parado";
velh = 0;
velv = 0;

direcao = 0;

direita		= 0;
esquerda	= 0;
cima		= 0;
baixo		= 0;

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

//MÁQUINA DE ESTADOS DO PLAYER
tempo_estado = 0;

//Durações dos estados temporários
duracao_sofrendo = max(
	1,
	round(GAME_SPEED * 0.25)
);

duracao_bebendo = max(
	1,
	round(GAME_SPEED * 0.5)
);

duracao_atacando = max(
	1,
	round(GAME_SPEED * 0.25)
);

//TRANSIÇÃO ENTRE ESTADOS
MudaEstado = function(_novo_estado)
{
	//Se já está sofrendo, renova a duração
	if(estado == _novo_estado)
	{
		if(_novo_estado == "sofrendo")
		{
			tempo_estado = duracao_sofrendo;
		}
		
		return;
	}
	
	estado = _novo_estado;
	
	switch (estado)
	{
		case "sofrendo":
		{
			tempo_estado = duracao_sofrendo;
			break;
		}
		case "bebendo":
		{
			tempo_estado = duracao_bebendo;
			break;
		}
		case "atacando":
		{
			tempo_estado = duracao_atacando;
			break;
		}
		default:
		{
			tempo_estado = 0;
			break;
		}
	}
	
	//Estados diferentes de movendo interrompem
	//o deslocamento calculado pelos controles.
	if(estado != "movendo")
	{
		velh = 0;
		velv = 0;
	}
};

//ATUALIZA A MOVIMENTAÇÃO DO PLAYER
AtualizaMovimento = function(_obstaculos = [obj_wall])
{
	PegaControles();
	
	if(velh != 0 || velv != 0)
	{
		if(estado != "movendo")
		{
			MudaEstado("movendo");
		}
		
		move_and_collide(
			velh,
			velv,
			_obstaculos
		);
	}
	else
	{
		if(estado != "parado")
		{
			MudaEstado("parado");
		}
	}
};

//Verifica se o cursor está sobre um slot da Hotbar
MouseSobreSlotHotbar = function()
{
	if(!instance_exists(obj_hotbar))
	{
		return false;
	}
	
	var _hotbar = instance_find(obj_hotbar, 0);
	
	var _mx_gui = device_mouse_x_to_gui(0);
	var _my_gui = device_mouse_y_to_gui(0);
	
	var _slot = _hotbar.SlotSobreMouse(
		_mx_gui,
		_my_gui
	);
	
	return _slot != -1;
};

//Calcula o alcance máximo com base no força
AlcancePocao = function()
{
	return max(0, atk * alcance_por_atk);
};

//Calcula a posição permitida para a área da poção
PosicaoAlvoPocao = function(_mx, _my)
{
	var _centro = Centro();
	
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

//EXECUTA A POÇÃO SELECIONADA
function ExecutaPocao(_modo)
{
	var _centro = Centro();
	var _indice = pocao_selecionada;
	
	
	//Valida o slot selecionado
	if(_indice < 0 || _indice >= SLOTS_HOTBAR_POCOES)
	{
		return false;
	}
	
	var _pocao = global.DadosJogador.hotbar_pocoes[_indice];
	
	//Verifica se existe uma poção
	if(is_undefined(_pocao))
	{
		CriaMensagem(
			_centro[0],
			_centro[1],
			"O slot selecionado está vazio."
		);
		
		return false;
	}
	
	//Verifica o cooldown
	if(_pocao.cooldown > 0)
	{
		CriaMensagem(
			_centro[0],
			_centro[1],
			"A poção está em recarga."
		);
		
		return false;
	}
	
	//Pegando o sprite e a cor da poção
	var _sprite = spr_pocao;
	var _cor = c_white;
	
	if(variable_struct_exists(_pocao, "sprite"))
	{
		if(!is_undefined(_pocao.sprite))
		{
			_sprite = _pocao.sprite;
		}
	}
	
	if(variable_struct_exists(_pocao, "cor"))
	{
		if(!is_undefined(_pocao.cor))
		{
			_cor = _pocao.cor;
		}
	}
	
	var _executada = false;
	
	//FORMAS DE USO
	switch (_modo)
	{
		//CLIQUE ESQUERDO: Arremesso até o cursor
		case "mouse":
		{
			var _alvo = PosicaoAlvoPocao(
				mouse_x,
				mouse_y
			);
			
			//Cria o efeito visual na posição do jogador
			var _efeito = instance_create_depth(
			 _centro[0],
			 _centro[1],
			 depth - 1,
			 obj_efeito_pocao
			);
			
			if(
				_efeito == noone
				|| !instance_exists(_efeito)
			)
			{
				return false;
			}
			
			//Configura o arremesso
			_efeito.Configurar(
				_pocao.algoritmo,
				_sprite,
				_cor,
				raio_pocao,
				_centro[0],
				_centro[1],
				_alvo[0],
				_alvo[1],
				"arremesso"
			);
			
			_executada = true;
			
			break;
		}
		
		//CLIQUE DIREITO: Quebra aos pés do personagem
		case "player_area":
		{
			var _efeito = instance_create_depth(
				_centro[0],
				_centro[1],
				depth - 1,
				obj_efeito_pocao
			);
			
			if(
				_efeito == noone
				|| !instance_exists(_efeito)
			)
			{
				return false;
			}
			
			//A poção quebra imediatamente no local
			_efeito.Configurar(
				_pocao.algoritmo,
				_sprite,
				_cor,
				raio_pocao,
				_centro[0],
				_centro[1],
				_centro[0],
				_centro[1],
				"impacto"
			);
			
			_executada = true;
			
			break;
		}
		
		//Modo inválido
		default:
		{
			return false;
		}
	}
	
	if(!_executada)
	{
		return false;
	}
	
	//Inicia o cooldown
	_pocao.cooldown = max(
		1,
		round(GAME_SPEED * SEGUNDOS_COOLDOWN_POCAO)
	);
	
	return true;
}