draw_set_font(fonte);
draw_set_halign(fa_center);
draw_set_valign(fa_top);

//MOUSE EM COORDENADAS GUI
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _slot_hover = SlotSobreMouse(_mx, _my);

//SLOT SELECIONADO
var _slot_selecionado = -1;

if(
    room == rm_masmorra
    && instance_exists(obj_player)
)
{
    var _player = instance_find(
        obj_player,
        0
    );

    if(_player != noone)
    {
        _slot_selecionado =
            _player.pocao_selecionada;
    }
}

//OBJETOS QUE PODEM DEIXAR A HOTBAR TRANSLÚCIDA
var _objetos_sob_hotbar = [
    obj_player,
	obj_saida
];

//VARIÁVEIS
var _objeto_sob_hotbar = false;
var _alpha_hotbar = 1;

//HOTBAR EM COORDENADAS GUI
var _hotbar_left =
    (RES_W - largura_hotbar) / 2;

var _hotbar_right =
    _hotbar_left + largura_hotbar;

var _hotbar_top =
    RES_H - altura_hotbar - margem_inferior;

var _hotbar_bottom =
    _hotbar_top + altura_hotbar;


//VERIFICA OBJETOS SOB A HOTBAR
if(room == rm_masmorra)
{
    for(var i = 0; i < array_length(_objetos_sob_hotbar); i++)
    {
        var _obj = _objetos_sob_hotbar[i];

        //QUANTIDADE DE INSTÂNCIAS DESSE OBJETO
        var _quantidade = instance_number(_obj);

        for(var j = 0; j < _quantidade; j++)
        {
            var _inst = instance_find(_obj, j);

            if(_inst == noone) continue;

            //CONVERTE OS CANTOS DA BBOX PARA GUI
            var _pos_sup_esq = MundoParaGUI(
                _inst.bbox_left,
                _inst.bbox_top
            );

            var _pos_inf_dir = MundoParaGUI(
                _inst.bbox_right,
                _inst.bbox_bottom
            );

            if(
                is_undefined(_pos_sup_esq)
                || is_undefined(_pos_inf_dir)
            ) continue;

            //POSIÇÃO DO OBJETO EM GUI
            var _left = _pos_sup_esq.x;
            var _right = _pos_inf_dir.x;

            var _top = _pos_sup_esq.y;
            var _bottom = _pos_inf_dir.y;

            //VERIFICA SOBREPOSIÇÃO
            if(
                _right > _hotbar_left
                && _left < _hotbar_right
                && _bottom > _hotbar_top
                && _top < _hotbar_bottom
            )
            {
                _objeto_sob_hotbar = true;
                break;
            }
        }

        //JÁ ENCONTROU UM OBJETO SOBRE A HOTBAR
        if(_objeto_sob_hotbar) break;
    }
}

//ALPHA DA HOTBAR
_alpha_hotbar = _objeto_sob_hotbar
    ? alpha_player_em_mim
    : 1;

//HOTBAR
for(var i = 0; i < SLOTS_HOTBAR_POCOES; i++)
{
    var _pos = PosicaoSlot(i);

    var _pocao = global.DadosJogador.hotbar_pocoes[i];

    var _cx = _pos[0] + largura_slot / 2;
    var _cy = _pos[1] + altura_slot / 2;

    //SLOT
	var _frame_slot = 0;

	//Slot selecionado ou sob o mouse
	if(
	    i == _slot_selecionado
	    || i == _slot_hover
	)
	{
	    _frame_slot = 1;
	}

	draw_sprite_ext(
	    sprite_meu_slot,
	    _frame_slot,
	    _pos[0],
	    _pos[1],
	    escala_slot,
	    escala_slot,
	    0,
	    c_white,
	    _alpha_hotbar
	);

    //POÇÃO
    if(!is_undefined(_pocao))
    {
		var _frasco = noone;
		
		switch(_pocao.sprite)
		{
			case spr_pocao:
			{
				_frasco = spr_pocao_borda;
				
				break;
			}
			case spr_pocao_quadrada:
			{
				_frasco = spr_pocao_quadrada_borda;
				
				break;
			}
			default:
			{
				_frasco = spr_pocao_borda;
				
				break;
			}
		}
		
		var _alpha_pocao = _alpha_hotbar;

		if(_pocao.cooldown > 0)
		{
		    _alpha_pocao *= alpha_player_em_mim;
		}
		
        if(!is_undefined(_pocao.sprite))
        {
			//poção com conteúdo colorido
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
			
			//frasco branco
			if(i != _slot_selecionado && i != _slot_hover)
			{
				draw_sprite_ext(
				    _frasco,
				    0,
				    _cx,
				    _cy,
				    escala_slot,
				    escala_slot,
				    0,
				    c_white,
				    _alpha_pocao
				);
			}
        }
		//se não tenho sprite
        else
        {
			//placeholder
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
		
		//RELÓGIO DO COOLDOWN
		if(_pocao.cooldown > 0)
		{
		    var _cooldown_max = max(
		        1,
		        round(GAME_SPEED * SEGUNDOS_COOLDOWN_POCAO)
		    );

		    //Fração do tempo que ainda resta
		    var _fracao = clamp(
		        _pocao.cooldown / _cooldown_max,
		        0,
		        1
		    );

		    //Posição e tamanho do relógio
		    //var _raio_relogio = max(
		    //   4,
		    //   floor(slot_tam * 0.16)
		    //);
			
			var _raio_relogio = 8;

		    //var _centro_x = _pos[0]
		    //   + slot_tam
		    //   - _raio_relogio
		    //   - 2;
			//
		    //var _centro_y = _pos[1]
		    //   + _raio_relogio
		    //   + 2;
			
			var _centro_x = _pos[0];
			var _centro_y = _pos[1];
			
		    //Fundo escuro do relógio
		    draw_set_alpha(0.9 * _alpha_hotbar);
			
		    //draw_set_color(c_black);
		    draw_set_color(c_white);

		    draw_circle(
		        _centro_x,
		        _centro_y,
		        _raio_relogio + 2,
		        false
		    );

		    //Calcula o fim do setor conforme
		    //a fração do cooldown que ainda resta
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

		    //Desenha o setor restante
		    //draw_set_color(c_white);
		    draw_set_color(c_black);

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

		    //Restaura o estado de desenho
		    draw_set_alpha(1);
		    draw_set_color(c_white);
		}

        //NOME DA POÇÃO
        define_align(1, 0);
        draw_set_font(fonte);
		draw_set_alpha(_alpha_hotbar);

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
	
	draw_set_alpha(_alpha_hotbar);
    //NÚMERO DA TECLA
    draw_set_font(fonte);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    //draw_set_colour(c_black);
    draw_set_colour(c_white);
    draw_circle(
        _cx,
        _pos[1] - 12,
        12,
        false
    );

    draw_set_colour(c_black);

    draw_text_transformed(
        _cx,
        _pos[1] - 22,
        string(i + 1),
        2,
        2,
        0
    );
	
	reseta_draw();
}

if(room != rm_masmorra) { exit; }

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

        draw_roundrect(
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