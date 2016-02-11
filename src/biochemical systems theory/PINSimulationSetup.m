classdef PINSimulationSetup < handle
    %PINETWORKSIMULATIONSETUP defines the input signal, end time and
    %inhibition for a simulation. For some predifined values use the static
    %methods
    
    properties
        input = -1;%function that shows the concentration of input (ligand) over time
        inhibit = -1;%inhibition function
        end_time = -1;
    end
    
    methods
        function self = PINSimulationSetup(end_time,input,inhibit)
            self.end_time = end_time;
            self.input = input;
            if nargin < 3
                self.inhibit = @(t,x) x;
            else
                self.inhibit = inhibit;                
            end
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
        function dx = inhibitOneProtein(t,x,dx,protein_idx,time)
           if t > time
              dx(protein_idx) = -x(protein_idx); 
           end
        end
        
        function inhibit = getInhibitionOfOneProtein(protein_idx,time)
            inhibit = @(t,x,dx) PINSimulationSetup.inhibitOneProtein(t,x,dx,protein_idx,time);
        end
              
        
        function res = getNoInhibition()
            res = @(t,x,dx) dx;
        end
    end
    
end

