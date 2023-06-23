-- C:\Program Files (x86)\Steam\steamapps\workshop\content\108600\

-- C:\Users\[user]\Zomboid\mods
-- C:\Users\[user]\Zomboid\Logs


local function getSafeHouseByLocation(objX, objY)
    local safehouseList = SafeHouse.getSafehouseList()
    for i= 0, safehouseList:size() - 1
    do
        local safehouse = safehouseList:get(i);
        if (objX >= safehouse:getX() and objX < safehouse:getX2() and objY >= safehouse:getY() and objY < safehouse:getY2())
        then
            return safehouse
        end
    end
    return nil
end


local function playerPartOfSafehouse(safehouse, player)
    local playerSafehouse = SafeHouse:alreadyHaveSafehouse(player);
    if playerSafehouse
    then
        if playerSafehouse == safehouse
        then
            return true
        end
    end
    return false
end


function ISDestroyCursor.canDestroy(self, object)

    local canDestroy = oldCanDestroy(self, object);

    if canDestroy == true
    then
        local square = getCell():getGridSquare(object:getX(), object:getY(), object:getZ())

        local safehouse = getSafeHouseByLocation(square:getX(), square:getY())

        if safehouse ~= nil
        then
            if safehouse:getOwner() == self.player:getUsername()
            then
                return true;
            elseif playerPartOfSafehouse(safehouse, self.player)
            then
                if SandboxVars.SledgeSafe.SafehouseMembersCanSledge
                then
                    return true;
                else
                    return false;
                end
            else
                return false;
            end
        else
            return canDestroy;
        end
    end
end

--[[
public static SafeHouse isSafeHouse(IsoGridSquare var0, String var1, boolean var2) {
      if (var0 == null) {
         return null;
      } else {
         if (GameClient.bClient) {
            IsoPlayer var3 = GameClient.instance.getPlayerFromUsername(var1);
            if (var3 != null && !var3.accessLevel.equals("")) {
               return null;
            }
         }

         SafeHouse var6 = null;
         boolean var4 = false;

         for(int var5 = 0; var5 < safehouseList.size(); ++var5) {
            var6 = (SafeHouse)safehouseList.get(var5);
            if (var0.getX() >= var6.getX() && var0.getX() < var6.getX2() && var0.getY() >= var6.getY() && var0.getY() < var6.getY2()) {
               var4 = true;
               break;
            }
         }

         if (var4 && var2 && ServerOptions.instance.DisableSafehouseWhenPlayerConnected.getValue() && (var6.getPlayerConnected() > 0 || var6.getOpenTimer() > 0)) {
            return null;
         } else {
            return !var4 || (var1 == null || var6 == null || var6.getPlayers().contains(var1) || var6.getOwner().equals(var1)) && var1 != null ? null : var6;
         }
      }
   }
]]