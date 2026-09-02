//numero de colunas
colunas = 4;

//usando macro para número de slots
inventario = array_create(SLOTS_INVENTARIO, -1); //deixando os slots vazios (-1) 

//quantidade de cada item em cada slot
quantidades = array_create(SLOTS_INVENTARIO, 0);

//Quantidade de slots atualmente visíveis
slots_ativos = 1;

//é caldeirão?
caldeirao = true;