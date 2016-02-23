y0 = [300;0;100];
[t,y] = ode45(@ode_model,[0 40],y0);
M = y(:,1);
M_p = y(:,2);
E_kin = y(:,3);
plot(t,M_p,t,E_kin);
legend({'M_p','E_{kin}'})
xlabel('Time [h]')
ylabel('Concentration [nM]')