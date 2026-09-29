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
		global.DadosJogador.hotbar_pocoes[
			_indice
		];
	
	
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