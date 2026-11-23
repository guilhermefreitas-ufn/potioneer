// Mantém poeira e splash da poção sempre atrás de todas as entidades em movimento
if (part_particles_count(ps_poeira) > 0)
{
    atualizar_depth_chao();
}

//1. Screenshake
if(shake_forca > 0.2)
{
    view_xport[0] = random_range(-shake_forca, shake_forca);
    view_yport[0] = random_range(-shake_forca, shake_forca);
    shake_forca *= shake_decay;
}
else if(shake_forca > 0)
{
    shake_forca = 0;
    view_xport[0] = 0;
    view_yport[0] = 0;
}

//2. Atualização das Estrelas (Giro estilo moeda do Super Mario)
for (var i = array_length(estrelas) - 1; i >= 0; i--)
{
    var _s = estrelas[i];

    _s.x += lengthdir_x(_s.vel, _s.dir);
    _s.y += lengthdir_y(_s.vel, _s.dir);
    _s.vel *= _s.atrito;

    //Avança o giro no eixo Y (cos(_s.fase) vai achatar e espelhar no Draw)
    _s.fase += _s.vel_giro;
    _s.angulo += _s.vel_rot;

    _s.vida--;
    if(_s.vida <= _s.fade_inicio)
    {
        _s.alpha = max(0, _s.vida / _s.fade_inicio);
    }

    if(_s.vida <= 0)
    {
        array_delete(estrelas, i, 1);
    }
}

//3. Atualização dos Emissores Contínuos
for (var i = array_length(emissores) - 1; i >= 0; i--)
{
    var _em = emissores[i];

    if(!_em.ativo)
    {
        array_delete(emissores, i, 1);
        continue;
    }

    if(_em.target != noone)
    {
        if(instance_exists(_em.target))
        {
            _em.x = _em.target.x + _em.offset_x;
            _em.y = _em.target.y + _em.offset_y;
        }
        else
        {
            array_delete(emissores, i, 1);
            continue;
        }
    }

    //Atualiza o tempo de vida das bolhas registradas para evitar sobreposição
    if(_em.tipo == "bolhas_panela")
    {
        for (var b = array_length(_em.bolhas_ativas) - 1; b >= 0; b--)
        {
            _em.bolhas_ativas[b].vida--;
            if(_em.bolhas_ativas[b].vida <= 0)
            {
                array_delete(_em.bolhas_ativas, b, 1);
            }
        }
    }

    if(_em.pausado) continue;

    _em.timer--;
    if(_em.timer <= 0)
    {
        switch (_em.tipo)
        {
            case "rastro_poeira":
            {
                atualizar_depth_chao();

                var _px = _em.x + random_range(-2, 2);
                var _py = _em.y + random_range(-2, 2);
                if (_em.cor == c_white)
                    part_particles_create(ps_poeira, _px, _py, pt_poeira, _em.qtd);
                else
                    part_particles_create_color(ps_poeira, _px, _py, pt_poeira, _em.cor, _em.qtd);
            }
            break;

            case "fogo_tocha":
            {
                part_type_color3(pt_tocha, _em.cores[0], _em.cores[1], _em.cores[2]);
                part_particles_create(ps_cima, _em.x + random_range(-_em.raio, _em.raio), _em.y, pt_tocha, _em.qtd);
            }
            break;

            case "fogo_fogao":
            {
                part_type_color3(pt_fogao, _em.cores[0], _em.cores[1], _em.cores[2]);
                var _passo = 360 / _em.bicos;
                for (var j = 0; j < _em.bicos; j++)
                {
                    var _ang = (j * _passo) + random_range(-3, 3);
                    var _px = _em.x + lengthdir_x(_em.raio_anel, _ang);
                    var _py = _em.y + lengthdir_y(_em.raio_anel, _ang);

                    part_type_direction(pt_fogao, _ang, _ang, 0, 0);
                    part_type_orientation(pt_fogao, _ang, _ang, 0, 0, false);
                    part_particles_create(ps_baixo, _px, _py, pt_fogao, 1);
                }
            }
            break;

            case "bolhas_panela":
            {
                //Raio máximo em pixels que uma bolha atinge antes de estourar (~14px)
                var _raio_bolha = 14;

                repeat (_em.qtd)
                {
                    //Tenta até 12 posições aleatórias para achar um espaço livre
                    for (var _tentativa = 0; _tentativa < 12; _tentativa++)
                    {
                        var _dist = sqrt(random(1)) * _em.raio;
                        var _ang  = random(360);
                        var _bx   = _em.x + lengthdir_x(_dist, _ang);
                        var _by   = _em.y + lengthdir_y(_dist, _ang);

                        var _livre = true;
                        var _total_b = array_length(_em.bolhas_ativas);
                        for (var b = 0; b < _total_b; b++)
                        {
                            var _outra = _em.bolhas_ativas[b];
                            if(point_distance(_bx, _by, _outra.x, _outra.y) < (_raio_bolha + _outra.raio + 2))
                            {
                                _livre = false;
                                break;
                            }
                        }

                        if(_livre)
                        {
                            part_particles_create_color(ps_cima, _bx, _by, pt_bolha, _em.cor, 1);
                            array_push(_em.bolhas_ativas, {
                                x: _bx,
                                y: _by,
                                raio: _raio_bolha,
                                vida: 22
                            });
                            break;
                        }
                    }
                }
            }
            break;
			
        }

        _em.timer = _em.intervalo;
    }

    if(_em.duracao > 0)
    {
        _em.duracao--;
        if(_em.duracao <= 0)
        {
            array_delete(emissores, i, 1);
        }
    }
}