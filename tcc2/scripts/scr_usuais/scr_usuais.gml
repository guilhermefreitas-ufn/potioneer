//macros
#macro RES_H display_get_gui_height()
#macro RES_W display_get_gui_width()
#macro GAME_SPEED game_get_speed(gamespeed_fps)

//define sprite 4 direcoes
function DefineSprite(_direcao, _spr_frente, _spr_lado, _spr_costas)
{
	var _sprite = spr_placeholder_32;
	
	switch(_direcao)
	{
		case 0: _sprite = _spr_lado; break;
		case 1: _sprite = _spr_costas; break;
		case 2: _sprite = _spr_lado; break;
		case 3: _sprite = _spr_frente; break;
	}
	
	return _sprite;
}

//sistema de save e load
function AjustaArraySave(_array, _tamanho, _valor_padrao)
{
    var _novo_array = array_create(
        _tamanho,
        _valor_padrao
    );

    if (!is_array(_array))
    {
        return _novo_array;
    }

    var _limite = min(
        array_length(_array),
        _tamanho
    );

    for (var i = 0; i < _limite; i++)
    {
        _novo_array[i] = _array[i];
    }

    return _novo_array;
}

//save
function salva_jogo()
{
    // SINCRONIZA A BOLSA, CASO ELA EXISTA NA ROOM
    var _bolsa = instance_find(obj_bolsa, 0);

    if (_bolsa != noone)
    {
        SincronizaBolsaGlobal(_bolsa);
    }

    // ORGANIZA TODOS OS DADOS
    global.stat_data =
    {
        versao: 1,

        // PROGRESSÃO
        fase: global.fase,

        // DADOS DO JOGADOR
        DadosJogador: DadosJogadorParaSave(),

        // INGREDIENTES FINAIS COLETADOS
        ingredientes_finais: global.ing_finais_coletados,
		
		// SAÍDA
		verificacao_saida: global.qtd_ing_finais
    };

    // CONVERTE PARA JSON
    var _json = json_stringify(global.stat_data);

    // CRIA O BUFFER
    var _buffer = buffer_create(
        string_byte_length(_json) + 1,
        buffer_fixed,
        1
    );

    // ESCREVE O JSON
    buffer_write(
        _buffer,
        buffer_string,
        _json
    );

   // SALVA O ARQUIVO
	buffer_save(_buffer, "savedata.sav");

	// LIBERA O BUFFER ORIGINAL
	buffer_delete(_buffer);

	// VERIFICA SE O SAVE FOI GRAVADO
	var _sucesso = false;

	var _buffer_verificacao = buffer_load("savedata.sav");

	if (_buffer_verificacao != -1)
	{
	    // LÊ O CONTEÚDO GRAVADO
	    var _json_verificado = buffer_read(
	        _buffer_verificacao,
	        buffer_string
	    );

	    // COMPARA COM O JSON ORIGINAL
	    _sucesso = (_json_verificado == _json);

	    // LIBERA O BUFFER DE VERIFICAÇÃO
	    buffer_delete(_buffer_verificacao);
	}

	// MENSAGEM
	if (_sucesso)
	{
	    show_debug_message("Jogo salvo com sucesso!");
	    CriaMensagem(x, y, "Jogo salvo com sucesso!");
	}
	else
	{
	    show_debug_message("ERRO: Não foi possível verificar o save.");
	    CriaMensagem(x, y, "ERRO: Não foi possível salvar o jogo.");
	}

	return _sucesso;
}

function SerializaArrayPocoes(_pocoes)
{
    var _salvas = array_create(
        array_length(_pocoes),
        undefined
    );

    for (var i = 0; i < array_length(_pocoes); i++)
    {
        var _pocao = _pocoes[i];

        // SLOT VAZIO
        if (is_undefined(_pocao))
        {
            continue;
        }

        if (!is_struct(_pocao))
        {
            continue;
        }

        // NOME DO SPRITE
        var _sprite_nome = sprite_get_name(spr_pocao);

        if (
            variable_struct_exists(_pocao, "sprite")
            && sprite_exists(_pocao.sprite)
        )
        {
            _sprite_nome = sprite_get_name(
                _pocao.sprite
            );
        }

        _salvas[i] =
        {
            id: _pocao.id,

            nome: _pocao.nome,
            algoritmo: _pocao.algoritmo,
            sentenca: _pocao.sentenca,

            cor: _pocao.cor,
            sprite_nome: _sprite_nome
        };
    }

    return _salvas;
}

