#include "OWMAPI.au3"

;~ Global $PublicOWMAPI = "8cc0cf33ff7c6ac14e22653a3f1eca9b"

Global $oWeather = OWM_GetWeather(OWM_RequestSearch("London", $PublicOWMAPI))

MsgBox(0, "Current Weather", $oWeather.city.name & " " & $oWeather.temp.value & $oWeather.temp.unit & @CRLF & _
			"Humidity " & $oWeather.humidity.value & "%" & @CRLF & _
			$oWeather.wind.direction.name & " wind, " & $oWeather.wind.speed.value & "m/s" & @CRLF & _
			"Cloudiness " & $oWeather.cloud.value & "%")
