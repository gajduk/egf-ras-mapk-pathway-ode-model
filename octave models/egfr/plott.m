load data.mat
global egfr
egfr = x(:,4);

function xdot=f(x,t)
  xdot=zeros(4,1);
  global egfr
  idx = min(1000,int32 (t/(80.0/1000))+1);
  egfr_a = egfr(idx);
  akt_k_cat = 100;
  akt_k_M = 100000;
  xdot(1) = -egfr_a*akt_k_cat*x(1)/(x(1)+akt_k_M)+2000*x(2)/(x(2)+akt_k_M);
  xdot(2) = egfr_a*akt_k_cat*x(1)/(x(1)+akt_k_M)-2000*x(2)/(x(2)+akt_k_M);
  
  xdot(3) = -egfr_a*30*x(3)/(x(3)+120000)+2500*x(4)/(x(4)+120000);
  xdot(4) = egfr_a*30*x(3)/(x(3)+120000)-2500*x(4)/(x(4)+120000);
  
endfunction
x_temp0 = [10000.0;0.0;10000.0;0.0];
  
  
#Creating linespace
t=linspace(0,80,1000);
#Solving equations
x_temp=lsode("f",x_temp0,t);
p = polyfit(t,x_temp(:,4)',5);
y = polyval(p,t);

x = [x,x_temp,y'];
labels      = {'EGFR',  'Raf',   'MEk',     'Erk' , 'Akt' , 'Src'};
Output_idxs = [2,      14*3+2,   16*3+2,    19*3+1, 100 , 103];
#ploting the results
Output_idxs = Output_idxs+2;
normalized = bsxfun(@rdivide,x(:,Output_idxs),max(x(:,Output_idxs)));
figure;
plot(t,normalized, "linewidth",2);
legend(labels)
xlabel('Time [min]')
ylabel('Activity')
h=get(gcf, "currentaxes");
set(h, "fontsize", 18, "linewidth", 1);

#1,1 - EGFR
#14,2 - Raf
#16,2 - MEK
#19,1 - ERK
csvwrite('egfr_time_series',[t',normalized])