switch (etapa)
{
    case "voando":
    {
		//girando
		if(rotacao > 0) { rotacao -= 45; }
		else { rotacao = 360; }
		
		//desenho
        if (sprite_pocao >= 0)
        {
            // Posiciona o centro do sprite em x, y,
            // independentemente da origem configurada.
            var _draw_x =
                x
                + sprite_get_xoffset(sprite_pocao)
                - sprite_get_width(sprite_pocao) / 2;

            var _draw_y =
                y
                + sprite_get_yoffset(sprite_pocao)
                - sprite_get_height(sprite_pocao) / 2;


            draw_sprite_ext(
			    sprite_pocao,
			    0,
			    _draw_x,
			    _draw_y,
			    escala_x,   
			    escala_y,   
			    rotacao,    
			    cor_pocao,  
			    1           
			);
        }

        break;
	}

    
    case "area":
    {

        var _fracao = clamp(
            tempo_area / max(1, duracao_area),
            0,
            1
        );

        var _alpha = ALPHA_AREA_EFEITO_POCAO * _fracao;

        draw_set_colour(cor_pocao);
        draw_set_alpha(_alpha);
        
        draw_circle(
            x,
            y,
            raio_efeito,
            false // false = círculo preenchido
        );

        // Restaura as configurações de desenho
        draw_set_alpha(1);
        draw_set_colour(c_white);

        break;
	}
}