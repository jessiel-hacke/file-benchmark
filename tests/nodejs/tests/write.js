var fs = require('fs'),
    stream = require('stream'),
    readline = require('readline');

var Helpers = require("../support/helpers"),
    IOBenchBase = require('./base')

var IOBenchWrite = (function() {
  var self = this;

  var BYTES_PER_LINE = 1024 // 1kb
  var DUMMY_CHARACTER = " " // whitespace as 1kb character

  var generateDummyData = function(block_size) {
    return (DUMMY_CHARACTER.repeat(block_size * BYTES_PER_LINE) + "\n")
  }

  self.testFull = function(cb) {
    var content = generateDummyData(this.options.block_size)

    fs.writeFile(this.file_path, content, cb);
  }

  self.testStream = function(cb) {
    var writer = fs.createWriteStream(this.file_path);

    for (var i = 0; i < this.options.block_size; i++) {
      writer.write(generateDummyData(1));
    }

    writer.end('\n');

    writer.on('finish', cb);
  }

});

IOBenchWrite.prototype = new IOBenchBase();

module.exports = IOBenchWrite