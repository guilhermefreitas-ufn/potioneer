//debug
if(global.debug)
{
	//pegando teclas
	var _enter = keyboard_check_pressed(vk_enter);
	var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));

	if(_enter)
	{
		//adicionando itens 0 e 13 no inventario
		//AdicionaInventario(id,irandom(13));
		for(var i = 0; i <= 13; i++)
		{
			for(var j = 0; j < 10; j++)
			{
				AdicionaInventario(id,i);
			}
		}
	}
	if(_1)
	{
		//verificando se existe o item 1 (lagrima) no inventario
		var _resultado = (ProcuraInventario(id,1) != -1) ? "tem item 1" : "nao tem item 1"

		show_debug_message(string(object_index)+" "+_resultado);
	}
}