require 'spec_helper'

describe LinkPreview do
  let(:link_preview) { LinkPreview::Factory.create('http://someurl.com') }
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
        <meta property=\"og:title\" content=\"\tThis is a title\t\">
        <meta property=\"og:description\" content=\"\tA description for your face\t\">
        <meta property=\"og:image\" content=\"\thttp://imageurl.com\t\">
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
      it 'should return an error' do
        expect {
          link_preview
        }.to  change(LinkOgData, :count).by(0)
      end

      it 'should fail quietly' do
        expect { link_preview.perform }.to_not raise_error
      end
    end

    context 'everything is valid' do
      it 'should.perform a record' do
        expect {
          link_preview.perform
        }.to  change(LinkOgData, :count).by(1)
      end
    end
  end
end