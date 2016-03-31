function dx = ode_model(t,x,kin,A,noise_level)
% A system of two proteins u and p
% u is activated/phosphorylated by a kinase with a rate ``kin''
% and deactivated/dephosphorylated by a a phosphatase ``p''
% The phosphatase ``p'' is activated with constant rate, and deactivated by
% variable rate which depends on the concentration of phosphorulated ``p''
% and ``A'' - if A == 1 then there is no dependence, for A > 1 there is a
% negative feedback, for A < 1 and > 0 there is a positive feedback


k_cat_kin = 1;
Km1 = 200;
k_cat_phos = 1;
Km2 = 200;
k_cat_act = 10;
Km3 = 20;
k_cat_de = 1;
Km4 = 10;
Ka = 1;

u = x(1);
up = x(2);

p = x(3);
pa = x(4);


v_kin = kin * k_cat_kin * u / ( Km1 + u );


v_phos =  pa * k_cat_phos * up / ( Km2 + up );


v_act = k_cat_act * p / ( Km3 + p );


v_de = k_cat_de*pa/(pa+Km4) * (1+A*up/Ka)/(1+up/Ka);

noise = randn(2,1)*noise_level;
dx = [ v_phos-v_kin+noise(1) ; v_kin-v_phos-noise(1) ; v_de-v_act+noise(2) ; v_act-v_de-noise(2) ];

end

