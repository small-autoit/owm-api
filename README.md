# OpenWeatherMap API

Request current weather with OpenWeatherMap API.

## Functions

* OWM_RequestSearch($sLocation, $sAPIKey)
````
     Request XML by location name.
````

* OWM_RequestID($iID, $sAPIKey)
````
     Request XML by city ID.
````

* OWM_RequestCoord($iLatitude, $iLongitude, $sAPIKey)
````
     Request XML by geographic coordinates.
````

* OWM_RequestZip($sZip, $sCountryCode, $sAPIKey)
````
     Request XML by ZIP code.
````

* OWM_GetWeather($sXML, $TempMode = "C")
````
     Get weather info from XML after request.
     This function will be return object variable.
````
## Returns
### Elements of weather

* city

     ``city.id`` City ID

     ``city.name`` City name

     ``city.coord``

     ``city.coord.lon`` City geo location, longitude

     ``city.coord.lat`` City geo location, latitude

     ``city.country`` Country code (GB, JP etc.)

     ``city.sun``

     ``city.sun.rise`` Sunrise time

     ``city.sun.set`` Sunset time

* temp

     ``temp.value`` Temperature

     ``temp.min`` Minimum temperature at the moment of calculation. This is deviation from 'temp' that is possible for large cities and megalopolises geographically expanded (use these parameter optionally).

     ``temp.max`` Maximum temperature at the moment of calculation. This is deviation from 'temp' that is possible for large cities and megalopolises geographically expanded (use these parameter optionally).

     ``temp.unit`` Unit of measurements. Possilbe valure is Celsius, Kelvin, Fahrenheit.

* humidity

     ``humidity.value`` Humidity value

     ``humidity.unit`` %

* pressure

     ``pressure.value`` Pressure value

     ``pressure.unit`` hPa

* wind

     ``wind.speed``

     ``wind.speed.value`` Wind speed, mps

     ``wind.speed.name`` Type of the wind

     ``wind.direction``

     ``wind.direction.value`` Wind direction, degrees (meteorological)

     ``wind.direction.code`` Code of the wind direction. Possilbe value is WSW, N, S etc.

     ``wind.direction.name`` Full name of the wind direction.

* cloud

     ``cloud.value`` Cloudiness

     ``cloud.name`` Name of the cloudiness

* visibility

     ``visibility.value`` Visibility, meter

* precipitation

     ``precipitation.value`` Precipitation, mm

     ``precipitation.mode`` Possible values are 'no", name of weather phenomena as 'rain', 'snow'

* weather

     ``weather.number`` Weather condition id

     ``weather.value`` Weather condition name

     ``weather.icon`` Weather icon id

* lastupdate

     ``lastupdate.value`` Last time when data was updated

See [here](http://openweathermap.org/current).
