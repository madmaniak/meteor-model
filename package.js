Package.describe({
  summary: "Models for Mongo collections elements"
});

var both = ['client', 'server'];
var model = [
  'lib/model/deps/rubyjs.coffee',
  'lib/model/deps/singularize.js',
  'lib/model/base.coffee',
  'lib/model/crud.coffee',
  'lib/model/relations.coffee',
  'lib/model.coffee'
];

Package.on_use(function (api) {
  api.use('coffeescript', both);
  api.add_files(model, both);
});
