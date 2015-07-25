if Meteor.isServer
  Sequelize = Npm.require('sequelize')
###*
# @summary Constructor for a Collection
# @locus Anywhere
# @instancename collection
# @class
# @param {String} name The name of the collection.  If null, creates an unmanaged (unsynchronized) local collection.
# @param {Object} [options]
# @param {Object} options.connection The server connection that will manage this collection. Uses the default connection if not specified.  Pass the return value of calling [`DDP.connect`](#ddp_connect) to specify a different server. Pass `null` to specify no connection. Unmanaged (`name` is null) collections cannot specify a connection.
# @param {String} options.idGeneration The method of generating the `_id` fields of new documents in this collection.  Possible values:
 - **`'STRING'`**: random strings
 - **`'MONGO'`**:  random [`Mongo.ObjectID`](#mongo_object_id) values
The default id generation technique is `'STRING'`.
# @param {Function} options.transform An optional transformation function. Documents will be passed through this function before being returned from `fetch` or `findOne`, and before being passed to callbacks of `observe`, `map`, `forEach`, `allow`, and `deny`. Transforms are *not* applied for the callbacks of `observeChanges` or to cursors returned from publish functions.
###

SQL.Collection = (name, options) ->
  self = @
  unless self instanceof SQL.Collection
    throw new Error('use "new" to construct a SQL.Collection')

  unless name is null or _.isString name
    throw new Error('First argument to SQL.Collection must be a string or null')

  if Meteor.isServer
    sequelize = new Sequelize process.env.MP_POSTGRES, options?.sequelize
    Model = sequelize.define(name,{
      firstName:
        type: Sequelize.STRING
        field: 'first_name'
      lastName:
        type: Sequelize.STRING
      })

    # PROBLEM right here. As this is asynch and return only a promise. Also
    # couldn't find a way to make a promise synchronous.
    Model.sync()

    _.extend self, Model

  return

SQL.Collection:: = new Array
