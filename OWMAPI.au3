#include-once
#include <String.au3>
#include "include\AutoitObject_Internal.au3"

Global Const $PublicOWMAPI = "8cc0cf33ff7c6ac14e22653a3f1eca9b" ;Free public API key.

Func OWM_RequestSearch($sLocation, $sAPIKey)
	If StringInStr($sLocation, ' ') Then _
		$sLocation = StringReplace($sLocation, ' ', "%20")
	Local $sReq = "http://api.openweathermap.org/data/2.5/" _
		& "weather?q=" & $sLocation & "&mode=xml&" _
		& "appid=" & $sAPIKey

	Local $sRet = InetRead($sReq, 16)
	If @error Then Return False
	$sRet = BinaryToString($sRet)
	If StringInStr($sRet, '>404') Then Return False

	Return $sRet
EndFunc   ;==>OWM_RequestSearch

Func OWM_RequestID($iID, $sAPIKey)
	Local $sReq = "http://api.openweathermap.org/data/2.5/" _
		& "weather?id=" & $iID & "&mode=xml&" _
		& "appid=" & $sAPIKey

	Local $sRet = InetRead($sReq, 1)
	If @error Then Return False
	$sRet = BinaryToString($sRet)
	If StringInStr($sRet, '>404') Then Return False

	Return $sRet
EndFunc   ;==>OWM_RequestID

Func OWM_RequestCoord($iLatitude, $iLongitude, $sAPIKey)
	Local $sReq = "http://api.openweathermap.org/data/2.5/" _
		& "weather?lat=" & $iLatitude & "&lon=" & $iLongitude & "&mode=xml&" _
		& "appid=" & $sAPIKey

	Local $sRet = InetRead($sReq, 1)
	If @error Then Return False
	$sRet = BinaryToString($sRet)
	If StringInStr($sRet, '>404') Then Return False

	Return $sRet
EndFunc   ;==>OWM_RequestCoord

Func OWM_RequestZip($sZip, $sCountryCode, $sAPIKey)
	If $sCountryCode Then $sCountryCode = "," & $sCountryCode
	Local $sReq = "http://api.openweathermap.org/data/2.5/" _
		& "weather?zip=" & $sZip & $sCountryCode & "&mode=xml&" _
		& "appid=" & $sAPIKey

	Local $sRet = InetRead($sReq, 1)
	If @error Then Return False
	$sRet = BinaryToString($sRet)
	If StringInStr($sRet, '>404') Then Return False

	Return $sRet
EndFunc   ;==>OWM_RequestZip

