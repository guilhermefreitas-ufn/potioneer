//iniciando variáveis
var _b, _r, _0, _9, _8, _7, _6, _5, _4, _3, _2, _1;

_b = keyboard_check_pressed(ord("B"));
_r = keyboard_check_pressed(ord("R"));
_0 = keyboard_check_pressed(vk_numpad0) || keyboard_check_pressed(ord("0"));
_1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));
_2 = keyboard_check_pressed(vk_numpad2) || keyboard_check_pressed(ord("2"));
_9 = keyboard_check_pressed(vk_numpad9) || keyboard_check_pressed(ord("9"));
_8 = keyboard_check_pressed(vk_numpad8) || keyboard_check_pressed(ord("8"));
_7 = keyboard_check_pressed(vk_numpad7) || keyboard_check_pressed(ord("7"));
_6 = keyboard_check_pressed(vk_numpad6) || keyboard_check_pressed(ord("6"));
var _enter = keyboard_check_pressed(vk_enter);
var _backspace = keyboard_check_pressed(vk_backspace);
var _space = keyboard_check_pressed(vk_space);

var _posso_clicar = false;

if(!instance_exists(obj_interpretador)) { _posso_clicar = true; }
if(instance_exists(obj_interpretador))
{
	if(!obj_interpretador.nomeando_pocao) { _posso_clicar = true; }
}

//usando teclas
//debug
if(_b) { global.debug = !global.debug; }

//resetando o jogo
if(_r && _posso_clicar) { game_restart(); }

//TESTANDO OS INVENTARIOS
//verificando se existe o item 1 (lagrima) no inventario
if(_6)
{
	VerificaIngrediente(6);
}

//testes de Int com valor
if(_0)
{
	/*
	int +4 + int +4 → junta
	*/
	if(instance_exists(obj_bolsa))
	{
		with(obj_bolsa)
		{
			AdicionaInventario(obj_bolsa, INGREDIENTE_INT, 4);
			alarm[0] = 60;
		}
	}
	else
	{
		msg_erro("Bolsa");
	}
}
if(_9)
{
	/*
	int +4 + int -3 → separa
	*/
	if(instance_exists(obj_bolsa))
	{
		with(obj_bolsa)
		{
			AdicionaInventario(obj_bolsa, INGREDIENTE_INT, 4);
			alarm[1] = 60;
		}
	}
	else
	{
		msg_erro("Bolsa");
	}
}

if(_posso_clicar)
{
	if(_enter)
	{
		PreencheBolsa();
	}
	if(_backspace)
	{
		if(instance_exists(obj_bolsa) && instance_exists(obj_caldeirao))
		{
			LimpaCaldeirao();
		}
		else
		{
			show_debug_message("Caldeirão e/ou Bolsa não encontrados!");
		}
	}
	if(_space)
	{
		if(room != rm_inventarios) { room_goto(rm_inventarios); }
	}
}

//if(!instance_exists(obj_caldeirao) || !instance_exists(obj_bolsa)) { exit; }

if(room == rm_inventarios)
{
// =====================================================
// CLIQUE NOS BOTÕES
// =====================================================

// posição do mouse na GUI
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);


// só executa quando clicar
if(mouse_check_button_pressed(mb_left))
{
	for(var i = 0; i < botoes_qtd; i++)
	{
		var _bx = botao_x + i * (botao_largura + botao_espaco);
		var _by = botao_y;

		// verificando se o mouse está sobre o botão
		if(point_in_rectangle(
			_mx,
			_my,
			_bx,
			_by,
			_bx + botao_largura,
			_by + botao_altura
		))
		{
			switch(i)
			{
				// =========================================
				// BOTÃO 0 - RESET
				// =========================================
				case 0:
					game_restart();
				break;

				// =========================================
				// BOTÃO 1 - INT +4 + ALARME 0
				// =========================================
				case 1:
				with(obj_bolsa)
				{
					AdicionaInventario(
						obj_bolsa,
						INGREDIENTE_INT,
						4
					);

					alarm[0] = 60;
				}
				break;

				// =========================================
				// BOTÃO 2 - INT +4 + ALARME 1
				// =========================================
				case 2:
				with(obj_bolsa)
				{
					AdicionaInventario(
						obj_bolsa,
						INGREDIENTE_INT,
						4
					);

					alarm[1] = 60;
				}
				break;

				// =========================================
				// BOTÃO 3 - ADICIONAR ITENS
				// =========================================
				case 3:
					PreencheBolsa();
				break;

				// =========================================
				// BOTÃO 4 - LIMPAR CALDEIRÃO
				// =========================================
				case 4:
					LimpaCaldeirao();
				break;
			}
		}
	}
}

// =====================================================
// CLIQUE NO BOTÃO "EXPLORAR MASMORRA"
// =====================================================

var _mx_masmorra = device_mouse_x_to_gui(0);
	var _my_masmorra = device_mouse_y_to_gui(0);

	var _x_masmorra = botao_masmorra_margem;

	var _y_masmorra = display_get_gui_height()
		- botao_masmorra_altura
		- botao_masmorra_margem;

	if(
		mouse_check_button_pressed(mb_left)
		&& point_in_rectangle(
			_mx_masmorra,
			_my_masmorra,
			_x_masmorra,
			_y_masmorra,
			_x_masmorra + botao_masmorra_largura,
			_y_masmorra + botao_masmorra_altura
		)
	)
	{
		VaiParaMasmorra(rm_masmorra);
	}
	
}