function DadosJogadorParaSave()
{
    var _dados = global.DadosJogador;

    return
    {
        // POÇÕES
        armario_pocoes: SerializaArrayPocoes(
            _dados.armario_pocoes
        ),

        hotbar_pocoes: SerializaArrayPocoes(
            _dados.hotbar_pocoes
        ),

        proximo_id_pocao: _dados.proximo_id_pocao,

        // BOLSA
        bolsa_inventario: _dados.bolsa_inventario,
        bolsa_quantidades: _dados.bolsa_quantidades,
        bolsa_valores: _dados.bolsa_valores
    };
}

//load
function RestauraArrayPocoes(_salvas, _quantidade_slots)
{
    var _pocoes = array_create(
        _quantidade_slots,
        undefined
    );

    if (!is_array(_salvas))
    {
        return _pocoes;
    }

    var _limite = min(
        array_length(_salvas),
        _quantidade_slots
    );

    for (var i = 0; i < _limite; i++)
    {
        var _salva = _salvas[i];

        // SLOT VAZIO
        if (!is_struct(_salva))
        {
            continue;
        }

        // RECUPERA O SPRITE
        var _sprite = asset_get_index(
            _salva.sprite_nome
        );

        // SPRITE INVÁLIDO
        if (
            _sprite < 0
            || !sprite_exists(_sprite)
        )
        {
            _sprite = spr_pocao;
        }

        // RECONSTRÓI A POÇÃO
        _pocoes[i] =
        {
            id: _salva.id,

            nome: _salva.nome,
            algoritmo: _salva.algoritmo,
            sentenca: _salva.sentenca,

            cor: _salva.cor,
            sprite: _sprite,

            cooldown: 0
        };
    }

    return _pocoes;
}

function AplicaDadosJogadorSave(_salvos)
{
    if (!is_struct(_salvos))
    {
        return false;
    }

    var _dados = global.DadosJogador;

    // POÇÕES DO ARMÁRIO
    if (variable_struct_exists(_salvos, "armario_pocoes"))
    {
        _dados.armario_pocoes = RestauraArrayPocoes(
            _salvos.armario_pocoes,
            SLOTS_ARMARIO_POCOES
        );
    }

    // POÇÕES DA HOTBAR
    if (variable_struct_exists(_salvos, "hotbar_pocoes"))
    {
        _dados.hotbar_pocoes = RestauraArrayPocoes(
            _salvos.hotbar_pocoes,
            SLOTS_HOTBAR_POCOES
        );
    }

    // PRÓXIMO ID DE POÇÃO
    if (variable_struct_exists(_salvos, "proximo_id_pocao"))
    {
        _dados.proximo_id_pocao = _salvos.proximo_id_pocao;
    }

    // BOLSA: INVENTÁRIO
    if (variable_struct_exists(_salvos, "bolsa_inventario"))
    {
        _dados.bolsa_inventario = AjustaArraySave(
            _salvos.bolsa_inventario,
            SLOTS_BOLSA,
            -1
        );
    }

    // BOLSA: QUANTIDADES
    if (variable_struct_exists(_salvos, "bolsa_quantidades"))
    {
        _dados.bolsa_quantidades = AjustaArraySave(
            _salvos.bolsa_quantidades,
            SLOTS_BOLSA,
            0
        );
    }

    // BOLSA: VALORES
    if (variable_struct_exists(_salvos, "bolsa_valores"))
    {
        _dados.bolsa_valores = AjustaArraySave(
            _salvos.bolsa_valores,
            SLOTS_BOLSA,
            undefined
        );
    }

    return true;
}

