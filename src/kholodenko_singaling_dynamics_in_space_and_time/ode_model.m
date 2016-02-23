function dx = ode_model(t,x)

M = x(1);
Mp = x(2);
E_kin = x(3);

k_cat_kin = 1;
A = 100;
Ka = 500;
Km1 = 500;

v_kin = k_cat_kin *E_kin * M/(Km1+M) * (1+A*Mp/Ka) / (1+Mp/Ka);

k_cat_phos = 1;
Km2 = 10;
E_phos = 200;

v_phos = k_cat_phos * E_phos * Mp / (Km2+Mp);

V0_kin = 150;
KI = 100;
I = 7.5;

v_synth_kin = V0_kin * (1+Mp/KI) / ( 1 + I * Mp / KI );

k_deg_kin = 1;

v_deg_kin = k_deg_kin * E_kin;

dx = [v_phos-v_kin;v_kin-v_phos;v_synth_kin-v_deg_kin];

end
