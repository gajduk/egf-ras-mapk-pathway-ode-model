function res = topology_parametar_example()
generator = pin_factory_m.PINFactory.get14NodesFactory();%defines the number of nodes, branches etc
generate = generator.getRandomNetworkGenerator();
res = generate();%generates a random topology complete with parameters
end