function carrega_jogo()
{
    var _filename = "savedata.sav";

    // VERIFICA SE O ARQUIVO EXISTE
    if (!file_exists(_filename))
    {
        show_debug_message("Nenhum save encontrado.");
        CriaMensagem(RES_W / 4, RES_H / 4,"Nenhum save encontrado.");

        return false;
    }

    // CARREGA O BUFFER
    var _buffer = buffer_load(_filename);

    if (_buffer < 0)
    {
        show_debug_message("ERRO: Não foi possível carregar o save.");
        CriaMensagem(RES_W / 4, RES_H / 4,"ERRO: Não foi possível carregar o save.");

        return false;
    }

    // LÊ O JSON
    var _json = buffer_read(
        _buffer,
        buffer_string
    );

    buffer_delete(_buffer);

    // INTERPRETA O JSON
    var _salvos;

    try
    {
        _salvos = json_parse(_json);
    }
    catch (_erro)
    {
        show_debug_message("ERRO: Arquivo de save inválido.");
        CriaMensagem(RES_W / 4, RES_H / 4,"ERRO: Arquivo de save inválido.");

        return false;
    }

    // COMPATIBILIDADE COM O FORMATO ANTIGO,
    // QUE UTILIZAVA UM ARRAY COM A STRUCT NA POSIÇÃO 0.
    if (is_array(_salvos))
    {
        if (array_length(_salvos) <= 0)
        {
            return false;
        }

        _salvos = _salvos[0];
    }

    if (!is_struct(_salvos))
    {
        return false;
    }

    // VERSÃO DO SAVE
    if (
        variable_struct_exists(_salvos, "versao")
        && _salvos.versao > 1
    )
    {
        show_debug_message("ERRO: Versão de save incompatível.");
        CriaMensagem(RES_W / 4, RES_H / 4,"ERRO: Versão de save incompatível.");

        return false;
    }

    // RESTAURA A FASE
    if (variable_struct_exists(_salvos, "fase"))
    {
        global.fase = max(0, _salvos.fase);
    }

    // RESTAURA OS DADOS DO JOGADOR
    if (variable_struct_exists(_salvos, "DadosJogador"))
    {
        AplicaDadosJogadorSave(
            _salvos.DadosJogador
        );
    }

    // RESTAURA OS INGREDIENTES FINAIS
    if (variable_struct_exists(_salvos, "ingredientes_finais"))
    {
        global.ing_finais_coletados =
            _salvos.ingredientes_finais;
    }
	
	// RESTAURA A VERIFICAÇÃO DA SAÍDA
	if (variable_struct_exists(_salvos, "verificacao_saida"))
	{
	    global.qtd_ing_finais =
	        _salvos.verificacao_saida;
	}

    // ATUALIZA A BOLSA, CASO ELA JÁ EXISTA
    var _bolsa = instance_find(obj_bolsa, 0);

    if (_bolsa != noone)
    {
        CarregaBolsaGlobal(_bolsa);
    }

    // MANTÉM A STRUCT DE SAVE ATUALIZADA
    global.stat_data = _salvos;

    show_debug_message("Jogo carregado com sucesso!");
    CriaMensagem(RES_W / 4, RES_H/4,"Jogo carregado com sucesso!");

    return true;
}

//on off overlay
///@description Desenha um overlay e pausa o jogo.
///@param {string} _tipo: pause, win, lose, pre, tutorial
///@param {bool} _ligar: true (liga), false (desliga)
function controla_overlay(_tipo, _ligar)
{
	//Verifica se há uma transição de sala ativa
	if(instance_exists(obj_transicao) && obj_transicao.state != 0)
	{
		//Se estiver ligando um overlay, salva o tipo pendente
		if(_ligar)
		{
			global.overlay_pendente = _tipo;
		}
		else
		{
			//Se estiver desligando, limpa o pendente (se for o mesmo tipo)
			if(global.overlay_pendente == _tipo)
			{
				global.overlay_pendente = "";
			}
		}
		//A transição será responsável por ativar ou ignorar o overlay pendente.
		return; 
	}
	
	//Nenhuma transição ativa, executa o overlay imediatamente
	if(_ligar)
	{
		global.overlay_tipo = _tipo;
		global.overlay_ativo = true;
		
		//pausa o jogo
		global.pause = true;
	}
	else
	{
		global.overlay_ativo = false;
		global.overlay_tipo = "";
		
		//retoma o jogo
		global.pause = false;
	}
}

