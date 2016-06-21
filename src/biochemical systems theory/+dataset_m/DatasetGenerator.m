classdef DatasetGenerator < handle    
    properties
        
    end
    
    
    methods
        function self = DatasetGenerator()
            
        end
        
        function res = generate(self,number_of_networks,pin_simulation_setups,pin_generator)
            res = cell(number_of_networks,1);
            parfor network_idx=1:number_of_networks
                %----------------------------------------------
                %-- generate a good random network topology  --
                %----------------------------------------------
                pin = pin_generator();
                %----------------------------------------------
                %-- simulate all the different setups        --
                %----------------------------------------------
                pin_simulation_results = cell(1,length(pin_simulation_setups));
                
                for setup_idx=1:length(pin_simulation_setups)
                   pin_simulation_setup = pin_simulation_setups{setup_idx};
                   %simulation = PINSimulationOriginal(pin,pin_simulation_setup);
                   simulation = simulation_m.PINSimulation(pin,pin_simulation_setup,pin.y0());
                   [t,y] = simulation.run();
                   simulation_results = {};
                   simulation_results.t = t;
                   simulation_results.y = real(y);
                   simulation_results.inhibit = pin_simulation_setup.inhibit_label;
                   pin_simulation_results{setup_idx} = simulation_results;
                end
                res{network_idx} = dataset_m.Instance(pin,pin_simulation_results);
                
            end
            res = dataset_m.Dataset(res);
        end
        
        function res = getEGFRnetwork(self)
            %Depracated
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


