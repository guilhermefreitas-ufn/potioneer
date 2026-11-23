var _qtd_estrelas = array_length(estrelas);
if(_qtd_estrelas > 0)
{
    var _tem_sprite = sprite_exists(spr_estrela);
    var _old_alpha = draw_get_alpha();

    gpu_set_blendmode(bm_add);

    for (var i = 0; i < _qtd_estrelas; i++)
    {
        var _s = estrelas[i];
        var _giro_x = cos(_s.fase); //Oscila entre +1 e -1 (efeito moeda girando)

        if(_tem_sprite)
        {
            draw_sprite_ext(
                spr_estrela, 0,
                _s.x, _s.y,
                _s.escala * _giro_x,
                _s.escala,
                _s.angulo,
                _s.cor,
                _s.alpha
            );
        }
        else
        {
            //Desenha estrela de 4 pontas com giro 3D caso não haja sprite
            draw_set_alpha(_s.alpha);
            draw_primitive_begin(pr_trianglefan);
            draw_vertex_color(_s.x, _s.y, c_white, _s.alpha); //Miolo brilhante

            var _r_ext = 13 * _s.escala;
            var _r_int = 4.5 * _s.escala;
            var _cos_a = dcos(_s.angulo);
            var _sin_a = dsin(_s.angulo);

            for (var v = 0; v <= 8; v++)
            {
                var _idx = v mod 8;
                var _rad = (_idx mod 2 == 0) ? _r_ext : _r_int;
                var _ang_v = _idx * 45;

                //Aplica o achatamento do giro 3D no eixo X local antes de rotacionar
                var _lx = dcos(_ang_v) * _rad * _giro_x;
                var _ly = dsin(_ang_v) * _rad;

                var _vx = _s.x + (_lx * _cos_a + _ly * _sin_a);
                var _vy = _s.y + (-_lx * _sin_a + _ly * _cos_a);

                draw_vertex_color(_vx, _vy, _s.cor, _s.alpha);
            }
            draw_primitive_end();
        }
    }

    gpu_set_blendmode(bm_normal);
    draw_set_alpha(_old_alpha);
}