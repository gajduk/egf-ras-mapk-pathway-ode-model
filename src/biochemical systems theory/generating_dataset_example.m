function res = generating_dataset_example()
    generator = dataset_m.DatasetGenerator();

	n_networks = 5;

	%generates topology and parameters
    pin_generator = pin_factory_m.PINFactory.get10NodesFactory().getRandomNetworkGenerator();

    %defines stimulation with ligands and/or inhibitions of nodes
    pin_simulation_setup = simulation_m.PINSimulationSetup(30, %how long to integrate in minutes
    	simulation_m.PINSimulationSetup.pulse_input(20), %type of input, pulsed, continues, oscilating
    	simulation_m.PINSimulationSetup.getNoInhibition()); %is there an inhibitor acting on some of the nodes, and at which point is the inhibitor added

    res = generator.generate(n_networks,pin_simulation_setup,pin_generator);
    res.dumpJson('example.json')
end

