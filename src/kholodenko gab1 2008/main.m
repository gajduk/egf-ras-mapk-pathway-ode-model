y0 = [0;1];
[t,y] = ode45(@ode_model,[0 20],y0);
plot(t,y)
legend({'RTK_P','PTP_A'})