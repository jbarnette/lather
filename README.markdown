# Lather

Lather is an easy way to watch files and do something when they
change. By default, it checks for changes every second.

## From the Command Line

The `lather` command-line tool lets you quickly track changes to a set
of files.

    $ lather 'test/**/*_test.rb'

By default, `lather` will print a message each time a file matching
your spec changes. `**` is supported for recursive globbing, but make
sure to escape/quote the glob so your shell doesn't expand it.

You can also run a command every time something changes:

    $ lather -r 'rake test' '{lib,test}/**/*.rb'

## From Code

    require "rubygems"
    require "lather"
    
    watcher = Lather::Watcher.new "**/*.rb" do |changed|
      puts "Files changed: #{changed.join(' ')}"
    end
    
    watcher.go!

If you want to mess with the polling interval:

    # :sleep is in seconds
    Lather::Watcher.new "*.rb", :sleep => 5

## From a Rakefile

    require "rake/lathertask"

    Rake::LatherTask.new "lib/**/*.rb" do |task|
      task.target = :test # the default
      task.globs << "test/**/*_test.rb"
    end

This will call the `target` task any time the `globs` change. The
block is optional.

## Installing

    $ [sudo] gem install jbarnette-lather -s http://gems.github.com

## Hacking

`rake lather` will watch `lib` and `test` and re-run the tests when
something changes. If you're looking for something to work on, chew on
these:

  * A `:force => true` option for `Lather::Watcher` so it'll call the
  change proc with all matched files when it first starts.
  
  * A way to get at the list of changed files in a `-r` command.

  * Some default exclude (like backup/editor files, `.svn`, `.git`)
  patterns, and an easy way to add new ones.

  * A `--sleep <secs>` switch for the command-line tool and the Rake
    task.

## Thanks

Lather owes a huge debt to Ryan Davis' ZenTest library, specifically
`autotest`. Use it. It'll change your life. See also Mike Clark and
Geoff Grossenbach's `rstakeout`.

## License

Copyright 2009 John Barnette [jbarnette@gmail.com]

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
