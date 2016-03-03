classdef DatasetGenerator < handle    
    properties
        
    end
    
    
    methods
        function self = DatasetGenerator()
            
        end
        
        function res = generate(self,number_of_networks,pin_simulation_setups,pin_generator)

            res = cell(number_of_networks,1);
            
            %----------------------------
            %define a simple simulation setup to test if the generated
            %network is generating networks that make sense
            %----------------------------
            end_time_ = 160;
            input = PINSimulationSetup.pulse_input(20);
            inhibition = PINSimulationSetup.getNoInhibition();
            simple_simulation_setup = PINSimulationSetup(end_time_,input,inhibition);
            
                
            for network_idx=1:number_of_networks
                %----------------------------------------------
                %-- generate a good random network topology  --
                %----------------------------------------------
                
                pin = pin_generator();
                tries = 1;
                tries_nonzero = 0;
                tries_nonequal = 0;
                while 1
                    simulation_ = PINSimulation(pin,simple_simulation_setup);
                    [t,y] = simulation_.run();
                    [~,m] = size(y);
                    plot(t,y);
                    check_times_nonzero = [50,100,150];
                    count_nonzero = zeros(1,m);
                    for time_=1:length(check_times_nonzero)
                        idx = max(t(t<check_times_nonzero(time_)))==t;
                        count_nonzero = count_nonzero | y(idx,:) > 0.01;
                    end
                    check_times_nonequal = [100,150];
                    count_nonequal = ones(1,m);
                    for time_=1:length(check_times_nonequal)
                        if time_<length(check_times_nonequal)
                           idx = max(t(t<check_times_nonequal(time_)))==t;
                           idx2 = max(t(t<check_times_nonequal(time_+1)))==t;
                           count_nonequal = count_nonequal & abs(y(idx,:)-y(idx2,:))>.05;   
                        end
                    end
                    if  sum(count_nonzero) == m && sum(count_nonequal) > m*0.4  && sum(count_nonequal) < m*0.8
                        break
                    end
                    tries = tries+1
                    tries_nonzero = tries_nonzero+(sum(count_nonzero) == m)
                    tries_nonequal = tries_nonequal+(sum(count_nonequal) > m*0.4  && sum(count_nonequal) < m*0.8)
                    pin = pin_generator();
                end
                
                %----------------------------------------------
                %-- simulate all the different setups        --
                %----------------------------------------------
                
                pin_simulation_results = cell(1,length(pin_simulation_setups));
                
                for setup_idx=1:length(pin_simulation_setups)
                   pin_simulation_setup = pin_simulation_setups{setup_idx};
                   simulation = PINSimulation(pin,pin_simulation_setup);
                   [t,y] = simulation.run();
                   simulation_results = {};
                   simulation_results.t = t;
                   simulation_results.y = real(y);
                   %subplot(2,3,setup_idx)
                   %plot(t,y)
                   simulation_results.inhibit = pin_simulation_setup.inhibit_label;
                   pin_simulation_results{setup_idx} = simulation_results;
                end
                res{network_idx} = Instance(pin,pin_simulation_results);
                
            end
            res = Dataset(res);
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


