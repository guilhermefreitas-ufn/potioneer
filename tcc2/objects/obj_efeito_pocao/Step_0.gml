switch (etapa)
{
    
    case "voando":
    

        tempo_voo++;

        var _progresso = clamp(
            tempo_voo / duracao_voo,
            0,
            1
        );

        // Interpola entre a origem e o destino
        x = x_inicio
            + (x_destino - x_inicio) * _progresso;

        y = y_inicio
            + (y_destino - y_inicio) * _progresso;


        // Chegou ao destino
        if (_progresso >= 1)
        {
            x = x_destino;
            y = y_destino;

            AplicarImpacto();
        }

        break;


    
    case "area":
    

        tempo_area--;

        if (tempo_area <= 0)
        {
            instance_destroy();
            exit;
        }

        break;


    
    case "nao_configurado":
    

        // Evita manter uma instância sem configuração
        instance_destroy();
        exit;

}