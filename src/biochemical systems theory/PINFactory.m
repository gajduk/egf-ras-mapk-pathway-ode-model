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
           random_pin_generator =  @() self.getRandomNetwork(self.n_nodes_gen, ...
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
        
        function pinetwork = getRandomNetwork(self,n_nodes_gen,A_g_gen,D_g_gen,f_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen)
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
    end
    methods (Static)
        function pin_factory = get14NodesFactory()
            pin_factory = PINFactory();
            pin_factory.A_g_gen = @(n) .06+0.1*rand(n,1);
            pin_factory.D_g_gen = @(n) .02+0.07*rand(n,1);
            pin_factory.f_gen = @(sign) sign.*(0.15*randn()+1);
            pin_factory.n_nodes_gen = @() 14;
            pin_factory.n_branches_gen = @() 2;
            pin_factory.n_positive_feedback_gen = @() 2;
            pin_factory.n_negative_feedback_gen = @() 5;
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


