var fs = require('fs'),
    stream = require('stream'),
    readline = require('readline');

var Helpers = require("../support/helpers"),
    IOBenchBase = require('./base')

const FORMAT = {
    type:               2,
    sequential:         7,
    card_number:        19,
    auth_code:          6,
    sale_date:          8,
    sale_option:        1,
    sale_value:         15,
    installments:       3,
    zero0:              15,
    zero1:              15,
    zero2:              15,
    installment_value:  15,
    resume_number:      7,
    zero3:              3,
    entity_numbeer:     10,
    reserved0:          30,
    status:             2,
    payment_date:       8,
    expirty:            4,
    zero4:              7,
    zero5:              15,
    reserved1:          3,
    error_code:         4,
    ref:                11,
    new_card:           19,
    new_expiry:         4,
    reserved2:          2
  };

var IOBenchParse = (function() {
  var self = this;

  self.testFull = function(cb) {
    var file = fs.readFileSync(this.file_path, 'utf8');
    file.split(/\r?\n/).forEach(function(line){
      self.parse(line);
    });
    cb.call();
  }

  self.testStream = function(cb) {
    var instream = fs.createReadStream(this.file_path);
    var outstream = new stream;

    var rl = readline.createInterface(instream, outstream);

    rl.on('line', function(line) {
      self.parse(line, cb);
    });

    rl.on('close', cb);
  }

  self.parse = function(line, cb) {
    var keys = Object.keys(FORMAT);
    var position = 0;
    var size = 0;
    keys.forEach(function(key){
      size = FORMAT[key] + position;
      line.slice(position, size);
      position = size;
    });
  }
});

IOBenchParse.prototype = new IOBenchBase();

module.exports = IOBenchParse
