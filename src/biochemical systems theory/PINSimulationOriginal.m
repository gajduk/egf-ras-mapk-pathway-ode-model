classdef PINSimulationOriginal < handle
    %PINETWORKSIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pinetwork = -1;
        y0 = [];%initial conditions
        end_time = -1;
        input = -1;
        inhibit = -1;
    end
    
    methods
        function self = PINSimulationOriginal(pinetwork,pinsetup,y0)
            self.pinetwork = pinetwork;
            n = self.pinetwork.n;
            self.end_time = pinsetup.end_time;
            self.input = pinsetup.input;
            self.inhibit = pinsetup.inhibit;
            if nargin < 3
                self.y0 = zeros(n,1);
            else
                self.y0 = y0;                
            end
            
        end
        
        function [t,y] = run(self,tspan)
            if nargin < 2
               tspan_temp = [0 self.end_time]; 
            else
               tspan_temp = tspan;
            end
            [t,y] = ode45(@(t,x) self.ode_model(t,x),tspan_temp,self.y0);
        end
        
        function dx = ode_model(self,t,x)
            current_input = self.input(t);
            n = self.pinetwork.n;
            dx = zeros(n,1);
            for i=1:n
               a = 0;
               A_x_i = self.pinetwork.A_g(i) .* ( (1-x(i)) .^ self.pinetwork.A_f_s(i) );
               D_x_i = self.pinetwork.D_g(i) .* ( x(i) .^ self.pinetwork.D_f_s(i) );

               for k=1:n
                   if i == k
                       continue
                   end
                   if self.pinetwork.f(k,i) > 0
                       a = 1;
                       if i>k
                           A_x_i = A_x_i .* real( x(k) .^ self.pinetwork.f(k,i) );
                       else
                           A_x_i = A_x_i .* (1 + real( x(k) .^ self.pinetwork.f(k,i) ) );
                       end
                   else
                       if self.pinetwork.f(k,i) < 0
                           D_x_i = D_x_i .* (1 + .1*real( x(k) .^ -self.pinetwork.f(k,i) )); 
                       end
                   end
               end
               A_x_i = A_x_i.*a + self.pinetwork.A_g(i) .* (1-x(i)) .* self.pinetwork.I_f(i) .* current_input;
               dx(i) = A_x_i-D_x_i;
            end
            dx = self.inhibit(t,x,dx);
        end
    end
    
end

