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
     We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).
     This function will be return variable. See [here](https://openweathermap.org/current).
````
