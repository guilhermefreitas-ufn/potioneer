///@function criar_efeito(x, y, effect_type, [color], [extra_data])
///@param {real} x Posição X no mundo
///@param {real} y Posição Y no mundo
///@param {string} effect_type Tipo do efeito
///@param {color|array<color>} [color] Cor única ou array de cores (ex: [c_yellow, c_orange, c_red])
///@param {struct} [extra_data] Struct opcional de configuração
function criar_efeito(_x, _y, _type, _color = undefined, _data = undefined)
{
	if(!instance_exists(obj_gerenciador_efeitos))
	{
		instance_create_depth(0, 0, -5000, obj_gerenciador_efeitos);
	}
	
	var _opt = function(_s, _key, _default)
	{
		return (_s != undefined && variable_struct_exists(_s, _key))
			? variable_struct_get(_s, _key)
			: _default;
	};
	
	//Normaliza _color para sempre retornar um array de 3 cores para os fogos
	var _resolver_cores_fogo = function(_cor_in, _padrao)
	{
		if(_cor_in == undefined) return _padrao;
		
		if(is_array(_cor_in))
		{
			var _len = array_length(_cor_in);
			if(_len >= 3) return [_cor_in[0], _cor_in[1], _cor_in[2]];
			if(_len == 2) return [_cor_in[0], _cor_in[1], _cor_in[1]];
			if(_len == 1) _cor_in = _cor_in[0];
			else return _padrao;
		}
		
		//Fallback caso passe apenas 1 cor: gera miolo claro -> cor -> ponta escura
		return [
			merge_color(c_white, _cor_in, 0.45),
			_cor_in,
			merge_color(_cor_in, c_black, 0.35)
		];
	};
	
	//Normaliza _color para efeitos de cor única (poeira e bolhas)
	var _resolver_cor_unica = function(_cor_in, _padrao)
	{
		if(_cor_in == undefined) return _padrao;
		if(is_array(_cor_in))
		{
			var _len = array_length(_cor_in);
			return (_len > 0) ? _cor_in[irandom(_len - 1)] : _padrao;
		}
		return _cor_in;
	};
	
	var _mgr = instance_find(obj_gerenciador_efeitos, 0);
	
	switch (_type)
	{
		//1. SCREENSHAKE
		case "screenshake":
		{
			var _forca = _opt(_data, "shake", 6);
			var _decay = _opt(_data, "shake_dec_spd", 0.88);
			_mgr.shake_forca = max(_mgr.shake_forca, _forca);
			_mgr.shake_decay = _decay;
			return noone;
		}
		
		//2. EXPLOSÃO DE ESTRELAS
		case "explosao_estrelas":
		{
			var _qtd = _opt(_data, "qtd", 22);
			var _paleta_padrao = [c_yellow, c_orange, c_aqua, c_fuchsia, c_lime];
			
			if(is_array(_color))
			    _paleta_padrao = _color;
			else if(_color != undefined)
			    _paleta_padrao = [_color, c_yellow, c_orange];
			
			var _cores = _opt(_data, "cores", _paleta_padrao);
			var _n_cor = array_length(_cores);
			
			repeat (_qtd)
			{
				var _base = (_n_cor > 0) ? _cores[irandom(_n_cor - 1)] : c_yellow;
				var _hue  = (color_get_hue(_base) + irandom_range(-18, 18) + 256) mod 256;
				var _sat  = clamp(color_get_saturation(_base) + irandom_range(-30, 30), 140, 255);
				var _val  = clamp(color_get_value(_base) + irandom_range(-20, 25), 210, 255);
				var _tom  = make_color_hsv(_hue, _sat, _val);
				
				var _vida = irandom_range(35, 55);
				
				array_push(_mgr.estrelas, {
					x:				_x + random_range(-6, 6),
					y:				_y + random_range(-6, 6),
					vel:			random_range(4.5, 11.5),
					dir:			random(360),
					atrito:			random_range(0.92, 0.96),
					escala:			random_range(0.45, 1.35),
					fase:			random(pi * 2),
					vel_giro:		random_range(0.18, 0.35) * choose(-1, 1),
					angulo:			random_range(-25, 25),
					vel_rot:		random_range(-2, 2),
					cor:			_tom,
					alpha:			1,
					vida:			_vida,
					fade_inicio:	floor(_vida * 0.35)
				});
			}
			return noone;
		}
		
		//3. EXPLOSÃO DE FUMAÇA
		case "explosao_fumaca":
		{
		    var _qtd         = _opt(_data, "qtd", 18);
		    var _raio_spawn  = _opt(_data, "raio_spawn", 10);
		    var _vida_min    = _opt(_data, "vida_min", 30);
		    var _vida_max    = _opt(_data, "vida_max", 48);
		    var _tam_min     = _opt(_data, "tam_min", 0.35);
		    var _tam_max     = _opt(_data, "tam_max", 0.75);
		    var _crescimento = _opt(_data, "crescimento", 0.022);
		    var _vel_min     = _opt(_data, "vel_min", 5.0);
		    var _vel_max     = _opt(_data, "vel_max", 11.0);
		
		    //Define as 3 cores da fumaça (início, meio e fim)
		    var _c1 = c_white;
		    var _c2 = c_ltgray;
		    var _c3 = c_dkgray;
		
		    if(_data != undefined && variable_struct_exists(_data, "cores"))
		    {
		        var _arr = _data.cores;
		        _c1 = _arr[0];
		        _c2 = (array_length(_arr) > 1) ? _arr[1] : _c1;
		        _c3 = (array_length(_arr) > 2) ? _arr[2] : _c2;
		    }
		    else if(is_array(_color) && array_length(_color) > 0)
		    {
		        _c1 = _color[0];
		        _c2 = (array_length(_color) > 1) ? _color[1] : _c1;
		        _c3 = (array_length(_color) > 2) ? _color[2] : _c2;
		    }
		    else if(_color != undefined && _color != c_white)
		    {
		        //Mantém a cor da poção forte e escurece levemente no final
		        _c1 = merge_color(c_white, _color, 0.80);
		        _c2 = _color;
		        _c3 = merge_color(_color, c_dkgray, 0.50);
		    }
		
		    part_type_life(_mgr.pt_fumaca, _vida_min, _vida_max);
		    part_type_size(_mgr.pt_fumaca, _tam_min, _tam_max, _crescimento, 0);
		    part_type_speed(_mgr.pt_fumaca, _vel_min, _vel_max, -0.16, 0);
		    part_type_color3(_mgr.pt_fumaca, _c1, _c2, _c3);
		
		    repeat (_qtd)
		    {
		        var _ox = random_range(-_raio_spawn, _raio_spawn);
		        var _oy = random_range(-_raio_spawn, _raio_spawn);
		        part_particles_create(_mgr.ps_cima, _x + _ox, _y + _oy, _mgr.pt_fumaca, 1);
		    }
		    return noone;
		}
		
		//4. RASTRO DE POEIRA
		case "rastro_poeira":
		{
		    var _em = {
		        ativo:          true,
		        pausado:        _opt(_data, "pausado", false),
		        persistir_room: _opt(_data, "persistir_room", false),
		        tipo:           "rastro_poeira",
		        x:              _x,
		        y:              _y,
		        target:         _opt(_data, "target", noone),
		        offset_x:       _opt(_data, "offset_x", 0),
		        offset_y:       _opt(_data, "offset_y", 0),
		        duracao:        _opt(_data, "duracao", -1),
		        intervalo:      _opt(_data, "intervalo", 10),
		        timer:          0,
		        qtd:            _opt(_data, "qtd", 1),
		        cor:            _resolver_cor_unica(_color, c_white)
		    };
		    array_push(_mgr.emissores, _em);
		    return _em;
		}
		
		//5. FOGO TIPO TOCHA
		case "fogo_tocha":
		{
		    var _cores_padrao = [c_yellow, c_orange, c_red];
		    var _cores_fogo   = _opt(_data, "cores", _resolver_cores_fogo(_color, _cores_padrao));
		
		    var _em = {
				ativo:			true,
				pausado:		_opt(_data, "pausado", false),
				persistir_room:	_opt(_data, "persistir_room", false),
				tipo:			"fogo_tocha",
				x:				_x,
				y:				_y,
				target:			_opt(_data, "target", noone),
				offset_x:		_opt(_data, "offset_x", 0),
				offset_y:		_opt(_data, "offset_y", 0),
				duracao:		_opt(_data, "duracao", -1),
				intervalo:		_opt(_data, "intervalo", 2),
				timer:			0,
				qtd:			_opt(_data, "qtd", 2),
				raio:			_opt(_data, "raio", 3),
				cores:			_cores_fogo
		    };
		    array_push(_mgr.emissores, _em);
		    return _em;
		}
		
		//6. FOGO BOCA DE FOGÃO (TOP-DOWN)
		case "fogo_fogao":
		{
		    var _cores_padrao = [make_color_rgb(110, 225, 255), make_color_rgb(25, 130, 255), c_orange];
		    var _cores_fogo   = _opt(_data, "cores", _resolver_cores_fogo(_color, _cores_padrao));
		
		    var _em = {
		        ativo:          true,
		        pausado:        _opt(_data, "pausado", false),
		        persistir_room: _opt(_data, "persistir_room", false),
		        tipo:           "fogo_fogao",
		        x:              _x,
		        y:              _y,
		        target:         _opt(_data, "target", noone),
		        offset_x:       _opt(_data, "offset_x", 0),
		        offset_y:       _opt(_data, "offset_y", 0),
		        duracao:        _opt(_data, "duracao", -1),
		        intervalo:      _opt(_data, "intervalo", 2),
		        timer:          0,
		        bicos:          _opt(_data, "bicos", 16),
		        raio_anel:      _opt(_data, "raio_anel", 16),
		        cores:          _cores_fogo
		    };
		    array_push(_mgr.emissores, _em);
		    return _em;
		}
		
		//7. BOLHAS TOP-DOWN
		case "bolhas_panela":
		{
		    var _em = {
		        ativo:          true,
		        pausado:        _opt(_data, "pausado", false),
		        persistir_room: _opt(_data, "persistir_room", false),
		        tipo:           "bolhas_panela",
		        x:              _x,
		        y:              _y,
		        target:         _opt(_data, "target", noone),
		        offset_x:       _opt(_data, "offset_x", 0),
		        offset_y:       _opt(_data, "offset_y", 0),
		        duracao:        _opt(_data, "duracao", -1),
		        intervalo:      _opt(_data, "intervalo", 5),
		        timer:          0,
		        qtd:            _opt(_data, "qtd", 1),
		        raio:           _opt(_data, "raio", 12),
		        cor:            _resolver_cor_unica(_color, c_white),
		        bolhas_ativas:  []
		    };
		    array_push(_mgr.emissores, _em);
		    return _em;
		}
		
		// 8. SPLASH DE POÇÃO QUEBRANDO (Sempre por baixo do player)
        case "splash_pocao":
        {
            var _cor_liq   = _resolver_cor_unica(_color, c_white);
            var _cor_clara = merge_color(_cor_liq, c_white, 0.55);
            var _raio      = max(8, _opt(_data, "raio", 64));
            var _duracao   = max(15, _opt(_data, "duracao", 60));
            var _qtd_gotas = _opt(_data, "qtd", clamp(round(_raio * 0.45), 16, 45));

            // Posiciona ps_poeira 1 unidade atrás da entidade mais ao fundo
            _mgr.atualizar_depth_chao();

            // 1. Poça principal e manchas menores no chão
            var _escala_poca = _raio / 32;
            part_type_life(_mgr.pt_splash_poca, _duracao, _duracao + 10);
            part_type_size(_mgr.pt_splash_poca, _escala_poca * 0.85, _escala_poca * 1.0, -(_escala_poca * 0.15) / _duracao, 0);
            part_particles_create_color(_mgr.ps_poeira, _x, _y, _mgr.pt_splash_poca, _cor_liq, 1);

            repeat (5)
            {
                var _ang_m  = random(360);
                var _dist_m = random_range(_raio * 0.35, _raio * 0.75);
                var _esc_m  = _escala_poca * random_range(0.22, 0.40);
                part_type_size(_mgr.pt_splash_poca, _esc_m, _esc_m, 0, 0);
                part_particles_create_color(
                    _mgr.ps_poeira,
                    _x + lengthdir_x(_dist_m, _ang_m),
                    _y + lengthdir_y(_dist_m, _ang_m),
                    _mgr.pt_splash_poca,
                    _cor_liq,
                    1
                );
            }

            // 2. Anel líquido expansivo
            var _escala_anel = (_raio / 32) * 1.05;
            part_type_size(_mgr.pt_splash_anel, 0.15, 0.15, (_escala_anel - 0.15) / 14, 0);
            part_particles_create_color(_mgr.ps_poeira, _x, _y, _mgr.pt_splash_anel, _cor_clara, 1);

            // 3. Gotículas líquidas espirrando
            var _vel_gota = clamp(_raio * 0.13, 3.0, 14.0);
            part_type_speed(_mgr.pt_splash_gota, _vel_gota * 0.45, _vel_gota, -(_vel_gota * 0.045), 0);

            repeat (_qtd_gotas)
            {
                var _tom_gota = choose(_cor_liq, _cor_liq, _cor_clara);
                part_particles_create_color(_mgr.ps_poeira, _x, _y, _mgr.pt_splash_gota, _tom_gota, 1);
            }

            // 4. Estilhaços de vidro
            repeat (8)
            {
                part_particles_create_color(_mgr.ps_poeira, _x, _y, _mgr.pt_splash_vidro, _cor_clara, 1);
            }

            return noone;
        }
	}
	
	return noone;
}

function parar_efeito(_emissor)
{
    if(is_struct(_emissor))
    {
        _emissor.ativo = false;
    }
}