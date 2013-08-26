require 'spec_helper'

describe LinkData::Extractor::OG do
  let(:parsed_body) { ::Nokogiri::HTML.parse(body) }
  let(:link_data) { LinkData.new }
  let(:extractor) { LinkData::Extractor::OG.new(parsed_body, link_data) }

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
        expect { extractor.perform }.to_not raise_error
      end
    end

    context 'there is og_data' do
      before do
        extractor.perform
      end

      it 'should populate link_data title' do
        link_data.og.title.should == 'This is a title'
      end

      it 'should populate link_data image_url' do
        link_data.og.image_url.should == "http://imageurl.com"
      end

      it 'should populate link_data description' do
        link_data.og.description.should == 'A description for your face'
      end
    end

  end
end