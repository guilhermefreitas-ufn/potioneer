//sprites HD
var _sprites = [
	#region Ingredientes
	spr_cubo_hd,
	spr_aconito_hd,
	spr_asa_hd,
	spr_cogumelo_hd,
	spr_crina_hd,
	spr_dente_hd,
	spr_escama_azul_hd,
	spr_escama_roxa_hd,
	spr_escama_vermelha_hd,
	spr_fruta_hd,
	spr_lagrima_hd,
	spr_mao_hd,
	spr_olho_hd,
	spr_prata_hd,
	spr_raiz_hd,
	#endregion
	
	spr_bg_inventarios,
	spr_caldeirao
];

if(room != rm_inventarios)
{
	//adiciona outros sprites
}

sprite_prefetch_multi(_sprites);