Darstellung [![Build Status](https://secure.travis-ci.org/durran/darstellung.png?branch=master&.png)](http://travis-ci.org/durran/darstellung) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/durran/darstellung)
========

Darstellung is a simple DSL for defining what should be displayed in
resource representations most of the time in API consumption. The
library is currently in an experimental phase (pre 1.0.0).

Usage
-----

Say we have a `UserResource` that is responsible for returning
representations of `User` models. With Darstellung, we tell it what
fields to display in a "detail" representation and in a "summary"
representation:

```ruby
class UserResource
  include Darstellung::Representable

  summary :username

  detail :first_name
  detail :last_name
end
```

Then we can initialize a new `UserResource` with a single `User` and ask for
the hash representation back:

```ruby
resource = UserResource.new(user)
resource.detail #=> { version: "none", resource: { first_name: "john", last_name: "doe" }}
resource.summary #=> { version: "none", resource: { username: "john" }}
```

If we provide the `UserResource` with an `Enumerable` of `User`s, we can ask
for a collection, which returns an array of summary representations for each
user in the list.

```ruby
resource = UserResource.new([ user_one, user_two ])
resource.collection #=> { version: "none", resource: [{ username: "john" }, { username: "joe" }]}
```

Versioning
----------

Just like any other piece of software, your application's API is a contract
for others to use, and changes to this contract should follow a sane and
predictable pattern. Darstellung handles this by allowing you to specify versions
in which various attributes are displayed in the detail and summary views.
Clients can request a specific version of the API and get the expected results
back at all times. It is expected that the version numbers follow the
Semantic Versioning Specification in order to maintain some consistency.

Here is a `UserResource` with versioning:

```ruby
class UserResource
  include Darstellung::Representable

  summary :username
  summary :created_at, from: "1.0.1"

  detail :first_name
  detail :last_name, from: "1.0.5", to: "2.0.0"
end
```

If we pass a version to the `detail`, `summary`, and `collection` methods on
the resource, we will only get back attributes that fall in line with the
version specified:

```ruby
resource = UserResource.new(user)
resource.detail("1.0.0")
  #=> { version: "1.0.0", resource: { first_name: "john" }}
resource.detail("1.0.5")
  #=> { version: "1.0.5", resource: { first_name: "john", last_name: "doe" }}

resource.summary("1.0.0")
  #=> { version: "1.0.0", resource: { username: "john" }}
resource.summary("2.0.0")
  #=> { version: "2.0.0", resource: { username: "john", created_at: "2012-1-1" }}

resource = UserResource.new([ user_one, user_two ])
resource.collection("2.0.0")
  # => {
  #   version: "2.0.0",
  #   resource: [
  #     { username: "john", created_at: "2012-1-1" },
  #     { username: "joe", created_at: "2012-1-2" }
  #   ]
  # }
```

Reasoning
---------

This is simply a case of SRP and maintainability. While some may argue against
SRP in Rails being overkill, I disagree and will simply show examples showing
the choices and the developer can decide for themselves. Although my personal
preference would be to use Sinatra or Webmachine in these API cases, there's a good
[blog post](http://blog.gomiso.com/2011/05/16/if-youre-using-to_json-youre-doing-it-wrong)
from the authors of RABL discussing how this gets out of hand quickly in Rails.

Speed
-----

Bypassing Active Model's serialization is going to provide you with a huge
performance benefit. Let's look at a basic Mongoid model:

```ruby
class Band
  include Mongoid::Document
  field :description, type: String
  field :formed_on, type: Date
  field :location, type: String
  field :genres, type: Array, default: []
  field :name, type: String
  field :similarities, type: Array, default: []
  field :sounds, type: Array, default: []
  field :website, type: String
end
```

Now let's serialize the model to json (using YAJL), 100,000 times:

```ruby
bench.report do
  100_000.times do
    band.to_json
  end
end
```
```
     user     system      total        real
37.150000   0.100000  37.250000 ( 37.250232)
```

When we create a resource for the `Band` with Darstellung and serialize it
that way, we get some serious improvement (over 6x faster).

```ruby
class BandResource
  include Darstellung::Representable
  detail :description
  detail :formed_on
  detail :location
  detail :genres
  detail :name
  detail :similarities
  detail :sounds
  detail :website
end

bench.report do
  100_000.times do
    BandResource.new(band).detail.to_json
  end
end
```

```
    user     system      total        real
6.270000   0.010000   6.280000 (  6.277472)
```

The results are drastically different in the simplest of examples, and expect
another order of magnitude gain when including relations.

Serialization
-------------

Darstellung does not deal in serialization at all. It's only purpose is to
provide hash representations of your API resources for specific versions. It's
up to you to call `to_json` or `to_xml` on them, using whatever serialization
library you want.

License
-------

Copyright (c) 2012 Durran Jordan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
