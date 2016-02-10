classdef Dataset < handle
    
    properties
        instances = -1;
    end
    
    methods
        function self = Dataset(instances)
           self.instances = instances; 
        end
        
        function dumpAsCsv(self,csv_filename,number_of_timepoints)
            X = [];
            Y = [];
            idxs = zeros(1,number_of_timepoints);
            
            for i=1:length(self.instances)
                instance = self.instances{i};
                max_time = max(instance.t)-1;
                delta_t = max_time/(number_of_timepoints-1);

                for i=0:number_of_timepoints-1
                    idxs(i+1) = find(instance.t>(delta_t*i),1);
                end
                x = instance.pin.f(:);
                y = instance.y(idxs,:);
                y = y(:);
                X = [X;x'];
                Y = [Y;y'];
            end
            csvwrite(sprintf('%s_Y.csv',csv_filename),real(X))
            csvwrite(sprintf('%s_X.csv',csv_filename),real(Y))
        end
    end
    
    methods (Static)
        function dataset = loadDefault()
            temp = load('100_instances_14_nodes_29_01_16.mat');
            dataset = Dataset(temp.dataset);
        end
    end
    
end

