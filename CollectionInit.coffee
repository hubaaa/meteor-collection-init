log = new ObjectLogger("practical.CollectionInit", "debug")


class @CollectionInit


  @init: (collection, opts = {})->
    try
      log.enter("init", opts)
      expect(collection, "collection is not a Mongo Collection").to.be.instanceOf(Mongo.Collection)
      expect(opts, "opts").to.be.an("object")

      collection.practical = {}

      if opts.autopublish
        _autoPublishCollection(collection)



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

