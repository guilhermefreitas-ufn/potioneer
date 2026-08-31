//pegando o número individual de cada objeto "salvável"
var _real_num = instance_number(obj_block_real);

var _room_struct =
{
	real_num : _real_num,
	real_dados : array_create(_real_num)
}

//pegando os dados de diferentes objetos "salváveis"
	//BLOCOS NO CALDEIRÃO
	for(var i = 0; i < _real_num; i++)
	{
		var _inst = instance_find(obj_block_real, i);
		
		_room_struct.real_dados[i] = 
		{
			//x				: _inst.x,
			//y				: _inst.y,
			//estado		: _inst.estado,
			//velh			: _inst.velh,
			//velv			: _inst.velv,
			//cd_atk		: _inst.cd_atk,
			//timer_estado	: _inst.timer_estado,
			//dei_dano		: _inst.dei_dano,
			//vida_atual	: _inst.vida_atual,
			//dano			: _inst.dano,
			//xscale		: _inst.xscale,
			//image_index	: _inst.image_index,
			//image_alpha	: _inst.image_alpha,
		};
	}