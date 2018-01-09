
echo "Formating data to graphics..."
ruby reports/normalize.rb
echo "> Dobe"

GRAPHIC_TYPE="bar" ./sh-scripts/generate-reports.sh
GRAPHIC_TYPE="pie" ./sh-scripts/generate-reports.sh