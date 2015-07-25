describe 'SQL.Collection', ->

  options = null

  beforeEach ->
    options =
      sequelize:
        dialect: 'postgres'

  describe 'initialize', ->

    it 'creates a new Model and makes it accessable via the collection', ->
      sql = new SQL.Collection('test', options)
      expect(sql.findById).toBeDefined()

    it 'is ready for inserts', ->
      sql = new SQL.Collection('test', options)
      console.log sql.QueryGenerator
      sql.create()
      sql.all().then((result) -> console.log(result))
      expect(sql.all()).toEqual([])
