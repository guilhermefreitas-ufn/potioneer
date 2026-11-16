
inventario_hover = -1;
slot_hover = -1;

inventario_drag = -1;
slot_drag = -1;
item_drag = -1;


//POÇÕES
pocao_inventario_hover = noone;
pocao_slot_hover = -1;

pocao_inventario_drag = noone;
pocao_slot_drag = -1;

pocao_drag = undefined;

//posição inicial do clique
mouse_inicio_x = 0;
mouse_inicio_y = 0;

//distância mínima para transformar clique em drag
distancia_drag = 8;

slot_tam = sprite_get_width(spr_slot_bolsa_ph);
entre_slots = 4;
espaco_borda = 6;

//ANIMAÇÃO DE TRANSFERÊNCIA POR CLICK
click_animando = false;

click_anim_item = -1;

click_anim_x = 0;
click_anim_y = 0;

click_anim_dest_x = 0;
click_anim_dest_y = 0;

click_anim_tempo = 0;
click_anim_duracao = 8;

//funções
//RETORNA O RETÂNGULO DE UM SLOT
get_slot_rect = function(_obj_inventario, _slot)
{
	var _sprite_slot = _obj_inventario.sprite_meu_slot;

	var _largura_slot = sprite_get_width(_sprite_slot);
	var _altura_slot = sprite_get_height(_sprite_slot);

	var _offset_x = sprite_get_xoffset(_sprite_slot);
	var _offset_y = sprite_get_yoffset(_sprite_slot);

	var _espaco = _obj_inventario.entre_slots;

	var _passo_x = _largura_slot + _espaco;
	var _passo_y = _altura_slot + _espaco;

	var _colunas = _obj_inventario.colunas;

	var _esquerda;
	var _topo;


	//CALDEIRÃO
	if(_obj_inventario.caldeirao)
	{
		//DIMENSÕES DO SPRITE
		var _sprite_fundo = _obj_inventario.sprite_index;

		var _largura_fundo = sprite_get_width(_sprite_fundo);
		var _altura_fundo = sprite_get_height(_sprite_fundo);

		var _origem_x = sprite_get_xoffset(_sprite_fundo);
		var _origem_y = sprite_get_yoffset(_sprite_fundo);

		//CANTO SUPERIOR ESQUERDO DO CALDEIRÃO
		var _fundo_x = _obj_inventario.x - _origem_x;
		var _fundo_y = _obj_inventario.y - _origem_y;

		//DIMENSÕES DA GRADE COMPLETA
		var _colunas_max = min(_colunas, SLOTS_CALDEIRAO);
		var _linhas_max = ceil(SLOTS_CALDEIRAO / _colunas_max);

		var _largura_grade =
			_colunas_max * _largura_slot
			+ (_colunas_max - 1) * _espaco;

		var _altura_grade =
			_linhas_max * _altura_slot
			+ (_linhas_max - 1) * _espaco;

		//POSIÇÃO INICIAL DA GRADE CENTRALIZADA
		var _inicio_x =
			_fundo_x + (_largura_fundo - _largura_grade) / 2;

		var _inicio_y =
			_fundo_y + (_altura_fundo - _altura_grade) / 2;

		//POSIÇÃO DO SLOT
		_esquerda =
			_inicio_x + (_slot mod _colunas) * _passo_x;

		_topo =
			_inicio_y + (_slot div _colunas) * _passo_y;
	}

	//BOLSA E OUTROS INVENTÁRIOS
	else
	{
		//MANTÉM O POSICIONAMENTO ORIGINAL
		var _draw_x =
			_obj_inventario.x
			+ (_slot mod _colunas) * _passo_x
			+ 2;

		var _draw_y =
			_obj_inventario.y
			+ (_slot div _colunas) * _passo_y
			+ 2;

		//CONVERTENDO A ORIGEM PARA CANTO SUPERIOR ESQUERDO
		_esquerda = _draw_x - _offset_x;
		_topo = _draw_y - _offset_y;
	}

	//RETORNANDO OS LIMITES DO SLOT
	return [
		_esquerda,
		_topo,
		_esquerda + _largura_slot,
		_topo + _altura_slot
	];
};

//RETORNA A POSIÇÃO DE DESENHO DE UM SLOT
get_slot_pos = function(_obj_inventario, _slot)
{
	var _rect = get_slot_rect(_obj_inventario, _slot);

	var _sprite_slot = _obj_inventario.sprite_meu_slot;

	return [
		_rect[0] + sprite_get_xoffset(_sprite_slot),
		_rect[1] + sprite_get_yoffset(_sprite_slot)
	];
};

