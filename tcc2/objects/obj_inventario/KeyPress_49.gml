//verificando se existe o item 1 (lagrima) no inventario
var _resultado = (ProcuraInventario(id,1) != -1) ? "tem item 1" : "nao tem item 1"

show_debug_message(_resultado);