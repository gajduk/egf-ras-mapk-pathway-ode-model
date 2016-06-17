classdef tanhPINFactory < PINFactory
    %PINETWORKFACTORY Constructs random or specific PINetworks
    
    properties
        f_gen = @(sign) sign*randn(1,1)*10;
        k_phos_gen = @() 1;
    end
    
    methods
        function self = tanhPINFactory()
        end
        
        
        function pinetwork = getParametersForTopology(self,topology)
           [n,~] = size(topology);
           f = zeros(n,n);
           for i=1:n
               for k=1:n
                   if topology(i,k) > 0
                       f(i,k) = self.f_gen(1);
                   else
                       if topology(i,k) < 0
                         f(i,k) = self.f_gen(-1);
                       end
                   end
               end
           end
           k_phos = zeros(n,1);
           for i=1:n
              k_phos(i) = self.k_phos_gen(); 
           end
           pinetwork = tanhPIN(n,k_phos,f);
        end
        
         function simple_simulation = getSimpleSimulation(self,pin)
            end_time_ = 4;
            input = PINSimulationSetup.pulse_input(1000);
            inhibition = PINSimulationSetup.getNoInhibition();
            y0 = rand(pin.n,1)*20-10;
            simple_simulation_setup = PINSimulationSetup(end_time_,input,inhibition);
            simple_simulation = PINSimulation(pin,simple_simulation_setup,y0);
         end
        
        function res = combinePINs(self,pins)
           error('tanhPINFactory:Not implemented'); 
        end
    end
    
end