mouse_over = function()
{
    //LIMPANDO HOVER
    slot_hover = -1;
    inventario_hover = -1;

    //COORDENADAS DO MOUSE NO MUNDO
    var _mx = mouse_x;
    var _my = mouse_y;

    //COORDENADAS DO MOUSE NA GUI
    var _mx_gui = device_mouse_x_to_gui(0);
    var _my_gui = device_mouse_y_to_gui(0);

    //INVENTÁRIOS COMUNS
	with(obj_inventario_pai)
	{
		//QUANTIDADE DE SLOTS
		var _slots = SLOTS_BOLSA;

		if(caldeirao)
		{
			_slots = slots_ativos;
		}

		//VERIFICANDO CADA SLOT
		for(var i = 0; i < _slots; i++)
		{
			//LIMITES REAIS DO SLOT
			var _rect = other.get_slot_rect(id, i);

			//MOUSE SOBRE O SLOT
			if(point_in_rectangle(
				_mx,
				_my,
				_rect[0],
				_rect[1],
				_rect[2],
				_rect[3]
			))
			{
				other.slot_hover = i;
				other.inventario_hover = id;

				break;
			}
		}
	}

    //LIMPANDO HOVER DAS POÇÕES
    pocao_inventario_hover = noone;
    pocao_slot_hover = -1;

    //ARMÁRIO: COORDENADAS DO MUNDO
    if(instance_exists(obj_armario))
    {
        var _armario = instance_find(obj_armario, 0);

        var _slot_armario = _armario.SlotSobreMouse(
            _mx,
            _my
        );

        if(_slot_armario != -1)
        {
            pocao_inventario_hover = _armario;
            pocao_slot_hover= _slot_armario;
        }
    }

    //HOTBAR: COORDENADAS GUI
    if(instance_exists(obj_hotbar))
    {
        var _hotbar = instance_find(obj_hotbar, 0);

        var _slot_hotbar = _hotbar.SlotSobreMouse(
            _mx_gui,
            _my_gui
        );

        if(_slot_hotbar != -1)
        {
            pocao_inventario_hover = _hotbar;
            pocao_slot_hover = _slot_hotbar;
        }
    }
};

estado_click = function()
{
	mouse_over();
	
	//SOLTOU -> FOI UM CLICK
	if(mouse_check_button_released(mb_left))
	{
		var _outro_inventario = noone;
		
		if(inventario_drag.caldeirao)
		{
			_outro_inventario = instance_find(obj_bolsa, 0);
		}
		else
		{
			_outro_inventario = instance_find(obj_caldeirao, 0);
		}
		
		
		if(_outro_inventario != noone)
		{
			//posição de origem
			var _pos_origem = get_slot_pos(
				inventario_drag,
				slot_drag
			);
			
			//vamos descobrir onde o item realmente irá
			//antes de executar a transferência
			var _item = inventario_drag.inventario[slot_drag];
			
			var _slot_destino = -1;
			
			//BOLSA -> CALDEIRÃO
			if(!inventario_drag.caldeirao && _outro_inventario.caldeirao)
			{
				//procurando o primeiro slot vazio
				for(var i = 0; i < _outro_inventario.slots_ativos; i++)
				{
					if(_outro_inventario.inventario[i] == -1)
					{
						_slot_destino = i;
						break;
					}
				}
			}
			
			//CALDEIRÃO -> BOLSA
			else if(inventario_drag.caldeirao && !_outro_inventario.caldeirao)
			{
				//primeiro procura a pilha existente
				_slot_destino = ProcuraInventario(
					_outro_inventario,
					_item,
					false
				);
				
				//não encontrou -> primeiro slot vazio
				if(_slot_destino == -1)
				{
					_slot_destino = ProcuraInventario(
						_outro_inventario,
						-1,
						false
					);
				}
			}
			
			//TEM DESTINO
			if(_slot_destino != -1)
			{
				var _pos_destino = get_slot_pos(
					_outro_inventario,
					_slot_destino
				);
				
				//iniciando animação
				click_animando = true;
				
				click_anim_item = _item;
				
				click_anim_x = _pos_origem[0];
				click_anim_y = _pos_origem[1];
				
				click_anim_dest_x = _pos_destino[0];
				click_anim_dest_y = _pos_destino[1];
				
				click_anim_tempo = 0;
				
				//executando a transferência imediatamente
				TransfereInventario(
					inventario_drag,
					slot_drag,
					_outro_inventario,
					inventario_drag.caldeirao,
					_outro_inventario.caldeirao
				);
			}
		}
		
		//encerrando clique
		inventario_drag = -1;
		slot_drag = -1;
		
		estado = estado_livre;
		
		return;
	}
	
	//VERIFICANDO SE VIROU DRAG
	var _distancia = point_distance(
	    mouse_inicio_x,
	    mouse_inicio_y,
	    device_mouse_x_to_gui(0),
	    device_mouse_y_to_gui(0)
	);

	if(_distancia >= distancia_drag)
	{
	    item_drag = inventario_drag.inventario[slot_drag];

	    estado = estado_drag;
	}
}

