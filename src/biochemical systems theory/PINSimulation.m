classdef PINSimulation < handle
    %PINETWORKSIMULATION wrapper for simulating a set of initial conditions
    %, inputs and inhibitors on a pin
    
    properties
        pin = -1;
        y0 = [];%initial conditions
        end_time = -1;
        input = -1;
        inhibit = -1;
    end
    
    methods
        function self = PINSimulation(pin,pinsetup,y0)
            self.pin = pin;
            self.end_time = pinsetup.end_time;
            self.input = pinsetup.input;
            self.inhibit = pinsetup.inhibit;
            if nargin < 4
                self.y0 = zeros(self.pin.n,1);
            else
                self.y0 = y0;                
            end
        end
        
        function [t,y] = run(self,tspan)
            if nargin < 2
               tspan_temp = 0:.1:self.end_time; 
            else
               tspan_temp = tspan;
            end
            [t,y] = ode45(@(t,x) self.ode_decorator(t,x),tspan_temp,self.y0);
        end
        
        function dx = ode_decorator(self,t,x)
            current_input = self.input(t);
            dx = self.pin.ode_model(t,x,current_input);
            dx = self.inhibit(t,x,dx);
        end
        
    end
    
end

