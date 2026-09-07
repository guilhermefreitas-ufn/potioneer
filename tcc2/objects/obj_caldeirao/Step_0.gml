//debug
if(global.debug)
{
	//pegando teclas
	var _backspace = keyboard_check_pressed(vk_backspace);
	var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));

	if(_backspace)
	{
		LimpaCaldeirao();
	}
	
	if(_1)
	{
		//verificando se existe o item 1 (lagrima) no inventario
		var _resultado = (ProcuraInventario(id,1) != -1) ? "tem item 1" : "nao tem item 1"

		show_debug_message(string(object_index)+" "+_resultado);
	}
}