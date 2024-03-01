-- Script
-- Author: SeelingCat
-- DateCreated: 4/22/2020 4:55:24 PM
--------------------------------------------------------------

local iCityNamingScheme = 0
for row in GameInfo.SC_Cohort_Config() do
	if row.Setting == "COHORT_CITY_NAME_MODE" then
		iCityNamingScheme = row.Mode
		print ("City naming Scheme: ", iCityNamingScheme)
	end
end

local currentLanguage = Locale.GetCurrentLanguage();
local currentLocale = currentLanguage and currentLanguage.Type or "en_US";

--print (currentLocale)

local tModernTechs = {}
local tModernCivics = {}
local tModernUnits = {}
local tExcludedNamingUnits = {}

local tNATOAlphabet = {
"LOC_COHORT_NATO_ALPHA",
"LOC_COHORT_NATO_BRAVO",
"LOC_COHORT_NATO_CHARLIE",
"LOC_COHORT_NATO_DELTA",
"LOC_COHORT_NATO_ECHO",
"LOC_COHORT_NATO_FOXTROT",
"LOC_COHORT_NATO_GOLF",
"LOC_COHORT_NATO_HOTEL",
"LOC_COHORT_NATO_INDIA",
"LOC_COHORT_NATO_JULIETT",
"LOC_COHORT_NATO_KILO",
"LOC_COHORT_NATO_LIMA",
"LOC_COHORT_NATO_MIKE",
"LOC_COHORT_NATO_NOVEMBER",
"LOC_COHORT_NATO_OSCAR",
"LOC_COHORT_NATO_PAPA",
"LOC_COHORT_NATO_QUEBEC",
"LOC_COHORT_NATO_ROMEO",
"LOC_COHORT_NATO_SIERRA",
"LOC_COHORT_NATO_TANGO",
"LOC_COHORT_NATO_UNIFORM",
"LOC_COHORT_NATO_VICTOR",
"LOC_COHORT_NATO_WHISKEY",
"LOC_COHORT_NATO_X_RAY",
"LOC_COHORT_NATO_YANKEE",
"LOC_COHORT_NATO_ZULU"}

for row in GameInfo.Technologies() do
	if (row.EraType == "ERA_INDUSTRIAL") or (row.EraType == "ERA_MODERN") or (row.EraType == "ERA_ATOMIC") or (row.EraType == "ERA_INFORMATION") or (row.EraType == "ERA_FUTURE") then
		tModernTechs[row.TechnologyType] = true
	end
end

for row in GameInfo.Civics() do
	if (row.EraType == "ERA_INDUSTRIAL") or (row.EraType == "ERA_MODERN") or (row.EraType == "ERA_ATOMIC") or (row.EraType == "ERA_INFORMATION") or (row.EraType == "ERA_FUTURE") then
		tModernCivics[row.CivicType] = true
	end
end

for row in GameInfo.Units() do
	if tModernTechs[row.PrereqTech] == true then
		tModernUnits[row.UnitType] = true
		print ("Modern Unit: ", row.UnitType)
	elseif tModernCivics[row.PrereqCivic] == true then
		tModernUnits[row.UnitType] = true
		print ("Modern Unit: ", row.UnitType)
	end
end

for row in GameInfo.SC_Cohort_Excluded_Units() do
	if row.Excluded == 1 then
		tExcludedNamingUnits[row.UnitType] = true
		print ("Excluded unit: ", row.UnitType)
	end
end

for row in GameInfo.HeroClasses() do
	tExcludedNamingUnits[row.UnitType] = true
	print ("Excluded unit (hero): ", row.UnitType)
end

