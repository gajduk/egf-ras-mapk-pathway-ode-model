classdef tanhPIN < PINAbstract
    %PINETWORK Describes a protoein interaction network using tanh dynamics
    % the odes are taken from Levnjatich paper in srep on
    % derivative-variable ..
    % dM^i_p/dt = -M^i_p + sum_k^N A_ij tanh M^k_p 
    
    
    properties
        k_phos = -1;% deactivation coefficients & one for each node
     end
    
    methods
        function self = tanhPIN(n,k_phos,f)
            self = self@PINAbstract(n,f);
            if ~ (self.checkN(k_phos,n))
                error('Error. There should be one coefficient for each node')
            end
            self.k_phos = k_phos;
        end
        
        function dx = ode_model(self,t,x,current_input)
            mp = x;
            dx = -self.k_phos.*mp + (tanh(mp)'*self.f)';
        end
    end
    
end

