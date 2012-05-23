casper = require('casper').create(
  verbose: true,
  loadImages: true,
  loadPlugins: true,
  logLevel: 'debug'
  onAlert: -> console.log 'POOP'
)

casper.start 'http://localhost:1337/'

casper.waitFor (->
    this.getGlobal 'TESTS_COMPLETE'
  ), (->
    numFailures = parseInt this.fetchText('.failures em')

    console.log '\n\t\t---------------------------'
    console.log '\t\tIMPORTANT STUFF HERE       '
    console.log '\t\t---------------------------'
    console.log '\t\tFailures: ', numFailures
    console.log '\t\tPasses: ' , this.fetchText('.passes em')
    console.log '\t\tDuration: ', this.fetchText('.duration em') + 's\n'

    this.test.assertEquals numFailures, 0
  ),(-> console.log "TIMED OUT"), 10000

casper.run ->
  this.test.renderResults true
