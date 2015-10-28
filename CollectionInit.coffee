log = new ObjectLogger("practical.CollectionInit", "debug")


class @CollectionInit


  @init: (collection, opts = {})->
    try
      log.enter("init", op)
      expect(collection, "collection is not a Mongo Collection").to.be.instanceOf(Mongo.Collection)
      expect(opts, "opts").to.be.an("object")

      collection.practical = {}

      if opts.autopublish
        _autoPublishCollection(collection)

      # Custom publish and subscription handlers
      if opts.sub and opts.pub and not opts.autopublish
        _customSubAndPub(collection, opts)

      if opts.populate? and Meteor.isServer
        expect(opts.populate, "populate").to.be.a("function")
        opts.populate()



    finally
      log.return()


  _autoPublishCollection = (collection)->
    try
      log.enter("_autoPublishCollection")
      expect(collection).to.be.instanceOf(Mongo.Collection)
      expect(collection.practical).to.be.an("object")

      if Meteor.isServer
        Meteor.publish collection._name, ->
          return collection.find({})

      if Meteor.isClient
        collection.practical.subHandle = Meteor.subscribe collection._name,{
          onReady: ->
          onError: (error)->
            log.error("Error with subscription [#{collection._name}]", error) if error
        }

    finally
      log.return()


  _customSubAndPub = (collection, opts)=>
    try
      log.enter("_customSubAndPub", opts)

      if Meteor.isServer
        expect(opts.pub, "custom publication").to.be.a("function")
        opts.pub()

      if Meteor.isClient
        expect(opts.sub, "custom subscription").to.be.a("function")
        opts.sub()

    finally
      log.return()