estado_click_pocao = function()
{
	mouse_over();
	
	//SOLTOU → FOI UM CLIQUE
	if(mouse_check_button_released(mb_left))
	{
		var _armario =
			instance_find(obj_armario, 0);
		
		var _hotbar =
			instance_find(obj_hotbar, 0);
		
		//ARMÁRIO → HOTBAR
		if(pocao_inventario_drag == _armario)
		{
			var _resultado =
				AdicionaPocaoHotbarPorClique(
					pocao_slot_drag
				);
			
			
			if(!_resultado)
			{
				show_debug_message(
					"Hotbar cheia."
				);
			}
		}
		
		//HOTBAR → ARMÁRIO
		//Só permitir no arsenal
		else if(pocao_inventario_drag == _hotbar
			&& room == rm_armario)
		{
			DevolvePocaoHotbarPorClique(
				pocao_slot_drag
			);
		}
		
		//RESET
		pocao_inventario_drag = noone;
		pocao_slot_drag = -1;
		pocao_drag = undefined;
		
		estado = estado_livre;
		
		return;
	}
	
	//VERIFICANDO SE VIROU DRAG
	var _distancia = point_distance(
	    mouse_inicio_x,
	    mouse_inicio_y,
	    device_mouse_x_to_gui(0),
	    device_mouse_y_to_gui(0)
	);

	if(_distancia >= distancia_drag)
	{
	    //SALVA A POÇÃO QUE ESTÁ SENDO ARRASTADA
	    if(pocao_inventario_drag == instance_find(obj_armario, 0))
	    {
	        pocao_drag =
	            global.DadosJogador.armario_pocoes[pocao_slot_drag];
	    }
	    else
	    {
	        pocao_drag =
	            global.DadosJogador.hotbar_pocoes[pocao_slot_drag];
	    }

	    estado = estado_drag_pocao;
	}
};

estado_livre = function()
{
	mouse_over();
	
	if(
		mouse_check_button_pressed(mb_left)
		&& slot_hover != -1
		&& inventario_hover.inventario[slot_hover] != -1
	)
	{
		mouse_inicio_x = device_mouse_x_to_gui(0);
		mouse_inicio_y = device_mouse_y_to_gui(0);
	
		inventario_drag = inventario_hover;
		slot_drag = slot_hover;
	
		estado = estado_click;
	
		return;
	}
	
	//POÇÃO
	if(
		mouse_check_button_pressed(mb_left)
		&& pocao_slot_hover != -1
		&& pocao_inventario_hover != noone
	)
	{
		var _pocao;

		//ARMÁRIO
		if(pocao_inventario_hover.object_index == obj_armario)
		{
			_pocao = global.DadosJogador.armario_pocoes[pocao_slot_hover];
		}
	
		//HOTBAR
		else
		{
			_pocao = global.DadosJogador.hotbar_pocoes[pocao_slot_hover];
		}
	
		if(!is_undefined(_pocao))
		{
			mouse_inicio_x = device_mouse_x_to_gui(0);
			mouse_inicio_y = device_mouse_y_to_gui(0);
		
			pocao_inventario_drag = pocao_inventario_hover;
		
			pocao_slot_drag = pocao_slot_hover;
		
			pocao_drag = _pocao;
		
			estado = estado_click_pocao;
		
			return;
		}
	}
}

estado_drag = function()
{
	mouse_over();
	
	//continua arrastando
	if(mouse_check_button(mb_left))
	{
		return;
	}
	
	//SOLTOU O ITEM
	if(slot_hover != -1)
	{
		//soltou no próprio slot
		if(inventario_hover == inventario_drag && slot_hover == slot_drag)
		{
			//não faz nada
		}
		else
		{
			TrocaInventario(
				inventario_drag,
				slot_drag,
				inventario_hover,
				slot_hover,
				inventario_drag.caldeirao,
				inventario_hover.caldeirao
			);
		}
	}
	
	//reset
	item_drag = -1;
	inventario_drag = -1;
	slot_drag = -1;
	
	estado = estado_livre;
}

