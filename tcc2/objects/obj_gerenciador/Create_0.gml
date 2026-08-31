randomize();
global.debug = true;

//Ingredientes
global.Ingredientes =
[
	CriarIngrediente(0, "if",       spr_placeholder_32,	TipoIngrediente.CONDICIONAL),
	CriarIngrediente(1, "hp",		spr_amarelo,		TipoIngrediente.VARIAVEL),
	CriarIngrediente(2, "spd",		spr_azul,			TipoIngrediente.VARIAVEL),
	CriarIngrediente(3, "atk",		spr_branco,			TipoIngrediente.VARIAVEL),
	CriarIngrediente(4, "decreases",spr_ing_folha,		TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(5, "increases",spr_ing_sol,		TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(6, "becomes",	spr_ciano,			TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(7, "greater",  spr_ing_lagrima,	TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(8, "lower",    spr_ing_fogo,		TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(9, "equal",	spr_magenta,		TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(10, "int",     spr_ing_osso,		TipoIngrediente.PRIMITIVO),
	CriarIngrediente(11, "target",  spr_verde,			TipoIngrediente.ALVO),
	CriarIngrediente(12, "ally",    spr_vermelho,		TipoIngrediente.ALVO),
	CriarIngrediente(13, "enemy",   spr_ing_estrela,	TipoIngrediente.ALVO)
];