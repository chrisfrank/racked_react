require 'spec_helper'

describe RackedReact::Server do
  it 'should serve index.html from any path' do
    get "/#{SecureRandom.uuid}.html"
    should_see_content_type('text/html')
    should_see_cache_header('no-cache')
  end

  it 'should serve assets from paths starting with /static' do
    get '/static/example.css'
    should_see_cache_header('public, max-age')
    should_see_content_type('text/css')
  end

  def should_see_content_type(content_type)
    expect(last_response).to be_ok
    expect(last_response.header['Content-Type']).to eq(content_type)
  end

  def should_see_cache_header(header)
    expect(last_response.header['Cache-Control']).to include(header)
  end
end
