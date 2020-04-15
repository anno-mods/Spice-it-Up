import Anno6, TextSources
class AI_Spawner:
	def __init__(self):
		print("ai_spawner active2")
		self.aiTrigger = {930201:"jorgensen", 930202:"qing", 930203:"wibblesock", 930204:"smith", 930205:"omara", 930206:"gasparov", 930207:"malching", 930208:"gravez", 930209:"silva", 930210:"hunt", 930211:"mercier", 930212:"nate"}
		self.aiGUID = {"queen": 75, "jorgensen": 47, "qing":79, "wibblesock":80, "smith":81, "omara":82, "gasparov":83, "malching":11, "gravez":48, "silva":84, "hunt":85, "mercier":220, "nate":77}
		self.aiPID  = {"queen": 15, "jorgensen": 25, "qing":26, "wibblesock":27, "smith":28, "omara":29, "gasparov":30, "malching":31, "gravez":32, "silva":33, "hunt":34, "mercier":64, "nate":22}
		self.denyQuest = {"alreadyInGame" :930500, "tooManyAIs":930501}
		self.acceptQuest = {"jorgensen": 930251, "qing":930252, "wibblesock":930253, "smith":930254, "omara":930255, "gasparov":930256, "malching":930257, "gravez":930258, "silva":930259, "hunt":930260, "mercier":930261, "nate":930262}
		self.aiLimit = 3
		self.doNotCount = {"queen","nate"}
	def isAlreadyThere(self, aiName):
		return (TextSources.TextSourceRoots.SessionParticipants.GetParticipant(self.aiPID[aiName]).GUID) == (self.aiGUID[aiName])
	def tooManyAIs(self):
		aiCount = 0
		for GUID in self.aiTrigger:
			if ((TextSources.TextSourceRoots.SessionParticipants.GetParticipant(self.aiPID[self.aiTrigger[GUID]]).GUID == (self.aiGUID[self.aiTrigger[GUID]])) and (self.aiTrigger[GUID] not in self.doNotCount)):
				aiCount += 1
		if(TextSources.TextSourceRoots.SessionParticipants.GetParticipant(17).GUID == 0): #Third_party_03 (Anne Harlow)
			aiCount -= 1
		if(TextSources.TextSourceRoots.SessionParticipants.GetParticipant(18).GUID == 0): #Third_party_04 (La Fortune)
			aiCount -= 1
		return (self.aiLimit <= aiCount)
	def accept(self, aiName):
		print("accept: ")
		print(aiName)
		TextSources.TextSourceRoots.SessionParticipants.SetCheatCreateSessionParticipant(self.aiPID[aiName])
		TextSources.TextSourceRoots.Quests.StartQuestForCurrentPlayerNet(self.acceptQuest[aiName])
	def trigger(self, GUID):
		if (GUID in self.aiTrigger):
			if (self.isAlreadyThere(self.aiTrigger[GUID])):
				TextSources.TextSourceRoots.Quests.StartQuestForCurrentPlayerNet(930500)
			elif (self.tooManyAIs()):
				TextSources.TextSourceRoots.Quests.StartQuestForCurrentPlayerNet(930501)
			else:
				self.accept(self.aiTrigger[GUID])
	def delete(self, ID):
		TextSources.TextSourceRoots.Participants.SetRemoveParticipant(ID)
ai_spawner = AI_Spawner()

