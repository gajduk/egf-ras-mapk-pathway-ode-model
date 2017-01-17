function res = topology_example()
factory = pin_factory_m.PINFactory.get14NodesFactory();%defines the number of nodes, branches etc
res = factory.getRandomPIN();%generates a random topology
end

