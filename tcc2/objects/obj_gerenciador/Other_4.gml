//if(room == rm_masmorra)
//{
//	//FASES 5, 10, 15, 20...
//	if(global.fase % 5 == 0 && global.fase != 0) //chefão
//	{
//		//a saída NÃO leva para um chefão
//		global.chefe = false;
	
//		//aumento em 1 a quantidade de inimigos
//		global.qtd_inimigo += 1;
//	}
	
//	//FASES 4, 8, 12, 16...
//	else if(global.fase % 4 == 0 && global.fase != 0)
//	{
//		//a saída LEVA para um chefão
//		global.chefe = true;
	
//		//aumento a quantidade de baú
//		global.qtd_bau += 1;
//	}
	
//	//FASES 3, 9, 18, 21...
//	else if(global.fase % 3 == 0 && global.fase != 0)
//	{
//		//SE AINDA NÃO ADICIONEI O MORCEGO
//		var _indice = array_get_index(global.tipo_inimigo,obj_ini_morcego);
	
//		if(_indice == -1)
//		{
//			//adiciono ele
//			array_push(global.tipo_inimigo,obj_ini_morcego);
//		}
	
//		//aumento em 1 a quantidade de inimigos
//		global.qtd_inimigo += 1;
//	}
	
//	//FASES 2, 6, 14, 22...
//	else if(global.fase % 2 == 0 && global.fase != 0)
//	{
	
//	}
	
//	//DEMAIS FASES
//	else
//	{
//		//SE AINDA NÃO ADICIONEI A SANGUESSUGA
//		var _indice = array_get_index(global.tipo_inimigo,obj_ini_sanguessuga);
	
//		if(_indice == -1)
//		{
//			//adiciono ela
//			array_push(global.tipo_inimigo,obj_ini_sanguessuga);
//		}
	
//		//aumento em 1 a quantidade de inimigos
//		global.qtd_inimigo += 1;
//	}
//}