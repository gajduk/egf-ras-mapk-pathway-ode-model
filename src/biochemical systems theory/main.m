function res = main()
    n_networks = 100;
    
    generator = dataset_m.DatasetGenerator();
    
    pin_generator = pin_factory_m.PINFactory.get10NodesFactory().getRandomNetworkGenerator();
    
    %define the different network setups
    pin_simulation_setups = cell(1,6);
    
    p_input = simulation_m.PINSimulationSetup.pulse_input(20);
    end_time = 3;
    inhibition = simulation_m.PINSimulationSetup.getNoInhibition();
    pin_simulation_setups{1} = simulation_m.PINSimulationSetup(end_time,p_input,inhibition);
    for inhibited_node=1:4
        inhibition = simulation_m.PINSimulationSetup.getInhibitionOfProteins([inhibited_node],[1.7]);
        pin_simulation_setups{inhibited_node+1} = simulation_m.PINSimulationSetup(end_time,p_input,inhibition);
    end
    inhibition = simulation_m.PINSimulationSetup.getInhibitionOfProteins([2,4],[1.3,1.9]);
    pin_simulation_setups{6} = simulation_m.PINSimulationSetup(end_time,p_input,inhibition);
   
    res = generator.generate(n_networks,pin_simulation_setups,pin_generator);
end


function pin_simulation_setups = getStandardSetupSet()
    n_setups = 5;
    pin_simulation_setups = cell(1,n_setups);
    
    p_input = PINSimulationSetup.pulse_input(20);
    o_input = PINSimulationSetup.oscilatory_input();
    end_time = 160;
    
    inhibition = PINSimulationSetup.getNoInhibition();
    pin_simulation_setups{1} = PINSimulationSetup(end_time,p_input,inhibition);

    inhibition = PINSimulationSetup.getInhibitionOfProteins([2],[70]);
    pin_simulation_setups{2} = PINSimulationSetup(end_time,p_input,inhibition);

    inhibition = PINSimulationSetup.getInhibitionOfProteins([2,4],[60,110]);
    pin_simulation_setups{3} = PINSimulationSetup(end_time,p_input,inhibition);

    inhibition = PINSimulationSetup.getNoInhibition();
    pin_simulation_setups{4} = PINSimulationSetup(end_time,o_input,inhibition);

    inhibition = PINSimulationSetup.getInhibitionOfProteins([2],[70]);
    pin_simulation_setups{5} = PINSimulationSetup(end_time,o_input,inhibition);
    
    %define the network generator
end
