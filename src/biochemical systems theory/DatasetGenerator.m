classdef DatasetGenerator < handle
    %DATASETGENERATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function self = DatasetGenerator()
            
        end
        
        function res = generate(self,number_of_networks,n_gen,n_branches_gen,n_positive_links_gen,n_negative_links_gen)
            res = cell(number_of_networks,1);
            pin_factory = PINetworkFactory();
            i = 0;
            while i<number_of_networks
                n = n_gen();
                pin = pin_factory.getRandomNetwork(n,           ...
                    @(n) .05+0.1*rand(n,1),                     ...
                    @(n) .05+0.1*rand(n,1),                     ...
                    @(sign) sign.*(randn()/8+1),                ...
                    n_branches_gen(), n_positive_links_gen(), n_negative_links_gen());

                simulation = PINetworkSimulation(pin,@(t) t<10);
                
                [t,y] = simulation.run([0 120]);
                count_nonzero = sum(y(end,:) > 0.01);
                if count_nonzero > n*0.7
                    i = i+1;
                    instance = {};
                    instance.pin = pin;
                    instance.t = t;
                    instance.y = y;
                    res{i} = instance;
                end
            end
        end
    end
    
end

