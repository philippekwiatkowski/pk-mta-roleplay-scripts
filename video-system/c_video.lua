function getMatrix( )
	local a, b, c, d, e, f = getCameraMatrix( )
	outputChatBox(a ..", ".. b ..", ".. c ..", ".. d ..", ".. e ..", ".. f, 255, 255, 255)
end
addCommandHandler("getmatrix", getMatrix, false, false)