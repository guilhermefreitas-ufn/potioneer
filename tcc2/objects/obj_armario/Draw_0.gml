draw_set_font(fonte);

var _mx = mouse_x;
var _my = mouse_y;

var _slot_hover =
	SlotSobreMouse(
		_mx,
		_my
	);



//SLOTS
for(var i = 0; i < SLOTS_ARMARIO_POCOES; i++)
{
	var _pos =
		PosicaoSlot(i);
	
	
	var _cx =
		_pos[0] + slot_tam / 2;
	
	var _cy =
		_pos[1] + slot_tam / 2;
	
	//SLOT
	var _hover = (_slot_hover == i);
	
	draw_sprite(
		sprite_meu_slot,
		_hover,
		_pos[0],
		_pos[1]
	);
	
	//POÇÃO DO SLOT
	var _pocao =
		global.DadosJogador.armario_pocoes[i];
	
	
	//slot vazio
	if(is_undefined(_pocao))
	{
		continue;
	}
	
	//SPRITE
	if(!is_undefined(_pocao.sprite))
	{
		draw_sprite_ext(
			_pocao.sprite,
			0,
			_cx,
			_cy,
			1,
			1,
			0,
			_pocao.cor,
			1
		);
	}
	else
	{
		//placeholder temporário
		draw_set_colour(
			_pocao.cor
		);
		
		draw_circle(
			_cx,
			_cy,
			slot_tam / 4,
			true
		);
		
		draw_set_colour(c_white);
	}
}

//NOME POR CIMA DOS SLOTS
for(var i = 0; i < SLOTS_ARMARIO_POCOES; i++)
{
	var _pos =
		PosicaoSlot(i);
	
	var _cx =
		_pos[0] + slot_tam / 2;
	
	var _cy =
		_pos[1] + slot_tam / 2;
		
	var _pocao = global.DadosJogador.armario_pocoes[i];
	
	//slot vazio
	if(is_undefined(_pocao))
	{
		continue;
	}
	
	define_align(1,0);
	draw_set_font(fonte);
	
	//draw_set_colour(c_white);
	var _cor_texto = c_white;
	var _cor_contorno = c_black;
	
	draw_text_outline(
		_cx,
		_pos[1] + slot_tam,
		_pocao.nome,
		_cor_texto,
		_cor_contorno,
		1,
		.5,
		.5,
		0,
		slot_tam + 20,
		-1
	);
}

//DESCRIÇÃO
draw_set_font(fonte);
define_align(0,0);

if(_slot_hover != -1)
{
	var _pocao =
		global.DadosJogador.armario_pocoes[
			_slot_hover
		];
	
	if(!is_undefined(_pocao))
	{
		var _x_desc = x + colunas * (slot_tam + entre_slots) + 30;
		
		var _y_desc = y;
		
		var _largura_desc = 260;
		
		var _altura_desc =
			string_height_ext(
				_pocao.sentenca,
				-1,
				_largura_desc
			) + 50;
		
		//FUNDO
		draw_set_colour(c_black);
		
		draw_rectangle(
			_x_desc - 10,
			_y_desc - 10,
			_x_desc + _largura_desc + 10,
			_y_desc + _altura_desc,
			false
		);
		
		//NOME
		draw_set_colour(c_white);
		
		draw_text(
			_x_desc,
			_y_desc,
			_pocao.nome
		);
		
		//SENTENÇA
		draw_text_ext(
			_x_desc,
			_y_desc + 24,
			_pocao.sentenca,
			-1,
			_largura_desc
		);
	}
}

reseta_draw();