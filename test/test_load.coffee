assert = require 'assert'
sinon = require 'sinon'

describe 'hubot-aws', ->
  beforeEach ->
    @robot =
      loadFile: sinon.spy()

    @app = require '../index'

  it 'can be imported without blowing up', ->
    assert @app != undefined

  it 'can run index', ->
    @app(@robot)
