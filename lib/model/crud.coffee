class @ModelCRUD extends ModelBase

  update: (attributes) ->
    @assignAttributes(attributes)
    @save()

  destroy: ->
    if @isPersisted()
      @constructor.collection.remove @_id
      @_id = null

  @_first: (selector = {}, options = {}) ->
    @collection.findOne(selector, options)

  @_where: (selector = {}, options = {}) ->
    @collection.find(selector, options)

  @first: (selector = {}, options = {}) ->
    @new @_first(selector, options)

  @where: (selector = {}, options = {}) ->
    new(@)(attributes) for attributes in @_where(selector, options).fetch()

  @all: @where


  @count: (selector = {}, options = {}) ->
    @_where(selector, options).count()

  @create: (attributes) ->
    @new(attributes).save()

  @destroy_all: (selector = {}) ->
    @collection.remove(selector)
