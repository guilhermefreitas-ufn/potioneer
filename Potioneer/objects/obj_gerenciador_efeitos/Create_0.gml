if(instance_number(object_index) > 1)
{
    instance_destroy();
    exit;
}

persistent = true;
depth = -5000; //Garante que o Draw Event das estrelas fique acima dos objetos


//1. DOIS SISTEMAS DE PARTÍCULAS

depth_baixo = 150;
ps_baixo = part_system_create();
part_system_depth(ps_baixo, depth_baixo);    //Acima do chão (depth 100+) e abaixo do caldeirão/player (depth <= 0)

depth_poeira = 150;
ps_poeira = part_system_create();
//part_system_depth(ps_poeira, depth_poeira);

atualizar_depth_chao = function()
{
    if (!instance_exists(obj_entidade)) return;

    var _maior_depth = -10000000;
    with (obj_entidade)
    {
        if (depth > _maior_depth)
        {
            _maior_depth = depth;
        }
    }

    var _nova_depth = _maior_depth + 1;
    if (depth_poeira != _nova_depth)
    {
        depth_poeira = _nova_depth;
        part_system_depth(ps_poeira, depth_poeira);
    }
};

ps_cima = part_system_create();
part_system_depth(ps_cima, -5000);  //Acima de tudo (tocha, bolhas do caldeirão e fumaça)

//--- PARTÍCULA 1: EXPLOSÃO DE FUMAÇA (Mais espalhada) ---
pt_fumaca = part_type_create();
part_type_shape(pt_fumaca, pt_shape_cloud);
part_type_size(pt_fumaca, 0.35, 0.75, 0.022, 0);
part_type_speed(pt_fumaca, 5.0, 11.0, -0.16, 0); //Velocidade maior e freia mais suave
part_type_direction(pt_fumaca, 0, 360, 0, 0);
part_type_gravity(pt_fumaca, 0.04, 90);
part_type_orientation(pt_fumaca, 0, 360, 1.5, 0, false);
part_type_color3(pt_fumaca, c_white, c_ltgray, c_dkgray);
part_type_alpha3(pt_fumaca, 0.9, 0.6, 0);
part_type_blend(pt_fumaca, false);
part_type_life(pt_fumaca, 60, 120);

//--- PARTÍCULA 2: RASTRO DE POEIRA ---
pt_poeira = part_type_create();
part_type_shape(pt_poeira, pt_shape_smoke);
part_type_size(pt_poeira, 0.08, 0.15, 0.004, 0);
part_type_speed(pt_poeira, 0.15, 0.5, -0.02, 0);
part_type_direction(pt_poeira, 0, 360, 0, 0);
part_type_gravity(pt_poeira, 0.015, 90);
part_type_color2(pt_poeira, c_white, c_ltgray);
part_type_alpha3(pt_poeira, 0.55, 0.3, 0);
part_type_blend(pt_poeira, false);
part_type_life(pt_poeira, 12, 20);

//--- PARTÍCULA 3: FOGO DE TOCHA ---
pt_tocha = part_type_create();
part_type_shape(pt_tocha, pt_shape_sphere);
part_type_size(pt_tocha, 0.22, 0.36, -0.01, 0);
part_type_speed(pt_tocha, 1.0, 1.9, 0, 0);
part_type_direction(pt_tocha, 80, 100, 0, 14);
part_type_color3(pt_tocha, c_yellow, c_orange, c_red);
part_type_alpha3(pt_tocha, 0.95, 0.8, 0);
part_type_blend(pt_tocha, false);
part_type_life(pt_tocha, 18, 26);

//--- PARTÍCULA 4: FOGO BOCA DE FOGÃO (TOP-DOWN) ---
pt_fogao = part_type_create();
part_type_shape(pt_fogao, pt_shape_sphere);
var _azul_claro = make_color_rgb(110, 225, 255);
var _azul_gas   = make_color_rgb(25, 130, 255);
part_type_size(pt_fogao, 0.30, 0.45, -0.012, 0);
part_type_speed(pt_fogao, 2.2, 3.2, -0.07, 0); //Alcance suficiente para sair ao redor do caldeirão
part_type_color3(pt_fogao, _azul_claro, _azul_gas, c_orange);
part_type_alpha3(pt_fogao, 0.95, 0.75, 0);
part_type_blend(pt_fogao, false);
part_type_life(pt_fogao, 14, 20);

//--- PARTÍCULA 5: BOLHAS TOP-DOWN (Translúcidas) ---
pt_bolha = part_type_create();
part_type_shape(pt_bolha, pt_shape_ring);
part_type_size(pt_bolha, 0.07, 0.13, 0.014, 0);
part_type_speed(pt_bolha, 0, 0.08, 0, 0);
part_type_direction(pt_bolha, 0, 360, 0, 0);
part_type_alpha3(pt_bolha, 0.12, 0.32, 0);
part_type_blend(pt_bolha, false);
part_type_life(pt_bolha, 14, 22);

//--- PARTÍCULA 6: SPLASH POÇÃO (POÇA LÍQUIDA NO CHÃO) ---
pt_splash_poca = part_type_create();
part_type_shape(pt_splash_poca, pt_shape_disk);
part_type_speed(pt_splash_poca, 0, 0, 0, 0);
part_type_alpha3(pt_splash_poca, 0.45, 0.35, 0);
part_type_blend(pt_splash_poca, false);

//--- PARTÍCULA 7: SPLASH POÇÃO (ANEL DE ONDA LÍQUIDA) ---
pt_splash_anel = part_type_create();
part_type_shape(pt_splash_anel, pt_shape_ring);
part_type_speed(pt_splash_anel, 0, 0, 0, 0);
part_type_alpha3(pt_splash_anel, 0.85, 0.45, 0);
part_type_blend(pt_splash_anel, false);
part_type_life(pt_splash_anel, 14, 18);

//--- PARTÍCULA 8: SPLASH POÇÃO (GOTÍCULAS ESPIRRADANDO) ---
pt_splash_gota = part_type_create();
part_type_shape(pt_splash_gota, pt_shape_sphere);
part_type_size(pt_splash_gota, 0.14, 0.30, -0.008, 0);
part_type_direction(pt_splash_gota, 0, 360, 0, 0);
part_type_alpha3(pt_splash_gota, 0.95, 0.8, 0);
part_type_blend(pt_splash_gota, false);
part_type_life(pt_splash_gota, 16, 26);

//--- PARTÍCULA 9: SPLASH POÇÃO (ESTILHAÇOS DE VIDRO) ---
pt_splash_vidro = part_type_create();
part_type_shape(pt_splash_vidro, pt_shape_spark);
part_type_size(pt_splash_vidro, 0.12, 0.24, -0.006, 0);
part_type_speed(pt_splash_vidro, 3.0, 7.5, -0.25, 0);
part_type_direction(pt_splash_vidro, 0, 360, 0, 0);
part_type_orientation(pt_splash_vidro, 0, 360, 12, 0, false);
part_type_alpha3(pt_splash_vidro, 1, 0.7, 0);
part_type_blend(pt_splash_vidro, true);
part_type_life(pt_splash_vidro, 12, 20);


//2. SCREENSHAKE, EMISSORES E ESTRELAS 3D

shake_forca = 0;
shake_decay = 0.88;

emissores = [];
estrelas = [];
spr_estrela = asset_get_index("spr_efeito_estrela"); //Usa seu sprite se existir, ou desenha estrela vetorial