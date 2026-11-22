if(room == rm_masmorra)
{
	//draw_text(RES_W / 2, 200, string(instance_number(obj_sombra)));
	
	//POSIÇÃO DO ALVO NO MUNDO
	var _alvo = PosicaoAlvoPocao(
		mouse_x,
		mouse_y
	);
	
	//CONVERTE ALVO PARA GUI
	var _pos_alvo = MundoParaGUI(
		_alvo[0],
		_alvo[1]
	);
	
	if(!is_undefined(_pos_alvo))
	{
		if(mostrar_area)
		{
			//ÁREA DA POÇÃO
			var _raio_x = raio_pocao * _pos_alvo.escala_x;
			var _raio_y = raio_pocao * _pos_alvo.escala_y;
			
			draw_set_colour(c_white);
			draw_set_alpha(alpha_area);
			
			draw_ellipse(
				_pos_alvo.x - _raio_x,
				_pos_alvo.y - _raio_y,
				_pos_alvo.x + _raio_x,
				_pos_alvo.y + _raio_y,
				true
			);
			
			//ALCANCE MÁXIMO DO PLAYER
			var _centro = Centro();
			
			var _pos_centro = MundoParaGUI(
				_centro[0],
				_centro[1]
			);
			
			if(!is_undefined(_pos_centro))
			{
				var _alcance = AlcancePocao();
				
				var _alcance_x = _alcance * _pos_centro.escala_x;
				var _alcance_y = _alcance * _pos_centro.escala_y;
				
				draw_set_colour(cor_alcance);
				draw_set_alpha(alpha_alcance);
				
				draw_ellipse(
					_pos_centro.x - _alcance_x,
					_pos_centro.y - _alcance_y,
					_pos_centro.x + _alcance_x,
					_pos_centro.y + _alcance_y,
					true
				);
			}
			
			draw_set_alpha(1);
			draw_set_colour(c_white);
		}
		
		//DESCRIÇÃO
		define_align();
		
		draw_set_alpha(alpha_descricao_area);
		draw_set_font(fnt_placeholder_pequena);
		
		draw_text(
			_pos_alvo.x,
			_pos_alvo.y,
			"ÁREA DA POÇÃO"
		);
		
		draw_set_alpha(1);
		reseta_draw();
	}
}