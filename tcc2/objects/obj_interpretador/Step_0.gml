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