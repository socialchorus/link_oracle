# LinkOracle
+[![Code Climate](https://codeclimate.com/github/socialchorus/link_oracle.png)](https://codeclimate.com/github/socialchorus/link_oracle)
TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'link_oracle'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install link_oracle

## Usage

To parse a link and extract information:

```link_data = LinkOracle.extract_from('http://example.com')```

This will return a LinkData object. This object makes a a semi-intelligent guess about which image, title, and description to use. To access these defaults:

```title = link_data.title
image_url = link_data.image_url
description = link_data.description```

The LinkData object also contains the parsed data:

```parsed_data = link_data.parsed_data```

Finally, the LinkData object contains the results from individual sections broken into OpenGraph, Meta, and Body. If you are only interested in OpenGraph results:

```found_og_data = link_data.og
title = found_og_data.title
image_url = found_og_data.image
description = found_og_data.description```

For Meta or body:

```found_meta_data = link_data.meta
found_body_data = link_data.body```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
