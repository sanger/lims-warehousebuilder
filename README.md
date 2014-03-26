# Lims-warehousebuilder
The warehousebuilder is used to build the S2 warehouse database from the messages available on the message bus. 
S2 warehouse is just another view of S2 data to be used for reporting purposes. Meaning that we could delete the S2 warehouse and rebuild it from scratch.

## Usage

Setup the RabbitMQ queue to match the configuration in config/amqp.yml. Edit the warehouse database connection in config/database.yml.

    bundle install
    bundle exec ruby script/setup_rabbitmq_bindings.rb -u user -p password -a http://localhost:15672/api/bindings/%2f/e/psd.s2/q/psd.s2.warehouse 
    rake dev:migrate
    rake dev:run

## Development

The warehouse database has two different kinds of table: current and historic tables. The warehouse builder 
works only with historic tables which contain all the records (potentially more than one record for a same resource).
Current tables are automatically updated with SQL triggers when historic tables are updated. Also, current tables 
contain only the most recent version of a given resource. 

The warehouse builder has a RabbitMQ queue as data source. It consumes the messages one by one from a queue, decodes
them and saves the data in the warehouse.

The warehouse builder uses a lot of default behaviour to save things into the warehouse. Here is an explanation of the 
key parts. 

### General behaviour

Every time the warehouse builder receive a message, the following action are done:

- Decode the payload of the message: the payload usually contains one or many S2 resources. The decoder extracts each S2 resources found in the payload and 
map them to warehouse models. This step returns a list of warehouse model instances.
- For each model involved in the decoding step, we maintain the trigger associated to the historic tables.
- The model instances are saved in the warehouse (in the historic tables and the current tables are updated with the triggers)
- The message is acknowledged (or rejected/requeued if something wrong happened)

### Decoders

In the code, the term 'decoder' refers to the decoding of the message payload into warehouse model instances.
The default behaviour of a decoder is defined in lib/lims-warehousebuilder/json\_decoder.rb. An important method is the
class method 'foreach\_s2\_resource' which is used to identify S2 resources in the message payload. This recursive method tries
to cover all the possible format of nested S2 resources.

For some messages, the default behaviour of JsonDecoder is not enough, and some methods are overriden under lib/lims-warehousebuilder/decoders/ for some models.
When calling a default JsonDecoder instance, it tries to map the payload of the S2 resource to the warehouse model by associating the fields having identical 
names (see JsonDecoder#map\_attributes\_to\_model method). 

### Models

In the warehousebuilder code, the term 'model' refers to the warehouse database table. Each model corresponds to one warehouse historic table. And each instance 
of a model corresponds to a record in a historic table. Models are created automatically for each historic tables (see lib/lims-warehousebuilder/model.rb).
If the model needs more methods than the default generated one, it can be overriden under lib/lims-warehousebuilder/models/. Or if some more models are needed,
it can be defined here too.
