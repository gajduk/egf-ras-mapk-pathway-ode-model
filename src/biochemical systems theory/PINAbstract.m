classdef PINAbstract  < handle
    %PINABSTRACT Describes a prtoein interaction network and its dynamics
    
    properties
        n = -1;%number of nodes in the netowrk (equal to the number of proteins)
        f = [];%adjecency matrix with strengths
    end
    
    methods
        function self = PINAbstract(n,f)
            if ~ (self.checkNN(f,n)  )
                error('Error. There should be one coefficient in `f` for each node-node  pair')
            end
            self.f = f;
            self.n = n;
        end
        
         function good = checkN(~,vector,n)
           good = length(vector) == n; 
        end
        
        function good = checkNN(~,vector,n)
           good = all(size(vector) == [n,n]); 
        end
    end
    
    methods (Abstract)
       dx = ode_model(self,t,x,current_input) 
    end
    
end

