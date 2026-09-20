var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));
var _2 = keyboard_check_pressed(vk_numpad2) || keyboard_check_pressed(ord("2"));

//testando poções
if(_1)
{
	ExecutaPocaoTeste(1);
}
if(_2)
{
	ExecutaPocaoTeste(2);
}