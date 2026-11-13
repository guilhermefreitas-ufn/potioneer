// CONFIGURAÇÕES DA INTERFACE
var _margem = 28;
var _espaco_colunas = 24;
var _largura_coluna = (RES_W - (_margem * 2) - _espaco_colunas) / 2;

var _x_esq = _margem;
var _x_dir = _margem + _largura_coluna + _espaco_colunas;

var _y_esq = 54;
var _y_dir = 54;

var _texto = "";
var _altura = 0;

draw_set_font(fnt_media_black);

// FUNDO
draw_set_alpha(0.92);
draw_set_color(make_color_rgb(18, 20, 28));
draw_rectangle(12, 8, RES_W - 12, RES_H - 8, false);
draw_set_alpha(1);

// TÍTULO
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);

draw_text(RES_W / 2, 18, "COMO JOGAR");

draw_set_halign(fa_left);

// COLUNA ESQUERDA
// CONTROLES
draw_set_color(c_yellow);
draw_text(_x_esq, _y_esq, "CONTROLES");

_y_esq += 20;

draw_set_color(c_white);

_texto =
    "- W, A, S, D: movimentar o personagem.\n" +
    "- Mouse clique esquerdo: arremessar uma poção na direção do cursor.\n" +
    "- Mouse clique direito: quebrar uma poção aos pés do personagem.\n" +
    "- Espaço: entrar nos alçapões.";

draw_text_ext(_x_esq, _y_esq, _texto, -1, _largura_coluna);

_y_esq += string_height_ext(_texto, -1, _largura_coluna) + 14;

// OBJETIVO
draw_set_color(c_yellow);
draw_text(_x_esq, _y_esq, "OBJETIVO");

_y_esq += 20;

draw_set_color(c_white);

_texto =
    "Explore as masmorras e colete os 5 ingredientes raros. " +
    "Eles podem ser encontrados nos baús azuis.";

draw_text_ext(_x_esq, _y_esq, _texto, -1, _largura_coluna);

_y_esq += string_height_ext(_texto, -1, _largura_coluna) + 14;

// SALVAMENTO AUTOMÁTICO
draw_set_color(c_yellow);
draw_text(_x_esq, _y_esq, "SALVAMENTO AUTOMÁTICO");

_y_esq += 20;

draw_set_color(c_white);

_texto =
    "O jogo salva seu progresso automaticamente somente quando você avança para o próximo nível após coletar um ingrediente raro em um baú azul. Esse é o único momento em que o salvamento acontece.";

draw_text_ext(_x_esq, _y_esq, _texto, -1, _largura_coluna);

_y_esq += string_height_ext(_texto, -1, _largura_coluna) + 14;


// CONSTRUÇÃO DE POÇÕES
draw_set_color(c_yellow);
draw_text(_x_esq, _y_esq, "CONSTRUÇÃO DE POÇÕES");

_y_esq += 20;

draw_set_color(c_white);

_texto =
    "Cada poção é formada por duas partes:\n\n" +
    "- CONDIÇÃO: valor + comparador + valor.\n" +
    "- EFEITO: valor + operador + valor.\n\n" +
    "A condição determina quando o efeito será executado.";

draw_text_ext(_x_esq, _y_esq, _texto, -1, _largura_coluna);

// COLUNA DIREITA
// ELEMENTOS DA POÇÃO
draw_set_color(c_yellow);
draw_text(_x_dir, _y_dir, "INGREDIENTES DA POÇÃO");

_y_dir += 20;

draw_set_color(c_white);

_texto =
    "COMPARADOR: igual a (equal), maior que (greater) ou menor que (lower).\n\n" +
    "OPERADOR: torna-se (becomes), diminui em (decreases) ou aumenta em (increases).\n\n" +
    "VALOR: valor inteiro (int) ou atributo + alvo.\n\n" +
    "ATRIBUTO: força (atk), velocidade (spd) ou saúde (hp).\n\n" +
    "ALVO: alvo (target), inimigo (enemy) ou aliado (ally)*. " +
    "*Por enquanto, aliado representa apenas o personagem do jogador.";

draw_text_ext(_x_dir, _y_dir, _texto, -1, _largura_coluna);

_y_dir += string_height_ext(_texto, -1, _largura_coluna) + 14;

// EXEMPLO DE POÇÃO
draw_set_color(c_yellow);
draw_text(_x_dir, _y_dir, "EXEMPLO DE POÇÃO");

_y_dir += 20;

draw_set_color(c_white);

_texto =
    "SENTENÇA:\n" +
    "Se saúde inimigo maior que 0, então saúde inimigo torna-se velocidade inimigo.\n\n" +

    "CONDIÇÃO:\n" +
    "[Saúde inimigo] [maior que] [0]\n\n" +

    "EFEITO:\n" +
    "[Saúde inimigo] [torna-se] [Velocidade inimigo]\n\n" +

    "INTERPRETAÇÃO:\n" +
    "Ao atingir um inimigo, a poção verifica se sua saúde é maior que zero. Se for, sua saúde passa a ter o mesmo valor da sua velocidade.";

draw_text_ext(_x_dir, _y_dir, _texto, -1, _largura_coluna);

// DIVISÓRIA ENTRE AS COLUNAS
draw_set_alpha(0.4);
draw_set_color(c_gray);
draw_line(RES_W / 2, 48, RES_W / 2, RES_H - 20);
draw_set_alpha(1);

// RESTAURAR CONFIGURAÇÕES DE DESENHO
reseta_draw();

// BOTÃO
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var _x = botao_margem;
var _y = RES_H
		- botao_altura
		- botao_margem;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _hover = point_in_rectangle(
	_mx,
	_my,
	_x,
	_y,
	_x + botao_largura,
	_y + botao_altura
);

//FUNDO
if(_hover)
{
	draw_set_color(c_ltgray);
}
else
{
	draw_set_color(c_dkgray);
}

draw_rectangle(
	_x,
	_y,
	_x + botao_largura,
	_y + botao_altura,
	false
);

//BORDA
draw_set_color(c_black);

draw_rectangle(
	_x,
	_y,
	_x + botao_largura,
	_y + botao_altura,
	true
);

//TEXTO
draw_set_color(c_white);
draw_set_font(fnt_media_black);

var _texto_botao = "VOLTAR";
//if(room == rm) { _texto = "VOLTAR AO CALDEIRÃO"; }
var _texto_largura = string_width(_texto_botao);
var _offset_y = 6;

draw_text(
	_x + (botao_largura - _texto_largura) / 2,
	_y + _offset_y,
	_texto_botao
);

reseta_draw();

// FAZENDO BOTÃO FUNCIONAR
if(
	mouse_check_button_pressed(mb_left)
	&& point_in_rectangle(
		_mx,
		_my,
		_x,
		_y,
		_x + botao_largura,
		_y + botao_altura
	)
)
{
	if(room == rm_tutorial)
	{
		aplica_transicao(rm_menu);
	}
	else
	{
		instance_destroy();
	}
}