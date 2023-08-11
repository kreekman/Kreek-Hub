local successPastebin, errormessagePastebin = pcall(function()
	loadstring(game:HttpGet("https://pastebin.com/raw/sthXfBdm"))()
end)

if not successPastebin then
	local successGithub, errormessageGithub = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/kreekman/Part-Remover/main/RAW%20PartRemover.lua"))()		
	end)
	
	if not successGithub then
		warn([[Error loading: ]]..errormessageGithub..[[ 
			Try re-installing the scripts at https://github.com/kreekman/Part-Deletor]])
	end
end
-- re-install the script if it doesn't work from the GitHub: https://github.com/kreekman/Part-Remover
