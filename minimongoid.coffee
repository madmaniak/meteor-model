class Minimongoid
  id: null
  attributes: {}

  constructor: (attributes = {}) ->
    @attributes = attributes
    @id = attributes._id

  isPersisted: -> @id?

  isValid: -> true

  save: ->
    return false unless @isValid()

    attributes = @constructor.mongoize(@attributes)
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

  @mongoize: (attributes) ->
    for name, value of attributes
      delete attributes[name] if name in ['_id', '_type']
    
    attributes

  @demongoize: @mongoize

  @_collection: null

  # Rubists will love me, everyone else will burn me!
  #
  # Allows calls like User.new firstname: 'John'
  @new: (attributes) ->
    new @(attributes)

  @create: (attributes) ->
    @new(attributes).save()

  @where: (selector = {}, options = {}) ->
    @_collection.find(selector, options)

  @all: (selector = {}, options = {}) ->
    @_collection.find(selector, options)

  @toArray: (selector = {}, options = {}) ->
    for attributes in @where(selector, options).fetch()
      @new(@demongoize(attributes))

  @count: (selector = {}, options = {}) ->
    @where(selector, options).count()

  @destroyAll: (selector = {}) ->
    @_collection.remove(selector)
