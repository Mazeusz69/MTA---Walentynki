--[[
	
	@Mazeusz for Modern Stories 2021
	@Walentynki 2021
	@Wszystkie prawa zastrzeżone.

--]]


function findPlayer(plr,cel)
	local target=nil
	if (tonumber(cel) ~= nil) then
		target=getElementByID("p"..cel)
	else -- podano fragment nicku
		for _,thePlayer in ipairs(getElementsByType("player")) do
			if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 0, true) then
				if (target) then
					outputChatBox("* Znaleziono więcej niż jednego gracza o pasującym nicku, podaj więcej liter.", plr)
					return nil
				end
				target=thePlayer
			end
		end
	end
	if target and getElementData(target,"p:inv") then return nil end
	return target
end

function akceptuje(plr,cmd)
	if not player then return end
	plr = player2
	giveWeapon(player, 14, 1, true )
	takeWeapon(plr, 14)
	killTimer(timer)
	setPedAnimation(plr, false)
	outputChatBox("* "..getPlayerName(plr).." wręcza ci kwiaty!", player)
	outputChatBox("* Wręczasz "..getPlayerName(player).." kwiaty.", plr)
	triggerEvent("broadcastCaptionedEvent", player, getPlayerName(plr).." wręcza kwiaty "..getPlayerName(player), 15, 15, true)
	setPedAnimation(plr, false)
	removeCommandHandler("tak", akceptuje) -- usuwanie komendy
	removeCommandHandler("nie", nieakceptuje) -- usuwanie komendy
end
function nieakceptuje(plr,cmd)
	if not player then return end
	plr = player2
	killTimer(timer)
	setPedAnimation(plr, false)
	takeWeapon(plr, 14)
	outputChatBox("* Nie chcesz kwiatów.", player)
	outputChatBox("* Nie chce twoich kwiatów.", plr)
	setPedAnimation(plr, false)
	removeCommandHandler("tak", akceptuje) -- usuwanie komendy
	removeCommandHandler("nie", nieakceptuje) -- usuwanie komendy
end

addEvent("dajkwiat:animacjastart", true)
function startAnimacja(plr2, plr)
   player = plr2
   player2 = plr
   outputChatBox("Gracz "..getPlayerName(plr).." chce ci wręczyć kwiaty czy akceptujesz <tak/nie>",player)
   addCommandHandler("tak", akceptuje)
   addCommandHandler("nie", nieakceptuje)
   setPedAnimation(plr, "CAMERA", "camstnd_to_camcrch", -1, false, false )
   giveWeapon(plr, 14, 1, true )
   timer=setTimer(function()
		player=nil
		setPedAnimation(plr, false)
		outputChatBox("* Gracz nie wybrał żadnej opcji - anulowano.", plr, 255, 0, 0)
		outputChatBox("* Nie wybrałeś-aś żadnej z opcji - anulowano.", player, 255, 0, 0)
		takeWeapon(plr, 14)
		removeCommandHandler("tak", akceptujTransakcje) -- usuwanie komendy
		removeCommandHandler("nie", akceptujTransakcje) -- usuwanie komendy
	end, 20000, 1)
end
addEventHandler("dajkwiat:animacjastart", root, startAnimacja)

function onPlayerGiveFlower(plr, cmd, target)
	if getElementData(plr, "mutespam") == 4 then return end
	setElementData(plr, "mutespam", 4)
	setTimer(function()
		setElementData(plr, "mutespam", false)
	end, 3000, 1)
    if not target then
        outputChatBox('* Użyj: /dajkwiatki <nick/ID>', plr)
        return
    end
    local target=findPlayer(plr,target)
	
	if plr == target then outputChatBox("Nie możesz dać sobie samemu!", plr) return end
   
    if not target then
		outputChatBox("* Nie znaleziono podanego gracza.", plr)
        return
    end
	if not (getElementData(target, "player:logged") == true) then
	   outputChatBox('* Gracz nie jest zalogowany!.', plr, 255, 0, 0)
	return end
	local x,y,z = getElementPosition(plr)
	local cub = createColSphere(x,y,z,1)
	local gracze = getElementsWithinColShape(cub, "player")
	if #gracze == 1 then
		outputChatBox("* Brak graczy w pobliżu.", plr)
		setTimer(destroyElement,3000,1,cub)
	return end
	setTimer(destroyElement,3000,1,cub)
	triggerEvent("dajkwiat:animacjastart", plr, target, plr)
end
addCommandHandler('dajkwiatki', onPlayerGiveFlower)
addCommandHandler('dajkwiat', onPlayerGiveFlower)




