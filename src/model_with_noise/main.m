function main()
    n_repetitions = 100;
    total_u = 100;
    total_p = 200;

    kins = 100;
    u_ratio = 0;

    noise = 10;

    y0  = [total_u.*(1-u_ratio); total_u.*u_ratio; total_p; total_p*0];

    tspan = 0:.01:50;

    link_weights = -5:.25:15;
    labels = cell(length(link_weights),1);
    res = cell(length(link_weights),1);
    for idx=1:length(link_weights)
        A = 2.*link_weights(idx);
        labels{idx} = num2str(link_weights(idx));
        res_cell = zeros(length(tspan),n_repetitions);
        parfor i=1:n_repetitions
            [~,y] = euler(@(t,x) ode_model(t,x,kins,A,noise),tspan,y0);
            u = y(:,1);
            up = y(:,2);
            res_cell(:,i) = up./(u+up);
            %plot(t,y);
            %legend({'u','u_p','p','p_a'})
        end
        res{idx} = res_cell;
    end
    
    temp = zeros(length(tspan),length(link_weights));
    for idx=1:length(link_weights)
       temp(:,idx) = std(res{idx}');
    end
    plot(link_weights,mean(temp),'+');
    xlabel('Feedback strength')
    ylabel('Variance')
end

function plot_six_subplots(res) 

    n_bins = 30;
    xlims = [0 1];
    figure('Position',[100 100 1800 1000]);
    subplot(3,2,1)
    hist(res(10,:),n_bins)
    title(sprintf('t = 1 [min]   F = %.3f',std(res(10,:))/mean(res(10,:))))
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

end
