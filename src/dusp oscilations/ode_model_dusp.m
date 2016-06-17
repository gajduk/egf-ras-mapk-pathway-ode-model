function dx = ode_model_dusp(t,x,input)

%input signal, can be a funciton of t
u = input(t);

%1
k1_R = .5;
kd1_R = .5;
Ptase_R = 1;

%k_syn = 0.0014;
%k_deg = 0.0014;
%k_i = 0.22;
%kd_i = 0.044;
%k_deg_i = 0.662;

%6
k6_R = 40;
k6 = 1;
kd6 = 7.5;
D6 = 1;
GAP = 1;

%5
k5 = 10;
K5 = 1;
kd5 = 3.75;
D5 = 1;
K_NFB = 0.05;
Ptase_Raf = 1;

%5a
k_PFB = 0;
K_PFB = 0.01;

%4
k4 = 2;
K4 = 1;
kd4 = 0.5;
D4 = 1;
Ptase_MEK = 1;

%2
k2 = 2;
K2 = 1;
kd2 = 0.25;
D2 = 0.1;

%3
k3_F = 0.0286;
K3 = 0.01;
K3R = 0.85;
kd3 = 0.0057;
D3 = 0.5;
Ptase_NFB = 1;

%7
k7 = 0.1;
K7 = 0.1;
kd7 = 0.005;
D7 = 0.1;
Ptase_PFB = 1;

%8
dusp_basal = 1;
dusp_ind = 6;
K_dusp = 0.1;
T_dusp = 90;

%11
T_DUSP = 90;

cell_x = num2cell(x);
%1 2   3   4     5   6     7   8     9   10    11  12    13  14    15   16
[R,R_A,Ras,Ras_A,Raf,Raf_A,MEK,MEK_A,ERK,ERK_A,NFB,NFB_A,PFB,PFB_A,dusp,DUSP] = deal(cell_x{:});
 %%
v1 = k1_R .* R .* u   -   kd1_R .* Ptase_R .* R_A;
 %%
v6 = k6_R .* R_A .* Ras ./ ( k6 + Ras )   -   kd6 .* GAP .* Ras_A ./ ( D6 + Ras_A );
 %%
v5 = k5 .* Ras_A .* Raf ./ ( k5 + Raf ) .* K_NFB^2 ./ ( K_NFB^2 + NFB_A^2 )   -   kd5 .* Ptase_Raf .* Raf_A ./ ( D5 + Raf_A );
 %%
v5a = k_PFB .* PFB_A .* Raf ./ ( K_PFB + Raf );
 %%
v4 = k4 .* Raf_A .* MEK ./ ( K4 + MEK )  -   kd4 .* Ptase_MEK .* MEK_A ./ ( D4 + MEK_A );
 %%
v2 = k2 .* MEK_A .* ERK ./ ( K2 + ERK ) - kd2 .* DUSP .* ERK_A ./ ( D2 + ERK_A );
 %%
v3a = k3_F .* ERK_A .* NFB ./ ( K3 + NFB ) .* R_A^2 ./ ( K3R^2 + R_A^2 )   -   kd3 .* Ptase_NFB .* NFB_A ./ ( D3 + NFB_A );
 %%
v7a = k7 .* ERK_A .* R_A .* PFB ./ ( K7 + PFB ) - kd7 .* Ptase_PFB .* PFB_A ./ ( D7 + PFB_A );
 %%
v8 = dusp_basal .* ( 1 + dusp_ind .* ERK_A ^ 2 ./ ( K_dusp + ERK_A ^ 2 ) ) .* log(2) ./ T_dusp;
 %%
v9 = dusp .* log(2) ./ T_dusp;
 %%
v10 = dusp .* log(2) ./ T_DUSP;
 %%
v11 = DUSP .* log(2) ./ T_DUSP;
 %%
dx=[-v1; v1; -v6; v6; -v5-v5a; v5+v5a; -v4; v4; -v2; v2; -v3a; v3a; -v7a; v7a; v8-v9; v10-v11];
end

