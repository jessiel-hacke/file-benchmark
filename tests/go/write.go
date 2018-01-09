package main

import (
 "os"
 "fmt"
 "time"
 "math"
 "bufio"
 "runtime"
 "strings"
 "strconv"
// "log"
// "io/ioutil"
)

func check(e error) {
    if e != nil {
        panic(e)
    }
}

func generate_dummy_data(block_size int) []byte {
  DUMMY_CHARACTER := " "
  BYTES_PER_LINE := 1024

  str := strings.Repeat(DUMMY_CHARACTER, (BYTES_PER_LINE * block_size))

  return []byte(str)
}


func test_full(file_path string, block_size int) {
  content := generate_dummy_data(block_size)
  file, err := os.OpenFile(file_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)

  check(err)

  _, _err := file.Write(content)

  check(_err)

  file.Close()
}

func test_stream(file_path string, block_size int) {
  file, err := os.OpenFile(file_path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, 0666)

  check(err)

  w := bufio.NewWriter(file)

  for i := 0; i < block_size; i++ {
    content := generate_dummy_data(1)
    w.WriteString(string(content))
  }

  w.Flush()
  file.Close()
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
/* In others languages benchmarks, this is achieved by running: ps -o rss= -p PID */
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
  test_name := os.Getenv("TEST_NAME")
  test_type := os.Getenv("TEST_TYPE")
  block_size, _ := strconv.Atoi(os.Getenv("KB_BLOCK_SIZE"))

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
    test_full(file, block_size)
  } else if test_mode == "stream" {
    test_stream(file, block_size)
  }

  memory_after := capture_memory_usage()

  elapsed := time.Since(start)

  if verbose == true {
    print_time_spend(elapsed.String());
    print_memory_usage(memory_before, memory_after)
  }
}