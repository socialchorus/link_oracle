require 'spec_helper'

describe LinkOracle::Extractor::Meta do
  let(:parsed_url) {
    {
      parsed_data: ::Nokogiri::HTML.parse(body),
      url: 'www.some-url.com'
    }
  }
  let(:link_data) { LinkOracle::Extractor::Meta.new(parsed_url).perform }

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

    context "the meta data is there but blank" do
      let(:body) {
        "<html>
          <head>
            <meta name=\"Description\" content=\"\">
            <title></title>
            <meta itemprop='thumbnailUrl' name='thumbnail' content=''>
          </head>
        </html>"
      }

      it 'should set link_data title to nil' do
        link_data.title.should == nil
      end

      it 'should set link_data image_url to nil' do
        link_data.image_url.should == nil
      end

      it 'should set link_data description to nil' do
        link_data.description.should == nil
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
