classdef (Abstract) PINFactory < handle
    %PINETWORKFACTORY Constructs random or specific PINetworks
    
    properties
        n_nodes_gen = @() 10;
        n_branches_gen = @() 2;
        n_positive_feedback_gen = @() 2;
        n_negative_feedback_gen = @() 3;
        n_pins_to_combine = 1;
    end
    
    methods (Abstract)
        
        getParametersForTopology(self,topology)%generate a pin with parameters given a topology
        
        res = combinePINs(self,pins)%given a cell array of pins combine into a single pin - implementation depends on the type of pins
        
        simple_simulation = getSimpleSimulation(self,pin)%used to test the dynamics of the generated network to see if they look realistic
        
    end
    
    methods ( Access = public )    
        function self = PINFactory(n_nodes_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen,n_pins_to_combine)
            if ( nargin > 0 )
               self.n_nodes_gen = n_nodes_gen; 
            end
            if ( nargin > 1 )
               self.n_branches_gen = n_branches_gen; 
            end
            if ( nargin > 2 )
               self.n_positive_feedback_gen = n_positive_feedback_gen; 
            end
            if ( nargin > 3 )
               self.n_negative_feedback_gen = n_negative_feedback_gen; 
            end
            if ( nargin > 4 )
                self.n_pins_to_combine = n_pins_to_combine;
            end
        end
        
        function random_pin_generator = getRandomNetworkGenerator(self)
           random_pin_generator =  @() self.getRandomPIN();
        end
    end
    methods ( Access = private )    
        function adjacency_matrix = getRandomNetworkTopology(self)
           n = self.n_nodes_gen;
           n_branches = self.n_branches_gen();
           n_positive_feedback = self.n_positive_feedback_gen();
           n_negative_feedback = self.n_negative_feedback_gen();
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
           adjacency_matrix = f;
        end
        
       
        
        function res = checkPIN(self,pin)
            %simulation_ = PINSimulationOriginal(pin,simple_simulation_setup);
            simulation_ = self.getSimpleSimulation(pin);
            [t,y] = simulation_.run();
            plot(t,y)
            [~,m] = size(y);
            check_times_nonzero = [1.1,2.1,3.1]*(simulation_.end_time/5.0);
            count_nonzero = zeros(1,m);
            for time_=1:length(check_times_nonzero)
                idx = max(t(t<check_times_nonzero(time_)))==t;
                count_nonzero = count_nonzero | abs(y(idx,:)) > 0.01;
            end
            check_times_nonequal = [1,2.5]*(simulation_.end_time/4.0);
            count_nonequal = ones(1,m);
            for time_=1:length(check_times_nonequal)
                if time_<length(check_times_nonequal)
                   idx = max(t(t<check_times_nonequal(time_)))==t;
                   idx2 = max(t(t<check_times_nonequal(time_+1)))==t;
                   count_nonequal = count_nonequal & abs(y(idx,:)-y(idx2,:))>.05;   
                end
            end
            if  sum(count_nonzero) == m && sum(count_nonequal) > m*0.4
                res = 1;
            else
                res = 0;
            end
        end
        
        function pin = getRandomPINInternal(self)
            %----------------------------
            %define a simple simulation setup to test if the generated
            %network is generating networks that make sense
            %----------------------------
            adjacency_matrix = self.getRandomNetworkTopology();
            pin = self.getParametersForTopology(adjacency_matrix);
            
            %generate several networks and find one that has good dynamics
            for i=1:100
                if self.checkPIN(pin);
                   break 
                end
                pin = self.getParametersForTopology(adjacency_matrix);
            end
            if i == 100
                 error('getRandomPinInternal:bad topology Could not geenerate parameters that result in reasonable dynamics');
            end
        end
        
        function pin = getRandomPIN(self)
            if self.n_pins_to_combine == 1
               pin = self.getRandomPINInternal();
            else
                pins = cell(self.n_pins_to_combine,1);
                for i=1:self.n_pins_to_combine
                   pins{i} = self.getRandomPINInternal();
                end
                pin = self.combinePINs(pins,f_gen);
                for i=1:100
                    if self.checkPIN(pin)
                        break
                    end   
                    pin = self.combinePINs(pins,f_gen);
                end
                if i == 100
                     error('getRandomPIN:combine failed - Could not combine the networks in a way that results in reasonable dynamics');
                end
            end
        end
        
    end
    
    methods (Static)
        function pin_factory = get14NodesFactory()
            pin_factory = BSTPINFactory();
            pin_factory.A_g_gen = @(n) .06+0.1*rand(n,1);
            pin_factory.D_g_gen = @(n) .02+0.07*rand(n,1);
            pin_factory.f_gen = @(sign) sign.*(0.1*randn()+1);
            pin_factory.n_nodes_gen = @() 14;
            pin_factory.n_branches_gen = @() 2;
            pin_factory.n_positive_feedback_gen = @() 2;
            pin_factory.n_negative_feedback_gen = @() 4;
            pin_factory.n_pins_to_combine = 1;
        end
        
        function pin_factory = get42NodesFactory()
            pin_factory = PINFactory.get14NodesFactory();
            pin_factory.n_pins_to_combine = 3;
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
            pin_factory.n_pins_to_combine = 1;
        end
        
        function pin_factory = get10NodesFactory()
            pin_factory = tanhPINFactory();
            pin_factory.n_nodes_gen = 10;
            pin_factory.n_branches_gen = 2;
            pin_factory.n_positive_feedback_gen = @() rand()*3;
            pin_factory.n_negative_feedback_gen = @() rand()*3+1;
            pin_factory.n_pins_to_combine = 1;
            
            pin_factory.f_gen = @(sign) sign*rand(1,1)*10;
        end
    end
    
end


