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

//poções
raio_teste = 80;
mostrar_area = true;

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
	
	
	var _contexto =
		CriaContextoAreaPocao(
			mouse_x,
			mouse_y,
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