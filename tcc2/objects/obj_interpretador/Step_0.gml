// procurando o caldeirão caso ainda não tenha sido encontrado
if(!instance_exists(caldeirao))
{
	caldeirao = instance_find(obj_caldeirao, 0);
}

// se não tem caldeirão na room, não executo nada
if(caldeirao == noone)
{
	exit;
}

// ==========================================
// DIGITAÇÃO DO NOME DA POÇÃO
// ==========================================

if(nomeando_pocao)
{
	keyboard_string = string_copy(
		keyboard_string,
		1,
		nome_pocao_max
	);
	
	nome_pocao = keyboard_string;
	
	
	// ==========================================
	// CONFIRMAR
	// ==========================================
	
	if(keyboard_check_pressed(vk_enter))
	{
		var _nome = string_trim(nome_pocao);
		
		if(_nome != "")
		{
			// ==========================================
			// VERIFICANDO NOME DUPLICADO
			// ==========================================
	
			if(PocaoNomeExisteNoArmario(_nome))
			{
				mensagem = "Nome de poção já usado!";
				mensagem_timer = mensagem_duracao;
		
				return;
			}
	
	
			// ==========================================
			// CRIANDO A POÇÃO
			// ==========================================
	
			AdicionaPocaoArmario(
				_nome,
				algoritmo,
				sentenca
			);
	
			ConsomeCaldeirao(caldeirao);
	
			nomeando_pocao = false;
			nome_pocao = "";
			keyboard_string = "";
	
			mensagem = "Poção criada com sucesso!";
			mensagem_timer = mensagem_duracao;
		}
	}
	
	
	// ==========================================
	// CANCELAR
	// ==========================================
	
	if(keyboard_check_pressed(vk_escape))
	{
		nomeando_pocao = false;
		nome_pocao = "";
		keyboard_string = "";
	}
	
	
	// ==========================================
	// NÃO EXECUTAR O RESTANTE DO STEP
	// ==========================================
	
	exit;
}

//atualizando a sentença (frase) em tempo real conforme as mudanças no caldeirão
var _resultado = InterpretarCaldeirao(caldeirao);

tokens = _resultado.tokens;
sentenca = _resultado.sentenca;

algoritmo = _resultado.algoritmo;

sintaxe_valida = _resultado.sintaxe_valida;
semantica_valida = _resultado.semantica_valida;

erro_sintaxe = _resultado.erro_sintaxe;
erro_semantica = _resultado.erro_semantica;

slot_erro = _resultado.slot_erro;

// ==========================================
// MENSAGEM
// ==========================================

if(mensagem_timer > 0)
{
	mensagem_timer--;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _x = display_get_gui_width()
		- botao_criar_largura
		- botao_criar_margem;

var _y = display_get_gui_height()
		- botao_criar_altura
		- botao_criar_margem;

if(
	mouse_check_button_pressed(mb_left)
	&& point_in_rectangle(
		_mx,
		_my,
		_x,
		_y,
		_x + botao_criar_largura,
		_y + botao_criar_altura
	)
)
{
	CriarPocao();
}