classdef PINetworkFactory < handle
    %PINETWORKFACTORY Constructs random or specific PINetworks
    
    properties
    end
    
    methods
        function self = PINetworkFactory()
        end
        
        function pinetwork = getYeast3PIN(self)
            pinetwork = PINetwork(3,                    ...
                                  ... %(de)-activation coefficients
                                  [1,1,2],[1,2,.2],    ...
                                  ... %self (de)-activation exponents
                                  [1,1,1],[1,1,1],      ...
                                  ...%input activation
                                  [1,0,0],              ...
                                  ... %activating exponents
                                  [ 0, 1, 0;
                                    0, 0, 1;
                                   -1, 0, 0]);
        end
        
        function pinetwork = getRandomNetwork(self,n,A_g_gen,D_g_gen,f_gen,k,n_positive_feedback,n_negative_feedback)
           %(de)-activation coefficients
           A_g = A_g_gen(n);
           D_g = D_g_gen(n);
           %activating exponents
           A_f_s = ones(n,1);
           D_f_s = ones(n,1);
           
           %links
           f = zeros(n,n);
           f(1,2) = f_gen(1);
           for i=2:n-1
               if rand < k/n
                   f(1,i+1) = f_gen(1);
               else
                   f(i,i+1) = f_gen(1);
               end
           end
           for i=1:n_positive_feedback
              source = randi(n-1)+1; 
              dest = randi(source-1);
              while f(source,dest) ~= 0
                  source = randi(n-1)+1; 
                  dest = randi(source-1);
              end
              f(source,dest) = f_gen(1);
           end
           for i=1:n_negative_feedback
              source = randi(n-1)+1; 
              dest = randi(source-1);
              while f(source,dest) ~= 0
                  source = randi(n-1)+1; 
                  dest = randi(source-1);
              end
              f(source,dest) = f_gen(-1);
           end
           %input activation
           I_f = zeros(1,n);
           I_f(1) = 1;
           pinetwork = PINetwork(n,A_g,D_g,A_f_s,D_f_s,I_f,f);
        end
    end
    
end

