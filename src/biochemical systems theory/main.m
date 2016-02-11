function dataset = main()
    generator = DatasetGenerator();

    n_networks = 1;
    pin_simulation_setups = cell(1,1);

    %define the different network setups
    input = PINSimulationSetup.pulse_input(20);
    inhibition = PINSimulationSetup.getInhibitionOfOneProtein(2,120);
    end_time = 240;
    pin_simulation_setups{1} = PINSimulationSetup(end_time,input,inhibition);

    %define the network generator
    A_g_gen = @(n) .05+0.1*rand(n,1);
    D_g_gen = @(n) .05+0.1*rand(n,1);
    f_gen = @(sign) sign.*(randn()/8+1);
    n_nodes_gen = @() 14;
    n_branches_gen = @() 2;
    n_positive_feedback_gen = @() 2;
    n_negative_feedback_gen = @() 4;

    pin_factory = PINFactory();
    pin_generator = pin_factory.getRandomNetworkGenerator(n_nodes_gen, ...
        A_g_gen,D_g_gen,f_gen,n_branches_gen, ...
        n_positive_feedback_gen,n_negative_feedback_gen);

    dataset = generator.generate(n_networks,pin_simulation_setups,pin_generator);
   