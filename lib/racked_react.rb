require 'rack'
require 'rack/static'

module RackedReact
  # serves up create-react-app compatible SPAs.
  # delivers index.html for all routes that aren't static assets
  # var `root` must be the path to a React app's `build` directory.
  #
  # mount as many of these things as you want in config.ru, like so:
  # map('/first_app') { run RackedReact::Server.new('path/to/first/build/dir') }
  # map('/second_app') { run RackedReact::Server.new('a/different/build') }
  # run RackedReact::Server.new('the/default/apps/buildpath')
  class Server
    # serves a file from the build directory, but always falls back
    # to index.html, never 404s
    class FileWithFallback
      def initialize(root)
        @root = root
      end

      def headers(path)
        ext = ".#{path.split('.').last}"
        ctype = Rack::Mime.mime_type(ext, 'text/html')
        {
          'Content-Type' => ctype,
          'Cache-Control' => 'no-cache',
        }
      end

      def body(path)
        fullpath = "#{@root}#{path}"
        outpath = File.file?(fullpath) ? fullpath : "#{@root}/index.html"
        File.open(outpath, File::RDONLY)
      end

      def call(env)
        path = env['PATH_INFO']
        [200, headers(path), body(path)]
      end
    end

    def initialize(root = 'build')
      rules = [[:all, { 'Cache-Control' => 'public, max-age=31536000' }]]
      @app = Rack::Builder.new do
        use Rack::Deflater
        use Rack::Static, root: root, urls: ['/static'], header_rules: rules
        run FileWithFallback.new(root)
      end
    end

    def call(env)
      @app.call(env)
    end
  end
end