///@function aplica_transicao(_room_destino, _alvo_out, _tempo_foco_out, _alvo_in, _tempo_foco_in)
///@param {real} _room_destino A room de destino.
///@param {real} _alvo_out Objeto para foco de saída (padrão: noone). Use 'noone' para centro da tela.
///@param {real} _tempo_foco_out Tempo em segundos do foco de saída (padrão: 2).
///@param {real} _alvo_in Objeto para foco de entrada (padrão: noone). Use 'noone' para centro da tela.
///@param {real} _tempo_foco_in Tempo em segundos do foco de entrada (padrão: 0).
function aplica_transicao(_room_destino, _alvo_out = noone, _tempo_foco_out = 2, _alvo_in = noone, _tempo_foco_in = 0)
{
    //show_debug_message("aplica transicao chamado");
    
    //Verifica se já existe uma transição ativa
    if(instance_exists(obj_transicao) && obj_transicao.state != 0)
    {
        return;
    }
    
    //Removendo overlays e pausando
    if(global.overlay_ativo) { global.overlay_ativo = false; global.overlay_tipo = ""; }
    if(!global.pause) { global.pause = true; }
    
    //Inicializa o objeto de transição
    var _inst = noone;
    
    if(!instance_exists(obj_transicao))
    {
        _inst = instance_create_layer(0, 0, "UI", obj_transicao);
    }
    else
    {
        _inst = instance_find(obj_transicao, 0);
    }
    
    with(_inst)
    {
        //1. Definições de Visão e Raio Máximo
        var _view_w = camera_get_view_width(view_camera[0]);
        var _view_h = camera_get_view_height(view_camera[0]);
        radius_max = ceil(point_distance(0, 0, _view_w, _view_h));
        radius = radius_max; //Inicia totalmente aberto
        
        //2. Parâmetros de SAÍDA (Out)
        var _out_target = noone;
        if(_alvo_out != noone)
        {
            _out_target = instance_find(_alvo_out, 0);
        }
        
        if(instance_exists(_out_target))
        {
            //Alvo EXISTE: Transição normal com foco
            alvo_out_id = _out_target;
            focus_time_out_frames = _tempo_foco_out * GAME_SPEED;
            
            var _spr_out = _out_target.sprite_index;
            var _spr_w_out = sprite_get_width(_spr_out);
            var _spr_h_out = sprite_get_height(_spr_out);
            
            //Raio mínimo é metade da maior dimensão
            radius_min_out = max(_spr_w_out, _spr_h_out) / 2;
            
            //Centralização pelo Offset do Sprite
            var _spr_xoff_out = sprite_get_xoffset(_spr_out);
            var _spr_yoff_out = sprite_get_yoffset(_spr_out);
            
            //Calcula o centro do sprite: Posição do Objeto - Offset da Origem + Metade da Largura/Altura
            center_x = (_out_target.x - _spr_xoff_out) + (_spr_w_out / 2);
            center_y = (_out_target.y - _spr_yoff_out) + (_spr_h_out / 2);
            
            state = 1; //Inicia FECHANDO
        }
        else
        {
            //Alvo NÃO EXISTE: Fechamento total imediato no centro da tela
            alvo_out_id = noone;
            radius_min_out = 0;
            focus_time_out_frames = 0;
            
            // Define o centro somando a posição da câmera com a metade da resolução
            center_x = camera_get_view_x(view_camera[0]) + (RES_W / 2);
            center_y = camera_get_view_y(view_camera[0]) + (RES_H / 2);
            
            state = 3; //Inicia FECHAMENTO_TOTAL
        }
        
        //Parâmetros de ENTRADA (In)
        alvo_in_id = _alvo_in; //Salva o ÍNDICE do objeto (ex: obj_player)
        focus_time_in_frames = _tempo_foco_in * GAME_SPEED;
        radius_min_in = 0; //Será calculado no Step Event
        
        //4. Parâmetro Final
        target_room = _room_destino;
    }
}