Func OWM_GetWeather($sXML, $TempMode = "C")
	If $TempMode = "" Or $TempMode = Default Then $TempMode = "C"
	Local $oWhr = IDispatch()
	If Not $sXML Then Return $oWhr
	$oWhr.src = $sXML

	;<City>
	Local $City = IDispatch()
	$City.src = _StringBetween($oWhr.src, '<city', '</city>')[0]
	$City.id = _StringBetween($City.src, 'id="', '"')[0]
	$City.name = _StringBetween($City.src, 'name="', '"')[0]
	$City.coord = IDispatch()
	$City.coord.lon = _StringBetween($City.src, 'lon="', '"')[0]
	$City.coord.lat = _StringBetween($City.src, 'lat="', '"')[0]
	$City.country = _StringBetween($City.src, '<country>', '</country>')[0]
	$City.sun = IDispatch()
	$City.sun.rise = _StringBetween($City.src, 'rise="', '"')[0]
	$City.sun.set = _StringBetween($City.src, 'set="', '"')[0]
	$oWhr.city = $City
	;</City>

	;<Temperature>
	Local $Temp = IDispatch()
	$Temp.src = _StringBetween($oWhr.src, '<temperature', '></temperature>')[0]
	$Temp.value = _StringBetween($Temp.src, 'value="', '"')[0]
	$Temp.min = _StringBetween($Temp.src, 'min="', '"')[0]
	$Temp.max = _StringBetween($Temp.src, 'max="', '"')[0]
	$Temp.unit = _StringBetween($Temp.src, 'unit="', '"')[0]
	$Temp.unit = "K"

	If $TempMode = "C" Then
		$Temp.value = TempK2C($Temp.value)
		$Temp.min = TempK2C($Temp.min)
		$Temp.max = TempK2C($Temp.max)
		$Temp.unit = "°C"
	ElseIf $TempMode = "F" Then
		$Temp.value = TempK2F($Temp.value)
		$Temp.min = TempK2F($Temp.min)
		$Temp.max = TempK2F($Temp.max)
		$Temp.unit = "°F"
	EndIf
	$oWhr.temp = $Temp
	;</Temperature>

	;<Humidity>
	Local $Humidity = IDispatch()
	$Humidity.src = _StringBetween($oWhr.src, '<humidity', '></humidity>')[0]
	$Humidity.value = _StringBetween($Humidity.src, 'value="', '"')[0]
	$Humidity.unit = _StringBetween($Humidity.src, 'unit="', '"')[0]
	$oWhr.humidity = $Humidity
	;</Humidity>

	;<Pressure>
	Local $Pressure = IDispatch()
	$Pressure.src = _StringBetween($oWhr.src, '<pressure', '></pressure>')[0]
	$Pressure.value = _StringBetween($Pressure.src, 'value="', '"')[0]
	$Pressure.unit = _StringBetween($Pressure.src, 'unit="', '"')[0]
	$oWhr.pressure = $Pressure
	;</Pressure>

	;<Wind>
	Local $Wind = IDispatch()
	$Wind.src = _StringBetween($oWhr.src, '<wind>', '</wind>')[0]
	If $Wind.src <> "" Then
		$Wind.speed = IDispatch()
		$Wind.speed.src = _StringBetween($Wind.src, '<speed', '></speed')[0]
		$Wind.speed.value = _StringBetween($Wind.speed.src, 'value="', '"')[0]
		$Wind.speed.name = _StringBetween($Wind.speed.src, 'name="', '"')[0]
		$Wind.direction = IDispatch()
		$Wind.direction.src = _StringBetween($Wind.src, '<direction', '></direction>')[0]
		$Wind.direction.value = _StringBetween($Wind.direction.src, 'value="', '"')[0]
		If StringInStr($Wind.direction.src, 'code') Then _
				$Wind.direction.code = _StringBetween($Wind.direction.src, 'code="', '"')[0]
		If StringInStr($Wind.direction.src, 'name') Then _
				$Wind.direction.name = _StringBetween($Wind.direction.src, 'name="', '"')[0]
	EndIf
	$oWhr.wind = $Wind
	;</Wind>

	;<Clouds>
	Local $Cloud = IDispatch()
	$Cloud.src = _StringBetween($oWhr.src, '<clouds', '></clouds>')[0]
	$Cloud.value = _StringBetween($Cloud.src, 'value="', '"')[0]
	$Cloud.name = _StringBetween($Cloud.src, 'name="', '"')[0]
	$oWhr.cloud = $Cloud
	;</Clouds>

	;<Visibility>
	Local $Visibility = IDispatch()
	$Visibility.src = _StringBetween($oWhr.src, '<visibility', '></visibility>')[0]
	If $Visibility.src <> "" Then
		$Visibility.value = _StringBetween($Visibility.src, 'value="', '"')[0]
	EndIf
	$oWhr.visibility = $Visibility
	;</Visibility>

	;<Precipitation>
	Local $Precipitation = IDispatch()
	$Precipitation.src = _StringBetween($oWhr.src, '<precipitation', '></precipitation>')[0]
	If $Precipitation.src <> "" Then
		If StringInStr($Precipitation.src, 'value') Then _
				$Precipitation.value = _StringBetween($Precipitation.src, 'value="', '"')[0]
		If StringInStr($Precipitation.src, 'mode') Then _
				$Precipitation.mode = _StringBetween($Precipitation.src, 'mode="', '"')[0]
	EndIf
	$oWhr.precipitation = $Precipitation
	;</Precipitation>

	;<Weather>
	Local $Weather = IDispatch()
	$Weather.src = _StringBetween($oWhr.src, '<weather', '></weather>')[0]
	$Weather.number = _StringBetween($Weather.src, 'number="', '"')[0]
	$Weather.value = _StringBetween($Weather.src, 'value="', '"')[0]
	$Weather.icon = _StringBetween($Weather.src, 'icon="', '"')[0]
	$oWhr.weather = $Weather
	;</Weather>

	;<LastUpdate>
	Local $LastUpdate = IDispatch()
	$LastUpdate.src = _StringBetween($oWhr.src, '<lastupdate', '></lastupdate>')[0]
	$LastUpdate.value = _StringBetween($LastUpdate.src, 'value="', '"')[0]
	$oWhr.lastupdate = $LastUpdate
	;</LastUpdate>

	Return $oWhr
EndFunc   ;==>OWM_GetWeather

Func TempK2C($iTemp, $bRevert = False)
	If Not IsNumber($iTemp) Then $iTemp = Number($iTemp)
	If $bRevert Then Return Round($iTemp + 273.15, 1)
	Return Round($iTemp - 273.15, 1)
EndFunc   ;==>TempK2C

Func TempF2C($iTemp, $bRevert = False)
	If Not IsNumber($iTemp) Then $iTemp = Number($iTemp)
	If $bRevert Then Return Round($iTemp * 1.8 + 32, 1)
	Return Round(($iTemp - 32) / 1.8, 1)
EndFunc   ;==>TempF2C

Func TempK2F($iTemp, $bRevert = False)
	If Not IsNumber($iTemp) Then $iTemp = Number($iTemp)
	If $bRevert Then Return TempK2C(TempF2C($iTemp), True)
	Return TempF2C(TempK2C($iTemp), True)
EndFunc   ;==>TempK2F
