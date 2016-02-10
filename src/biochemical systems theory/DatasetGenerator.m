classdef DatasetGenerator < handle
    %DATASETGENERATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods(Static)
        function input = oscilatory_input()
            input = @(t) (cos(t/10)+1)/2;
        end
        function input = pulse_input(duration)
            input = @(t) t<duration;
        end
        function input = continous(duration)
            input = @(t) t<duration;
        end
         
    end
    
    methods
        function self = DatasetGenerator()
            
        end
        
        function res = generate(self,number_of_networks,input,n_gen,n_branches_gen,n_positive_links_gen,n_negative_links_gen)
            res = cell(number_of_networks,1);
            pin_factory = PINetworkFactory();
            parfor i=1:number_of_networks
                n = n_gen();
                while 1
                    pin = pin_factory.getRandomNetwork(n,           ...
                        @(n) .05+0.1*rand(n,1),                     ...
                        @(n) .05+0.1*rand(n,1),                     ...
                        @(sign) sign.*(randn()/8+1),                ...
                        n_branches_gen(), n_positive_links_gen(), n_negative_links_gen());

                    simulation = PINetworkSimulation(pin,input);

                    [t,y] = simulation.run([0 120]);
                    count_nonzero = sum(y(end,:) > 0.01 | y(int32(length(t)/2),:) > 0.01);
                    if count_nonzero == n
                        instance = {};
                        instance.pin = pin;
                        instance.t = t;
                        instance.y = y;
                        res{i} = instance;
                        break
                    end
                end
            end
            res = Dataset(res);
        end
        
        function res = getEGFRnetwork(self)
            pin = PINetwork(6,                    ...
                                  ... %(de)-activation coefficients
                                  [1,1,1,1,1,1],[1,1,1,1,1,1],    ...
                                  ... %self (de)-activation exponents
                                  [1,1,1,1,1,1],[1,1,1,1,1,1],      ...
                                  ...%input activation
                                  [1,0,0,0,0,0],              ...
                                  ... %activating exponents
                               ...% 1  2  3  4  5  6
                                  [ 0, 1, 0, 0, 0, 1;
                                    0, 0, 1, 0, 0, 0;
                                    0, 0, 0, 1, 0, 0;
                                    0, 0, 0, 0, 1, 0;
                                    0,-1, 0,-1, 0, 0;
                                   -1, 0, 0, 0, 0, 0 ]);
            simulation = PINetworkSimulation(pin,@(t) t<10);

            [t,y] = simulation.run([0 120]);
            plot(t,y);
            instance = {};
            instance.pin = pin;
            instance.t = t;
            instance.y = y;
            res = cell(1,1);
            res{1} = instance;
            res = Dataset(res);
        end
    end
    
end

