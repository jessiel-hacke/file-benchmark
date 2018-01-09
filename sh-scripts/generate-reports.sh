BASEDIR="$(echo `pwd`)/reports/results/"

generate_graphic() {
  test_type=$1
  name=$(basename $2 ".txt")

  mkdir -p "$(echo $BASEDIR)/${test_type}"
  mkdir -p "$(echo $BASEDIR)/${test_type}/json"

  echo "Generating ${test_type} Graphics for ${name}"

  TXT_FILENAME="${test_type}/${name}.txt"
  JSON_FILENAME="${test_type}/json/${name}.json"

  SOURCE_FILENAME=$TXT_FILENAME DEST_FILENAME=$JSON_FILENAME ruby reports/normalize.rb
  ruby reports/generate-graphics.rb -i $JSON_FILENAME

  echo "> Done"
  echo ""
}

generate_graphics_for_test() {
  FILES="$(echo $BASEDIR)/$1/*.txt"
  echo "Generating graphics for $1 tests"

  for f in $FILES
  do
    generate_graphic $1 $f
  done

  echo "> Done"
  echo ""
}

generate_graphics_for_test "read"
generate_graphics_for_test "write"
generate_graphics_for_test "parse"