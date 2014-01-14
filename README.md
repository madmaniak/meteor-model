#meteor-model

## Installation

Move your ```<body>``` to ```<template name='body'>```.

###Using meteorite

```
mrt add model
```

### Alternative (if something doesn't work)

Copy whole ```lib/```into your Meteor app. 
Install the `coffeescript` package:

```
meteor add coffeescript
```

## Features

```coffeescript

class User extends Model
  @set_collection()
  
  @belongs_to 'group'
  
  isValid: ->
    @name.length >= 3 and \
    @age >= 18
    
class Group extends Model
  @set_collection()
  @has_many 'users'
  
User.new(name: 'Bob', age: 18).save()

```

```set_collection``` generates reference to mongo collection and ```Template.modelName.collection```.

### CRUD

```#update``` ,
```#destroy``` ,
```.first``` ,
```.where``` ,
```.all``` ,
```.count``` ,
```.create``` ,
```.destroy_all``` .

#### actions straight from templates

You can use ```create``` , ```.update``` , ```.destroy``` in html and it'll work out of the box. Demo in Haml (according to models from previous example):

```haml
%template{ name: :body }
  {{> groups}}
  
%template{ name: :groups }
  {{> new_group}}
  
  / collection is defined by Model
  {{#each collection}}
  {{> group}}
  {{/each}}
  
%template{ name: :new_group }
  / create class will trigger action
  %form.create{ model: :Group }
    %input{ name: :name }
    %button{ type: :submit } Add group
    
%template{ name: :group }
  %h1 {{name}}
  / destroy class
  .destroy Remove
  {{> users}}
  
%template{ name: :users }
  {{> new_user}}
  
  {{#each collection}}
  {{> user}}
  {{/each}}
  
%template{ name: :new_user }
  %form.create{ model: :User }
    %input{ name: :name }
    %input{ name: :age }
    %button{ type: :submit } Add user
    
%template{ name: :user }
  %h2 {{name}}
  {{age}}
  .destroy Remove
```

### Hooks
```.on_update``` ,
```.on_destroy``` ,
```.on_create``` .

### Relations

```.belongs_to``` ,
```.has_many``` :

```coffeescript

user = User.first()
user.group.new name: 'Group #2' # => Group
user.group() # => Group

group = Group.create name: 'G #3'
user.group.set group # => Group

group.users() # => Array[Group]
group.users(name: 'Bob') # => Array[Group]

#other

group.users.new name: 'Username' # => User
group.users.add User.first(name: 'Marek') # => User

```

### Validations

```coffeescript

User.create name: 'Bob', age: 18 # => User
User.create name: '' # => false
```

### Looks great in Meteor Template usage, e. g.:

```coffeescript
  Template.groups.collection = -> Group.all()
  Templage.users.collection = -> @.users()
  
  Template.users.events
    'click .remove': -> @.destroy()
```


## Notices

Package under development. Proof of concept. Good for prototyping. There is no tests, but code is short and easy. You can fix bugs and add new features yourself. You're welcome to contribute or reporting.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
