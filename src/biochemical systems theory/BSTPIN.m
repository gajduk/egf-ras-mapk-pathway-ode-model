classdef BSTPIN < PINAbstract
    %PINETWORK Describes a protein interaction network under the
    %Biochemical Systems Theory model
    
    properties
        A_g = [];%activation coefficients - one for each node
        D_g = [];%deactivation coefficients - one for each node
        A_f_s = [];%self-activation exponents - should be ones  - one for each node
        D_f_s = [];%self-deactivation exponents - should be ones  - one for each node
        I_f = [];%activation by input signal (ligand) - one for each node
     end
    
    methods
        function self = BSTPIN(n,A_g,D_g,A_f_s,D_f_s,I_f,f)
            self = self@PINAbstract(n,f);
            if ~ (self.checkN(A_g,n) && self.checkN(D_g,n) && self.checkN(A_f_s,n) && self.checkN(D_f_s,n) && self.checkN(I_f,n))
                error('Error. There should be one coefficient for each node')
            end
            self.A_g = A_g;
            self.D_g = D_g;
            self.A_f_s = A_f_s;
            self.D_f_s = D_f_s;
            self.I_f = I_f;
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

