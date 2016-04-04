function [t,y] = srep05030_example2()
h = zeros(6,6);

h(1,2) = 0.7;
h(1,3) = 0.32;
h(1,6) = 0.04;

h(2,1) = 0.7;
h(2,3) = 0.9;

h(3,1) = 0.845;
h(3,2) = 0.91;
h(3,3) = 0.75;
h(3,4) = 0.11;

h(4,1) = -0.13;
h(4,2) = -0.6;
h(4,3) = -0.68;
h(4,5) = -0.22;

h(5,1) = -0.69;

h(6,2) = -0.27;
h(6,4) = -0.95;
h(6,5) = -0.375;

[t,y] = ode45(@(t,x) ode_model(t,x,h),[0:.2:4],rand(6,1));
plot(t,y)

end

function dx = ode_model(t,x,h)
    dx = zeros(6,1);
    for i=1:6
       dx(i) = -x(i);
       for k=1:6
           temp = 0.0;
           if h(i,k) < 0
               temp = 1.0/(1.0+x(k).^5);
           end
           if h(i,k) > 0
               temp = x(k).^5/(1.0+x(k).^5);
           end
           dx(i) = dx(i) + abs(h(i,k))*temp;
       end
    end
end
