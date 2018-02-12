function takeMoney( amount )
	takePlayerMoney( source, amount*100)
end
addEvent("takeMoney", true)
addEventHandler("takeMoney", root, takeMoney)