Package.describe({
  summary: "Models for Mongo collections elements"
});

var both = ['client', 'server'];

Package.on_use(function (api) {
  api.use('coffeescript', both);
  api.add_files('lib/model.coffee', both);
});

Package.on_test(function (api) {
  api.add_files('tests/model_tests.coffee', both);
});
