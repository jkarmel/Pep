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
      results = { passed : [], failed : [] }
      $('.test.fail h2').each (index, element) ->
        results.failed.push $(element).text()

      $('.test.pass h2').each (index, element) ->
        results.passed.push $(element).text()

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
