require 'spec_helper'

describe Utils::ImageUrlFormatter do
  let(:url) { "http://berkin.com/whatever/else/is/here" }
  let(:formatted_url) { Utils::ImageUrlFormatter.new(url, image_url).perform }

  context 'the host is missing from the image url' do
    let(:image_url) { "/some/stupid/path" }

    context 'scheme is http' do
      it 'should return the image as a full url using the host as domain' do
        expect(formatted_url).to eq('http://berkin.com/some/stupid/path')
      end
    end

    context 'scheme is https' do
      let(:url) { "https://berkin.com/whatever/else/is/here" }

      it 'should return the image as a full url using the host as domain' do
        expect(formatted_url).to eq('https://berkin.com/some/stupid/path')
      end
    end
  end

  context 'but the host is present, but the scheme is missing' do
    let(:image_url) { "//berkin.com/some/stupid/path" }

    it 'should return the image as a full url using http as the protocol' do
      expect(formatted_url).to eq('http://berkin.com/some/stupid/path')
    end
  end

  context 'image_url is nil' do
    let(:image_url) { nil }
    it 'fails silently' do
      expect {
        formatted_url
      }.not_to raise_error
    end

    it 'returns nil' do
      expect(formatted_url).to be_nil
    end
  end
end
