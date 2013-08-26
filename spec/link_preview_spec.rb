require 'spec_helper'

describe LinkPreview do
  let(:link_data) { LinkPreview.extract_from('http://someurl.com') }
  let(:response) {
    double(
      code: 200,
      body: body,
      headers: {}
    )
  }

  let(:body) {
    <<-HTML
      <html>
        <head>
          <meta property="og:title" content="This is a title">
          <meta property="og:description" content="A description for your face">
          <meta property="og:image" content="http://imageurl.com">
          <meta name="Description" content="Here is a description not for facebook">
          <meta name="KEYWORDS"    content="Keywords, Keywords everywhere">
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
  before do
    RestClient.stub(:get).and_return(response)
  end

  describe '.extract_from' do
    it "returns a link data object" do
      link_data.should be_a(LinkPreview::LinkData)
    end

    it "defaults to the og title" do
      link_data.title.should == "This is a title"
    end

    it 'defaults to the og image' do
      link_data.image_url.should == 'http://imageurl.com'
    end

    it "defaults to the og description" do
      link_data.description.should == 'A description for your face'
    end
  end

end