if(!instance_exists(obj_player))
{
    exit;
}

//define limites
var limite_max = 1;
var limite_min = min_percent;

//define modulação proporcional
var tam_modificador = tam_mod;

//pulsação
if(pulsa)
{
	if(diminuir)
	{
		escala_pulso = max(escala_pulso - tam_modificador, limite_min);
		
		if(escala_pulso <= limite_min)
		{
			diminuir = false;
		}
	}
	else
	{
		escala_pulso = min(escala_pulso + tam_modificador, limite_max);
		
		if(escala_pulso >= limite_max)
		{
			diminuir = true;
		}
	}
}

//aplica a escala proporcional nos dois eixos
image_xscale = tam_x * escala_pulso;
image_yscale = tam_y * escala_pulso;

var _player = instance_find(
    obj_player,
    0
);

var _centro = _player.CentroPlayer();

// VERIFICA A SOBREPOSIÇÃO DOS BBOX
// Adiciona uma margem para facilitar a coleta.
var _margem_coleta = 8;

var _fora_do_alcance = (
    bbox_right < _player.bbox_left - _margem_coleta
    || bbox_left > _player.bbox_right + _margem_coleta
    || bbox_bottom < _player.bbox_top - _margem_coleta
    || bbox_top > _player.bbox_bottom + _margem_coleta
);

if(_fora_do_alcance)
{
    exit;
}

// MENSAGEM 
CriaMensagem(
	x,
	y,
    nome + " encontrado!"
);

//me removo da lista possivel
var _indice = array_get_index(global.ingredientes_finais,nome);
	
//Procura o índice do ingrediente para remover
//Se foi encontrada (o índice será diferente de -1)
if (_indice != -1)
{
	//remove ele
    array_delete(global.ingredientes_finais, _indice, 1);
}

global.ing_finais_coletados += 1;

//me destruo
instance_destroy();