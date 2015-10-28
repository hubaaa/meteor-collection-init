log = new ObjectLogger("practical.CollectionInit", "debug")


class @CollectionInit


  @init: (collection, opts = {})->
    try
      log.enter("init", opts)
      expect(collection, "collection is not a Mongo Collection").to.be.instanceOf(Mongo.Collection)
      expect(opts, "opts").to.be.an("object")

      collection.practical = {}
