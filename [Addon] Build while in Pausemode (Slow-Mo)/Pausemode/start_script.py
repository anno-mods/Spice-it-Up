class Speed:
	def __init__(self):
		print("speed init done")
	def toggle(self):
		print('speed toggled')
		if scenes.ResourceBar.GlobalRightBarData.PauseBtn.Selected:
			scenes.ResourceBar.GlobalRightBarData.PauseBtn.Selected = 0
			TextSources.TextSourceRoots.GameClock.SetSetGameSpeed(2)
			scenes.ResourceBar.GlobalRightBarData.PlayBtn.ButtonReleasedL()
		else:
			scenes.ResourceBar.GlobalRightBarData.PauseBtn.Selected = 1
			TextSources.TextSourceRoots.GameClock.SetSetGameSpeed(0)
			
speed = Speed();

