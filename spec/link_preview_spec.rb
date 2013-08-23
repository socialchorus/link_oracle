require 'spec_helper'

describe LinkPreview do
  let(:link_preview) { LinkPreview::Factory.extract('http://someurl.com') }
  let(:code) { 200 }
  let(:response_hash) {
    {
      code: code,
      body: body,
      headers: {}
    }
  }

  let(:body) {
    "<html>
      <head>
        <meta property=\"og:title\" content=\"This is a title\">
        <meta property=\"og:description\" content=\"A description for your face\">
        <meta property=\"og:image\" content=\"http://imageurl.com\">
        <meta name=\"Description\" content=\" \tOfficial U.S. site for Kia Motors, featuring information on new models, local dealers, search inventory, and special offers. Find out more about the fine selection of cars, SUVs, crossovers, and minivans at Kia.com.\t\">
        <meta name=\"Description\" content=\" \tOfficial U.S. site for Kia Motors, featuring information on new models, local dealers, search inventory, and special offers. Find out more about the fine selection of cars, SUVs, crossovers, and minivans at Kia.com.\t\">
        <meta name=\"KEYWORDS\"    content=\" \tKia, cars, kia cars, kia motors  \t\">
        <title>Kia Cars, SUVs, Crossovers, Minivans, &amp; Future Vehicles | Kia Motors</title>
      </head>
    </html>"
  }

  describe '.perform' do
    before do
      RestClient.stub(:get).and_return(
        double(
          'response',
          response_hash
        )
      )
    end
    context 'invalid url' do
      let(:code) { 404 }

      it 'should not persist the data' do
        link_preview.should == {errors: 'Invalid Url'}
      end

      it 'should fail quietly' do
        expect { link_preview }.to_not raise_error
      end
    end

    context 'url is valid but no ogdata' do
      let(:body) {
        "<html>
          <head>
            <meta name=\"Description\" content=\" \tOfficial U.S. site for Kia Motors, featuring information on new models, local dealers, search inventory, and special offers. Find out more about the fine selection of cars, SUVs, crossovers, and minivans at Kia.com.\t\">
            <meta name=\"KEYWORDS\"    content=\" \tKia, cars, kia cars, kia motors  \t\">
            <title>Kia Cars, SUVs, Crossovers, Minivans, &amp; Future Vehicles | Kia Motors</title>
          </head>
        </html>"
      }
      it 'should fail quietly' do
        expect { link_preview }.to_not raise_error
      end
    end

    context 'everything is valid' do
      it 'should.perform a record' do
        link_preview.should == {
          title: 'This is a title',
          image_url: "http://imageurl.com",
          description: 'A description for your face'
        }
      end
    end
  end
end