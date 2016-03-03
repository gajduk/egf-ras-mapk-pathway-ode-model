classdef MMPIN < handle
    %PINETWORK Describes a prtoein interaction network under the
    %Micahelis Menten Kinetics
    %*) activation function is defined as
    % v^i_kin = k^i_kin * M^i / (K^i_m1+M^i), where
    % k^i_kin and K^i_m1 are constants M is the concentration of
    % UNphosphorylated protein
    %*) deactivation is defined as 
    % v^i_phos = k^i_phos * M^i_p / (K^i_m2+M^i_P) , where
    % k^i_phos and K^i_m2 are constants M^i_p is the concentration of
    % phosphorylated protein
    %*) positive and negative feedbacks are defined as
    % h^ik = ( 1 + A^ik * M^k_p / K^ik )/( 1 + M^k_p / K^ik ), where
    %  A^ik is a constant >1, note that 1 means no link, k^ik is also a constant
    %  associated with the link, M^k_P is the concentration of
    %  phosphorylated protein
    %the ode for the $i$th protein is written as
    %
    %dM^i_p/dt = v^i_kin * h^ij - v^i_phos * h^ik, 
    %where j has a positive regulation on i
    %and k has a negative regulation on i
    
    
    properties
        n = -1;%number of nodes in the netowrk (equal to the number of proteins)
        k_kin = [];%activation coefficients - one for each node
        k_phos = [];%deactivation coefficients - one for each node
        K_m1 = [];%activating half rate - one for each node
        K_m2 = [];%deactivating half rate - one for each node
        I_kin = [];%activation by input signal (ligand) - one for each node
        A_pos = [];%regulation strengths - 1 means no link one for each link, 
        K_pos = [];%regulation denominator - one for each link
        A_neg = [];%regulation strengths - 1 means no link one for each link, 
        K_neg = [];%regulation denominator - one for each link
        
     end
    
    methods
        function self = MMPIN(n,k_kin,k_phos,K_m1,K_m2,I_kin,A_pos,K_pos,A_neg,K_neg)
            if ~ (self.checkN(k_kin,n) && self.checkN(k_phos,n) && self.checkN(K_m1,n) && self.checkN(K_m2,n) && self.checkN(I_kin,n))
                error('Error. There should be one coefficient for each node')
            end
            if ~ (self.checkNN(A_pos,n) && self.checkNN(K_pos,n) && self.checkNN(A_neg,n) && self.checkNN(K_neg,n) )
                error('Error. There should be one coefficient for each node-node pair')
            end
            self.n = n;
            self.k_kin = k_kin;
            self.k_phos = k_phos;
            self.K_m1 = K_m1;
            self.K_m2 = K_m2;
            self.I_kin = I_kin;
            self.A_pos = A_pos;
            self.K_pos = K_pos;
            self.A_neg = A_neg;
            self.K_neg = K_neg;
        end
        
        function good = checkN(~,vector,n)
           good = length(vector) == n; 
        end
        
        function good = checkNN(~,vector,n)
           good = all(size(vector) == [n,n]); 
        end
        
        
        function dx = ode_model(self,t,x,current_input)
            mp = x;  m = 1-x;
            v_kin = (self.k_kin + current_input .* self.I_kin) .* m ./ (self.K_m1+m);
            v_phos = self.k_phos .* mp ./ (self.K_m2+mp);
            temp_kin = bsxfun(@rdivide,mp,self.K_pos);
            v_kin = v_kin .*  prod( ( 1 +  self.A_pos.*temp_kin)./(1+temp_kin) )';
            temp_phos = bsxfun(@rdivide,mp,self.K_neg);
            v_phos = v_phos .*  prod( ( 1 +  self.A_neg*temp_phos)./(1+temp_phos) )';
            dx = v_kin-v_phos;
        end
    end
    
end

