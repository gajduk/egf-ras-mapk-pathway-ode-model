
function main()

    y0 = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1];
    inputs = {@pulse,@sustained,@oscilation};
    tspan = linspace(0,120,100);
    figure('Position',[100 100 1000 500]);
    for input_idx=1:3
        subplot(1,3,input_idx)
        input = inputs{input_idx};
        [~,y_dusp] = ode45(@(t,x) ode_model_dusp(t,x,input),tspan,y0);
        [~,y_NOdusp] = ode45(@(t,x) ode_model_NOdusp(t,x,input),tspan,y0);
        plot(tspan,y_dusp(:,6),tspan,y_NOdusp(:,6));
        legend({'dusp','NOdusp'},'Location','South')
        xlabel('Time [min]');
        ylabel('Erk activity');
        title(func2str(input));
        xlim([0 120])
    end
    export_fig -transparent erk_response.png
    %idxs = [10];
    %labels = {'Receptor','Receptor_A','Ras','Ras_A','Raf','Raf_A','MEK','MEK_A','ERK','ERK_A','NFB','NFB_A','PFB','PFB_A','dusp','DUSP'};
    %plot(t,y(:,idxs));
    %legend(labels{idxs});
    %xlabel('Time [min]');
    %ylabel('Ratio');
    %csvwrite_with_headers('time_series.csv',[t,y],{'Time [min]',labels{:}})

end

function input = pulse(t)
   input = t<20;
end

function input = sustained(t)
   input = 1;
end

function input = oscilation(t)
   input = (sin(t/10)+1)*0.5;
end