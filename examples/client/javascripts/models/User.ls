@User = class

  @id = 0

  (@name) ->
    @id = @@id++

  getId: -> @id

  getName: -> @name

  setName: !(@name) ->
