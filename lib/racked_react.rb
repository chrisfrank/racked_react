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
    def initialize(root = 'build', h: html_headers, rules: asset_headers)
      @app = Rack::Builder.new do
        use Rack::Deflater
        use Rack::Static, urls: ['/static'], root: root,
                          header_rules: rules
        run ->(_env) { [200, h, File.open("#{root}/index.html", File::RDONLY)] }
      end
    end

    def html_headers
      { 'Content-Type' => 'text/html', 'Cache-Control' => 'no-cache' }
    end

    def asset_headers
      [[:all, { 'Cache-Control' => 'public, max-age=31536000' }]]
    end

    def call(env)
      @app.call(env)
    end
  end
end
