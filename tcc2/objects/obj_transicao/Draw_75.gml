//Só desenha se a transição estiver ativa
//O estado 0 (NONE) deve ser ignorado.
if(state == 0) { exit; }

//Garante que a surface existe
var _surf_w = RES_W;
var _surf_h = RES_H;

if(
	!surface_exists(global.iris_surface)
	|| surface_get_width(global.iris_surface) != _surf_w
	|| surface_get_height(global.iris_surface) != _surf_h
)
{
	if(surface_exists(global.iris_surface))
	{
		surface_free(global.iris_surface);
	}
	global.iris_surface = surface_create(_surf_w, _surf_h);
}

//1. Desenha a Máscara na Surface
surface_set_target(global.iris_surface);
{
	//A. Limpa a surface, preenchendo-a de preto
	draw_set_color(c_black);
	draw_rectangle(0, 0, _surf_w, _surf_h, false);
	
	//B. Mapeia a posição do player (center_x, center_y) para as coordenadas da GUI (0, 0 até _surf_w, _surf_h)
	var _gui_x = center_x - camera_get_view_x(view_camera[0]);
	var _gui_y = center_y - camera_get_view_y(view_camera[0]);
	
	//C. Usa o modo de mistura bm_subtract
	//Desenhar branco sobre preto resulta em transparente (o "buraco" do círculo).
	gpu_set_blendmode(bm_subtract);
	
	draw_set_color(c_white);
	draw_circle(_gui_x, _gui_y, radius, false);
	
	//D. Retorna ao modo de mistura normal
	gpu_set_blendmode(bm_normal);
}
surface_reset_target();

//2. Desenha a Surface na Tela
draw_surface(global.iris_surface, 0, 0);