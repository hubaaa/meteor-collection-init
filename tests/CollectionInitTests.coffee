log = new ObjectLogger("practical.CollectionInitTests")

describe "CollectionInit", ->

  collectionName = "collection"
  collection = new Mongo.Collection(collectionName)

  beforeEach ->

    delete collection.practical

    spies.create("Meteor.subscribe", Meteor, "subscribe") if Meteor.isClient

    if Meteor.isServer
      spies.create("Meteor.publish", Meteor, "publish")

    stubs.create("collection.ensureIndex", collection, "_ensureIndex")


  it "Add 'practical' property to the collection", ->

    CollectionInit.init(collection)
    expect(collection.practical).to.be.an("object")
