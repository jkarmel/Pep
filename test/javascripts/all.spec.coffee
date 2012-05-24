casper = require('casper').create(
#  verbose: true,
#  loadImages: true,
#  loadPlugins: true,
#  logLevel: 'debug'
)

casper.start 'http://localhost:1337/'

casper.waitFor (->
    this.getGlobal 'TESTS_COMPLETE'
  ), (->
    results = this.evaluate ->
      pretty = ($element) ->
        s = $element.clone().children().remove().end().text()
        $duration = $element.find('span')
        s += " [#{$duration.text()}]" if $duration.length
        s

      results = { passed : [], failed : [] }
      $('.test.fail').each (index, element) ->
        $element = $(element)
        s = pretty $element.find('h2')

        $error = $element.find('.error')
        s += " \n\n\t#{$error.text()}\n" if $error.length
        results.failed.push s

      $('.test.pass h2').each (index, element) ->
        results.passed.push pretty $(element)

      results

    console.log '\n\t\tFailures: ', results.failed.length
    console.log '\t\tPasses: ' , results.passed.length
    console.log '\t\tDuration: ', this.fetchText('.duration em') + 's\n'

    for test in results.passed
      casper.test.assert true, test

    for test in results.failed
      casper.test.assert false, test

  ),(-> console.log "TIMED OUT"), 10000

casper.run ->
  this.test.renderResults true
