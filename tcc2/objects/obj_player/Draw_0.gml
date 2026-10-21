//Inherit the parent event
event_inherited();

if(room == rm_masmorra)
{
    //Calcula a posição permitida para a área
    var _alvo = PosicaoAlvoPocao(
        mouse_x,
        mouse_y
    );

    if(mostrar_area)
    {
        //Área da poção: tamanho permanece fixo
        draw_circle(
            _alvo[0],
            _alvo[1],
            raio_teste,
            true
        );
		
		//ALCANCE MÁXIMO DO PLAYER
		var _centro = CentroPlayer();

		draw_set_colour(c_white);
		draw_set_alpha(0.2);

		draw_circle(
		    _centro[0],
		    _centro[1],
		    AlcancePocao(),
		    true
		);

		draw_set_alpha(1);
		draw_set_colour(c_white);
    }

    define_align();
    draw_set_alpha(.33);
    draw_set_font(fnt_placeholder_pequena);

    draw_text(
        _alvo[0],
        _alvo[1],
        "Área da poção."
    );

    draw_set_alpha(1);
    reseta_draw();
}