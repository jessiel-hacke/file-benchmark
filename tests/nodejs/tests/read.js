var fs = require('fs'),
    stream = require('stream'),
    readline = require('readline');

var Helpers = require("../support/helpers"),
    IOBenchBase = require('./base')

var IOBenchRead = (function() {
  var self = this;

  self.testFull = function(cb) {
    fs.readFile(this.file_path, 'utf8', cb);
  }

  self.testStream = function(cb) {
    var instream = fs.createReadStream(this.file_path);
    var outstream = new stream;

    var rl = readline.createInterface(instream, outstream);

    rl.on('line', function(line) {
      // console.log(line)
    });

    rl.on('close', cb);
  }
});

IOBenchRead.prototype = new IOBenchBase();

module.exports = IOBenchRead