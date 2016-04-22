M = csvread('egfr_time_series');
t = M(:,1);
x = M(:,2:end);
x(1:500,1) = x(6:505,2);
x(1:11,4) = 0;
x(11:310,4) = x(1:300,3);

plot(t,x)
legend({'EGFR',  'Raf',   'MEk',     'Erk' , 'Akt' , 'Src'},'Location','East')
xlabel('Time [min]')
ylabel('Activity (normalized)')
ylim([-.01 1.05])
xlim([-.1 15])
grid on
export_fig -transparent egfr_time_series.png