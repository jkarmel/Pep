chai = require 'chai'
sinon = require 'sinon'
sinonChai = require 'sinon-chai'
coffeekup = require 'coffeekup'
cheerio = require 'cheerio'
fs = require 'fs'

chai.use sinonChai
should = chai.should()

layouts = require '../../helpers/layouts'

describe "layout", ->
  html = ""
  $ = ""

  before ->
    content =
      js: "main"
      head: ->
        meta name: 'test-meta', content: 'test-meta-content'
      content: ->
        h1 ".test", "heading 1"

    html = coffeekup.render (-> application()), layouts
    $ = cheerio.load(html)

  it "has doctype html5", ->
    html.should.match(/^<!DOCTYPE html>/)

  it "adds a favicon", ->
    $favicon = $('head link[href="/favicon.ico"]')
    $favicon.length.should.equal(1)
    $favicon.attr('rel').should.equal('shortcut icon')

  it "has a head tag", ->
    $('head').length.should.equal(1)

  it "links to basic stylesheets", ->
    $('head link[rel="stylesheet"][href="/stylesheets/reset.css"]').length.should.equal(1)
    $('head link[rel="stylesheet"][href="/stylesheets/main.css"]').length.should.equal(1)

  it "links to basic javascript libraries", ->
    $('head script[src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"]').length.should.equal(1)
    $('head script[src="/nowjs/now.js"]').length.should.equal(1)

  describe "when content is passed in", ->
    before ->
      html = coffeekup.render (-> application(
        js: "main"
        head: ->
          meta name: 'test-meta', content: 'test-meta-content'
        body: ->
          h1 ".test", ""
      )), layouts
      $ = cheerio.load(html)

    it "uses require.js to load specified entry point", ->
      $('head script[src="/javascripts/vendor/require.min.js"][data-main="/javascripts/entry_point/main"]')
        .length.should.equal 1

    it "allows more elements to be injected into head", ->
      $('head meta[name="test-meta"][content="test-meta-content"]').length.should.equal 1

    # NOTE: #content is temporary so don't test for it
    it "allows content to be injected into body", ->
      $('body h1.test').length.should.equal 1