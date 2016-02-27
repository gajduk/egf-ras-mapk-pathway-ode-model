function dataset = main()
    n_nodes = 14;
    n_networks = 20;
    n_setups = 5;
    
    generator = DatasetGenerator();
    
    
    %define the different network setups
    pin_simulation_setups = cell(1,n_setups);
    p_input = PINSimulationSetup.pulse_input(20);
    o_input = PINSimulationSetup.oscilatory_input();
    end_time = 160;
    
    inhibition = PINSimulationSetup.getNoInhibition();
    pin_simulation_setups{1} = PINSimulationSetup(end_time,p_input,inhibition);
    
    inhibition = PINSimulationSetup.getInhibitionOfProteins([2],[70]);
    pin_simulation_setups{2} = PINSimulationSetup(end_time,p_input,inhibition);  
        
    inhibition = PINSimulationSetup.getInhibitionOfProteins([2,4],[60,120]);
    pin_simulation_setups{3} = PINSimulationSetup(end_time,p_input,inhibition);  
    
    inhibition = PINSimulationSetup.getNoInhibition();
    pin_simulation_setups{4} = PINSimulationSetup(end_time,o_input,inhibition);
    
    inhibition = PINSimulationSetup.getInhibitionOfProteins([2],[70]);
    pin_simulation_setups{5} = PINSimulationSetup(end_time,o_input,inhibition);   
   
    %define the network generator
    A_g_gen = @(n) .06+0.1*rand(n,1);
    D_g_gen = @(n) .02+0.07*rand(n,1);
    f_gen = @(sign) sign.*(0.15*randn()+1);
    n_nodes_gen = @() n_nodes;
    n_branches_gen = @() 2;
    n_positive_feedback_gen = @() 3;
    n_negative_feedback_gen = @() 5;

    pin_factory = PINFactory();
    pin_generator = pin_factory.getRandomNetworkGenerator(n_nodes_gen, ...
        A_g_gen,D_g_gen,f_gen,n_branches_gen, ...
        n_positive_feedback_gen,n_negative_feedback_gen);

    dataset = generator.generate(n_networks,pin_simulation_setups,pin_generator);
   