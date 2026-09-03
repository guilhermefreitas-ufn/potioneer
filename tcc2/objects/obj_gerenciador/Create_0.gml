//aleatorizando
randomize();

//debug
global.debug = true;

//Cadastro de Ingredientes
global.Ingredientes =
[
	CriarIngrediente(0, "if",       spr_ing_cubo,		TipoIngrediente.CONDICIONAL),
	CriarIngrediente(1, "int",		spr_ing_osso,		TipoIngrediente.PRIMITIVO),
	CriarIngrediente(2, "hp",		spr_ing_chifre,		TipoIngrediente.VARIAVEL),
	CriarIngrediente(3, "spd",		spr_ing_crina,		TipoIngrediente.VARIAVEL),
	CriarIngrediente(4, "atk",		spr_ing_alma,		TipoIngrediente.VARIAVEL),
	CriarIngrediente(5, "decreases",spr_ing_folha,		TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(6, "increases",spr_ing_sol,		TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(7, "becomes",	spr_ing_nadadeira,	TipoIngrediente.OPERADOR_EFEITO),
	CriarIngrediente(8, "greater",  spr_ing_lagrima,	TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(9, "lower",    spr_ing_fogo,		TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(10, "equal",	spr_ing_olho,		TipoIngrediente.OPERADOR_COMPARACAO),
	CriarIngrediente(11, "target",  spr_ing_mandragora,	TipoIngrediente.ALVO),
	CriarIngrediente(12, "ally",    spr_ing_escama,		TipoIngrediente.ALVO),
	CriarIngrediente(13, "enemy",   spr_ing_estrela,	TipoIngrediente.ALVO)
	//,CriarIngrediente(14, "while", spr_ing_lua, TipoIngrediente.CONDICIONAL)
];