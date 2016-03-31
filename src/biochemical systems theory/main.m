function dataset = main()
    n_nodes = 14;
    n_networks = 10;
    
    generator = DatasetGenerator();
    
    pin_generator = PINFactory.get14NodesFactory().getRandomNetworkGenerator();
    
    %define the different network setups
    pin_simulation_setups = cell(1,n_nodes+1);
    
    p_input = PINSimulationSetup.pulse_input(20);
    end_time = 160;
    inhibition = PINSimulationSetup.getNoInhibition();
    pin_simulation_setups{1} = PINSimulationSetup(end_time,p_input,inhibition);
    for inhibited_node=1:n_nodes
        inhibition = PINSimulationSetup.getInhibitionOfProteins([inhibited_node],[70]);
        pin_simulation_setups{inhibited_node+1} = PINSimulationSetup(end_time,p_input,inhibition);
    end
    
    dataset = generator.generate(n_networks,pin_simulation_setups,pin_generator);
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
