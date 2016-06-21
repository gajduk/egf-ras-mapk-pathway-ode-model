classdef Instance < handle
    %INSTANCE consist of information about a pinetwork and several
    %simulations run on it  ussually with different inputs and or inhibitions
    
    properties
        pin = -1;%a PINetwork
        pin_simulation_results = -1;%a cell array of {t:array,y:matrix [num_nodes x len(t)]}
    end
    
    methods
        function self = Instance(pin,pin_simulation_results)
           self.pin = pin;
           self.pin_simulation_results = pin_simulation_results;
        end
    end
    
end

