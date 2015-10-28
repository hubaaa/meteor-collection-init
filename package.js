Package.describe({
  name: "practicalmeteor:collection-init",
  summary: "write package tests with mocha and run them in the browser or from the command line with spacejam.",
  git: "https://github.com/practicalmeteor/meteor-mocha.git",
  version: '0.1.0'
});


Package.onUse(function(api){
  // Meteor packages
  api.use("coffeescript");
  api.use("mongo");

  // Practical Meteor packages
  api.use("practicalmeteor:core");

  // Vendor packages

  // Files
  api.addFiles("CollectionInit.coffee")

});

Package.onTest(function (api) {

  api.use("coffeescript");
  api.use("mongo");

  api.use("practicalmeteor:collection-init");
  api.use("practicalmeteor:loglevel");

  api.addFiles("tests/CollectionInitTests.coffee")
});