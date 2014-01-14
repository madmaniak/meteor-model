if Meteor.isClient

  serializeForm = (e) ->
    formcontents = {}
    $.each $(e.target).serializeArray(), ->
      formcontents[@name] = @value
    formcontents

  Template.crud.events
    'submit .create': (e) ->
      e.preventDefault()

      model = global[ e.target.getAttribute("model") ]
      data = serializeForm(e)

      if @has_relation_with?(model)
        data[@constructor.relation_key()] = @_id

      model.create data
      e.target.reset()

    'submit .update': (e) ->
      e.preventDefault()
      @.update serializeForm(e)

    'click .destroy': ->
      @.destroy()
