require 'spec_helper'

describe LinkData::Extractor::Body do
  let(:parsed_body) { ::Nokogiri::HTML.parse(body) }
  let(:link_data) { LinkData.new }
  let(:extractor) { LinkData::Extractor::Body.new(parsed_body, link_data) }

  let(:body) {
    <<-HTML
    <html>
      <head>
        <meta property=\"og:title\" content=\"This is a title\">
        <meta property=\"og:description\" content=\"A description for your face\">
        <meta property=\"og:image\" content=\"http://imageurl.com\">
        <meta name=\"Description\" content=\"Here is a description not for facebook\">
        <meta name=\"KEYWORDS\"    content=\"Keywords, Keywords everywhere\">
        <title>TITLE!</title>
        <meta itemprop='thumbnailUrl' name='thumbnail' content='http://imageurlfrommeta.com'>
      </head>
      <body>
        <img src='http://ads.berkin.com'>
        <img src='http://berkin.com'>
        <img src='/berkin/cherbin.jpg'>
        <img src='http://cherbin.com'>
        <img src='http://flerbin.com'>
        <h1>Berkin</h1>
        <h2>Derbin</h2>
        <h3>Cherbin</h3>
        <p>paragraph 1</p>
        <p>paragraph 2</p>
        <p>paragraph 3</p>
      </body>
    </html>
    HTML
  }

  describe 'perform' do
    context 'there is no suitable stuff in the body' do
      let(:body) {
        "<html>
        <head>
        </head>
        <body>
        </body>
      </html>"
      }

      it 'should fail quietly' do
        expect { extractor.perform }.to_not raise_error
      end
    end

    context 'there are body attributes' do
      before do
        extractor.perform
      end

      it 'should populate link_data titles' do
        link_data.body.titles.should == [
          'Berkin',
          'Derbin',
          'Cherbin'
        ]
      end

      it 'should populate link_data image_urls' do
        link_data.body.image_urls.should == [
          "http://berkin.com",
          "http://cherbin.com",
          "http://flerbin.com"
        ]
      end

      it 'should populate link_data descriptions' do
        link_data.body.descriptions.should == [
          "paragraph 1",
          "paragraph 2",
          "paragraph 3"
        ]
      end
    end
  end
end