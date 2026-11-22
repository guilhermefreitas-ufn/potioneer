//ESTADO DO BAÚ
aberto = false;
sumir = false;
itens_droppados = false;

//CONFIGURAÇÕES DOS DROPS
escala_drop = ESCALA_BASE * 0.5;
tamanho_celula_drop = CELL_T;


//DISTÂNCIA NECESSÁRIA PARA ABRIR O BAÚ
distancia_abertura = 64;

//ESPECIAL
if(!variable_instance_exists(id, "especial"))
{
	especial = false;
}

//DEFINE O SPRITE
sprite_index = especial
	? spr_bau_especial
	: spr_bau;

//CENTRO DO BAÚ
cx = (bbox_left + bbox_right) / 2;
cy = (bbox_top + bbox_bottom) / 2;

//DROP
Dropar = function(_especial = especial)
{
	if(!_especial)
	{
		DropaIngredientes(
			irandom_range(3, 5),
			"Cubo",
			"Cubo",
			id,
			escala_drop,
			tamanho_celula_drop
		);
	}
	
	if(_especial)
	{
		//VERIFICO SE EXISTEM INGREDIENTES DISPONÍVEIS
		if(array_length(global.ingredientes_finais) > 0)
		{
			//SORTEIO UM ÍNDICE ALEATÓRIO
			var _indice = irandom(array_length(global.ingredientes_finais) - 1);
			
			//RECUPERO O INGREDIENTE
			var _ingrediente = global.ingredientes_finais[_indice];
			
			//CRIO O COLETÁVEL
			with(instance_create_layer(cx, cy, layer, obj_coletavel_final))
			{
				nome = _ingrediente.nome;
				sprite_index = _ingrediente.sprite;
				tam_x = .5;
				tam_y = .5;
			}
		}
	}
};

//ANIMAÇÃO
image_speed = 0;
image_index = 0;
image_alpha = 1;