if(global.pause)
{
	MudaEstado("parado");
	exit;
}

//controlando o alpha do hit flash
if(alpha > 0)
{
	alpha -= 0.1;
}
else
{
	alpha = 0;
}

//controlando minhas condições
//HP
if(hp == MAX_HP)
{
	var _indice = array_get_index(condicao,"Revigorado");
	
	//se to com a vida cheia
	//ainda não to com a condição Revigorado
	if(_indice == -1)
	{
		//adiciono a condição revigorado
		array_push(condicao,"Revigorado");
	}
}
else //se não
{
	var _indice = array_get_index(condicao,"Revigorado");
	
	//Procura o índice da condição para remover
	//Se foi encontrada (o índice será diferente de -1)
	if (_indice != -1)
	{
		//remove ela
	    array_delete(condicao, _indice, 1);
	}
}

//SPD
if(spd == MAX_SPD)
{
	var _indice = array_get_index(condicao, "Acelerado");
	
	//se to com Velocidade máxima
	//se ainda não adicionei a condição Acelerado
	if(_indice == -1)
	{
		//adiciono a condição
		array_push(condicao, "Acelerado");
	}
}
//se não, se to com Velocidade 0 (zero)
else if(spd == 0)
{
	var _indice = array_get_index(condicao, "Paralisado");
	
	//se ainda não adicionei a condição Paralisado
	if(_indice == -1)
	{
		array_push(condicao, "Paralisado");
	}
}
//se minha Velocidade não é máxima nem 0 (zero)
else
{
	//Removo as condições de Velocidade
	var _indice_ace = array_get_index(condicao, "Acelerado");
	var _indice_par = array_get_index(condicao, "Paralisado");
	
	//Procura o índice da condição para remover
	//Se foi encontrada (o índice será diferente de -1)
	if (_indice_ace != -1)
	{
		//remove ela
	    array_delete(condicao, _indice_ace, 1);
	}
	
	//Procura o índice da condição para remover
	//Se foi encontrada (o índice será diferente de -1)
	if (_indice_par != -1)
	{
		//remove ela
	    array_delete(condicao, _indice_par, 1);
	}
}

//ATK
//Se to com Força 0 (zero)
if(atk == 0)
{
	//se ainda não adicionei a condição Enfraquecido
	var _indice = array_get_index(condicao, "Enfraquecido");
	
	if(_indice == -1)
	{
		//adiciono ela
		array_push(condicao, "Enfraquecido");
	}
}
//se não to com Força 0
else
{
	//Procura o índice da condição para remover
	var _indice = array_get_index(condicao, "Enfraquecido");
	
	//Se foi encontrada (o índice será diferente de -1)
	if (_indice != -1)
	{
		//remove ela
	    array_delete(condicao, _indice, 1);
	}
}