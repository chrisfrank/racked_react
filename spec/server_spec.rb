require 'spec_helper'

describe RackedReact::Server do
  it 'should always fall back to index.html' do
    get "/#{SecureRandom.uuid}"
    should_see_content_type('text/html')
    should_see_cache_header('no-cache')
  end

  it 'should serve static files from root if they exist' do
    get '/other.txt'
    should_see_content_type('text/plain')
    should_see_body_with('plain text')
  end

  it 'should serve cached assets from paths starting with /static' do
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

  def should_see_body_with(text)
    expect(last_response.body).to include(text)
  end
end
