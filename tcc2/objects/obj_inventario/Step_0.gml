if(global.debug)
{
	//debug
	var _backspace = keyboard_check_pressed(vk_backspace);
	var _enter = keyboard_check_pressed(vk_enter);
	var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));

	if(_backspace)
	{
		//removendo item 1 do inventario
		RemoveInventario(id,1);
	}
	if(_enter)
	{
		//adicionando itens 0 e 1 no inventario
		AdicionaInventario(id,irandom(1));
	}
	if(_1)
	{
		//verificando se existe o item 1 (lagrima) no inventario
		var _resultado = (ProcuraInventario(id,1) != -1) ? "tem item 1" : "nao tem item 1"

		show_debug_message(_resultado);
	}

}