fs   = require 'fs'
path = require 'path'

module.exports = (robot) ->
  scripts_path = path.resolve __dirname, 'scripts'
  if fs.existsSync scripts_path
    for category_file in fs.readdirSync(scripts_path)
      category_path = path.resolve scripts_path, category_file
      if fs.existsSync category_path
        robot.loadFile category_path, file for file in fs.readdirSync(category_path)
