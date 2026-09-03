estado();

if(click_animando)
{
	click_anim_tempo++;
	
	if(click_anim_tempo >= click_anim_duracao)
	{
		click_animando = false;
		click_anim_item = -1;
	}
}