function MundoParaGUI(_x, _y, _viewport = 0)
{
    //VERIFICA SE EXISTE UMA CÂMERA ATIVA
    if(
        !view_enabled
        || !view_visible[_viewport]
    )
    {
        return undefined;
    }

    var _camera = view_camera[_viewport];

    if(_camera == -1)
    {
        return undefined;
    }

    //POSIÇÃO DA CÂMERA
    var _camera_x = camera_get_view_x(_camera);
    var _camera_y = camera_get_view_y(_camera);

    //DIMENSÕES DA CÂMERA
    var _camera_w = camera_get_view_width(_camera);
    var _camera_h = camera_get_view_height(_camera);

    //DIMENSÕES DA GUI
    var _gui_w = RES_W;
    var _gui_h = RES_H;

    //ESCALAS
    var _escala_x = _gui_w / _camera_w;
    var _escala_y = _gui_h / _camera_h;

    //CONVERSÃO
    var _gui_x = (_x - _camera_x) * _escala_x;
    var _gui_y = (_y - _camera_y) * _escala_y;

    //RETORNA POSIÇÃO E ESCALAS
    return {
        x: _gui_x,
        y: _gui_y,

        escala_x: _escala_x,
        escala_y: _escala_y
    };
}

/// @func cria_luz(_x, _y, _tam_x, _tam_y, _pulsa)
/// @desc Cria uma luz na posição e tamanho especificados.
/// @param _x (real) — posição x da luz (origem centro)
/// @param _y (real) — posição y da luz (origem centro)
/// @param _tam_x (real) — largura da luz (em pixels)
/// @param _tam_y (real) — altura da luz (em pixels)
/// @param _pulsa (boolean) — define se a luz pulsa ou não.
function cria_luz(_x, _y, _tam_x, _tam_y, _pulsa = true)
{
	if(!instance_exists(obj_iluminacao))
	{
	    instance_create_layer(0,0,"UI",obj_iluminacao);
	}
	
	with(obj_iluminacao)
	{
		//configurando minha luz
		luz_tam_x = _tam_x; //largura em pixels (este valor * 40)
		luz_tam_y = _tam_y; //altura em pixels (este valor * 40)
		
		//posição
		luz_pos_x = _x; //posição x (origem da sprite no centro dela)
		luz_pos_y = _y; //posição y (origem da sprite no centro dela)
	}
	
	var l = instance_create_layer(_x, _y, "Iluminacao", obj_luz);
	l.pos_x = _x;
	l.pos_y = _y;
	
	l.tam_x = _tam_x / l.sprite_width;
	l.tam_y = _tam_y / l.sprite_height;
	
	l.image_xscale = l.tam_x;
	l.image_yscale = l.tam_y;
	
	l.pulsa = _pulsa;
	
	return l;
}

//desenha a sombra dos objetos
function DesenhaSombra(_offset_x = 0, _offset_y = 0, _sprite = sprite_index, _escala_x = image_xscale, _escala_y = image_yscale)
{
	var _tenho_sombra = false;
	
	if(instance_exists(obj_sombra))
	{
		with(obj_sombra)
		{
			if(pai == other.id)
			{
				_tenho_sombra = true;
			}
		}
	}
	
	if(!_tenho_sombra)
	{
		instance_create_layer(x,y,"Sombras",obj_sombra, { pai : id, offset_x : _offset_x, offset_y : _offset_y, sprite : _sprite, escala_x : _escala_x, escala_y : _escala_y })
	}
}

//efeito de hit flash
function HitFlash(
	_alpha,
	_color = c_white,
	_spr = sprite_index,
	_img_id = image_index,
	_x = x,
	_y = y,
	_xscale = image_xscale,
	_yscale = image_yscale,
	_rot = 0
)
{
	gpu_set_fog(true, _color, 0, 0);
	
	draw_sprite_ext(_spr,_img_id,_x,_y,_xscale,_yscale,_rot,_color,_alpha);
	
	gpu_set_fog(false, _color, 0, 0);
}

//cria bolhas
function CriaBolhas(_chance, _cor = c_white, _layer = "UI", _pai = id, _x = x + sprite_height / 2, _y = y)
{
	if(layer_exists(_layer))
	{
		//criando bolhas
		with(instance_create_layer(_x,_y,_layer,obj_gerador_bolhas,
			{
				pai : _pai
			})
		)
		{
			cor = _cor;
			chance = _chance;
		}
	}
	else
	{
		show_debug_message("A Layer informada não existe!");
	}
}

