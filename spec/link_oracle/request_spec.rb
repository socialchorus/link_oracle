require 'spec_helper'

describe LinkOracle::Request do
  let(:requester) { LinkOracle::Request.new(url) }
  let(:url) { 'http://someurl.com' }
  let(:code) { 200 }
  let(:response_hash) {
    {
      status: code,
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

  describe '#parsed_url' do
    context 'request failures' do
      before do
        stub_request(:any, url).to_return(response_hash)
      end

      context 'page not found' do
        context 'response code is 404' do
          let(:code) { 404 }

          it 'should raise PageNotFound' do
            expect {
              requester.parsed_url
            }.to raise_error(LinkOracle::PageNotFound)
          end
        end

        context 'nonexistant url' do
          it 'should raise ServerNotFound' do
            curl = double('curl', "follow_location=" => true, "max_redirects=" => true)
            allow(curl).to receive(:perform).and_raise(Curl::Err::HostResolutionError)
            allow(Curl::Easy).to receive(:new).and_return(curl)

            expect {
              requester.parsed_url
            }.to raise_error(LinkOracle::ServerNotFound)
          end
        end

        context 'response code is 403' do
          let(:code) { 403 }

          it 'should raise PermissionDenied' do
            expect {
              requester.parsed_url
            }.to raise_error(LinkOracle::PermissionDenied)
          end
        end

        context 'response code is weird' do
          let(:code) { 42 }

          it 'should raise BadThingsHappened' do
            expect {
              requester.parsed_url
            }.to raise_error(LinkOracle::BadThingsHappened)
          end
        end

        context 'parsing goes awry' do
          before do
            ::Nokogiri::HTML.should_receive(:parse).and_raise(ArgumentError)
          end

          it 'should raise ParsingError' do
            expect {
              requester.parsed_url
            }.to raise_error(LinkOracle::ParsingError)
          end
        end
      end
    end

    context 'malformed url' do
      context 'url is invalid' do
        let(:url) { nil }

        it 'should raise InvalidUrl' do
          expect {
            requester.parsed_url
          }.to raise_error(LinkOracle::InvalidUrl)
        end
      end

      context 'url is blank' do
        let(:url) { '' }

        it 'should raise InvalidUrl' do
          expect {
            requester.parsed_url
          }.to raise_error(LinkOracle::InvalidUrl)
        end
      end

      context "the url has weird characters in it" do
        before do
          stub_request(:any, url).to_return(response_hash)
        end

        let(:url) { 'http://www.autoblog.com/2014/09/26/porsche-911-nissan-gtr-world-greatest-drag-race-video/?icid=autos|latest-auto-news|content' }

        it "should encode and not raise an error" do
          expect {
            requester.parsed_url
          }.to_not raise_error
        end
      end
    end
  end
end
