switch (etapa)
{
    
    case "voando":
    

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
			    1,          // Escala horizontal
			    1,          // Escala vertical
			    0,          // Rotação
			    cor_pocao,  // Cor de tonalização
			    1           // Opacidade
			);
        }

        break;


    
    case "area":
    

        var _fracao = clamp(
            tempo_area / max(1, duracao_area),
            0,
            1
        );

        var _alpha =
            ALPHA_AREA_EFEITO_POCAO * _fracao;


        draw_set_colour(cor_pocao);
        draw_set_alpha(_alpha);

        // false = círculo preenchido
        draw_circle(
            x,
            y,
            raio_efeito,
            false
        );


        // Restaura as configurações de desenho
        draw_set_alpha(1);
        draw_set_colour(c_white);

        break;
}