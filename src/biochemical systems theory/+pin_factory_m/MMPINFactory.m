classdef MMPINFactory < PINFactory
    %PINETWORKFACTORY Constructs random or specific PINetworks
    
    properties
        link_strength_gen = @(a) rand()+2;
    end
    
    methods
        function self = MMPINFactory()
        end
        
        
        function random_pin_generator = getRandomNetworkGenerator(self)
             random_pin_generator =  @() self.getRandomNetwork(self.n_nodes_gen,...
                 self.link_strength_gen,self.n_branches_gen,self.n_positive_feedback_gen, ...
                 self.n_negative_feedback_gen);
        end
        
        function pinetwork = getRandomNetwork(self,n_nodes_gen,link_strength_gen,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen)
           n = n_nodes_gen();
           
           adjecency_matrix = self.getRandomNetworkTopology(@() n,n_branches_gen,n_positive_feedback_gen,n_negative_feedback_gen);
           %links and feedbacks
           A_pos = ones(n,n);
           K_pos = ones(n,n);
           A_neg = ones(n,n);
           K_neg = ones(n,n);
           for i=1:n
               for k=1:n
                   if adjecency_matrix(i,k) > 0
                       A_pos(i,k) = link_strength_gen(1);
                   else
                       if adjecency_matrix(i,k) < 0
                           A_neg(i,k) = link_strength_gen(-1);
                       end
                   end
               end
           end
           %(de)-activation coefficients
           k_kin = .07+randn(n,1)*.01;
           k_phos = .07+randn(n,1)*.01;
           K_m1 = ones(n,1);
           K_m2 = ones(n,1);
           
           %input activation
           I_kin = zeros(n,1);
           I_kin(1) = .07;
           pinetwork = MMPIN(n,k_kin,k_phos,K_m1,K_m2,I_kin,A_pos,K_pos,A_neg,K_neg);
        end
    end
    
end


