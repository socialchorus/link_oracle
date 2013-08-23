require 'spec_helper'

describe LinkPreview do
  let(:link_data) { LinkPreview::Factory.extract('http://someurl.com') }
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

      context 'response code is 404' do
        let(:code) { 404 }
        it 'should return "Page not found"' do
          link_data.errors.should == 'Page not found'
        end
      end

      context 'response code is 403' do
        let(:code) { 403 }
        it 'should return "Permission denied" when 403' do
          link_data.errors.should == 'Permission denied'
        end
      end

      context 'response code is neither 404 or 403' do
        let(:code) { 42 }
        it 'should return "Something terrible has happened" for all other non-200s' do
          link_data.errors.should == 'Something terrible has happened'
        end
      end

      context 'url is invalid' do
        let(:code) { nil }
        it 'should return "Invalid url" when the url is invalid' do
          link_data.errors.should == 'Invalid url'
        end
      end

      it 'should fail quietly' do
        expect { link_data }.to_not raise_error
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
        expect { link_data }.to_not raise_error
      end
    end

    context 'everything is valid' do
      it 'should return a populated LinkPreview object' do
        link_data.title.should == 'This is a title'
        link_data.image_url.should == "http://imageurl.com"
        link_data.description.should == 'A description for your face'
      end
    end
  end
end