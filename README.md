# SQL Databases for Meteor

This is kind of like a blueprint to how an proper SQL DB integration for Meteor
could look like. With livequery, pub/sub, latency compensation and client side
cache.  

While working on it I run into a couple of problems, which are not that hard but
really a bit time consuming (~1-2 weeks probably). Sadly I do not have this time
right now to work on it, but I have thought it through quite a bit, so I will
outline here the basic architectures and steps for maybe someone else or some
time later.

### Multi SQL-Databases support

I think it is very convenient to taggle most of the popular SQL Databases at
one, as they are very similar. A great start is definitely [sequelize](https://github.com/sequelize/sequelize), a very mature and well written JS SQL ORM for PostgreSQL, MySQL (MariaDB), SQLite, MSSQL. This provides an epic interface to interact with the underlying database. It also provides migrations, something very important for a production.

### Schemas and Migrations

One thing that `Mongo.Collection` does not have to care about are Schemas and
Migrations. Sequelize only returns `promises` - including for table creation -
which makes it inconvenient to create a Table at an `SQL.Collection()`
construction. I think the most practicable solution would be, to drop the
Schemas in their own file and make sure that the schema is properly migrated and
executed on `Meteor.startup`. But one has to make sure, that the startup
finishes only when the `.sync()` promise is done. But once this is figured out,
how to properly integrate sequelize and the table schemas into Meteor, we have
already made a big step, as we do not have to worry about the database querying.
That's very convenient.

### Server - Database reactivity

Another part we have to take care of, is that we observe the database for data
changes, as we have to push them down to connected clients via DDP.
The approach to this might differ slightly from DB to DB, but for Postgres we
would have to create a proper Function or Trigger (a working example for the query
is at meteor-postgres package). Then on the server, when we create the publish
endpoint, we have to listen to this Function and convert the incoming messages
into a proper DDP format. Nothing, too fancy about this, as most of the code is
already written somewhere.

### "miniSQL" aka Database on the client

We would need some sort of "miniSQL", the pendant for "miniMongo" - which makes
the latency compensation and client side cache possible. I think a reasonable
approach would be to just rely on 'miniMongo'. Would need maybe a bit of
queeking but I don't see, why we could not make use of `miniMongo` for the
client side `SQL.Collection`. Another solution might be to use sequelize and
construct an in-memory SQLite table - but again this could be tricky and slow on
the client startup.
