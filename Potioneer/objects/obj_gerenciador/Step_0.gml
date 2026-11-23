#region iniciando variáveis
var _p, _b, _r, _0, _9, _8, _7, _6, _5, _4, _3, _2, _1, _m;

_b = keyboard_check_pressed(ord("B"));
_r = keyboard_check_pressed(ord("R"));
_p = keyboard_check_pressed(ord("P"));
_m = keyboard_check_pressed(ord("M"));
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
var _menos = keyboard_check_pressed(vk_subtract) || keyboard_check_pressed(ord("-"));

var _posso_clicar = false;
#endregion

if(!instance_exists(obj_interpretador)) { _posso_clicar = true; }

if(instance_exists(obj_interpretador))
{
	if(!obj_interpretador.personalizando_pocao) { _posso_clicar = true; }
}

#region debug
//usando teclas

//if(_b) { global.debug = !global.debug; }

//resetando o jogo

//if(_r && _posso_clicar) { room_restart(); }

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
	int +4 + int +4 -> junta
	*/
	if(instance_exists(obj_bolsa))
	{
		with(obj_bolsa)
		{
			//AdicionaInventario(obj_bolsa, INGREDIENTE_INT, 4);
			//alarm[0] = 60;
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
	int +4 + int -3 -> separa
	*/
	if(instance_exists(obj_bolsa))
	{
		with(obj_bolsa)
		{
			//AdicionaInventario(obj_bolsa, INGREDIENTE_INT, 4);
			//alarm[1] = 60;
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
		//PreencheBolsa();
	}
	if(_backspace)
	{
		if(instance_exists(obj_bolsa) && instance_exists(obj_caldeirao))
		{
			//LimpaCaldeirao();
		}
		else
		{
			show_debug_message("Caldeirão e/ou Bolsa não encontrados!");
		}
	}
	if(_menos)
	{
		//if(room != rm_inventarios) { room_goto(rm_inventarios); }
	}
}

//if(!instance_exists(obj_caldeirao) || !instance_exists(obj_bolsa)) { exit; }

if(room == rm_inventarios)
{
	//CRIANDO 5 POÇÕES TESTE
	if(_m && CaldeiraoVazio())
	{
		//CriaPocoesTeste();
	}
	
	//CLIQUE NOS BOTÕES
	//posição do mouse na GUI
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	//só executa quando clicar
	if(mouse_check_button_pressed(mb_left))
	{
		for(var i = 0; i < botoes_qtd; i++)
		{
			var _bx = botao_x + i * (botao_largura + botao_espaco);
			var _by = botao_y;

			//verificando se o mouse está sobre o botão
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
					//BOTÃO 0 - RESET
					case 0:
					{
						//game_restart();
						break;
					}
					
					//BOTÃO 1 - INT +4 + ALARME 0
					case 1:
					{
						with(obj_bolsa)
						{
							//AdicionaInventario(obj_bolsa,INGREDIENTE_INT,4);
							//alarm[0] = 60;
						}
						break;
					}
					
					//BOTÃO 2 - INT +4 + ALARME 1
					case 2:
					{
						with(obj_bolsa)
						{
							//AdicionaInventario(obj_bolsa,INGREDIENTE_INT,4);
							//alarm[1] = 60;
						}
						break;
					}

					//BOTÃO 3 - ADICIONAR ITENS
					case 3:
					{
						//PreencheBolsa();
						break;
					}

					//BOTÃO 4 - LIMPAR CALDEIRÃO
					case 4:
					{
						//LimpaCaldeirao();
						break;
					}
				}
			}
		}
	}
}
#endregion

