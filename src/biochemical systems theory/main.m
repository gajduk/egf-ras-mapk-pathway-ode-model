function dataset = main()
    generator = DatasetGenerator();
    n_nodes = 14;

    n_networks = 20;
    pin_simulation_setups = cell(1,10);

    %define the different network setups
    input = PINSimulationSetup.pulse_input(20);
    end_time = 160;
    
    for i=1:10
        ps = randi(n_nodes-2,2,1)+2;
        while length(unique(ps)) < 3
           ps = randi(n_nodes-2,2,1)+2;
        end
        inhibition = PINSimulationSetup.getInhibitionOfProteins(ps,[65,110]);
        pin_simulation_setups{i} = PINSimulationSetup(end_time,input,inhibition);   
    end
    
    %define the network generator
    A_g_gen = @(n) .05+0.1*rand(n,1);
    D_g_gen = @(n) .02+0.07*rand(n,1);
    f_gen = @(sign) sign.*(randn()/8+1);
    n_nodes_gen = @() n_nodes;
    n_branches_gen = @() 2;
    n_positive_feedback_gen = @() 2;
    n_negative_feedback_gen = @() 4;

    pin_factory = PINFactory();
    pin_generator = pin_factory.getRandomNetworkGenerator(n_nodes_gen, ...
        A_g_gen,D_g_gen,f_gen,n_branches_gen, ...
        n_positive_feedback_gen,n_negative_feedback_gen);

    dataset = generator.generate(n_networks,pin_simulation_setups,pin_generator);
   