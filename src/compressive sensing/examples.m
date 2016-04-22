%See paper 10.1186/s12859-014-0400-4
%Exact reconstruction of gene regulator networks using compressive sensing
%Young Chang, Joe Gray, Claire Tomlin

function examples()
    y0 = [0.6,0.8,0.9];
    tspan = [0:.01:10];
    [t,y] = ode45(@ode_model_example3,tspan,y0);
    plot(t,y);
    legend({'x_1','x_2','x_3'})
    xlabel('Time [min]')
    ylabel('Protein activity (concentration)');
    t_sampling = [0,0.4,3.5,6.7,9.9];
    M = length(t_sampling);
    n = 3;
    N = 9;
    t_index = zeros(1,M);
    for i=1:M
        t_index(i) = min(find(t>t_sampling(i)));
    end
    hold on
    plot(t(t_index),y(t_index,:),'o')
    observations = y(t_index,:);
    F_b = {@(x) x(1),@(x) x(2),@(x) x(3), ...
            @(x) x(1)^4/(1+x(1)^4), @(x) x(2)^4/(1+x(2)^4), @(x) x(3)^4/(1+x(3)^4), ...
            @(x) 1/(1+x(1)^4), @(x) 1/(1+x(2)^4), @(x) 1/(1+x(3)^4)};
    FF = zeros(M,N);
    for i=1:M
        for k=1:N
           FF(i,k) = F_b{k}(observations(i,:));
        end
    end
    L = n*N;  % signal length, or number of columns in Omega
    K = n*M;  % number of observations to make or number of rows in Omega
    Omega = zeros(K,L);
    Y = zeros(K,1);
    for i=1:n
       Y((i-1)*M+1:i*M) = observations(:,i);
       Omega((i-1)*M+1:i*M,(i-1)*N+1:i*N) = FF;
    end
    q0 = Omega'*Y;
    q_est = l1eq_pd(q0, Omega, [], Y, 1e-3);
    reshape(q_est,[9,3])
    
end

function [dx] = ode_model_example5(t,x)
	dx = zeros(3,1);
	g = [-.25,-.23,-.26];
	k = zeros(3,3);
	k(1,2) = 1.2;
	k(1,3) = 1.25;
	k(2,1) = 2.8;
	k(2,3) = 2.1;
	k(3,1) = 2.7;
	k(3,2) = 1.8;
	n_act = 4; n_inh = 4;
	dx(1) = g(1)*x(1) + ...
	        k(1,2) .* x(2) .^ n_act ./ ( 1 + x(2) .^ n_act  ) + ...
	        k(1,3) .* x(3) .^ n_act ./ ( 1 + x(3) .^ n_act  );
	dx(2) = g(2)*x(2) + ...
	        k(2,1) .* 1 ./ ( 1 + x(1) .^ n_inh  ) + ...
	        k(2,3) .* 1 ./ ( 1 + x(3) .^ n_inh  );
	dx(3) = g(3)*x(3) + ...
	        k(3,1) .* 1 ./ ( 1 + x(1) .^ n_inh  ) + ...
	        k(3,2) .* 1 ./ ( 1 + x(2) .^ n_inh  );
end


function [dx] = ode_model_example3(t,x)
	dx = zeros(3,1);
	g = [-.3,-.25,-.35];
	k = zeros(3,3);
	k(1,2) = 1.2;
	k(1,3) = 0.9;
	k(2,3) = 2.2;
	n_act = 4; n_inh = 4;
	dx(1) = g(1)*x(1) + ...
	        k(1,2) .* x(2) .^ n_act ./ ( 1 + x(2) .^ n_act  );
	dx(2) = g(2)*x(2) + ...
	        k(2,3) .* 1 ./ ( 1 + x(3) .^ n_inh  );
	dx(3) = g(3)*x(3) + ...
	        k(1,3) .*  x(1) .^ n_act ./ ( 1 + x(1) .^ n_act  );
end