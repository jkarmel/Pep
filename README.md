# Lift

A fast and convient service for Feeling Good

## Development Guide

When developing follow these simple rules:

 * *100% Test Coverage* - Every piece of code should be tested rigorously.
 * *Use Libraries* - Use open source libraries, it's faster and better than writing it ourselves.
 * *Simplicity* - Only write as much code as necessary to complete the task (but still high quality).
 * *Refactor* - When working with code a second time, refactor as necessary to keep the quality and abstraction high.
 * *Pair* - 66% of your development should be spent pairing. It's fun, social, and a great learning experience.
 * *Enjoy It* - If you aren't enjoying working in this code base, then we're doing something wrong.

## Style Guide

Style guides make the code easier to read regardless of who wrote it, please reference this guide for LESS and CoffeeScript. **If you're unsure about what to do, go for the most readable option!**

### CoffeeScript

```coffeescript
express = require 'express'

app.configure ->
  app.use express.session secret: 'secret123'
  app.use express.compiler
    src: __dirname + '/public'
    enable: [ 'coffeescript' ]

now.configure(poop).run 3000
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

 * Install [node](http://nodejs.org/#download) and [npm](http://npmjs.org/).
 * Install supervisor via `npm install -g supervisor` (make sure npm's bin folder is in your PATH).
 * Install foreman via `[sudo] gem install foreman`.
 * Install [mongodb](http://www.mongodb.org/display/DOCS/Quickstart+OS+X).
 * Checkout the source code and run `npm install`.
 * `make setup`

***TODO***: Write a script to do installations

## Running

To run the app simply use `make run` or `make watch` (if you want the server to update when changes happen)

## Tests

The tests are written in [mocha](http://visionmedia.github.com/mocha/) and follow BDD convention. Use `make test` to run them.  
**NOTE:** If you add a new directory under tests, you will have to add them to the Makefile (***TODO:*** Write a script to programmatically do this)

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

[mocha](http://visionmedia.github.com/mocha/) - BDD/TDD testing framework similar to Jasmine but modular  
[chai](http://chaijs.com/) - BDD/TDD assertion library  
[sinon](http://sinonjs.org/) - Spy/stubbing/mocking framework
