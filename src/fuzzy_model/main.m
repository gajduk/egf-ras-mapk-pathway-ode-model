clear all
close all

n_initial = 100;

total_u = ones(1,n_initial)*100;
total_p = (randn(1,n_initial)/5+2).*total_u;
%total_p = ones(1,n_initial)*200;

kins = (randn(1,n_initial)*10+100);
u_ratio = randn(1,n_initial)/30+0.1;
u_ratio(u_ratio<0) = 0;

y0  = [total_u.*(1-u_ratio); total_u.*u_ratio; total_p; total_p*0];

tspan = [0:.1:200];

res = zeros(length(tspan),n_initial);
parfor i=1:n_initial
    [t,y] = ode45(@(t,x) ode_model(t,x,kins(i)),tspan,y0(:,i));
    
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
grid on
subplot(3,2,3)
hist(res(50,:),n_bins)
xlim(xlims)
title(sprintf('t = 5 [min]   F = %.3f',std(res(100,:))/mean(res(100,:))))
xlabel('Fraction of active protein')
grid on
subplot(3,2,5)
hist(res(300,:),n_bins)
xlim(xlims)
title(sprintf('t = 30 [min]   F = %.3f',std(res(300,:))/mean(res(300,:))))
xlabel('Fraction of active protein')
grid on


subplot(3,2,2)

px=[tspan,fliplr(tspan)];
std_res = std(res(:,:)');
mean_res = mean(res(:,:)');
min_res = min(res(:,:)');
max_res = max(res(:,:)');

for k=1:10
    py=[mean_res-std_res*k/3, fliplr(mean_res+std_res*k/3)];
    patch(px,py,1,'FaceColor','b','FaceAlpha',0.1,'EdgeColor','none');
end
hold on
%plot(tspan,min_res,'k')
%plot(tspan,max_res,'k')
xlim([0 40])
xlabel('Time [min]')
ylabel('Fraction of active protein')

subplot(3,2,4)
plot(tspan,std(res')')
xlim([0 40])
xlabel('Time [min]')
ylabel('Std')


subplot(3,2,6)
plot(tspan,std(res')'./mean(res')')
xlim([0 40])
xlabel('Time [min]')
ylabel('Fano factor')
