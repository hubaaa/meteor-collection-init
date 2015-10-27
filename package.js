Package.describe({
  name: "practicalmeteor:collection-init",
  summary: "write package tests with mocha and run them in the browser or from the command line with spacejam.",
  git: "https://github.com/practicalmeteor/meteor-mocha.git",
  version: '2.1.0_5'
});


Package.onUse(function(api){
  // Meteor packages
  api.use("coffeescript");

  // Practical Meteor packages
  api.use("practicalmeteor:core");

  // Vendor packages

  // Files
  api.addFiles("CollectionInit.coffee")

});

Package.onTest(function (api) {

  api.use("coffeescript");

  api.use("practicalmeteor:collection-init");

  api.addFiles("tests/CollectionInitTests.coffee")
});