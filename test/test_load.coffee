assert = require 'assert'
sinon = require 'sinon'
fs = require 'fs'
path = require 'path'

describe 'hubot-aws', ->
  beforeEach ->
    @robot =
      loadFile: sinon.spy()

    @app = require '../index'

  it 'can be imported without blowing up', ->
    assert @app != undefined

  it 'can run index', ->
    @app(@robot)

  it 'can import scripts', ->
    scripts_path = path.resolve __dirname, '../scripts'
    false unless fs.existsSync scripts_path

    for category_file in fs.readdirSync(scripts_path)
      category_path = path.resolve scripts_path, category_file
      false unless fs.existsSync category_path

      for file in fs.readdirSync(category_path)
        script = require path.resolve category_path, file
        assert script != undefined
