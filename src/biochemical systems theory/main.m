generator = DatasetGenerator();
dataset = generator.generate(20,DatasetGenerator.oscilatory_input(), @() 14,@() 2,@() 2,@() 4);
dataset.dumpAsCsv('out_oscilatory',12);