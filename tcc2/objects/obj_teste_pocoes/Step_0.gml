var _1 = keyboard_check_pressed(vk_numpad1) || keyboard_check_pressed(ord("1"));
var _2 = keyboard_check_pressed(vk_numpad2) || keyboard_check_pressed(ord("2"));
var _3 = keyboard_check_pressed(vk_numpad3) || keyboard_check_pressed(ord("3"));
var _4 = keyboard_check_pressed(vk_numpad4) || keyboard_check_pressed(ord("4"));
var _5 = keyboard_check_pressed(vk_numpad5) || keyboard_check_pressed(ord("5"));

//testando poções
if(_1)
{
	ExecutaPocaoTeste(1);
}
if(_2)
{
	ExecutaPocaoTeste(2);
}
if(_3)
{
	ExecutaPocaoTeste(3);
}
if(_4)
{
	ExecutaPocaoTeste(4);
}
if(_5)
{
	ExecutaPocaoTeste(5);
}