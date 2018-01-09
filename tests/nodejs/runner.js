(function(context) {
  'use strict';

  var path = require('path')

  // Kind of namespace for classes
  var IOBench = (function() {
    return {
      read: require('./tests/read.js'),
      write: require('./tests/write.js'),
      parse: require('./tests/parse.js')
    }
  })();


  var init = (function(args) {
    var file_path = args.TEST_FILE,
        test_type = args.TEST_TYPE,
        test_mode = (args.TEST_MODE || 'full'),
        test_name = (args.TEST_NAME || path.basename(file_path)),
        verbose = (args.VERBOSE == 'true');

    var bench;

    if(test_type == "" || test_type == null) {
      throw('You must suply TEST_TYPE with one the values: read, write, read+write')
    }

    var options = {}

    if(test_type == 'read') {
      bench = new IOBench.read
    }
    else if(test_type == 'parse') {
      bench = new IOBench.parse
    } else if(test_type == 'write') {
      var block_size = parseInt(args.KB_BLOCK_SIZE || 1)
      options.block_size = block_size

      bench = new IOBench.write
    }

    if(bench) {
      bench.setup(file_path, test_mode, test_name, test_type, verbose, options)
      bench.run()
    }
  });

  init(process.env);

})(this)
