//macros
#macro RES_H display_get_gui_height()
#macro RES_W display_get_gui_width()
#macro GAME_SPEED game_get_speed(gamespeed_fps)

//desenha texto com outline
function draw_text_outline(_x, _y, _texto, _corTexto, _corContorno, _offset, _xscale = 1, _yscale = 1, _angle = 0, _sep = -1, _w = -1)
{
	draw_set_color(_corContorno);
	draw_text_ext_transformed(_x - _offset, _y, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x + _offset, _y, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x, _y - _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x, _y + _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x - _offset, _y - _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x + _offset, _y - _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x - _offset, _y + _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	draw_text_ext_transformed(_x + _offset, _y + _offset, _texto, _sep, _w,_xscale,_yscale, _angle);
	
	draw_set_color(_corTexto);
	draw_text_ext_transformed(_x, _y, _texto, _sep, _w,_xscale,_yscale, _angle);
	
	reseta_draw();
}

//define alinhamento de texto
function define_align(_halign = fa_center, _valign = fa_middle)
{
	draw_set_halign(_halign);
	draw_set_valign(_valign);
}

//reseta configs de texto
function reseta_draw()
{
	draw_set_font(-1);
	draw_set_color(-1);
	draw_set_halign(-1);
	draw_set_valign(-1);
	draw_set_alpha(1);
}

//mensagem de objeto não encontrado
function msg_erro(_objeto)
{
	show_debug_message("Erro: "+_objeto+" não encontrado!");
}

//mudando de sprite
function muda_sprite(_sprite)
{
	if(sprite_index != _sprite)
	{
		image_index = 0;
		sprite_index = _sprite;
	}
}

//acabou minha animação
function animation_end()
{
	return image_index >= image_number - 1;
}

//efeito blink
function blink_alpha(_vel, _alpha_min = 0, _alpha_max = 1)
{
	return min(max(sin(get_timer()/(50000/_vel)), _alpha_min), _alpha_max);
}

//verifica se estou numa room de gameplay
function gameplay_room()
{
	return room == rm_01_fazenda
	|| room == rm_02_estrada
	|| room == rm_03_torre
	|| room == rm_04_cerco
	|| room == rm_05_cidade;
}

//cria feedback de duração (relógio estilo gráfico de pizza)
function criar_feedback_duracao(_x, _y, _raio, _duracao, _tempo_restante, _cor, _cor_fundo_contorno, _tam_contorno = 0)
{
	//var _fx = instance_create_layer(_x, _y, "UI", obj_feedback_duracao);
	
	with(instance_create_layer(_x, _y, "UI", obj_feedback_duracao))
	{
		raio = _raio;
		duracao = _duracao;
		tempo_restante = _tempo_restante;
		cor_pizza = _cor;
		cor_fundo_contorno = _cor_fundo_contorno;
		tam_contorno = _tam_contorno;
		pai = other.id;
		
		return id;
	}
}

//trocando de room quando acaba uma sequencia
function fim_cena_goto(_room, _foco_out = noone, _dur_foco_out = 0, _foco_in = noone, _dur_foco_in = 0)
{
	aplica_transicao(_room, _dur_foco_out, _dur_foco_out, _dur_foco_in, _dur_foco_in);
}

//sons
///@function set_song_ingame(_song, _fade_out_current_song, _fade_in)
///@description Toca uma música no jogo, parando a música atual (se houver), com ou sem Fade In / Fade Out.
///@param _song Qualquer música (defina "noone" para parar ou diminuir o volume da faixa atual).
///@param _fade_out_current_song Duração (em frames) do Fade Out da música atual (se está tocando).
///@param _fade_in Duração (em frames) do Fade In do som desejado (se _song != noone).
function set_song_ingame(_song, _fade_out_current_song = 0, _fade_in = 0)
{
	if(instance_exists(obj_mus))
	{
		with(obj_mus)
		{
			target_song_asset = _song;
			end_fade_out_time = _fade_out_current_song;
			start_fade_in_time = _fade_in;
		}
	}
	else
	{
		msg_erro("Gerenciador de Músicas");
	}
}

//contador estilo gráfico de pizza
///@function draw_pie(x1, y1, x2, y2, x3, y3, x4, y4, outline, precision)
///@description Desenha um setor de uma elipse.
///Permite desenhar preenchido ou somente o contorno, usando uma primitiva com resolução limitada.
///O setor é formado por um arco da elipse e por duas linhas ligando o centro aos pontos inicial e final do arco.
///O arco é desenhado na borda da elipse no sentido anti-horário, do ponto inicial ao ponto final.
///O ponto inicial é a interseção entre a elipse e a linha do centro até (x3, y3).
///O ponto final é a interseção entre a elipse e a linha do centro até (x4, y4).
///@param {real} x1 Coordenada X do canto superior esquerdo do retângulo delimitador.
///@param {real} y1 Coordenada Y do canto superior esquerdo do retângulo delimitador.
///@param {real} x2 Coordenada X do canto inferior direito do retângulo delimitador.
///@param {real} y2 Coordenada Y do canto inferior direito do retângulo delimitador.
///@param {real} x3 Coordenada X do ponto que determina o ângulo inicial.
///@param {real} y3 Coordenada Y do ponto que determina o ângulo inicial.
///@param {real} x4 Coordenada X do ponto que determina o ângulo final.
///@param {real} y4 Coordenada Y do ponto que determina o ângulo final.
///@param {bool} outline Desenha apenas o contorno (true).
///@param {real} precision [Opcional] Número de segmentos usados para desenhar a elipse completa (4 — 64, divisível por 4). Padrão: 24.
function draw_pie(x1, y1, x2, y2, x3, y3, x4, y4, outline, precision)
{
	if(argument_count < 10 || precision == 0) { precision = 24; }
	
	var res,xm,ym,xr,yr,r,a1,a2,sx,sy,a;
	res = 360 / min(max(4,4*(precision div 4)),64);
	xm = (x1+x2)/2;
	ym = (y1+y2)/2;
	xr = abs(x2-x1)/2;
	yr = abs(y2-y1)/2;
	if(xr > 0) r = yr/xr; else r = 0;
	
	a1 = point_direction(0,0,(x3-xm)*r,y3-ym);
	a2 = point_direction(0,0,(x4-xm)*r,y4-ym);
	if(a2 < a1) a2 += 360;
	
	if(outline) { draw_primitive_begin(pr_linestrip); }
	else { draw_primitive_begin(pr_trianglefan); }
	
	draw_vertex(xm, ym);
	sx = xm + lengthdir_x(xr, a1);
	sy = ym + lengthdir_y(yr, a1);
	draw_vertex(sx, sy);
	
	for(a = res * (a1 div res + 1); a < a2; a += res)
	{
		sx = xm + lengthdir_x(xr, a);
		sy = ym + lengthdir_y(yr, a);
		draw_vertex(sx, sy);
	}
	
	sx = xm + lengthdir_x(xr, a2);
	sy = ym + lengthdir_y(yr, a2);
	draw_vertex(sx, sy);
	
	if(outline) { draw_vertex(xm, ym); }
	
	draw_primitive_end();
	return 0;
}

//grid
///@function desenha_grid(_tam, _linhas, _colunas, _thickness, _cor, _alpha, _posicao_x, _posicao_y, _origem_x, _origem_y)
///@description Desenha um grid com número definido de linhas e colunas, com pivô e posição controláveis. Caso _origem_x/_origem_y não sejam informados, o pivô padrão é o centro geométrico do grid (meio exato).
///@param {real} _tam Tamanho de cada célula (em pixels)
///@param {real} _linhas Número de linhas do grid
///@param {real} _colunas Número de colunas do grid
///@param {real} _thickness	Espessura das linhas
///@param _cor Cor do grid
///@param {real} _alpha Transparência (0–1)
///@param {real} _posicao_x	Posição X onde o grid será desenhado
///@param {real} _posicao_y	Posição Y onde o grid será desenhado
///@param {real} _origem_x Posição do pivô dentro do grid (em pixels, a partir do canto superior esquerdo)
///@param {real} _origem_y Posição do pivô dentro do grid (em pixels, a partir do canto superior esquerdo)
function desenha_grid(_tam, _linhas, _colunas, _thickness, _cor, _alpha, _posicao_x, _posicao_y, _origem_x = _colunas * _tam * 0.5, _origem_y = _linhas  * _tam * 0.5)
{
	//CÁLCULOS BÁSICOS
	var largura_total = _colunas * _tam;
	var altura_total  = _linhas  * _tam;
	
	//DESENHO DO GRID
	draw_set_color(_cor);
	draw_set_alpha(_alpha);
	
	//Linhas horizontais
	for(var i = 0; i <= _linhas; i++)
	{
		var _y = _posicao_y - _origem_y + i * _tam;
		draw_line_width(
			_posicao_x - _origem_x,
			_y,
			_posicao_x - _origem_x + largura_total,
			_y,
			_thickness
		);
	}
	
	//Linhas verticais
	for(var j = 0; j <= _colunas; j++)
	{
		var _x = _posicao_x - _origem_x + j * _tam;
		draw_line_width(
			_x,
			_posicao_y - _origem_y,
			_x,
			_posicao_y - _origem_y + altura_total,
			_thickness
		);
	}
	
	//RESTAURA CONFIGURAÇÕES
	reseta_draw();
}
