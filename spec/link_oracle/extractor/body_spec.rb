require 'spec_helper'

describe LinkOracle::Extractor::Body do
  let(:parsed_body) { ::Nokogiri::HTML.parse(body) }
  let(:link_data) { LinkOracle::Extractor::Body.new({ url: 'http://berkin.com', parsed_data: parsed_body}).perform }

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
    before do
      FastImage.stub(:size).and_return([0, 0])
    end

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
        expect { link_data }.to_not raise_error
      end
    end

    context 'there are body attributes' do
      it 'should populate link_data titles' do
        link_data.titles.should == [
          'Berkin',
          'Derbin',
          'Cherbin'
        ]
      end

      it 'should populate link_data descriptions' do
        link_data.descriptions.should == [
          "paragraph 1",
          "paragraph 2",
          "paragraph 3"
        ]
      end

      context 'images are a correct size' do
        before do
          FastImage.stub(:size).and_return([100, 121])
        end

        it 'should populate link_data image_urls with the first image of the right size' do
          expect(link_data.image_urls).to match_array([
            "http://berkin.com"
          ])
        end
      end

      context 'images are incorrect size' do
        it 'should populate link_data image_urls' do
          expect(link_data.image_urls).to eq([])
        end
      end

      context 'some images are correct size and some are not' do
        it 'should populate link_data image_urls only with the first correctly sized images' do
          FastImage.should_receive(:size).with("http://berkin.com").and_return([50, 60])
          FastImage.should_receive(:size).with("http://berkin.com/berkin/cherbin.jpg").and_return([160, 155])
          FastImage.should_not_receive(:size).with("http://cherbin.com")
          FastImage.should_not_receive(:size).with("http://flerbin.com")

          expect(link_data.image_urls).to match_array([
            "http://berkin.com/berkin/cherbin.jpg"
          ])
        end
      end
    end
  end
end
