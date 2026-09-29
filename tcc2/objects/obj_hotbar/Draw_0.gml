draw_set_font(fonte);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

var _mx = mouse_x;
var _my = mouse_y;

var _slot_hover =
	SlotSobreMouse(
		_mx,
		_my
	);

//HOTBAR
for(
	var i = 0;
	i < SLOTS_HOTBAR_POCOES;
	i++
)
{
	var _pos = PosicaoSlot(i);
	
	var _pocao = global.DadosJogador.hotbar_pocoes[i];
	
	var _cx = _pos[0] + slot_tam / 2;
	
	var _cy = _pos[1] + slot_tam / 2;
	
	//SLOT
	draw_sprite(
		sprite_meu_slot,
		_slot_hover == i,
		_pos[0],
		_pos[1]
	);
	
	//POÇÃO
	if(!is_undefined(_pocao))
	{
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
	
	//HOVER
	//if(_slot_hover == i)
	//{
	//	draw_set_colour(c_white);
	//	
	//	draw_rectangle(
	//		_pos[0],
	//		_pos[1],
	//		_pos[0] + slot_tam,
	//		_pos[1] + slot_tam,
	//		true
	//	);
	//}
	
	//NÚMERO - TECLA
	draw_set_font(fonte);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_colour(c_black);
	draw_circle(_cx, _pos[1] - 6, 6, false);
	draw_set_colour(c_white);
	draw_text(_cx, _pos[1] - 12,string(i+1));
}

//DESCRIÇÃO
draw_set_font(fonte);
define_align(0,0);

if(_slot_hover != -1)
{
	var _pocao = global.DadosJogador.hotbar_pocoes[_slot_hover];
	
	if(!is_undefined(_pocao))
	{
		var _x_desc =
			x
			+ SLOTS_HOTBAR_POCOES
				* (slot_tam + entre_slots)
			+ 20;
		
		var _y_desc = y;
		
		var _largura_desc = 260;
		
		if(instance_exists(obj_armario))
		{
			with(obj_armario)
			{
				_x_desc = x + colunas * (slot_tam + entre_slots) + 30;
				
				_y_desc = y;
				
				var _altura_desc =
					string_height_ext(
						_pocao.sentenca,
						-1,
						_largura_desc
				) + 50;
			}
		}
		else
		{
			msg_erro("Armário");
		}
		
		draw_set_colour(c_black);
		
		draw_rectangle(
			_x_desc - 10,
			_y_desc - 10,
			_x_desc + _largura_desc + 10,
			_y_desc + 110,
			false
		);
		
		draw_set_colour(c_white);
		
		draw_text(
			_x_desc,
			_y_desc,
			_pocao.nome
		);
		
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