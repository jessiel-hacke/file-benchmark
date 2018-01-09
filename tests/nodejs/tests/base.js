var Helpers = require("../support/helpers")

var IOBenchBase = (function() {
  var self = this;

  var log = function(message) {
    if(!self.verbose) { return false; }

    Helpers.log(message)
  }

  self.setup = function(file_path, test_mode, test_name, test_type, verbose, options) {
    this.configured = true
    this.file_path = file_path
    this.test_mode = test_mode
    this.test_name = test_name
    this.test_type = test_type
    this.verbose = verbose
    this.options = options

    return this
  }

  self.run = function() {
    var self = this;
    if(this.configured != true) {
      throw("Please, call setup() before calling run()")
    }

    if(this.verbose == true) {
      Helpers.printTestType(this)
    }

    var startTime = Date.now();

    // pass callback through IO fucntions
    var codeBlock = function(cb) {
      if(this.test_mode == 'full') {
        this.testFull(cb)
      } else if(this.test_mode == 'stream') {
        this.testStream(cb)
      }
    };

    // this run after the file was entirely read(at once or line by line)
    var callback = (function(memoryBefore, memoryAfter) {
      var elapsedTime = (Date.now() - startTime)

      if(this.verbose == true) {
        Helpers.printResults(elapsedTime, memoryBefore, memoryAfter)
      }
    });

    Helpers.withMemoryUsage(this, process.pid, codeBlock, callback)
  }
});

module.exports = IOBenchBase