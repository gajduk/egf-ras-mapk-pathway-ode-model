function [t,y] = srep05030_example1()
A = [0 7.2 9.3 0 0 -1;
     -1 0 7 0 0 0;
     -3 4.2 -3.5 -4.4 0 0;
     8.5 6.7 -7.7 0 -9 0;
     -5 0 0 0 0 0;
     0 2.5 0 10 -2.5 0];

[t,y] = ode45(@(t,x) ode_model(t,x,A),[0 10],randn(6,1));
plot(t,y)
pin.n = 6;
pin.f = A;

pin_simulation_result.t = t;
pin_simulation_result.y = y;
pin_simulation_results = cell(1,1);
pin_simulation_results{1} = pin_simulation_result;

instance = Instance(pin,pin_simulation_results);

instances = cell(2,1);
instances{1} = instance;
instances{2} = instance;
dataset = Dataset(instances);
dataset.dumpJson('example1.json');

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
