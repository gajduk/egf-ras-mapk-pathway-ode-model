function [t,y] = euler(f,tspan,y0)
    y = zeros(length(tspan),length(y0));
    prev_y = y0;
    y(1,:) = prev_y;
    for i=1:length(tspan)-1
        h = tspan(i+1)-tspan(i);
        time = (tspan(i+1)+tspan(i))/2;
        prev_y = prev_y+h*f(time,prev_y);
        y(i+1,:) = prev_y;
    end
    t = tspan;
end

