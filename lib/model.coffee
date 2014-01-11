class @Model
  id: undefined
  attributes: {}

  constructor: (attributes = {}) ->
    if attributes._id
      @attributes = @_demongoize(attributes)
      @id = attributes._id
    else
      @attributes = attributes

  isPersisted: -> @id?

  isValid: -> true

  save: ->
    return false unless @isValid()

    attributes = @_mongoize(@attributes)
    attributes['_type'] = @constructor._type if @constructor._type?

    if @isPersisted()
      @constructor._collection.update @id, { $set: attributes }
    else
      @id = @constructor._collection.insert attributes

    this

  update: (@attributes) ->
    @save()

  destroy: ->
    if @isPersisted()
      @constructor._collection.remove @id
      @id = null

  _mongoize: (attributes) ->
    taken = {}
    for name, value of attributes
      continue if name.match(/^_/)
      taken[name] = value
    taken

  _demongoize: (attributes) -> @_mongoize(attributes)

  @_collection: undefined
  @_type: undefined

  @new: (attributes) ->
    new @(attributes)

  @create: (attributes) ->
    @new(attributes).save()

  @first: (selector = {}, options = {}) ->
    @_collection.findOne(selector, options)

  @where: (selector = {}, options = {}) ->
    @_collection.find(selector, options)

  @all: (selector = {}, options = {}) ->
    @where(selector, options)

  @toArray: (selector = {}, options = {}) ->
    for attributes in @where(selector, options).fetch()
      new(eval(attributes._type) ? @)(attributes)

  @count: (selector = {}, options = {}) ->
    @where(selector, options).count()

  @destroyAll: (selector = {}) ->
    @_collection.remove(selector)
