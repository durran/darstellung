Darstellung [![Build Status](https://secure.travis-ci.org/durran/darstellung.png?branch=master&.png)](http://travis-ci.org/durran/darstellung) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/durran/darstellung)
========

Darstellung is a simple DSL for defining what should be displayed in
resource representations most of the time in API consumption.

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
