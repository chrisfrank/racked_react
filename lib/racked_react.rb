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
    def initialize(root = 'build')
      rules = [[:all, { 'Cache-Control' => 'public, max-age=31536000' }]]
      @app = Rack::Builder.new do
        use Rack::Deflater
        use Rack::Static, root: root, urls: ['/static'], header_rules: rules
        run FileOrIndex.new(root)
      end
    end

    def call(env)
      @app.call(env)
    end

    # if the request has a file extension, this class tries to serve it.
    # requests with no file extension fall back to /index.html, which is
    # what makes a static SPA with client side routing work.
    class FileOrIndex
      def initialize(root)
        @root = root
      end

      def headers
        {
          'Content-Type' => Rack::Mime.mime_type(@extension, 'text/html'),
          'Cache-Control' => 'no-cache',
        }
      end

      def body
        File.open(@path, File::RDONLY)
      end

      def call(env)
        path = env['PATH_INFO']
        matches = path.match(/(?<extension>\.\w*)\z/)
        @extension = matches ? matches[:extension] : nil
        @path = @extension ? "#{@root}#{path}" : "#{@root}/index.html"
        [200, headers, body]
      end
    end
  end
end
