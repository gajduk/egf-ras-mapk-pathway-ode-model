classdef PINSimulationSetup < handle
    %PINETWORKSIMULATIONSETUP defines the input signal, end time and
    %inhibition for a simulation. For some predifined values use the static
    %methods
    
    properties
        input = -1;%function that shows the concentration of input (ligand) over time
        inhibit = -1;%inhibition function
        inhibit_label = -1;%inhibition function
        end_time = -1;
    end
    
    methods
        function self = PINSimulationSetup(end_time,input,inhibit)
            self.end_time = end_time;
            self.input = input;
            if nargin < 3
                temp_inhibit = PINSimulationSetup.getNoInhibition();
            else
                temp_inhibit = inhibit;          
            end
            self.inhibit = temp_inhibit.f;
            self.inhibit_label = temp_inhibit.label;
        end
    end
    
    methods(Static)
        %-------------------------------------
        %--    Predefined inputs            --
        %-------------------------------------
        function input = oscilatory_input()
            input = @(t) (cos(t/10)+1)/2;
        end
        
        function input = pulse_input(duration)
            input = @(t) t<duration;
        end
        
        function input = continous(duration)
            input = @(t) t<duration;
        end
         
        %-------------------------------------
        %--    Predefined inhibitions       --
        %-------------------------------------
        function dx = inhibitProteins(t,x,dx,proteins_idx,times)
            idxs = times < t;
            dx(proteins_idx(idxs)) = -0.5*x(proteins_idx(idxs)); 
        end
        
        function res = getInhibitionOfProteins(protein_idx,time)
            res = {};
            res.label = sprintf('InhibitOneProtein_%d',protein_idx);
            res.f = @(t,x,dx) PINSimulationSetup.inhibitProteins(t,x,dx,protein_idx,time);
        end
                     
        function res = getNoInhibition()
            res = {};
            res.f = @(t,x,dx) dx;
            res.label = 'NoInhibition';
        end
    end
    
end

