function [t,y] = srep05030_example1()
A = [0 7.2 9.3 0 0 -1;
     -1 0 7 0 0 0;
     -3 4.2 -3.5 -4.4 0 0;
     8.5 6.7 -7.7 0 -9 0;
     -5 0 0 0 0 0;
     0 2.5 0 10 -2.5 0];

[t,y] = ode45(@(t,x) ode_model(t,x,A),[0 10],randn(6,1));
plot(t,y)

end

function dx = ode_model(t,x,A)
    dx = zeros(6,1);
    for i=1:6
       dx(i) = -x(i);
       for k=1:6
           dx(i) = dx(i) + A(i,k)*tanh(x(k));
       end
    end
end
