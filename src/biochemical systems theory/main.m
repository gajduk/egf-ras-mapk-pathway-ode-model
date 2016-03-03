function dataset = main()
    n_nodes = 30;
    n_networks = 1;
    n_setups = 1;
    
    generator = DatasetGenerator();
    
    
    %define the different network setups
    pin_simulation_setups = cell(1,n_setups);
    p_input = PINSimulationSetup.pulse_input(20);
    o_input = PINSimulationSetup.oscilatory_input();
    end_time = 160;
    
    inhibition = PINSimulationSetup.getNoInhibition();
    pin_simulation_setups{1} = PINSimulationSetup(end_time,p_input,inhibition);

    %define the network generator

    pin_factory = PINFactory.get30NodesFactory();
    pin_generator = pin_factory.getRandomNetworkGenerator();

    dataset = generator.generate(n_networks,pin_simulation_setups,pin_generator);
   