// CRIA UMA MENSAGEM NA POSIÇÃO INFORMADA
// EVITA SOBREPOSIÇÃO COM MENSAGENS PRÓXIMAS
function CriaMensagem(
    _x,
    _y,
    _texto,
    _cor = c_white,
    _layer = "UI"
)
{
    // CONFIGURAÇÕES
    var _espaco_max = 160;
    var _espacamento = 6;

    // GARANTE QUE O TEXTO SEJA UMA STRING
    var _texto_mensagem = string(_texto);
    
    // CALCULA A ALTURA DA NOVA MENSAGEM
    // GUARDA A FONTE ATUAL
    var _fonte_anterior = draw_get_font();

    // UTILIZA A MESMA FONTE DO OBJETO
    draw_set_font(fnt_placeholder_pequena);

    // CALCULA A ALTURA CONSIDERANDO AS QUEBRAS DE LINHA
    var _altura_nova = string_height_ext(
        _texto_mensagem,
        -1,
        _espaco_max
    );

    // PEQUENA MARGEM DE SEGURANÇA
    _altura_nova = ceil(_altura_nova) + 2;

    // RESTAURA A FONTE ANTERIOR
    draw_set_font(_fonte_anterior);

    // PROCURA A MENSAGEM MAIS ALTA DO GRUPO
    var _encontrou_mensagem = false;
    var _topo_mais_alto = 0;

    var _total = instance_number(
        obj_mensagem
    );

    for(var i = 0; i < _total; i++)
    {
        var _existente = instance_find(
            obj_mensagem,
            i
        );

        if(_existente == noone)
        {
            continue;
        }

        // VERIFICA SE PERTENCE AO MESMO GRUPO
        if(
            abs(_existente.origem_x - _x) < 100
            && abs(_existente.origem_y - _y) < 120
        )
        {
            // LIMITE SUPERIOR DO TEXTO EXISTENTE
            var _topo = _existente.y
                - _existente.altura_texto / 2;

            // GUARDA A MENSAGEM MAIS ALTA
            if(
                !_encontrou_mensagem
                || _topo < _topo_mais_alto
            )
            {
                _topo_mais_alto = _topo;
                _encontrou_mensagem = true;
            }
        }
    }

    // DEFINE A POSIÇÃO DA NOVA MENSAGEM
    var _nova_y = _y;

    if(_encontrou_mensagem)
    {
        // POSICIONA A NOVA MENSAGEM ACIMA DAS EXISTENTES
        _nova_y = _topo_mais_alto
            - _espacamento
            - _altura_nova / 2;
    }

    // CRIA A MENSAGEM
    var _mensagem = instance_create_layer(
        _x,
        _nova_y,
        _layer,
        obj_mensagem
    );
	
    // CONFIGURA A MENSAGEM
    if(_mensagem != noone)
    {
        _mensagem.texto = _texto_mensagem;

        _mensagem.cor = _cor;

        _mensagem.largura_maxima = _espaco_max;

        _mensagem.altura_texto = _altura_nova;

        // GUARDA A POSIÇÃO ORIGINAL PARA IDENTIFICAR O GRUPO
        _mensagem.origem_x = _x;
        _mensagem.origem_y = _y;
    }

    return _mensagem;
}

