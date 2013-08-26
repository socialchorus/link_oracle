require 'spec_helper'

describe LinkData::OGData::Extractor do
  let(:parsed_body) { ::Nokogiri::HTML.parse(body) }
  let(:link_data) { LinkData.new }
  let(:extractor) { LinkData::OGData::Extractor.new(parsed_body, link_data) }

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
      it 'should return a populated LinkPreview object' do
        extractor.perform
        link_data.og_data.title.should == 'This is a title'
        link_data.og_data.image_url.should == "http://imageurl.com"
        link_data.og_data.description.should == 'A description for your face'
      end
    end

  end
end