function SC_Cohort_Get_Plural_Name(sUnitType, sUnitTypeName)

	local bSimplePlural = true
	local sUnitTypePlural = sUnitTypeName

	if currentLocale == "en_US" then
		--print ("checking plurals")
		for row in GameInfo.SC_Cohort_English_Plurals() do
			if row.UnitType == sUnitType then
				--print ("plural rule found")
				bSimplePlural = false
				
				if row.PluralType == "1" then
					--print ("plural = singular")
				else
					sUnitTypePlural = row.PluralType
					--print ("plural = ", row.PluralType)
				end
			end
		end

		if bSimplePlural == true then
			--print ("simple plural")
			sUnitTypePlural = Locale.Lookup(sUnitTypeName) .. "s"
		end
	end

	--print (sUnitTypePlural)

	return sUnitTypePlural
end

function SC_Cohort_Get_Roman_Numeral(iNumber)

	--print (iNumber)
	local sRomanString = ""

	-- Special Cases
	if iNumber == 18 then
		iNumber = 0
		sRomanString = "XIIX"
	end

	while iNumber > 0 do
		while iNumber >= 1000 do
			sRomanString = sRomanString .. "M"
			iNumber = iNumber - 1000
		end

		while iNumber >= 900 do
			sRomanString = sRomanString .. "CM"
			iNumber = iNumber - 900
		end

		while iNumber >= 500 do
			sRomanString = sRomanString .. "D"
			iNumber = iNumber - 500
		end

		while iNumber >= 400 do
			sRomanString = sRomanString .. "CD"
			iNumber = iNumber - 400
		end

		while iNumber >= 100 do
			sRomanString = sRomanString .. "C"
			iNumber = iNumber - 100
		end

		while iNumber >= 90 do
			sRomanString = sRomanString .. "XC"
			iNumber = iNumber - 90
		end

		while iNumber >= 50 do
			sRomanString = sRomanString .. "L"
			iNumber = iNumber - 50
		end

		while iNumber >= 40 do
			sRomanString = sRomanString .. "XL"
			iNumber = iNumber - 40
		end

		while iNumber >= 10 do
			sRomanString = sRomanString .. "X"
			iNumber = iNumber - 10
		end

		while iNumber >= 9 do
			sRomanString = sRomanString .. "IX"
			iNumber = iNumber - 9
		end

		while iNumber >= 5 do
			sRomanString = sRomanString .. "V"
			iNumber = iNumber - 5
		end

		while iNumber >= 4 do
			sRomanString = sRomanString .. "IV"
			iNumber = iNumber - 4
		end

		while iNumber >= 1 do
			sRomanString = sRomanString .. "I"
			iNumber = iNumber - 1
		end
	end

	return (sRomanString)
end


function Cohort_NATO_Getter(iNumber)

	--print (iNumber)
	local sNATOString = ""
	local iRolloverCounter = math.floor(iNumber/26)

	while iNumber > 26 do
		iNumber = iNumber-26
	end

	sNATOString = tNATOAlphabet[iNumber]

	sNATOString = Locale.Lookup(sNATOString)

	--print (sNATOString)

	if iRolloverCounter > 0 then
		sNATOString = sNATOString .. "-" .. iRolloverCounter
	end

	--print (sNATOString)

	return (sNATOString)
end

