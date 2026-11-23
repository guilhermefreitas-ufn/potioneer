//procurando o caldeirão caso ainda não tenha sido encontrado
if(!instance_exists(caldeirao))
{
	caldeirao = instance_find(obj_caldeirao, 0);
}

//se não tem caldeirão na room, não executo nada
if(caldeirao == noone)
{
	exit;
}

//DIGITAÇÃO DO NOME DA POÇÃO
if(personalizando_pocao)
{
	keyboard_string =
		string_copy(
			keyboard_string,
			1,
			nome_pocao_max
		);
	
	nome_pocao = keyboard_string;
	
	//SELEÇÃO DA COR DA POÇÃO
	if(mouse_check_button_pressed(mb_left))
	{
		var _mx_gui = device_mouse_x_to_gui(0);
		var _my_gui = device_mouse_y_to_gui(0);
		
		for(var i = 0; i < array_length(paleta_cores); i++)
		{
			var _ret = RetanguloCorPocao(i);
			
			if(point_in_rectangle(
					_mx_gui,
					_my_gui,
					_ret[0],
					_ret[1],
					_ret[2],
					_ret[3]
				)
			)
			{
				indice_cor_selecionada = i;
				
				cor_nova_pocao = paleta_cores[i].valor;
				
				break;
			}
		}
	}
	
	//SELEÇÃO DO SPRITE DA POÇÃO
	//SÓ PERMITE ESCOLHER SE EXISTIR MAIS DE UMA OPÇÃO
	if(
		array_length(opcoes_sprites_pocao) > 1
		&& mouse_check_button_pressed(mb_left)
	)
	{
		var _mx_gui = device_mouse_x_to_gui(0);
		var _my_gui = device_mouse_y_to_gui(0);
		
		for(var i = 0; i < array_length(opcoes_sprites_pocao); i++)
		{
			var _ret = RetanguloSpritePocao(i);
			
			if(point_in_rectangle(
					_mx_gui,
					_my_gui,
					_ret[0],
					_ret[1],
					_ret[2],
					_ret[3]
				)
			)
			{
				indice_sprite_selecionado = i;
				
				sprite_nova_pocao =
				opcoes_sprites_pocao[i].sprite;
				
				break;
			}
		}
	}
	
	//ENTER
	if(keyboard_check_pressed(vk_enter))
	{
		var _nome =
			string_trim(nome_pocao);
		
		if(_nome != "")
		{
			if(PocaoNomeExiste(_nome))
			{
				mensagem = "Nome de poção já usado!";
				mensagem_timer = mensagem_duracao;
				return;
			}
	
	
			AdicionaPocaoArmario(
				_nome,
				algoritmo,
				sentenca,
				cor_nova_pocao,
				sprite_nova_pocao
			);
	
			ConsomeCaldeirao(caldeirao);
			
			//Explosão de estrelas centralizada na boca do caldeirão
		    criar_efeito(obj_caldeirao.x, obj_caldeirao.y, "explosao_estrelas", cor_nova_pocao, {
		        qtd: 100,
		        cores: [cor_nova_pocao]
		    });
	
			personalizando_pocao = false;
			nome_pocao = "";
			keyboard_string = "";
	
			mensagem = "Poção criada com sucesso!";
			mensagem_timer = mensagem_duracao;
		}
	}
	
	//ESC
	if(keyboard_check_pressed(vk_escape))
	{
		personalizando_pocao = false;
		nome_pocao = "";
		keyboard_string = "";
	}
	
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

//MENSAGEM
if(mensagem_timer > 0)
{
	mensagem_timer--;
}

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _x = RES_W
		- botao_criar_largura
		- botao_criar_margem;

var _y = RES_H
		- botao_criar_altura
		- botao_criar_margem;

if(global.pause) { exit; }

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
	&& !CaldeiraoVazio()
)
{
	CriarPocao();
}