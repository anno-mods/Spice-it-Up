local Participants = {
	"jorgensen",
	"qing",
	"wibblesock",
	"smith",
	"omara",
	"gasparov",
	"malching",
	"gravez",
	"silva",
	"hunt",
	"mercier",
	"nate",
	"harlow",
	"fortune"
}

local ParticipantID = {
	["queen"] = 15,
	["jorgensen"] = 25,
	["qing"] = 26,
	["wibblesock"] = 27,
	["smith"] = 28,
	["omara"] = 29,
	["gasparov"] = 30,
	["malching"] = 31,
	["gravez"] = 32,
	["silva"] = 33,
	["hunt"] = 34,
	["mercier"] = 64,
	["nate"] = 22,
	["harlow"] = 17,
	["fortune"] = 18
}

local DenyQuest = {
	["AlreadyIngame"] = 930500,
	["tooManyAIs"] = 930501
}

local AcceptQuest = {
	["jorgensen"] = 930251,
	["qing"] = 930252,
	["wibblesock"] = 930253,
	["smith"] = 930254,
	["omara"] = 930255,
	["gasparov"] = 930256,
	["malching"] = 930257,
	["gravez"] = 930258,
	["silva"] = 930259,
	["hunt"] = 930260,
	["mercier"] = 930261,
	["nate"] = 930262,
	["harlow"] = 0,
	["fortune"] = 0
}

local AiLimit = 3

local DoNotCount = {
	["queen"] = 1, 
	["nate"] = 1
}

--#region FUNCTIONS

local function Accept(ParticipantName)
	ts.SessionParticipants.SetCheatCreateSessionParticipant(ParticipantID[ParticipantName])
	ts.Quests.StartQuestForCurrentPlayerNet(AcceptQuest[ParticipantName])
end

local function TooManyParticipants()
	local _aiCount = 0

	for key, participant in pairs(Participants) do
		print(participant)
		-- I am beginning to hate this language
		local def = AISpawner.IsParticipantDefined(participant)
		local counted = AISpawner.IsParticipantCounted(participant)
		if def and counted then
			_aiCount = _aiCount + 1
		end
	end
	return AiLimit <= _aiCount
end

local function IsCounted(ParticipantName)
	return not DoNotCount[participant] == 1
end

local function IsDefinedByID(ParticipantID)
	local participant = ts.SessionParticipants.GetParticipant(ParticipantID).GUID
	local result = not participant == 0
	return result
end

local function IsDefined(ParticipantName)
	local pid = ParticipantID[ParticipantName]
	return IsDefinedByID(pid)
end

local function IsValidParticipant(ParticipantName)
	for key, participant in pairs(Participants) do
		if participant == ParticipantName then
			return true
		end
	end
	return false
end

local function Spawn(ParticipantName)
	
	print("trying to spawn " .. ParticipantName)

	if not IsValidParticipant(ParticipantName) then
		print("Invalid Participant: " .. ParticipantName)
		return
	end

	print("we got past the valid state")

	if IsDefined(ParticipantName) then
		print(ParticipantName .. " is already defined")
		ts.Quests.StartQuestForCurrentPlayerNet(DenyQuest["AlreadyIngame"])
	elseif TooManyParticipants() then
		print("maximum participants reached")
		ts.Quests.StartQuestForCurrentPlayerNet(DenyQuest["tooManyAIs"])
	else
		print("accept" .. ParticipantName)
		Accept(ParticipantName)
	end
end

local function Delete(ParticipantName)
	if IsValidParticipant(ParticipantName) then
		local pid = ParticipantID[ParticipantName]
		ts.Participants.SetRemoveParticipant(pid)
	end
end

-- #Region AI Spawner API Definition

AISpawner = {
	Participants = Participants,
	AiLimit = AiLimit,
	SetCheatSpawnParticipant = Accept,
	ParticipantLimitReached = TooManyParticipants,
	IsParticipantDefined = IsDefined,
	IsParticipantCounted = IsCounted,
	SpawnParticipant = Spawn,
	DeleteParticipant = Delete,
	CheckParticipantValidity = IsValidParticipant
}

print("initializing AI spawner")