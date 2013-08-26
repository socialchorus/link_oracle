require 'spec_helper'

describe LinkOracle::Request do
  let(:requester) { LinkOracle::Request.new(url) }
  let(:url) { 'http://someurl.com' }
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
        <meta name=\"Description\" content=\"Here is a description not for facebook\">
        <meta name=\"KEYWORDS\"    content=\"Keywords, Keywords everywhere\">
        <title>TITLE!</title>
        <meta itemprop='thumbnailUrl' name='thumbnail' content='http://imageurlfrommeta.com'>
      </head>
    </html>"
  }

  describe 'perform' do
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

        it 'should raise PageNotFound' do
          expect {
            requester.parsed_data
          }.to raise_error(LinkOracle::PageNotFound)
        end
      end

      context 'response code is 403' do
        let(:code) { 403 }

        it 'should raise PermissionDenied' do
          expect {
            requester.parsed_data
          }.to raise_error(LinkOracle::PermissionDenied)
        end
      end

      context 'response code is weird' do
        let(:code) { 42 }

        it 'should raise BadThingsHappened' do
          expect {
            requester.parsed_data
          }.to raise_error(LinkOracle::BadThingsHappened)
        end
      end

      context 'url is invalid' do
        let(:url) { nil }

        it 'should raise InvalidUrl' do
          expect {
            requester.parsed_data
          }.to raise_error(LinkOracle::InvalidUrl)
        end
      end

      context 'parsing goes awry' do
        before do
          ::Nokogiri::HTML.should_receive(:parse).and_raise(ArgumentError)
        end

        it 'should raise ParsingError' do
          expect {
            requester.parsed_data
          }.to raise_error(LinkOracle::ParsingError)
        end
      end
    end
  end
end