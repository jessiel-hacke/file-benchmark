echo "Formating data to graphics..."
ruby reports/normalize.rb
echo "> Done"

echo "Generating for greyscale..."
THEME_NAME="greyscale" ruby reports/generate-graphics.rb
echo "> Done"

echo "Generating for odeo..."
THEME_NAME="odeo" ruby reports/generate-graphics.rb
echo "> Done"


echo "Generating for pastel..."
THEME_NAME="pastel" ruby reports/generate-graphics.rb
echo "> Done"

echo "Generating for rails_keynote..."
THEME_NAME="rails_keynote" ruby reports/generate-graphics.rb
echo "> Done"

echo "Generating for thirtyseven_signals..."
THEME_NAME="thirtyseven_signals" ruby reports/generate-graphics.rb
echo "> Done"