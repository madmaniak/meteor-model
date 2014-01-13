#meteor-model

## Installation

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
  @collection: new Meteor.Collection('users')
  @belongs_to 'group'
  
  isValid: ->
    @name.length >= 3 and \
    @age >= 18
    
class Group extends Model
  @collection: new Meteor.Collection('groups')
  @has_many 'users'
  
User.new(name: 'Bob', age: 18).save()

```

### CRUD

```#update``` ,
```#destroy``` ,
```.first``` ,
```.where``` ,
```.all``` ,
```.count``` ,
```.create``` ,
```.destroy_all``` .

### Relations

```#belongs_to``` ,
```#has_many``` :

```coffeescript

user = User.first()
user.group.new name: 'Group #2' # => Group
user.group() # => Group

group = Group.create name: 'G #3'
user.group.set group # => Group

group.users() # => Array[Group]

#other

group.users.new name: 'Username' # => User
group.users.add User.first(name: 'Marek') # => User

```

### Validations

```coffeescript

User.create name: 'Bob', age: 18 # => User
User.create name: '' # => false
```

## Notices

Package under development. Good for prototyping. There is no tests, but code is short and easy. You can fix bugs and add new features yourself. You're welcome to contribute or reporting.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
