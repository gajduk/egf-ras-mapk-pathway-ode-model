function dx = ode_model(t,x,kin)

u = x(1);
up = x(2);

p = x(3);
pa = x(4);

k_cat_kin = 1;
Km1 = 200;

v_kin = kin * k_cat_kin * u / ( Km1 + u );

k_cat_phos = 1;
Km2 = 200;

v_phos =  pa * k_cat_phos * up / ( Km2 + up );

k_cat_act = 10;
Km3 = 20;

v_act = k_cat_act * p / ( Km3 + p );

k_cat_de = 1;
Km4 = 10;
de = 200;
A = 5;
Ka = 1;

v_de = k_cat_de*pa/(pa+Km4) * (1+A*up/Ka)/(1+up/Ka);

dx = [ v_phos-v_kin ; v_kin-v_phos ; v_de-v_act ; v_act-v_de ];

end

