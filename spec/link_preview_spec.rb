require 'spec_helper'

describe LinkPreview do
  let(:link_data) { LinkPreview.extract_from('http://someurl.com') }
  let(:code) { 200 }
  let(:response_hash) {
    {
      code: code,
      body: 'body',
      headers: {}
    }
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
  end
end