function SC_Cohort_Get_Unique_Name(sUnitType, sUnitClassType, sCivilizationType, bNavalUnit)

	print ("Getting unique name for: ", sUnitType, sUnitClassType, sCivilizationType, bNavalUnit)
	-- at some point differentiate between CORPS/ARMY as well?

	local sUniqueName = ""
	local sTestUniqueName = ""

	local tUnitCivNames = {}
	local tClassCivNames = {}
	local tGenericCivNames = {}
	local tGenericNames = {}

	local sGenericString = "GENERIC"

	if bNavalUnit == true then
		sGenericString = sGenericString .. "_NAVAL"
	end

	local bNameFound = false

	tUnitCivNames = DB.Query ("SELECT * FROM SC_Cohort_Unique_Names WHERE CivilizationType = '" .. sCivilizationType .. "' AND UnitType = '" .. sUnitType .. "'")

	-- check for unit-civ
	if #tUnitCivNames ~= 0 then
		local bDone = false
		while (#tUnitCivNames > 0) and (not bDone) do
			local iRandom = TerrainBuilder.GetRandomNumber(#tUnitCivNames, "Cohort Unique Unit-Civ")+1
			sTestUniqueName = tUnitCivNames[iRandom].LOCName
			print ("Trying the following Unit-Civ Unique: ", sTestUniqueName)
			table.remove(tUnitCivNames, iRandom)

			local iInUse = Game:GetProperty("Name_In_Use_" .. sTestUniqueName)

			if iInUse == nil then
				Game:SetProperty("Name_In_Use_" .. sTestUniqueName, 1)
				print ("name not in use!")
				sUniqueName = Locale.Lookup(sTestUniqueName)
				bDone = true
				bNameFound = true
				return sUniqueName
			else
				print ("name already in use - trying again")
			end
		end

		if not (bDone) then
			print ("all names of this category already used")
		end
	else
		print ("no unit-civ names found")
	end

	tClassCivNames = DB.Query ("SELECT * FROM SC_Cohort_Unique_Names WHERE CivilizationType = '" .. sCivilizationType .. "' AND UnitType = '" .. sUnitClassType .. "'")

	-- check for unit class-civ
	if #tClassCivNames ~= 0 then
		local bDone = false
		while (#tClassCivNames > 0) and (not bDone) do
			local iRandom = TerrainBuilder.GetRandomNumber(#tClassCivNames, "Cohort Unique Unit Class-Civ")+1
			sTestUniqueName = tClassCivNames[iRandom].LOCName
			print ("Trying the following Unit Class-Civ Unique: ", sTestUniqueName)
			table.remove(tClassCivNames, iRandom)

			local iInUse = Game:GetProperty("Name_In_Use_" .. sTestUniqueName)

			if iInUse == nil then
				Game:SetProperty("Name_In_Use_" .. sTestUniqueName, 1)
				print ("name not in use!")
				sUniqueName = Locale.Lookup(sTestUniqueName)
				bDone = true
				bNameFound = true
				return sUniqueName
			else
				print ("name already in use - trying again")
			end
		end

		if not (bDone) then
			print ("all names of this category already used")
		end
	else
		print ("no unit class-civ names found")
	end

	tGenericCivNames = DB.Query ("SELECT * FROM SC_Cohort_Unique_Names WHERE CivilizationType = '" .. sCivilizationType .. "' AND UnitType = '" .. sGenericString .. "'")

	-- check for generic-civ
	if #tGenericCivNames ~= 0 then
		local bDone = false
		while (#tGenericCivNames > 0) and (not bDone) do
			local iRandom = TerrainBuilder.GetRandomNumber(#tGenericCivNames, "Cohort Unique Generic-Civ")+1
			sTestUniqueName = tGenericCivNames[iRandom].LOCName
			print ("Trying the following Generic-Civ Unique: ", sTestUniqueName)
			table.remove(tGenericCivNames, iRandom)

			local iInUse = Game:GetProperty("Name_In_Use_" .. sTestUniqueName)

			if iInUse == nil then
				Game:SetProperty("Name_In_Use_" .. sTestUniqueName, 1)
				print ("name not in use!")
				sUniqueName = Locale.Lookup(sTestUniqueName)
				bDone = true
				bNameFound = true
				return sUniqueName
			else
				print ("name already in use - trying again")
			end
		end

		if not (bDone) then
			print ("all names of this category already used")
		end
	else
		print ("no Generic-civ names found")
	end

	tGenericNames = DB.Query ("SELECT * FROM SC_Cohort_Unique_Names WHERE CivilizationType = 'GENERIC' AND UnitType = '" .. sGenericString .. "'")

	-- check for overall generic
	if #tGenericNames ~= 0 then
		local bDone = false
		while (#tGenericNames > 0) and (not bDone) do
			local iRandom = TerrainBuilder.GetRandomNumber(#tGenericNames, "Cohort Unique Generic")+1
			sTestUniqueName = tGenericNames[iRandom].LOCName
			print ("Trying the following Generic Unique: ", sTestUniqueName)
			table.remove(tGenericNames, iRandom)

			local iInUse = Game:GetProperty("Name_In_Use_" .. sTestUniqueName)

			if iInUse == nil then
				Game:SetProperty("Name_In_Use_" .. sTestUniqueName, 1)
				print ("name not in use!")
				sUniqueName = Locale.Lookup(sTestUniqueName)
				bDone = true
				bNameFound = true
				return sUniqueName
			else
				print ("name already in use - trying again")
			end
		end

		if not (bDone) then
			print ("all names of this category already used")
		end
	else
		print ("no Generic names found")
	end

	--print ("weird - no names found at all!")
	return sUniqueName

end

function Cohort_Number_Getter (iNumber)

	local iTempNumber = iNumber
	local sNumberString = "#" .. iNumber

	while iTempNumber > 100 do
		iTempNumber = iTempNumber - 100
	end

	--if currentLocale == "en_US" then
		if iTempNumber > 10 then
			if (iTempNumber == 11) or (iTempNumber == 12) or (iTempNumber == 13) then
				sNumberString = iNumber
				return sNumberString
			end

			while iTempNumber > 10 do
				iTempNumber = iTempNumber - 10
			end
		end

		if iTempNumber == 1 then
			sNumberString = iNumber .. "st"
		elseif iTempNumber == 2 then
			sNumberString = iNumber .. "nd"
		elseif iTempNumber == 3 then
			sNumberString = iNumber .. "rd"
		else
			sNumberString = iNumber .. "th"
		end
	--end

	-- will do a check to see if other languages have a better-defined 1st/2nd/3rd system as they're add in localization

	return sNumberString
end

function SC_Cohort_Find_Best_Existing_Name(sCivUnit, sCivClass, sCivGeneric, sGenericUnit, sGenericClass, sGenericGeneric)

	-- Priority is Civ Unit, Civ Class, Civ Generic, Generic Unit, Generic Class, Generic Generic

	--print (sMostUniqueName, sMediumUniqueName,sLeastUniqueName)
	if string.match(Locale.Lookup(sCivUnit), "LOC_") then
		--print (sMostUniqueName)
		if string.match(Locale.Lookup(sCivClass), "LOC_") then
			--print (sMediumUniqueName)
			if string.match(Locale.Lookup(sCivGeneric), "LOC_") then
				--print (sMediumUniqueName)
				if string.match(Locale.Lookup(sGenericUnit), "LOC_") then
					--print (sMediumUniqueName)
					if string.match(Locale.Lookup(sGenericClass), "LOC_") then
						--print (sMediumUniqueName)
						if string.match(Locale.Lookup(sGenericGeneric), "LOC_") then
							print ("Warning: No Valid Names found!")
							print (sGenericGeneric)
							return sGenericGeneric
						else
							--print (sLeastUniqueName)
							return sGenericGeneric
						end
					else
						print ("Unit Class-Specific Name Found! It's ", sGenericClass)
						return sGenericClass
					end
				else
					print ("Unit-Specific Name Found! It's ", sGenericUnit)
					return sGenericUnit
				end
			else
				print ("Civ-Specific Generic Name Found! It's ", sCivGeneric)
				return sCivGeneric
			end
		else
			print ("Civ-Specific Unit Class Name Found! It's ", sCivClass)
			return sCivClass
		end
	else
		print ("Civ-Specific Unit Name Found! It's ", sCivUnit)
		return sCivUnit
	end
end

function SC_Cohort_Get_Best_Name(sUnitType, sUnitTypeName, sUnitClassType, sCivilizationType, sFormation, sCityName, iCivCountNumber, sUniqueName, bNavalUnit, playerID, iCityID, sEventType, unitID)

	--print (sUnitType, sUnitClassType, sCivilizationType, sFormation, sCityName, sNumber)

	local sLOCStart = "LOC_COHORT_"
	local sGeneric = "GENERIC"
	local sCitySuffix = "LOC_COHORT_CITY_SUFFIX"
	local sAltCityName = ""
	local sSimpleCity = ""
	local sEraName = ""
	local sFounderString = "LOC_COHORT_FOUNDERS"
	local sOriginalName = sUniqueName

	if sUnitType == "UNIT_SETTLER" then
		local iSettlerNumber = Game:GetProperty(playerID.. "FIRST_SETTLER")

		if iSettlerNumber ~= 1 then -- first Settler
			local pPlayer = Players[playerID]
			local pPlayerCities = pPlayer:GetCities()
			local iNumberCities = pPlayerCities:GetCount()
			--print ("Number of Cities", iNumberCities)
			if iNumberCities == 0 then -- no cities already (might be important for scenarios or something?)
				Game:SetProperty(playerID.. "FIRST_SETTLER", 1)
				local sCivilizationAdjective = GameInfo.Civilizations[sCivilizationType].Adjective -- i.e American
				local sFounderName = Locale.Lookup(sFounderString, sCivilizationAdjective)
				--print ("Founders!")
				return sFounderName
			end
		end
	end

	if tModernUnits[sUnitType] == true then
		sEraName = "_MODERN"
		--print ("it's a modern unit")
	end

	if sUniqueName == nil then
		sUniqueName = ""
	end

	if sFormation == "_CORPS" or sFormation == "_ARMY" then
		sUnitType = sUnitType .. sFormation
		sUnitClassType = sUnitClassType .. sFormation
		sGeneric = sGeneric .. sFormation
		--print ("it's a ", sFormation)
	end

	if bNavalUnit == true then
		if sUniqueName == "" then -- ship does not already have a name
			sGeneric = sGeneric .. "_NAVAL"
			print ("it's a ship that doesn't already have a name!")
			sUniqueName = SC_Cohort_Get_Unique_Name(sUnitType, sUnitClassType, sCivilizationType, bNavalUnit)

			--print (sUniqueName)

			if sUniqueName == "" then
				sGeneric = "GENERIC"
				print ("no naval name found!")
			end
		elseif sFormation == "_CORPS" or sFormation == "_ARMY" then
			sGeneric = sGeneric .. "_NAVAL"
		end
	else
		-- to catch stuff like Legions and anything else that later gets Unique Names
		sUniqueName = SC_Cohort_Get_Unique_Name(sUnitType, sUnitClassType, sCivilizationType, bNavalUnit)
	end

	local sTestName1
	local sTestName2
	local sTestName3
	local sTestName4
	local sTestName5
	local sTestName6

	local sBestTestName
	local sBestTestNameLOC

	sTestName1 = sLOCStart .. sUnitType .. "_".. sCivilizationType -- Roman names for Legion
	sTestName2 = sLOCStart .. sUnitType -- Any names for Legions
	sTestName3 = sLOCStart .. sUnitClassType .. "_" .. sCivilizationType .. sEraName -- Roman names for melee units
	sTestName4 = sLOCStart .. sUnitClassType .. sEraName -- Any names for melee units
	sTestName5 = sLOCStart .. sGeneric .. "_" .. sCivilizationType .. sEraName -- Roman names for any Units
	sTestName6 = sLOCStart .. sGeneric .. sEraName -- Any names for units

	print ("test Names are : ", sTestName1, sTestName2, sTestName3, sTestName4, sTestName5, sTestName6)

	sBestTestName = SC_Cohort_Find_Best_Existing_Name(sTestName1, sTestName2, sTestName3, sTestName4, sTestName5, sTestName6)
	
	print ("The best Test name is: ", sBestTestName)

	local iNumber = 0
	local iCivCountNumber = 0

	---- DEFINING VARIABLES
	if sBestTestName == sTestName3 or sBestTestName == sTestName4 then
		--number depends on unitClass
		iNumber = Game:GetProperty(playerID.. sUnitClassType.. sFormation.. iCityID.. "Number")
		--print (playerID.. sUnitClassType.. sFormation.. iCityID.. "Number")

		if iNumber == nil then
			iNumber = 1
		end

		iCivCountNumber = Game:GetProperty(playerID.. sUnitClassType.. sFormation.. "CivNumber")

		if iCivCountNumber == nil then
			iCivCountNumber = 1
		end

		Game:SetProperty(playerID.. sUnitClassType.. sFormation.. iCityID.. "Number", iNumber+1)
		Game:SetProperty(playerID.. sUnitClassType.. sFormation.. "CivNumber", iCivCountNumber+1)
	else
		--number depends on unit type
		iNumber = Game:GetProperty(playerID.. sUnitType.. sFormation.. iCityID.. "Number")
		--print (playerID.. sUnitType.. sFormation.. iCityID.. "Number")

		if iNumber == nil then
			iNumber = 1
		end

		iCivCountNumber = Game:GetProperty(playerID.. sUnitType.. sFormation.. "CivNumber")

		if iCivCountNumber == nil then
			iCivCountNumber = 1
		end

		Game:SetProperty(playerID.. sUnitType.. sFormation.. iCityID.. "Number", iNumber+1)
		Game:SetProperty(playerID.. sUnitType.. sFormation.. "CivNumber", iCivCountNumber+1)
	end


	if iCityNamingScheme > 0 and iCityNamingScheme < 5 then
		sCitySuffix = sCitySuffix .. "_ALT" .. iCityNamingScheme
	elseif iCityNamingScheme ~= 0 then
		print ("weird City Name mode value")
	end

	--print ("sCityName is: ", sCityName)

	if sCityName ~= nil then
		sSimpleCity = Locale.Lookup(sCityName)
		if iCityNamingScheme == 4 then
			sAltCityName = Locale.Lookup(sCitySuffix, sCityName)
			sCityName = ""
			--print ("sAltCityName is: ", sCityName)
		else
			sCityName = Locale.Lookup(sCitySuffix, sCityName)
			--print ("sCityName is: ", sCityName)
		end
	else
		sCityName = ""
		iNumber = iCivCountNumber
	end

	-- something here to detect if it's a unique name and thus should use GameInfo.Civilizations[sCivilizationType].Name in case there's no city name? (See Norway's Field Cannons)

	--print ("NUMBER IS ", iNumber)

	local sNumber = Cohort_Number_Getter(iNumber)
	--print (sNumber)

	local sRomanNumeral = SC_Cohort_Get_Roman_Numeral(iNumber)
	--print (sRomanNumeral)

	local sCivCountNumber = Cohort_Number_Getter(iCivCountNumber)
	--print (sCivCountNumber)

	local sNATOAlphabet = Cohort_NATO_Getter(iNumber)
	--print (sNATOAlphabet)

	local sSingleLetter = string.sub(sNATOAlphabet, 1, 1)
	--print (sSingleLetter)

	local sUnitTypePlural = SC_Cohort_Get_Plural_Name(sUnitType, sUnitTypeName)

	--print (sBestTestName, sNumber, sUnitTypeName, sUnitTypePlural, sCityName, sAltCityName, sSimpleCity, sUniqueName, iNumber, iCivCountNumber, sCivCountNumber, sRomanNumeral, sNATOAlphabet, sSingleLetter)

	-- 1 = Number, 2 = UnitType, 3 = UnitType (Plural), 4 = City, 5 = AltCity, 6 = SimpleCity, 7 = UniqueName, 8 = Cardinal Number, 9 = Cardinal CivCount Number, 10 = CivCountNumber, 11 = Roman Number, 12 = NATO Alphabet, 13 = Single Letter

	sBestTestNameLOC = Locale.Lookup(sBestTestName, sNumber, sUnitTypeName, sUnitTypePlural, sCityName, sAltCityName, sSimpleCity, sUniqueName, iNumber, iCivCountNumber, sCivCountNumber, sRomanNumeral, sNATOAlphabet, sSingleLetter)

	return sBestTestNameLOC
end

function Cohort_City_Getter (unitX, unitY)
	local sCityName = ""
	local iCityID = -1

	--print ("City getter running")
	if unitX and unitY then
		local pPlot = Map.GetPlot(unitX,unitY)
		if pPlot then
			local pPlotIndex = pPlot:GetIndex()
			local pCity = Cities.GetPlotPurchaseCity(pPlotIndex)

			if pCity then
				sCityName = pCity:GetName()
				iCityID = pCity:GetID()
				print ("City found. Name: ", sCityName)
			else
				print ("No city found")
			end
		else
			print ("no unit plot found?")
		end
	else
		print ("no unit location found?")
	end

	--print ("sending back: ", sCityName)
	return sCityName, iCityID
end


function Cohort_Unit_Namer (sEventType, playerID, unitID, sUnitTypeName, unitX, unitY, sFormation, sUniqueName)

	--print (sEventType, playerID, unitID, sUnitTypeName, unitX, unitY, sFormation, sUniqueName)

	local sUnitName = ""
	local sUnitType
	local sUnitClassType
	local bNavalUnit = false
	local bAirUnit = false

	--local pPlayer = Players[playerID]
	local pPlayerConfig = PlayerConfigurations[playerID]
	local sCivilizationType = pPlayerConfig:GetCivilizationTypeName()

	for row in GameInfo.Units() do
		if row.Name == sUnitTypeName then
			sUnitType = row.UnitType
			sUnitClassType = row.PromotionClass
			if not sUnitClassType then
				sUnitClassType = "NONE"
			end
			--print (sUnitClassType)

			if row.Domain == "DOMAIN_SEA" then
				bNavalUnit = true
			end

			if row.Domain == "DOMAIN_AIR" then
				bAirUnit = true
			end
		end
	end

	if tExcludedNamingUnits[sUnitType] == true then
		print ("this unit is on the excluded naming list")
		return sUnitName
	end

	if not sUnitClassType then
		sUnitClassType = "NONE"
	end

	if (sFormation ~= "_CORPS") and (sFormation ~= "_ARMY") then
		sFormation = ""
	end

	--print (sUnitClassType)

	if sEventType == "Upgrade" and bNavalUnit == true then
		print ("upgraded ships do not change names")
		return sUniqueName
	end

	sCityName, iCityID = Cohort_City_Getter(unitX, unitY)

	if iCityID == -1 then
		iCityID = ""
	end

	if sCityName ~= "" then
		--print (sCityName)
		sUnitName = SC_Cohort_Get_Best_Name(sUnitType, sUnitTypeName, sUnitClassType, sCivilizationType, sFormation, sCityName, iCivCountNumber, sUniqueName, bNavalUnit, playerID, iCityID, sEventType, bAirUnit)
	else
		print ("sending w/o city")
		sUnitName = SC_Cohort_Get_Best_Name(sUnitType, sUnitTypeName, sUnitClassType, sCivilizationType, sFormation, nil, iCivCountNumber, sUniqueName, bNavalUnit, playerID, iCityID, sEventType, bAirUnit)
	end

	print (sUnitName)

	return sUnitName
end

function Cohort_Unit_Added ( playerID, unitID, unitX, unitY)
	local pUnit = UnitManager.GetUnit(playerID, unitID)
	
	if pUnit then -- Moved to avoid nil

		local sUnitName = ""
		local sUnitTypeName = ""

		sUnitTypeName = UnitManager.GetTypeName(pUnit)
		--print ("unit type is: ", sUnitTypeName)

		--print ("There's a unit!")
		sUnitName = pUnit:GetExperience():GetVeteranName()
		--print ("unit name is: ", sUnitName)

		if sUnitName ~= "" then
			print ("unit already has name")
		else
			sFormation = pUnit:GetMilitaryFormation()

			if sFormation == MilitaryFormationTypes.CORPS_FORMATION then
				sFormation = "_CORPS"
			elseif sFormation == MilitaryFormationTypes.ARMY_FORMATION then
				sFormation = "_ARMY"
			end

			local sNewName = Cohort_Unit_Namer("Added", playerID, unitID, sUnitTypeName, unitX, unitY, sFormation)

			if sNewName ~= "" then
				print ("name exists")
				pUnit:GetExperience():SetVeteranName(sNewName)
				print (sNewName)
			else
				print ("name does not exist")
			end
		end

		--LuaEvents.SC_UnitsUpdate(playerID, unitID)
	end
end

function Cohort_Unit_Upgraded (playerID, unitID)
	local pPlayer = Players[playerID]
	local pPlayerUnits = pPlayer:GetUnits()
	local pUnit = pPlayerUnits:FindID(unitID)

	if pUnit then -- CUSTOM Moved to avoid nil

		local sUnitName = ""
		local sUnitTypeName = ""
		local sFormation

		local sUniqueName = ""

		sUnitTypeName = UnitManager.GetTypeName(pUnit)
		--print ("unit type is: ", sUnitTypeName)
	
		--print ("There's a unit!")
		sUnitName = pUnit:GetExperience():GetVeteranName()
		--print ("unit name is: ", sUnitName)

		if sUnitName ~= "" then
			sUniqueName = sUnitName
		end

		sFormation = pUnit:GetMilitaryFormation()

		if sFormation == MilitaryFormationTypes.CORPS_FORMATION then
			sFormation = "_CORPS"
		elseif sFormation == MilitaryFormationTypes.ARMY_FORMATION then
			sFormation = "_ARMY"
		end

		local iX, iY = pUnit:GetX(), pUnit:GetY()

		local sNewName = Cohort_Unit_Namer("Upgrade", playerID, unitID, sUnitTypeName, unitX, unitY, sFormation, sUniqueName)

		if sNewName ~= "" then
			print ("name exists")
			pUnit:GetExperience():SetVeteranName(sNewName)
			print (sNewName)
		else
			print ("name does not exist")
		end

		--LuaEvents.SC_UnitsUpdate(playerID, unitID)
	end

end

function Cohort_Unit_Join (playerID, unitID)
	local pPlayer = Players[playerID]
	local pPlayerUnits = pPlayer:GetUnits()
	local pUnit = pPlayerUnits:FindID(unitID)

	if pUnit then -- CUSTOM Moved to avoid nil

		local sUnitName = ""
		local sUnitTypeName = ""
		local sFormation

		local sUniqueName = ""

		sUnitTypeName = UnitManager.GetTypeName(pUnit)
		--print ("unit type is: ", sUnitTypeName)
	
		--print ("There's a unit!")
		sUnitName = pUnit:GetExperience():GetVeteranName()
		--print ("unit name is: ", sUnitName)

		if sUnitName ~= "" then
			sUniqueName = sUnitName
		end

		sFormation = pUnit:GetMilitaryFormation()

		if sFormation == MilitaryFormationTypes.CORPS_FORMATION then
			sFormation = "_CORPS"
		elseif sFormation == MilitaryFormationTypes.ARMY_FORMATION then
			sFormation = "_ARMY"
		end

		local unitX, unitY = pUnit:GetX(), pUnit:GetY()

		local sNewName = Cohort_Unit_Namer("Joined", playerID, unitID, sUnitTypeName, unitX, unitY, sFormation, sUniqueName)

		if sNewName ~= "" then
			print ("name exists")
			pUnit:GetExperience():SetVeteranName(sNewName)
			print (sNewName)
		else
			print ("name does not exist")
		end

		--LuaEvents.SC_UnitsUpdate(playerID, unitID)
	end

end
Events.UnitAddedToMap.Add(Cohort_Unit_Added)
Events.UnitUpgraded.Add(Cohort_Unit_Upgraded)
Events.UnitFormCorps.Add(Cohort_Unit_Join)
Events.UnitFormArmy.Add(Cohort_Unit_Join)

print ("Loaded!")