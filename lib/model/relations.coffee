class @ModelRelations extends ModelCRUD

  constructor: (attributes = {}) ->
    super attributes
    @setRelations()

  setRelations: ->
    @setBelongsTo()
    @setHasMany()

  @_belongs_to: R([])
  @_has_many:   R([])

  @belongs_to: (models...) ->
    @_belongs_to = R models

  @has_many: (models...) ->
    @_has_many = R models

  setBelongsTo: ->
    @constructor._belongs_to.each (relation) =>
      relation_key = "#{relation}_id"
      id = @[relation_key]
      related_model_name = R(relation).capitalize()
      related_model = global[related_model_name]
      model = @

      class BelongsTo
        constructor: ->
          return related_model.where _id: id if id

        @set: (object) =>
          model[relation_key] = object._id
          model.save()
          object

        @new: (attributes) =>
          @set related_model.create(attributes)

      @[relation] = BelongsTo

  setHasMany: ->
    @constructor._has_many.each (relation) =>
      related_model_name = R( singularize(relation) ).capitalize()
      related_model = global[related_model_name]
      relation_key = "#{@constructor.name.toLowerCase()}_id"
      selector = {}
      selector[relation_key] = @_id
      model = @

      class HasMany
        constructor: ->
          return related_model.where selector

        @add: (object) =>
          object[relation_key] = model._id
          object.save()

        @new: (attributes) =>
          @add related_model.create(attributes)

      @[relation] = HasMany
