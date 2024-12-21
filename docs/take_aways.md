#### how to test:
1. different tests for each vseq and a script to run them.
2. test is just time consuming sequence so just write all the sequences probably

#### uvm_object_wrapper:
1. Registration: When you register a class with the UVM factory using uvm_object_utils or uvm_component_utils, a corresponding wrapper class (derived from uvm_object_wrapper) is automatically created. This wrapper class stores metadata about the registered class, such as its type and name.

2. Creation: When you use the factory to create an object (e.g., using type_id::create()), the factory looks up the corresponding wrapper class. The wrapper class then uses its stored metadata to create an instance of the actual class.

3. Override: The wrapper class allows for factory overrides. This means you can dynamically replace the original class with a different one without modifying the code that creates the object. This is useful for configurations, customizations, and testing different implementations. 

4. late binding, and configuration control.

#### virtual sequences vs virtual sequencers:
1. Virtual sequencers are best reserved for cases where tight synchronization between multiple agents is essential.
2. Virtual sequences can be designed to work with different sets of sequencers without being tightly coupled to any specific implementation, promoting reusability.

#### general: (things to remember)
1. directly instantiating everything creates tight coupling.
