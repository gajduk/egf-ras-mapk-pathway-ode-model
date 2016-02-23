clear all
close all
total_u = 100;
total_p = 200;

n_initial = 1000;

up_ratio = randn(1,n_initial)/15.0+0.2;
up_ratio(up_ratio<0) = 0;

pa_ratio = randn(1,n_initial)/15.0+0.2;
pa_ratio(pa_ratio<0) = 0;

y0  = [total_u*(1-up_ratio) ; total_u*up_ratio ; total_p*(1-pa_ratio) ; total_p*pa_ratio];

tspan = [0:.1:200];

res = zeros(length(tspan),n_initial);
parfor i=1:n_initial
    [t,y] = ode45(@ode_model,tspan,y0(:,i));
    
    u = y(:,1);
    up = y(:,2);
    res(:,i) = up./(u+up);
    p = y(:,3);
    pa = y(:,4);
end


n_bins = 30;
xlims = [0 1];
figure('Position',[100 100 1800 1000]);
subplot(3,2,1)
hist(res(1,:),n_bins)
title(sprintf('t = 0 [min]   F = %.3f',std(res(1,:))/mean(res(1,:))))
xlabel('Fraction of active protein')
xlim(xlims)
subplot(3,2,3)
hist(res(100,:),n_bins)
xlim(xlims)
title(sprintf('t = 10 [min]   F = %.3f',std(res(100,:))/mean(res(100,:))))
xlabel('Fraction of active protein')
subplot(3,2,5)
hist(res(300,:),n_bins)
xlim(xlims)
title('t = 30 [min]')
title(sprintf('t = 10 [min]   F = %.3f',std(res(300,:))/mean(res(300,:))))
xlabel('Fraction of active protein')


subplot(3,2,4)
for i=1:n_initial
    plot(tspan,res(:,i),'b')
    hold on
end
xlim([0 30])
xlabel('Time [min]')
ylabel('Fraction of active protein')