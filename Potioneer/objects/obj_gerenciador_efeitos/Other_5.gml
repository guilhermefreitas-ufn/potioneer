for (var i = array_length(emissores) - 1; i >= 0; i--)
{
    if(!emissores[i].persistir_room)
    {
        array_delete(emissores, i, 1);
    }
}

estrelas = [];
part_particles_clear(ps_baixo);
part_particles_clear(ps_cima);
part_particles_clear(ps_poeira);
shake_forca = 0;
view_xport[0] = 0;
view_yport[0] = 0;