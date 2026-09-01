//se não tem caldeirão na room, não executo nada
if(caldeirao = noone) { exit; }

//atualizando a sentença (frase) em tempo real conforme as mudanças no caldeirão
var _resultado = InterpretarCaldeirao(caldeirao);

tokens = _resultado.tokens;
sentenca = _resultado.sentenca;

algoritmo = _resultado.algoritmo;

sintaxe_valida = _resultado.sintaxe_valida;
semantica_valida = _resultado.semantica_valida;

erro_sintaxe = _resultado.erro_sintaxe;
erro_semantica = _resultado.erro_semantica;

slot_erro = _resultado.slot_erro;