# Lift

Discover yourself, be free.

## Development Guide

When developing follow these simple rules:

 * **100% Test Coverage** - Every piece of code should be tested rigorously.
 * **Use Libraries** - Use open source libraries, it's faster and better than writing it ourselves!
 * **Simplicity** - Write as much high quality code as necessary to complete the task.
 * **Refactor** - When working with code a second time, refactor as necessary to keep the quality and abstraction high.
 * **Pair** - 66% of your development should be spent pairing. It's fun, social, and a great learning experience. Why not!
 * **Enjoy It** - Most importantly, if you aren't enjoying working in this code base, then we're doing something wrong.

## Style Guide

Style guides make the code easier to read regardless of who wrote it, please reference this guide for LESS and CoffeeScript. **If you're unsure about what to do, go for the most readable option!**

### CoffeeScript

```coffeescript
lib = require 'lib'

number   = 42
opposite = true
multiWordVariable = 'camelcase'

number = -42 if opposite

square = (x) -> x * x

list = [1, 2, 3, 4, 5]

math =
  root:   Math.sqrt
  square: square
  cube:   (x) -> x * square x

race = (winner, runners...) ->
  print winner, runners

alert "I knew it!" if elvis?

cubes = (math.cube num for num in list)

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

largeList = [
  "a"
  "b"
  "c"
  "d"
  "e"
  "f"
  "g"
  "h"
]

kids =
  brother:
    name: "Max"
    age:  11
  sister:
    name: "Ida"
    age:  9

inlineFunction = -> 1 * 5
```

### Less

```less
@width: 960px;

.transition(@time: .2s) {
  -webkit-transition: all @time ease-in-out;
  -moz-transition: all @time ease-in-out;
  -o-transition: all @time ease-in-out;
  -ms-transition: all @time ease-in-out;
  transition: all @time ease-in-out;
}

a {
  color: @blue-dark;
  font-weight: @bold-weight;

  text-decoration: none;
  cursor: pointer;

  &:hover {
    color: @blue;
    text-decoration: underline;
  }
}
```

## Installation

To get up and running with the project you will need to do the following:

 * Run `script/setup`

That's it, really. We're not kidding.

## Running

To run the app simply use `babushka run` or, if you want the server to update when changes happen, `babushka watch`.

## Tests

The tests are written in [mocha](http://mochajs.org/) and follow BDD convention. Use `babushka test` to run all of them.

 * `babushka test.browser` - Starts our test server and opens up page in your favorite browser to run the client-side tests.
 * `babushka test.client` - Runs all client-side tests automatically using a headless Webkit.
 * `babushka test.backend` - Runs all server tests.

## Technology Stack

### Data Storage

[MongoDB](http://www.mongodb.org/) - NoSQL database with a javascript interface

### Platform

[node](http://www.nodejs.org) - Javascript platform to build network applications  
[express](http://www.expressjs.com) - Minimalist web framework a la Ruby's sinatra

### ORM

[mongoosejs](http://mongoosejs.com/) - Asynchronous object modelling tool for MongoDB 

### Front-End

[less](http://http://lesscss.org/) - Superset of CSS that compiles to CSS  
[coffeekup](http://http://coffeekup.org/) - HTML builder thact utilizes coffeescript  
[space-pen](https://github.com/BamPowLabs/space-pen) - Clientside HTML builder that builds on top of JQuery

### Misc

[now](http://nowjs.com/) - Realtime RPC

### Testing

[mocha](http://mochajs.org/) - BDD/TDD testing framework similar to Jasmine but modular  
[chai](http://chaijs.com/) - BDD/TDD assertion library  
[sinon](http://sinonjs.org/) - Spy/stubbing/mocking framework
