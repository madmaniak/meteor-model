class @ModelRelations extends ModelCRUD

  constructor: (attributes = {}) ->
    super attributes
    @setRelations()

  setRelations: ->
    @setBelongsTo()
    @setHasMany()

  @class: -> @name.toLowerCase()
  @relation_key: -> "#{@class()}_id"

  @_belongs_to: R([])
  @_has_many:   R([])

  @in_relation: (relations_to_check...)->
    relations_to_check = R relations_to_check
    relations = @_belongs_to.concat @_has_many
    return relations if relations_to_check.empty()
    relations.intersection(relations_to_check).any()

  has_relation_with: (model) ->
    @_id and model.in_relation @constructor.class()

  @belongs_to: (model) ->
    @_belongs_to = R([model])

  @has_many: (models...) ->
    @_has_many = R models

  setBelongsTo: ->
    @constructor._belongs_to.each (relation) =>
      related_model_name = R(relation).capitalize()
      related_model = global[related_model_name]
      id = @[related_model.relation_key()]
      model = @

      class BelongsTo
        constructor: ->
          return related_model.where _id: id if id

        @set: (object) =>
          model[related_model.relation_key()] = object._id
          model.save()
          object

        @new: (attributes) =>
          @set related_model.create(attributes)

      @[relation] = BelongsTo

  setHasMany: ->
    @constructor._has_many.each (relation) =>
      related_model_name = R( singularize(relation) ).capitalize()
      related_model = global[related_model_name]
      selector = {}
      selector[@constructor.relation_key()] = @_id
      model = @

      class HasMany
        constructor: (attributes = {}, options = {}) ->
          return related_model.where $.extend(selector, attributes), options

        @add: (object) =>
          object[@constructor.relation_key()] = model._id
          object.save()

        @new: (attributes) =>
          @add related_model.create(attributes)

      @[relation] = HasMany
