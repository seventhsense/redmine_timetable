# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features)

## Uncomment to clear the screen before every task
# clearing :on

## Guard internally checks for changes in the Guardfile and exits.
## If you want Guard to automatically start up again, run guard in a
## shell loop, e.g.:
##
##  $ while bundle exec guard; do echo "Restarting Guard..."; done
##
## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard 'sass', :input => 'src/sass', :output => 'assets/stylesheets', style: :compressed, 
  compass: true, smart_partials: true

guard :sprockets, destination: 'assets/javascripts', asset_paths: ['src/coffee'],
  root_file: 'assets/javascripts/mygraph.js', js_minify: true do
  watch %r{^coffee/([^/]*)\.js.coffee$}
end


# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
  # watch(/(.*).txt/) {|m| `tail #{m[0]}` }
  watch(%r{^app/models/(.*)\.rb$}) {|m| `ruby test/unit/#{m[1]}_test.rb`}
end
