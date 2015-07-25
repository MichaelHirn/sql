describe 'SQL.Collection', ->

  options = null
  beforeEach ->
    options =
      sequelize:
        dialect: 'postgres'

  describe 'initialize', ->

    it 'throws an error when constructed without "new"', ->
      expect( -> SQL.Collection()).toThrow( new Error('use "new" to construct a SQL.Collection'))

    it 'throws an error when first argument is neither null nor a string', ->
      expect( -> new SQL.Collection()).toThrow( new Error('First argument to SQL.Collection must be a string or null'))
      expect( -> new SQL.Collection([])).toThrow( new Error('First argument to SQL.Collection must be a string or null'))
      expect( -> new SQL.Collection(123)).toThrow( new Error('First argument to SQL.Collection must be a string or null'))
      expect( -> new SQL.Collection('123', options)).not.toThrow()
      expect( -> new SQL.Collection(null, options)).not.toThrow()
