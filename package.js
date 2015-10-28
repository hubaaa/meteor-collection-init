Package.describe({
  name: "practicalmeteor:collection-init",
  summary: "write package tests with mocha and run them in the browser or from the command line with spacejam.",
  git: "https://github.com/practicalmeteor/meteor-mocha.git",
  version: '0.1.0'
});


Package.onUse(function(api){

  // TODO add specific packages versions
  // Meteor packages
  api.use("coffeescript");
  api.use("mongo");
  api.use("underscore");

  // Practical Meteor packages
  api.use("practicalmeteor:core");

  // Vendor packages
  api.use("aldeed:simple-schema");
  api.use("aldeed:collection2@2.5.0");

  api.imply("aldeed:simple-schema@1.3.3");
  api.imply("aldeed:collection2@2.5.0");

  // Files
  api.addFiles("CollectionInit.coffee")
  api.addFiles("BaseSchemaRules.coffee")

});

Package.onTest(function (api) {

  api.use("coffeescript");
  api.use("mongo");
  api.use("underscore");

  api.use("practicalmeteor:collection-init");
  api.use("practicalmeteor:loglevel");

  api.addFiles("tests/CollectionInitTests.coffee");
});