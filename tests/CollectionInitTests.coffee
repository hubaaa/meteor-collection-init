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

  it "Calls populate function", ->

    opts = {
      populate: stubs.create("populate")
    }
    CollectionInit.init(collection, opts)

    if Meteor.isServer
      expect(stubs.populate).to.have.been.called
    if Meteor.isClient
      expect(stubs.populate).not.to.have.been.called

  it "create indexes for the collection", ->

    opts = {
      indexes:[
        {
          keys: {name: 1}
          options: {unique: true}
        },
        {
          keys: {title: 1}
          options: {}
        }
      ]
    }

    CollectionInit.init(collection, opts)

    if Meteor.isServer
      expect(stubs["collection.ensureIndex"]).to.have.been.callCount(opts.indexes.length)
      for index in opts.indexes
        expect(stubs["collection.ensureIndex"]).to.have.been.calledWith(index.keys, index.options)

    if Meteor.isClient
      expect(stubs["collection.ensureIndex"]).not.to.have.been.called


  it "Attach base schema to collection", ->

    opts = {
    }

    CollectionInit.init(collection, opts)

    expect(collection.practical.schema).to.be.instanceOf(SimpleSchema)
    expect(_.keys(collection.practical.schemaRules)).to.eql(_.keys(practical.BaseSchemaRules()))

    # I'm using a private property to determinate the keys of the schema of the collection,
    # this can change and made the tests to fail in next releases of the package
    expect(_.keys(collection.practical.schemaRules)).to.eql(collection.practical.schema._schemaKeys)


  it "Attach base schema and other schema to the collection", ->

    opts = {
      schemaRules: {
        name:
          type: String
      }
    }
    expectKeys = _.keys(practical.BaseSchemaRules()).concat(_.keys(opts.schemaRules))


    CollectionInit.init(collection, opts)


    expect(collection.practical.schema).to.be.instanceOf(SimpleSchema)
    expect(_.keys(collection.practical.schemaRules)).to.eql(expectKeys)

    # I'm using a private property to determinate the keys of the schema of the collection,
    # this can change and made the tests to fail in next releases of the package
    expect(_.keys(collection.practical.schemaRules)).to.eql(collection.practical.schema._schemaKeys)

