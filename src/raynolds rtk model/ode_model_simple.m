function dx = ode_model_simple(t,x)

rtk_p = x(1);
ptp_a = x(2);

dx = [ 1 - ptp_a .^ 2 ./ ( 1 + ptp_a .^ 2 ) .* rtk_p ; - rtk_p .^ 2 ./ ( 1 + rtk_p .^ 2 ) .* ptp_a ];
    

end

