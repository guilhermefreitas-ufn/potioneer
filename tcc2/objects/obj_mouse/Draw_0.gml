// ANIMAÇÃO DO CLICK
if(click_animando && click_anim_item != -1)
{
    var _t = click_anim_tempo / click_anim_duracao;

    var _xx = lerp(
        click_anim_x,
        click_anim_dest_x,
        _t
    );

    var _yy = lerp(
        click_anim_y,
        click_anim_dest_y,
        _t
    );

    draw_set_alpha(0.5);

    draw_sprite(
        global.Ingredientes[click_anim_item].sprite,
        0,
        _xx,
        _yy
    );

    draw_set_alpha(1);
}