log = new ObjectLogger("practical.BaseSchema", "debug")


@practical.BaseSchemaRules = ->
  return {
    # https://github.com/aldeed/meteor-collection2#autovalue
    # Force value to be current date (on server) upon insert
    # and prevent updates thereafter.
    createdAt:
      type: Date
      index: 1
      autoValue: ->
        if @isInsert
          return lv.util.getCurrentDate()
        else if @isUpsert
          return {$setOnInsert: lv.util.getCurrentDate()}
        else
          this.unset()
      denyUpdate: true

    # https://github.com/aldeed/smeteor-collection2#autovalue
    # Force value to be current date (on server) upon update.
    # On insert, it will always be set to the insert date.
    modifiedAt:
      type: Date
      index: 1
      autoValue: ->
        if @isUpdate
          return lv.util.getCurrentDate()
        else if @isUpsert
          return {$set: lv.util.getCurrentDate()}
      denyInsert: true
      optional: true
    }
