require 'csv'

class WeatherReport
  attr_reader :city, :year, :month, :file_path  # Just Getter Function

  MAX_TEMP_KEY = 'Max TemperatureC'
  MIN_TEMP_KEY = 'Min TemperatureC'
  HUMIDITY_KEY = 'Max Humidity'

  def initialize(city, year, month)
    @city = city.capitalize
    @year = year
    @month = month.capitalize
    @file_path = build_file_path
  end

  def build_file_path
    folder = "#{city}_weather"
    "#{folder}/#{city}_weather_#{year}_#{month}.txt"
  end

  def parse
    return nil unless File.exist?(file_path)

    max_temps = []
    min_temps = []
    humidities = []

    begin
      CSV.foreach(file_path, headers: true) do |row|
        max = (row[MAX_TEMP_KEY]).to_i
        min = (row[MIN_TEMP_KEY]).to_i
        hum = (row[HUMIDITY_KEY]).to_i

        max_temps << max if max
        min_temps << min if min
        humidities << hum if hum

      end
    rescue CSV::MalformedCSVError => e
      puts "Error reading file: #{e.message}"
      return nil
    end

   

    # File.foreach(file_path) do |line|
    #   next if line.start_with?("GST") # Because Every file first line start with GST

    #   parts = line.split(',')
    #   max = parts[1].to_i rescue nil
    #   min = parts[3].to_i rescue nil
    #   hum = parts[8].to_i rescue nil

    #   max_temps << max if max
    #   min_temps << min if min
    #   humidities << hum if hum
    # end

    return nil if max_temps.empty? || min_temps.empty? || humidities.empty?

    {
      max: max_temps.max,
      min: min_temps.min,
      avg_humidity: humidities.sum / humidities.size
    }
  end

  def display_report
    puts "\nReading from: #{file_path}"

    report = parse()

    if report
      puts "\nWeather Report for #{city}, #{month} #{year}:"
      puts "Highest Temperature: #{report[:max]} C"
      puts "Lowest Temperature: #{report[:min]} C"
      puts "Average Humidity: #{report[:avg_humidity]}%"
    else
      puts "File not found OR No valid data"
    end
  end
end


print "Enter city name: "
city = gets.chomp()

print "Enter year (e.g. 2004): "
year = gets.chomp()

print "Enter month (e.g. Aug): "
month = gets.chomp()

report = WeatherReport.new(city, year, month)
report.display_report()
