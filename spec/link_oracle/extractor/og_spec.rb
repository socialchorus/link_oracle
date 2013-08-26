require 'spec_helper'

describe LinkOracle::Extractor::OG do
  let(:parsed_body) { ::Nokogiri::HTML.parse(body) }
  let(:link_data) { LinkOracle::Extractor::OG.new(parsed_body).perform }

  let(:body) {
    "<html>
      <head>
        <meta property=\"og:title\" content=\"This is a title\">
        <meta property=\"og:description\" content=\"A description for your face\">
        <meta property=\"og:image\" content=\"http://imageurl.com\">
        <meta name=\"Description\" content=\" \tHere is a description not for facebook\t\">
        <meta name=\"KEYWORDS\"    content=\" \tKeywords, Keywords everywhere  \t\">
        <title>TITLE!</title>
      </head>
    </html>"
  }

  describe 'perform' do
    context 'there is no og_data' do
      let(:body) {
        "<html>
        <head>
          <meta name=\"Description\" content=\" \tHere is a description not for facebook\t\">
        <meta name=\"KEYWORDS\"    content=\" \tKeywords, Keywords everywhere  \t\">
        <title>TITLE!</title>
        </head>
      </html>"
      }

      it 'should fail quietly' do
        expect { link_data }.to_not raise_error
      end
    end

    context 'there is og_data' do

      it 'should populate link_data title' do
        link_data.title.should == 'This is a title'
      end

      it 'should populate link_data image_url' do
        link_data.image_url.should == "http://imageurl.com"
      end

      it 'should populate link_data description' do
        link_data.description.should == 'A description for your face'
      end
    end
  end
end