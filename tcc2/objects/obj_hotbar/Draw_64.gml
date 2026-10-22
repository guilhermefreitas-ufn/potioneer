draw_set_font(fonte);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

//MOUSE EM COORDENADAS GUI
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _slot_hover = SlotSobreMouse(_mx, _my);

//HOTBAR
for(var i = 0; i < SLOTS_HOTBAR_POCOES; i++)
{
    var _pos = PosicaoSlot(i);

    var _pocao = global.DadosJogador.hotbar_pocoes[i];

    var _cx = _pos[0] + largura_slot / 2;
    var _cy = _pos[1] + altura_slot / 2;

    //SLOT
    draw_sprite_ext(
        sprite_meu_slot,
        _slot_hover == i,
        _pos[0],
        _pos[1],
        escala_slot,
        escala_slot,
        0,
        c_white,
        1
    );

    //POÇÃO
    if(!is_undefined(_pocao))
    {
		var _alpha_pocao = 1;

		if(_pocao.cooldown > 0)
		{
		    _alpha_pocao = 0.35;
		}
		
        if(!is_undefined(_pocao.sprite))
        {
            draw_sprite_ext(
                _pocao.sprite,
                0,
                _cx,
                _cy,
                escala_slot,
                escala_slot,
                0,
                _pocao.cor,
                _alpha_pocao
            );
        }
        else
        {
            draw_set_colour(_pocao.cor);
			draw_set_alpha(_alpha_pocao);
			
            draw_circle(
                _cx,
                _cy,
                slot_tam / 2,
                true
            );

            draw_set_colour(c_white);
			draw_set_alpha(1);
        }
		
		// RELÓGIO DO COOLDOWN
		if(_pocao.cooldown > 0)
		{
		    var _cooldown_max = max(
		        1,
		        round(GAME_SPEED * SEGUNDOS_COOLDOWN_POCAO)
		    );

		    // Fração do tempo que ainda resta
		    var _fracao = clamp(
		        _pocao.cooldown / _cooldown_max,
		        0,
		        1
		    );

		    // Posição e tamanho do relógio
		    var _raio_relogio = max(
		        4,
		        floor(slot_tam * 0.16)
		    );

		    var _centro_x = _pos[0]
		        + slot_tam
		        - _raio_relogio
		        - 2;

		    var _centro_y = _pos[1]
		        + _raio_relogio
		        + 2;

		    // Fundo escuro do relógio
		    draw_set_alpha(0.9);
		    draw_set_color(c_black);

		    draw_circle(
		        _centro_x,
		        _centro_y,
		        _raio_relogio + 1,
		        false
		    );

		    // Calcula o fim do setor conforme
		    // a fração do cooldown que ainda resta
		    var _angulo_final = (
		        90 + 359.8 * _fracao
		    ) % 360;

		    var _x_final = _centro_x
		        + lengthdir_x(
		            _raio_relogio,
		            _angulo_final
		        );

		    var _y_final = _centro_y
		        + lengthdir_y(
		            _raio_relogio,
		            _angulo_final
		        );

		    // Desenha o setor restante
		    draw_set_color(c_white);

		    draw_pie(
		        _centro_x - _raio_relogio,
		        _centro_y - _raio_relogio,
		        _centro_x + _raio_relogio,
		        _centro_y + _raio_relogio,

		        _centro_x,
		        _centro_y - _raio_relogio,

		        _x_final,
		        _y_final,

		        false,
		        24
		    );

		    // Restaura o estado de desenho
		    draw_set_alpha(1);
		    draw_set_color(c_white);
		}

        //NOME DA POÇÃO
        define_align(1, 0);
        draw_set_font(fonte);

        draw_text_outline(
            _cx,
            _pos[1] + altura_slot + 2,
            _pocao.nome,
            c_white,
            c_black,
            1,
            1,
            1,
            0,
            largura_slot + 20,
            -1
        );
    }

    //NÚMERO DA TECLA
    draw_set_font(fonte);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_colour(c_black);
    draw_circle(
        _cx,
        _pos[1] - 12,
        12,
        false
    );

    draw_set_colour(c_white);

    draw_text_transformed(
        _cx,
        _pos[1] - 22,
        string(i + 1),
        2,
        2,
        0
    );
}

//DESCRIÇÃO
draw_set_font(fonte);
define_align(0, 0);

if(_slot_hover != -1)
{
    var _pocao = global.DadosJogador.hotbar_pocoes[_slot_hover];

    if(!is_undefined(_pocao))
    {
        var _x_desc = (RES_W + largura_hotbar) / 2 + 20;
        var _y_desc = RES_H - altura_hotbar - margem_inferior;

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

        //DESCRIÇÃO
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