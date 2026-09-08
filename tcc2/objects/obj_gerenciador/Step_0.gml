//iniciando variáveis
var _b, _r, _0, _9, _8, _7;

_b = keyboard_check_pressed(ord("B"));
_r = keyboard_check_pressed(ord("R"));
_0 = keyboard_check_pressed(vk_numpad0) || keyboard_check_pressed(ord("0"));
_9 = keyboard_check_pressed(vk_numpad9) || keyboard_check_pressed(ord("9"));
_8 = keyboard_check_pressed(vk_numpad8) || keyboard_check_pressed(ord("8"));
_7 = keyboard_check_pressed(vk_numpad7) || keyboard_check_pressed(ord("7"));
var _enter = keyboard_check_pressed(vk_enter);
var _backspace = keyboard_check_pressed(vk_backspace);

//usando teclas
//debug
if(_b) { global.debug = !global.debug; }

//trocando de room
var _nova_room = noone;

switch(room)
{
	case rm_inventarios:{ _nova_room = rm_teste; break; }
	case rm_teste:		{ _nova_room = rm_inventarios; break; }
}

//if(_r) { room_goto(_nova_room); }

//resetando o jogo
if(_r) { game_restart(); }

//testes de Int com valor
if(_0)
{
	/*
	int +4 + int +4 → junta
	*/
	AdicionaInventario(obj_bolsa, INGREDIENTE_INT, 4);
	alarm[0] = 60;
}
if(_9)
{
	/*
	int +4 + int -3 → separa
	*/
	
	AdicionaInventario(obj_bolsa, INGREDIENTE_INT, 4);
	alarm[1] = 60;
}
if(_enter)
{
	
	with(obj_bolsa){
		//adicionando itens 0 e 13 no inventario
		//AdicionaInventario(id,irandom(13));
		for(var i = 0; i <= 13; i++)
		{
			for(var j = 0; j < 10; j++)
			{
				AdicionaInventario(id,i);
			}
		}
	}
}
if(_backspace)
	{
		LimpaCaldeirao();
	}
	
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
					with(obj_bolsa)
					{
						for(var j = 0; j <= 13; j++)
						{
							for(var k = 0; k < 10; k++)
							{
								AdicionaInventario(id, j);
							}
						}
					}
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