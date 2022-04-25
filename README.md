# ONS Firestore RubyGem
An opionated abstraction for reading and writing [Google Firestore](https://cloud.google.com/firestore) documents. Note that this gem targets Ruby 3.0 and above.

## Installation

```
gem install ons-firestore
```

## Examples

```ruby
require 'ons-firestore'

firestore = Firestore.new('my-project')
doc = firestore.read_document('cities', 'London')
```

## Licence

This library is licensed under the MIT licence. Full licence text is available in [LICENCE](LICENCE).

## Copyright
Copyright (C) 2022 Crown Copyright (Office for National Statistics)
