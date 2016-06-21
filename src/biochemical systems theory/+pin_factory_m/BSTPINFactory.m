classdef BSTPINFactory < pin_factory_m.PINFactory
    %PINETWORKFACTORY Constructs random or specific PINetworks unser the
    %Biochemical Systems Theory model
    
    properties
        A_g_gen = @(n) .06+0.1*rand(n,1);
        D_g_gen = @(n) .02+0.07*rand(n,1);
        f_gen = @(sign) sign.*(0.15*randn()+1);
    end
    
    methods
        function self = BSTPINFactory()
        end
        
        function pinetwork = getParametersForTopology(self,topology)
           adjecency_matrix = topology;
           f = zeros(n,n);
           for i=1:n
               for k=1:n
                   if adjecency_matrix(i,k) > 0
                       f(i,k) = self.f_gen(1);
                   else
                       if adjecency_matrix(i,k) < 0
                           f(i,k) = self.f_gen(-1);
                       end
                   end
               end
           end
           %(de)-activation coefficients
           A_g = self.A_g_gen(n);
           D_g = self.D_g_gen(n);
           
           %activating exponents
           A_f_s = ones(n,1);
           D_f_s = ones(n,1);
           
           %input activation
           I_f = zeros(1,n);
           I_f(1) = 1;
           pinetwork = PIN(n,A_g,D_g,A_f_s,D_f_s,I_f,f);
        end
        
         function simple_simulation = getSimpleSimulation(self,pin)
            end_time_ = 160;
            input = PINSimulationSetup.pulse_input(1000);
            inhibition = PINSimulationSetup.getNoInhibition();
            simple_simulation_setup = PINSimulationSetup(end_time_,input,inhibition);
            simple_simulation = PINSimulation(pin,simple_simulation_setup,zeros(pin.n));
        end
              
        function res = combinePINs(self,pins)
            n = 0;
            for i=1:length(pins)
               n = n+pins{i}.n;
            end
            A_g = zeros(n,1);
            D_g = zeros(n,1);
            A_f_s = zeros(n,1);
            D_f_s = zeros(n,1);
            I_f = zeros(n,1);
            I_f(1) = 1;
            f = zeros(n,n);
            start_i = 1;
            for i=1:length(pins)
                pin = pins{i};
                end_i = start_i + pin.n-1;
                A_g(start_i:end_i) = pin.A_g;
                D_g(start_i:end_i) = pin.D_g;
                A_f_s(start_i:end_i) = pin.A_f_s;
                D_f_s(start_i:end_i) = pin.D_f_s;
                f(start_i:end_i,start_i:end_i) = pin.f;
                if i > 1
                   f(1,start_i) = self.f_gen(1); 
                end
                
                for ii=1:start_i-1
                    for kk=start_i:end_i
                        if rand() < .01
                            f(kk,i) = self.f_gen(-1);
                        end
                        if rand() < .01
                            f(kk,ii) = self.f_gen(1);
                        end
                    end
                end
                start_i = end_i+1;
            end
            res = PIN(n,A_g,D_g,A_f_s,D_f_s,I_f,f);
        end
        
    end
    
end


