class @ModelBase

  @collection: undefined

  @collection_name: ->
    pluralize @class()

  @set_collection: ->
    @collection = new Meteor.Collection @collection_name()
    if Meteor.isClient
      model = @
      Template[@collection_name()].collection = ->
        return @[model.collection_name()]() if @has_relation_with?(model)
        model.all()

  constructor: (attributes = {}) ->
    @assignAttributes attributes

  assignAttributes: (attributes) ->
    for name, value of attributes
      @[name] = value

  getAttributes: ->
    attributes = {}
    for own key, value of @
      continue if key.match(/^_/)
      attributes[key] = value
    attributes

  isPersisted: -> @_id?

  isValid: -> true

  save: ->
    return false unless @isValid()

    attributes = @getAttributes()

    if @isPersisted()
      @constructor.collection.update @_id, { $set: attributes }
    else
      @_id = @constructor.collection.insert attributes

    this

  @new: (attributes) ->
    new @(attributes) if attributes
