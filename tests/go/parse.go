package main

import (
 "os"
 "fmt"
 "time"
 "math"
 "bufio"
 "log"
 "io/ioutil"
 "strings"
 "runtime"
)

func test_full(file_path string) {
  content, err := ioutil.ReadFile(file_path)

  if err != nil {
      log.Fatal(err)
  }

  lines := strings.Split(string(content), "\n")

  for _,line := range lines {
    parse(line)
  }
}

func test_stream(file_path string) {
  file, err := os.Open(file_path)

  if err != nil {
      log.Fatal(err)
  }

  defer file.Close()

  scanner := bufio.NewScanner(file)

  for scanner.Scan() {
    parse(scanner.Text())
  }
}

type Field struct {
  name string
  size int
}

var format = []Field {
  Field{name: "type",               size:  2},
  Field{name: "sequential",         size:  7},
  Field{name: "card_number",        size: 19},
  Field{name: "auth_code",          size:  6},
  Field{name: "sale_date",          size:  8},
  Field{name: "sale_option",        size:  1},
  Field{name: "sale_value",         size: 15},
  Field{name: "installments",       size:  3},
  Field{name: "zero0",              size: 15},
  Field{name: "zero1",              size: 15},
  Field{name: "zero2",              size: 15},
  Field{name: "installment_value",  size: 15},
  Field{name: "resume_number",      size:  7},
  Field{name: "zero3",              size:  3},
  Field{name: "entity_numbeer",     size: 10},
  Field{name: "reserved0",          size: 30},
  Field{name: "status",             size:  2},
  Field{name: "payment_date",       size:  8},
  Field{name: "expirty",            size:  4},
  Field{name: "zero4",              size:  7},
  Field{name: "zero5",              size: 15},
  Field{name: "reserved1",          size:  3},
  Field{name: "error_code",         size:  4},
  Field{name: "ref",                size: 11},
  Field{name: "new_card",           size: 19},
  Field{name: "new_expiry",         size:  4},
  Field{name: "reserved2",          size:  2} }

func parse(line string) map[string]string {
  position := 0
  var parsed = make(map[string]string)

  if len(line) > 0 {
    for _, field := range format {
      parsed[field.name] = line[position:(position+field.size)]
      position = position + field.size
    }
  }

  return parsed
}

func Round(f float64) int {
    if math.Abs(f) < 0.5 {
        return 0
    }
    return int(f + math.Copysign(0.5, f))
}


func print_memory_usage(memory_before, memory_after uint64) {
  memory := ((memory_after - memory_before) / 1024.0)
  memory_usage := Round(float64(memory))

  fmt.Println(fmt.Sprintf("Memory: %d MB", memory_usage))
}

/* This basically parse /proc/PID/status to get RAM usage */
/* In others languages benchmarks, this is achieved by running: ps -o rss= -p */
func capture_memory_usage() uint64 {
  var mem runtime.MemStats
  runtime.ReadMemStats(&mem)

  return (mem.Alloc / 1024)
}

func print_time_spend(time string) {
  fmt.Println(fmt.Sprintf("Time: %s", time))
}

func print_test_type(test_type string, test_mode string, test_name string) {
  str := `
Test Language: GoLang
Test Language Version: go version go1.7.3 linux/amd64
Test Type: %s
Test Name: %s
Test Mode: %s
`

  fmt.Print(fmt.Sprintf(str, test_type, test_name, test_mode))
}

func main() {
  file := os.Getenv("TEST_FILE")
  verbose := os.Getenv("VERBOSE") == "true"
  test_mode := os.Getenv("TEST_MODE")
  test_type := os.Getenv("TEST_TYPE")
  test_name := os.Getenv("TEST_NAME")

  if test_mode == "" { test_mode = "full" }

  if test_type == "" {
    panic("You must suply TEST_TYPE with one the values: read, write, read+write")
  }

  start := time.Now()

  memory_before := capture_memory_usage()

  if verbose == true {
    print_test_type(test_type, test_mode, test_name)
  }

  if test_mode == "full" {
    test_full(file)
  } else if test_mode == "stream" {
    test_stream(file)
  }

  memory_after := capture_memory_usage()

  elapsed := time.Since(start)

  if verbose == true {
    print_time_spend(elapsed.String());
    print_memory_usage(memory_before, memory_after)
  }
}
