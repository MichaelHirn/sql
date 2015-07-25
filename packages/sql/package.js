Package.describe({
  name: 'storeness:sql',
  version: '0.0.1',
  summary: 'SQL for Meteor - just like Mongo but with SQL.Collections',
  git: 'https://github.com/storeness/sql',
  documentation: 'README.md'
});

Npm.depends({
  'sequelize': '3.4.1',
  'pg': '4.4.0',
  'pg-hstore': '2.3.2'
});

Package.onUse(function(api) {
  api.versionsFrom('1.1.0.2');
  api.use('coffeescript');
  api.use('underscore');
  api.use('ddp');

  api.addFiles([
    'lib/init.js',
    'lib/collection.coffee'
  ]);

  api.export('SQL');
});

Package.onTest(function(api) {
  api.use('sanjo:jasmine@0.15.1');
  api.use('coffeescript');
  api.use('underscore');
  api.use('storeness:sql');

  // Start postgres test-server
  api.use('numtel:pg-server');
  api.addFiles('tests/db-settings.pg.json');

  api.addFiles('tests/jasmine/collectionSpec.coffee');

  api.addFiles([
    'tests/jasmine/server/collectionServerSpec.coffee'
  ], 'server');
});
