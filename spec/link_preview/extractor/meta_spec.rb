require 'spec_helper'

describe LinkPreview::Extractor::Meta do
  let(:parsed_body) { ::Nokogiri::HTML.parse(body) }
  let(:link_data) { LinkPreview::Extractor::Meta.new(parsed_body).perform }

  let(:body) {
    "<html>
      <head>
        <meta property=\"og:title\" content=\"This is a title\">
        <meta property=\"og:description\" content=\"A description for your face\">
        <meta property=\"og:image\" content=\"http://imageurl.com\">
        <meta name=\"Description\" content=\"Here is a description not for facebook\">
        <meta name=\"KEYWORDS\"    content=\"Keywords, Keywords everywhere\">
        <title>TITLE!</title>
        <meta itemprop='thumbnailUrl' name='thumbnail' content='http://imageurlfrommeta.com'>
      </head>
    </html>"
  }

  describe 'perform' do
    context 'there is no suitable meta data' do
      let(:body) {
        "<html>
        <head>
        </head>
      </html>"
      }

      it 'should fail quietly' do
        expect { link_data }.to_not raise_error
      end
    end

    context 'there is meta data' do
      it 'should populate link_data title' do
        link_data.title.should == 'TITLE!'
      end

      it 'should populate link_data image_url' do
        link_data.image_url.should == "http://imageurlfrommeta.com"
      end

      it 'should populate link_data description' do
        link_data.description.should == 'Here is a description not for facebook'
      end
    end
  end
end