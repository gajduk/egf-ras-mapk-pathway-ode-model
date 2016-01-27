y0 = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1];
length(y0);
[t,y] = ode45(@ode_model1,[0 120],y0);
idxs = [2,10,12];
labels = {'R','R_A','Ras','Ras_A','Raf','Raf_A','MEK','MEK_A','ERK','ERK_A','NFB','NFB_A','PFB','PFB_A','dusp','DUSP'};
plot(t,y(:,idxs));
legend(labels{idxs});
xlabel('Time [min]');
ylabel('Ratio');