//desenha texto com outline
function draw_text_outline(_x, _y, _texto, _corTexto, _corContorno, _offset, _xscale = 1, _yscale = 1, _angle = 0, _sep = -1, _w = -1)
{
	draw_set_color(_corContorno);
	draw_text_ext_transformed(_x - _offset, _y, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x + _offset, _y, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x, _y - _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x, _y + _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x - _offset, _y - _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x + _offset, _y - _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x - _offset, _y + _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x + _offset, _y + _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	
	draw_set_color(_corTexto);
	draw_text_ext_transformed(_x, _y, _texto, _sep, _w,_xscale,_yscale, _angle);
	
	//reseta_draw();
}

//define alinhamento de texto
function define_align(_halign = fa_center, _valign = fa_middle)
{
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}

//reseta configs de texto
function reseta_draw()
{
	draw_set_font(-1);
	draw_set_color(-1);
	draw_set_halign(-1);
	draw_set_valign(-1);
	draw_set_alpha(1);
}

//mensagem de objeto não encontrado
function msg_erro(_objeto)
{
	show_debug_message("Erro: "+_objeto+" não encontrado!");
}

//mudando de sprite
function muda_sprite(_sprite)
{
	if(sprite_index != _sprite)
	{
		image_index = 0;
		sprite_index = _sprite;
	}
}

//acabou minha animação
function animation_end()
{
	return image_index >= image_number - 1;
}

//efeito blink
function blink_alpha(_vel, _alpha_min = 0, _alpha_max = 1)
{
	return min(max(sin(get_timer()/(50000/_vel)), _alpha_min), _alpha_max);
}

//verifica se estou numa room de gameplay
function gameplay_room()
{
	return room == rm_masmorra;
}

//cria feedback de duração (relógio estilo gráfico de pizza)
function criar_feedback_duracao(_x, _y, _raio, _duracao, _tempo_restante, _cor, _cor_fundo_contorno, _tam_contorno = 0)
{
	//var _fx = instance_create_layer(_x, _y, "UI", obj_feedback_duracao);
	
	with(instance_create_layer(_x, _y, "UI", obj_feedback_duracao))
	{
		raio = _raio;
		duracao = _duracao;
		tempo_restante = _tempo_restante;
		cor_pizza = _cor;
		cor_fundo_contorno = _cor_fundo_contorno;
		tam_contorno = _tam_contorno;
		pai = other.id;
		
		return id;
	}
}

//trocando de room quando acaba uma sequencia
function fim_cena_goto(_room, _foco_out = noone, _dur_foco_out = 0, _foco_in = noone, _dur_foco_in = 0)
{
	aplica_transicao(_room, _dur_foco_out, _dur_foco_out, _dur_foco_in, _dur_foco_in);
}

//sons
///@function set_song_ingame(_song, _fade_out_current_song, _fade_in)
///@description Toca uma música no jogo, parando a música atual (se houver), com ou sem Fade In / Fade Out.
///@param _song Qualquer música (defina "noone" para parar ou diminuir o volume da faixa atual).
///@param _fade_out_current_song Duração (em frames) do Fade Out da música atual (se está tocando).
///@param _fade_in Duração (em frames) do Fade In do som desejado (se _song != noone).
function set_song_ingame(_song, _fade_out_current_song = 0, _fade_in = 0)
{
	if(instance_exists(obj_mus))
	{
		with(obj_mus)
		{
			target_song_asset = _song;
			end_fade_out_time = _fade_out_current_song;
			start_fade_in_time = _fade_in;
		}
	}
	else
	{
		msg_erro("Gerenciador de Músicas");
	}
}

//contador estilo gráfico de pizza
///@function draw_pie(x1, y1, x2, y2, x3, y3, x4, y4, outline, precision)
///@description Desenha um setor de uma elipse.
///Permite desenhar preenchido ou somente o contorno, usando uma primitiva com resolução limitada.
///O setor é formado por um arco da elipse e por duas linhas ligando o centro aos pontos inicial e final do arco.
///O arco é desenhado na borda da elipse no sentido anti-horário, do ponto inicial ao ponto final.
///O ponto inicial é a interseção entre a elipse e a linha do centro até (x3, y3).
///O ponto final é a interseção entre a elipse e a linha do centro até (x4, y4).
///@param {real} x1 Coordenada X do canto superior esquerdo do retângulo delimitador.
///@param {real} y1 Coordenada Y do canto superior esquerdo do retângulo delimitador.
///@param {real} x2 Coordenada X do canto inferior direito do retângulo delimitador.
///@param {real} y2 Coordenada Y do canto inferior direito do retângulo delimitador.
///@param {real} x3 Coordenada X do ponto que determina o ângulo inicial.
///@param {real} y3 Coordenada Y do ponto que determina o ângulo inicial.
///@param {real} x4 Coordenada X do ponto que determina o ângulo final.
///@param {real} y4 Coordenada Y do ponto que determina o ângulo final.
///@param {bool} outline Desenha apenas o contorno (true).
///@param {real} precision [Opcional] Número de segmentos usados para desenhar a elipse completa (4 — 64, divisível por 4). Padrão: 24.
function draw_pie(x1, y1, x2, y2, x3, y3, x4, y4, outline, precision)
{
	if(argument_count < 10 || precision == 0) { precision = 24; }
	
	var res,xm,ym,xr,yr,r,a1,a2,sx,sy,a;
	res = 360 / min(max(4,4*(precision div 4)),64);
	xm = (x1+x2)/2;
	ym = (y1+y2)/2;
	xr = abs(x2-x1)/2;
	yr = abs(y2-y1)/2;
	if(xr > 0) r = yr/xr; else r = 0;
	
	a1 = point_direction(0,0,(x3-xm)*r,y3-ym);
	a2 = point_direction(0,0,(x4-xm)*r,y4-ym);
	if(a2 < a1) a2 += 360;
	
	if(outline) { draw_primitive_begin(pr_linestrip); }
	else { draw_primitive_begin(pr_trianglefan); }
	
	draw_vertex(xm, ym);
	sx = xm + lengthdir_x(xr, a1);
	sy = ym + lengthdir_y(yr, a1);
	draw_vertex(sx, sy);
	
	for(a = res * (a1 div res + 1); a < a2; a += res)
	{
		sx = xm + lengthdir_x(xr, a);
		sy = ym + lengthdir_y(yr, a);
		draw_vertex(sx, sy);
	}
	
	sx = xm + lengthdir_x(xr, a2);
	sy = ym + lengthdir_y(yr, a2);
	draw_vertex(sx, sy);
	
	if(outline) { draw_vertex(xm, ym); }
	
	draw_primitive_end();
	return 0;
}

//grid
///@function desenha_grid(_tam, _linhas, _colunas, _thickness, _cor, _alpha, _posicao_x, _posicao_y, _origem_x, _origem_y)
///@description Desenha um grid com número definido de linhas e colunas, com pivô e posição controláveis. Caso _origem_x/_origem_y não sejam informados, o pivô padrão é o centro geométrico do grid (meio exato).
///@param {real} _tam Tamanho de cada célula (em pixels)
///@param {real} _linhas Número de linhas do grid
///@param {real} _colunas Número de colunas do grid
///@param {real} _thickness	Espessura das linhas
///@param _cor Cor do grid
///@param {real} _alpha Transparência (0–1)
///@param {real} _posicao_x	Posição X onde o grid será desenhado
///@param {real} _posicao_y	Posição Y onde o grid será desenhado
///@param {real} _origem_x Posição do pivô dentro do grid (em pixels, a partir do canto superior esquerdo)
///@param {real} _origem_y Posição do pivô dentro do grid (em pixels, a partir do canto superior esquerdo)
function desenha_grid(_tam, _linhas, _colunas, _thickness, _cor, _alpha, _posicao_x, _posicao_y, _origem_x = _colunas * _tam * 0.5, _origem_y = _linhas  * _tam * 0.5)
{
	//CÁLCULOS BÁSICOS
	var largura_total = _colunas * _tam;
	var altura_total  = _linhas  * _tam;
	
	//DESENHO DO GRID
	draw_set_color(_cor);
	draw_set_alpha(_alpha);
	
	//Linhas horizontais
	for(var i = 0; i <= _linhas; i++)
	{
		var _y = _posicao_y - _origem_y + i * _tam;
		draw_line_width(
			_posicao_x - _origem_x,
			_y,
			_posicao_x - _origem_x + largura_total,
			_y,
			_thickness
		);
	}
	
	//Linhas verticais
	for(var j = 0; j <= _colunas; j++)
	{
		var _x = _posicao_x - _origem_x + j * _tam;
		draw_line_width(
			_x,
			_posicao_y - _origem_y,
			_x,
			_posicao_y - _origem_y + altura_total,
			_thickness
		);
	}
	
	//RESTAURA CONFIGURAÇÕES
	reseta_draw();
}