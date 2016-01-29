classdef PINetworkSimulation
    %PINETWORKSIMULATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pinetwork = -1;
        y0 = [];%initial conditions
        input = -1;%function that shows the concentration of input (ligand) over time
    end
    
    methods
        function self = PINetworkSimulation(pinetwork,input,y0)
            self.pinetwork = pinetwork;
            
            self.input = input;
            if nargin > 2
                self.y0 = y0;
            else
                n = self.pinetwork.n;
                self.y0 = zeros(n,1);
            end
        end
        
        function [t,y] = run(self,tspan)
            [t,y] = ode45(@(t,x) self.ode_model(t,x),tspan,self.y0);
        end
        
        function dx = ode_model(self,t,x)
            input = self.input(t);
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
                       A_x_i = A_x_i .* ( x(k) .^ self.pinetwork.f(k,i) ); 
                   else
                       if self.pinetwork.f(k,i) < 0
                           D_x_i = D_x_i .* ( x(k) .^ -self.pinetwork.f(k,i) ); 
                       end
                   end
               end
               A_x_i = A_x_i*a + self.pinetwork.A_g(i) .* (1-x(i)) .* self.pinetwork.I_f(i) .* input;
               dx(i) = A_x_i-D_x_i;
            end            
        end
    end
    
end