estado_drag_pocao = function()
{
    mouse_over();

    // CONTINUA ARRASTANDO
    if(mouse_check_button(mb_left))
    {
        return;
    }

    // SOLTOU
    if(mouse_check_button_released(mb_left))
    {
        var _armario = instance_find(obj_armario, 0);

        var _hotbar = instance_find(obj_hotbar, 0);
			
		// IDENTIFICA A ORIGEM DO ARRASTE
		var _origem_armario = pocao_inventario_drag == _armario;

		var _origem_hotbar = pocao_inventario_drag == _hotbar;
   
        // VERIFICA SE SOLTOU SOBRE A LIXEIRA
        var _descartar = false;
        var _lixeira = noone;

        // SOMENTE POÇÕES ARRASTADAS DO ARMÁRIO
        if(
		    room == rm_armario
		    && (_origem_armario || _origem_hotbar)
		    && instance_exists(obj_lixeira)
		)
        {
            _lixeira = instance_find(
                obj_lixeira,
                0
            );

            if(_lixeira != noone)
            {
                _descartar = _lixeira.MouseSobre(
                    mouse_x,
                    mouse_y
                );
            }
        }

        // DESCARTA A POÇÃO
		if(_descartar)
		{
		    var _pocao_descartada = undefined;

		    // DESCARTA A PARTIR DO ARMÁRIO
		    if(_origem_armario)
		    {
		        _pocao_descartada =
		            DescartaPocaoArmario(pocao_slot_drag);
		    }

		    // DESCARTA A PARTIR DA HOTBAR
		    else if(_origem_hotbar)
		    {
		        _pocao_descartada =
		            DescartaPocaoHotbar(pocao_slot_drag);
		    }

		    // MENSAGEM DE CONFIRMAÇÃO
		    if(!is_undefined(_pocao_descartada))
		    {
		        CriaMensagem(
		            _lixeira.x + _lixeira.largura / 2,
		            _lixeira.y - 12,
		            "\"" + _pocao_descartada.nome
		                + "\" descartada!",
		            c_orange,
		            "UI"
		        );
				
				obj_lixeira.image_index = 1;
		    }
		}

        // TRANSFERÊNCIAS NORMAIS
        else
        {
            // ORIGEM = ARMÁRIO
            if(
                pocao_inventario_drag == _armario
            )
            {
                // ARMÁRIO → HOTBAR
                if(
                    pocao_inventario_hover == _hotbar
                )
                {
                    TransferePocaoArmarioParaHotbar(
                        pocao_slot_drag,
                        pocao_slot_hover
                    );
                }


                // ARMÁRIO → ARMÁRIO
                else if(
                    pocao_inventario_hover == _armario
                )
                {
                    if(
                        pocao_slot_hover!= pocao_slot_drag
                    )
                    {
                        TrocaPocaoArmario(
                            pocao_slot_drag,
                            pocao_slot_hover
                        );
                    }
                }
            }


            // ORIGEM = HOTBAR
            else if(
                pocao_inventario_drag == _hotbar
            )
            {
                // HOTBAR → HOTBAR
                if(
                    pocao_inventario_hover == _hotbar
                )
                {
                    if(
                        pocao_slot_hover!= pocao_slot_drag
                    )
                    {
                        TrocaPocaoHotbar(
                            pocao_slot_drag,
                            pocao_slot_hover
                        );
                    }
                }


                // HOTBAR → ARMÁRIO
                // PERMITIDO SOMENTE NO ARMÁRIO
                else if(
                    pocao_inventario_hover == _armario
                    && room == rm_armario
                )
                {
                    TransferePocaoHotbarParaArmario(
                        pocao_slot_drag,
                        pocao_slot_hover
                    );
                }


                // HOTBAR → ÁREA VAZIA DO ARMÁRIO
                // PERMITIDO SOMENTE NO ARMÁRIO
                else if(
                    room == rm_armario
                    && instance_exists(_armario)
                    && _armario.AreaSobreMouse(
                        mouse_x,
                        mouse_y
                    )
                )
                {
                    TransferePocaoHotbarParaFimDoArmario(
                        pocao_slot_drag
                    );
                }
            }
        }


        
        // RESET
        

        pocao_inventario_drag = noone;
        pocao_slot_drag = -1;
        pocao_drag = undefined;

        estado = estado_livre;
    }
};

MouseSobreItem = function()
{
	return (
		inventario_hover != -1
		&& slot_hover != -1
		&& inventario_hover.inventario[slot_hover] != -1
	);
}

estado = estado_livre;