require 'spec_helper'

describe Utils::ImageUrlFormatter do
  let(:url) { "http://berkin.com/whatever/else/is/here" }
  let(:image_url) { "/some/stupid/path" }
  let(:formatted_url) { Utils::ImageUrlFormatter.new(url, image_url).perform }

  context 'scheme is http' do
    it 'should return the image as a full url using the host as domain' do
      formatted_url.should == 'http://berkin.com/some/stupid/path'
    end
  end

  context 'scheme is https' do
    let(:url) { "https://berkin.com/whatever/else/is/here" }
    it 'should return the image as a full url using the host as domain' do
      formatted_url.should == 'https://berkin.com/some/stupid/path'
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
      formatted_url.should == nil
    end
  end
end