//BOTÃO COMO JOGAR
if(room == rm_armario || room == rm_inventarios || room == rm_masmorra)
{
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	
	var _botao_raio = 16;
	var _margem = 32;
	
	var _x = RES_W - _margem;
	var _y = _margem;
	
	var _click_esq = mouse_check_button_pressed(mb_left);

	var _hover = point_in_circle(
		_mx,
		_my,
		_x,
		_y,
		_botao_raio
	);
	
	//se to com o cursor no lugar certo
	//se cliquei com o esquerdo
	//ou cliquei P
	if((_hover && _click_esq) || _p)
	{
		//se não existe o "como jogar"
		if(!instance_exists(obj_tutorial))
		{
			//se não existe o interpretador
			if(!instance_exists(obj_interpretador))
			{
				//crio o "como jogar"
				instance_create_layer(0,0,"UI",obj_tutorial);
			}
			//se existe o interpretador
			//mas não to personalizando a poção
			else if(!obj_interpretador.personalizando_pocao)
			{
				//crio o "como jogar"
				instance_create_layer(0,0,"UI",obj_tutorial);
			}
		}
		else
		{
			with(obj_tutorial)
			{
				instance_destroy();
			}
		}
	}
}

if(global.pause) { exit; }

//OUTROS BOTÕES
if(room == rm_armario || room == rm_inventarios)
{
	//VAI PRA MASMORRA
	var _x =
		RES_W
		- botao_largura
		- botao_margem;

	var _y =
		RES_H
		- botao_altura
		- botao_margem;

	//posição do mouse na GUI
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);

	if(room == rm_armario)
	{
		//clique
		if(
			mouse_check_button_pressed(mb_left)
			&& point_in_rectangle(
				_mx,
				_my,
				_x,
				_y,
				_x + botao_largura,
				_y + botao_altura
			)
		)
		{
			aplica_transicao(rm_masmorra);
			//room_goto(rm_masmorra);
		}
	}
	

	//POSIÇÃO ESPECIAL NA SALA DE INVENTÁRIOS
	if(room == rm_inventarios)
	{
	 _x =
	 2 * botao_margem + botao_largura;

	 _y =
	 RES_H
	 - botao_altura
	 - botao_margem;
		
		//VERIFICA CLIQUE
		if(
		 device_mouse_check_button_pressed(0, mb_left)
		 && point_in_rectangle(
		 _mx,
		 _my,
		 _x,
		 _y,
		 _x + botao_largura,
		 _y + botao_altura
		 )
		)
		{
			DevolveItens();
			
		 aplica_transicao(rm_masmorra);
		}
	}
	
	//VOLTA PRO MENU
	_x = 3 * botao_margem + botao_largura * 2;
	_y = RES_H - botao_altura - botao_margem;

	//POSIÇÃO ESPECIAL NA SALA DE INVENTÁRIOS
	if(room == rm_armario)
	{
	 _x =
			RES_W
			- botao_largura * 2
			- botao_margem * 2;

		_y =
			RES_H
			- botao_altura
			- botao_margem;
	}
	
	//VERIFICA CLIQUE
	if(
		device_mouse_check_button_pressed(0, mb_left)
		&& point_in_rectangle(
			_mx,
			_my,
			_x,
			_y,
			_x + botao_largura,
			_y + botao_altura
		)
	)
	{
		DevolveItens();
		
		//room_goto(rm_menu);
		
		aplica_transicao(rm_menu);
	}
}

//INVERTE ARMARIO x CRIAÇÃO DE POÇÕES
if(room != rm_inicio && room != rm_masmorra)
{
	//CLIQUE NO BOTÃO ARMARIO / CALDEIRAO
	var _mx_armario = device_mouse_x_to_gui(0);
	var _my_armario = device_mouse_y_to_gui(0);

	var _x_armario = botao_margem;

	var _y_armario = RES_H
		- botao_altura
		- botao_margem;

	if(
		mouse_check_button_pressed(mb_left)
		&& point_in_rectangle(
			_mx_armario,
			_my_armario,
			_x_armario,
			_y_armario,
			_x_armario + botao_largura,
			_y_armario + botao_altura
		)
	)
	{
		if(room == rm_inventarios) { DevolveItens(); aplica_transicao(rm_armario); }
		if(room == rm_armario) { /*room_goto(rm_inventarios);*/ aplica_transicao(rm_inventarios); }
	}
}