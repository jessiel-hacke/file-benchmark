var exec = require('child_process').exec

var Helpers = (function() {
  var self = this;

  var log = function(message) {
    console.log(message)
  }

  var printExecutionTime = function(elapsedTime) {
    log("Time: " + elapsedTime + "ms")
  }

  var printMemoryUsage = function(memoryBefore, memoryAfter) {
    var memory = ((memoryAfter - memoryBefore) / 1024.0)

    log("Memory: " + Math.round(memory, 2) + " MB")
  }

  var testTypeLabel = function() {
    return "\
      Test Language: NodeJS\n\
      Test Language Version: %s\n\
      Test Type: %s\n\
      Test Name: %s\n\
      Test Mode: %s".replace(/^(\s+)/mg, '')
  }

  var printTestType = function(test) {
    console.log(testTypeLabel(), process.versions.node, test.test_type, test.test_name, test.test_mode)
  }

  var printResults = function(elapsedTime, memoryBefore, memoryAfter) {
    printExecutionTime(elapsedTime)
    printMemoryUsage(memoryBefore, memoryAfter)
  }

  var captureMemoryUsage = function(pid, cb) {
    var command = ('ps -o rss= -p ' + pid);
    return exec(command, cb);
  }

  var withMemoryUsage = function(context, pid, codeBlock, cb) {
    captureMemoryUsage(pid, function(err, memory, stderr) {

      var memoryBefore = parseFloat(memory);
      // call with null context
      codeBlock.call(context, function() {
        captureMemoryUsage(pid, function(err, memory, stderr) {
          var memoryAfter = parseFloat(memory);

          cb.apply(context, [memoryBefore, memoryAfter]);
        })
      });
    });
  }

  return {
    log: log,
    printResults: printResults,
    printTestType: printTestType,
    withMemoryUsage: withMemoryUsage,
    printMemoryUsage: printMemoryUsage,
    captureMemoryUsage: captureMemoryUsage,
    printExecutionTime: printExecutionTime
  }

})();

module.exports = Helpers