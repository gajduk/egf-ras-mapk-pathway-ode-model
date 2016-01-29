function dx = ode_model(t,x)
rtk_total = 1;
ptp_total = 1;
rtk_p = x(1);
ptp_a = x(2);
k1 = 1;
k2 = 1;
k3 = 1;
k4 = 1;
a1 = 1;
a2 = 10;
b = 100;
g = 200;

dx = [ ( rtk_total - rtk_p ) .* ( k1 .* a1  .* ( rtk_total - rtk_p ) + k1 .* a2 .* rtk_p ) - k2 .* g .* rtk_p .* ptp_a ; k4 .* ( ptp_total - ptp_a ) - k3 .* b .* rtk_p .* ptp_a ];

end

