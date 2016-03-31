classdef PIN < handle
    %PINETWORK Describes a prtoein interaction network under the
    %Biochemical Systems Theory model
    
    properties
        n = -1;%number of nodes in the netowrk (equal to the number of proteins)
        A_g = [];%activation coefficients - one for each node
        D_g = [];%deactivation coefficients - one for each node
        A_f_s = [];%self-activation exponents - should be ones  - one for each node
        D_f_s = [];%self-deactivation exponents - should be ones  - one for each node
        I_f = [];%activation by input signal (ligand) - one for each node
        f = [];%activation exponents - positive or negative (0 = no link) - one for each protein-protein pari
     end
    
    methods
        function self = PIN(n,A_g,D_g,A_f_s,D_f_s,I_f,f)
            if ~ (self.checkN(A_g,n) && self.checkN(D_g,n) && self.checkN(A_f_s,n) && self.checkN(D_f_s,n) && self.checkN(I_f,n))
                error('Error. There should be one coefficient for each node')
            end
            if ~ (self.checkNN(f,n)  )
                error('Error. There should be one coefficient for each node-node pair')
            end
            self.n = n;
            self.A_g = A_g;
            self.D_g = D_g;
            self.A_f_s = A_f_s;
            self.D_f_s = D_f_s;
            self.I_f = I_f;
            self.f = f;
        end
        
        function good = checkN(~,vector,n)
           good = length(vector) == n; 
        end
        
        function good = checkNN(~,vector,n)
           good = all(size(vector) == [n,n]); 
        end
         function dx = ode_model(self,t,x,current_input)
            x = x+.0000000001;
            A_x = self.A_g .* ( (1-x) .^ self.A_f_s );
            D_x = self.D_g .* ( x .^ self.D_f_s );
            A_x = A_x .*  prod( real( bsxfun(@power,x,-(self.f>0).*self.f) ))';
            D_x = D_x .*  prod( real( bsxfun(@power,x,(self.f<0).*self.f) ))';
            A_x = A_x + (1-x) .* self.I_f' .* current_input;
            dx = A_x-D_x;
        end
        function dx = ode_model_backup(self,t,x,current_input)
            A_x = self.A_g .* ( (1-x) .^ self.A_f_s );
            D_x = self.D_g .* ( x .^ self.D_f_s );
            A_x = A_x .*  prod( real( bsxfun(@power,x,(self.f>0).*self.f) ))';
            D_x = D_x .* (1 + .1* prod( real( bsxfun(@power,x(x<0),-self.f(x<0,:)) )))';
            A_x = A_x + (1-x) .* self.I_f' .* current_input;
            dx = A_x-D_x;
        end
    end
    
end

