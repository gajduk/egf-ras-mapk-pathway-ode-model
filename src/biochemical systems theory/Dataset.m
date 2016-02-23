classdef Dataset < handle
    
    properties
        instances = -1;
    end
    
    methods
        function self = Dataset(instances)
           self.instances = instances; 
        end
        function dumpJson(self,json_filename)
            previouswd = pwd;
            full_filename = strcat('..\..\output\',json_filename);
            fid = fopen(full_filename,'wt');
            fprintf(fid, savejson(self.instances));
            fclose(fid);
            zip(strcat(full_filename,'.zip'),full_filename);
            cd(previouswd);
        end
        
        
        function dumpAsCsv(self,csv_filename,number_of_timepoints)
            %Depracated
            X = [];
            Y = [];
            idxs = zeros(1,number_of_timepoints);
            
            for i=1:length(self.instances)
                instance = self.instances{i};
                max_time = max(instance.t)-1;
                delta_t = max_time/(number_of_timepoints-1);

                for ii=0:number_of_timepoints-1
                    idxs(ii+1) = find(instance.t>(delta_t*ii),1);
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
        function convertFromCsvToJson()
            csv_filename = 'egfr_time_series.csv';
            previouswd = pwd;
            full_filename = strcat('..\..\octave models\',csv_filename);
            M = csvread(full_filename);
            t = M(:,1);
            y = M(:,2:end); 
            %%normalize (not needed)
            %y = bsxfun(@rdivide,y',max(y,[],1)')';
            %%stretch the series (not needed)
            %p = polyfit(t(1:40),y(1:40,1),20);
            %y1 = polyval(p,t/5);
            %y(:,1) = y1;
            
            %build the mapk network
            f = zeros(6,6);
            f(1,2) = 1;
            f(2,3) = 1;
            f(3,4) = 1;
            f(1,5) = 1;
            f(1,6) = 1;
            f(4,2) = -1;
            f(4,1) = -1;
            f(6,1) = 1;
            
            labels = {'EGFR','Raf','MEK','Erk','Akt','Src'};
            
            %build the dataset
            pin.f = f;
            pin_simulation_results1.t = t;
            pin_simulation_results1.y = y;
            pin_simulation_results = cell(1,2);
            pin_simulation_results{1,1} = pin_simulation_results1;    
            pin_simulation_results{1,2} = pin_simulation_results1;
            instance = Instance(pin,pin_simulation_results);
            instances = cell(2,1);
            instances{1,1} = instance;
            instances{2,1} = instance;
            dataset = Dataset(instances);
            
            
            dataset.dumpJson('egfr_model.json')
            cd(previouswd);
        end
    end
    
end

