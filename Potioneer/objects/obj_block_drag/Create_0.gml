pai = noone;
posso_criar = false;
nome = "";
//set = RealIng(nome);
var _ing = IngredientePorToken(nome);
set = _ing.obj_real;

if(global.debug) { show_debug_message("dragged foi criado"); }