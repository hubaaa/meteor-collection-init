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


  it "Create publication and subscription for collection is autopublish is true ", ->

    opts = {
      autopublish: true
    }

    CollectionInit.init(collection, opts)

    if Meteor.isClient
      # Save subscription handle into practical
      expect(collection.practical.subHandle).to.be.an("object")
      expect(spies["Meteor.subscribe"]).to.have.been.called
      expect(spies["Meteor.subscribe"].args[0][0]).to.equals(collectionName)

    if Meteor.isServer
      expect(spies["Meteor.publish"]).to.have.been.called
      expect(spies["Meteor.publish"].args[0][0]).to.equals(collectionName)


  it "Calls custom sub and pub if not autopublish", ->

    opts = {
      sub: stubs.create("sub")
      pub: stubs.create("pub")
    }

    CollectionInit.init(collection, opts)
    if Meteor.isClient
      expect(stubs.sub).to.have.been.called

    if Meteor.isServer
      expect(stubs.pub).to.have.been.called

  it "Don't calls custom sub and pub if not autopublish", ->

    opts = {
      autopublish: true
      sub: stubs.create("sub")
      pub: stubs.create("pub")
    }

    CollectionInit.init(collection, opts)

    if Meteor.isClient
      expect(stubs.sub).not.to.have.been.called

    if Meteor.isServer
      expect(stubs.pub).not.to.have.been.called

