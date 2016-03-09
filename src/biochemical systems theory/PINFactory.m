classdef PINFactory < handle
    %PINETWORKFACTORY Constructs random or specific PINetworks
    
    properties
        A_g_gen = @(n) .06+0.1*rand(n,1);
        D_g_gen = @(n) .02+0.07*rand(n,1);
        f_gen = @(sign) sign.*(0.15*randn()+1);
        n_nodes_gen = @() 14;
        n_branches_gen = @() 2;
        n_positive_feedback_gen = @() 2;
        n_negative_feedback_gen = @() 5;
    end
    
    methods
        function self = PINFactory()
        end
        
        
        function random_pin_generator = getRandomNetworkGenerator(self)
           random_pin_generator =  @() self.getRandomPIN(self.n_nodes_gen, ...
               self.A_g_gen,self.D_g_gen,self.f_gen,self.n_branches_gen,       ...
               self.n_positive_feedback_gen,self.n_negative_feedback_gen);
        end
        
        function adjecency_matrix = getRandomNetworkTopology(self,n_nodes_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen)
           n = n_nodes_gen();
           n_branches = n_branches_gen();
           n_positive_feedback = n_positive_feedback_gen();
           n_negative_feedback = n_negative_feedback_gen();
           
           %links
           f = zeros(n,n);
           f(1,2) = 1;
           for i=2:n-1
               if rand < n_branches/n
                   from = int32(exprnd(sqrt(n)));
                   from = min(max(from,1),i);
                   f(from,i+1) = 1;
               else
                   f(i,i+1) = 1;
               end
           end
           %positive feedback
           for i=1:n_positive_feedback
              source = randi(n-1)+1; 
              dest = randi(source-1);
              while f(source,dest) ~= 0
                  source = randi(n-1)+1; 
                  dest = randi(source-1);
              end
              f(source,dest) = 1;
           end
           %negative feedback
           for i=1:n_negative_feedback
              source = randi(n-1)+1; 
              dest = randi(source-1);
              while f(source,dest) ~= 0
                  source = randi(n-1)+1; 
                  dest = randi(source-1);
              end
              f(source,dest) = -1;
           end
           adjecency_matrix = f;
        end
        
        function pinetwork = getRandomTopologyAndParameters(self,n_nodes_gen,A_g_gen,D_g_gen,f_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen)
           n = n_nodes_gen();
           f = zeros(n,n);
           adjecency_matrix = self.getRandomNetworkTopology(@() n,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen);
           for i=1:n
               for k=1:n
                   if adjecency_matrix(i,k) > 0
                       f(i,k) = f_gen(1);
                   else
                       if adjecency_matrix(i,k) < 0
                           f(i,k) = f_gen(-1);
                       end
                   end
               end
           end
           %(de)-activation coefficients
           A_g = A_g_gen(n);
           D_g = D_g_gen(n);
           
           %activating exponents
           A_f_s = ones(n,1);
           D_f_s = ones(n,1);
           
           %input activation
           I_f = zeros(1,n);
           I_f(1) = 1;
           pinetwork = PIN(n,A_g,D_g,A_f_s,D_f_s,I_f,f);
        end
        
        function res = checkPIN(self,pin)
            end_time_ = 160;
            input = PINSimulationSetup.pulse_input(20);
            inhibition = PINSimulationSetup.getNoInhibition();
            simple_simulation_setup = PINSimulationSetup(end_time_,input,inhibition);
            simulation_ = PINSimulationOriginal(pin,simple_simulation_setup);
            [t,y] = simulation_.run();
            [~,m] = size(y);
            plot(t,y);
            check_times_nonzero = [50,100,150];
            count_nonzero = zeros(1,m);
            for time_=1:length(check_times_nonzero)
                idx = max(t(t<check_times_nonzero(time_)))==t;
                count_nonzero = count_nonzero | y(idx,:) > 0.01;
            end
            check_times_nonequal = [100,150];
            count_nonequal = ones(1,m);
            for time_=1:length(check_times_nonequal)
                if time_<length(check_times_nonequal)
                   idx = max(t(t<check_times_nonequal(time_)))==t;
                   idx2 = max(t(t<check_times_nonequal(time_+1)))==t;
                   count_nonequal = count_nonequal & abs(y(idx,:)-y(idx2,:))>.05;   
                end
            end
            if  sum(count_nonzero) == m && sum(count_nonequal) > m*0.4  && sum(count_nonequal) < m*0.8
                res = 1;
            else
                res = 0;
            end
        end
        
        function pin = getRandomPINInternal(self,n_nodes_gen,A_g_gen,D_g_gen,f_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen)
            %----------------------------
            %define a simple simulation setup to test if the generated
            %network is generating networks that make sense
            %----------------------------
            pin = self.getRandomTopologyAndParameters(n_nodes_gen,A_g_gen,D_g_gen,f_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen);
            
            %generate several networks and find one that has good dynamics
            while 1
                if self.checkPIN(pin);
                   break 
                end
                pin = self.getRandomTopologyAndParameters(n_nodes_gen,A_g_gen,D_g_gen,f_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen);
            end
        end
        
        function pin = getRandomPIN(self,n_nodes_gen,A_g_gen,D_g_gen,f_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen)
            pins = cell(3,1);
            for i=1:3
               pins{i} = self.getRandomPINInternal(n_nodes_gen,A_g_gen,D_g_gen,f_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen); i
            end
            pin = self.combinePINs(pins,f_gen);
            for i=1:100
                if self.checkPIN(pin)
                    break
                end   
                pin = self.combinePINs(pins,f_gen);
            end
        end
        
        function res = combinePINs(self,pins,f_gen)
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
                   f(1,start_i) = f_gen(1); 
                end
                
                for ii=1:start_i-1
                    for kk=start_i:end_i
                        if rand() < .01
                            f(kk,i) = f_gen(-1);
                        end
                        if rand() < .01
                            f(kk,ii) = f_gen(1);
                        end
                    end
                end
                start_i = end_i+1;
            end
            res = PIN(n,A_g,D_g,A_f_s,D_f_s,I_f,f);
        end
        
    end
    methods (Static)
        function pin_factory = get14NodesFactoryOLD()
            pin_factory = PINFactory();
            pin_factory.A_g_gen = @(n) .06+0.1*rand(n,1);
            pin_factory.D_g_gen = @(n) .02+0.07*rand(n,1);
            pin_factory.f_gen = @(sign) sign.*(0.15*randn()+1);
            pin_factory.n_nodes_gen = @() 14;
            pin_factory.n_branches_gen = @() 2;
            pin_factory.n_positive_feedback_gen = @() 2;
            pin_factory.n_negative_feedback_gen = @() 5;
        end
        function pin_factory = get14NodesFactory()
            pin_factory = PINFactory();
            pin_factory.A_g_gen = @(n) .06+0.1*rand(n,1);
            pin_factory.D_g_gen = @(n) .02+0.07*rand(n,1);
            pin_factory.f_gen = @(sign) sign.*(0.1*randn()+1);
            pin_factory.n_nodes_gen = @() 14;
            pin_factory.n_branches_gen = @() 2;
            pin_factory.n_positive_feedback_gen = @() 2;
            pin_factory.n_negative_feedback_gen = @() 4;
        end
        
        function pin_factory = get30NodesFactory()
            pin_factory = MMPINFactory();
            pin_factory.n_nodes_gen = @() 30;
            pin_factory.n_branches_gen = @() rand(5)+5;
            pin_factory.n_positive_feedback_gen = @() rand()*4+2;
            pin_factory.n_negative_feedback_gen = @() rand()*8+6;
            pin_factory.link_strength_gen = @(a) rand()*2+2;
            
            pin_factory.n_nodes_gen = @() 30;
            pin_factory.n_branches_gen = @() 0;
            pin_factory.n_positive_feedback_gen = @() 0;
            pin_factory.n_negative_feedback_gen = @() 0;
            pin_factory.link_strength_gen = @(a) 10;
        end
    end
    
end


