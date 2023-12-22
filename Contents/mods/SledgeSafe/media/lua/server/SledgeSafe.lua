--
--                                  @*x/||x8
--                                   %8%n&v]`Ic
--                                     *)   }``W
--                                     *>&  1``n
--                                  &@ tI1/^`"@
--                                 &11\]"``^v
--                                M"`````,[&@@@@@
--                            &#cv(`:[/];"`````^r%
--                        @z);^`^;}"~}"........;&
--                 @WM##n~;+"`^^^.<[}}+,`'''`:tB
--                 #*xj<;).`i"``"l}}}}}}}%@B
--                 j^'..`+..,}}}}}}}}}}}(
--                  /,'.'...I}}}}}}}}}}}r
--                    @Muj/x*c"`'';}}}}}n
--                           !..'!}}}}}}x
--                          r`^;[}}}}}}}t                        @|M
--                         8{}}}}}}}}}}}{&                       B?>|@
--                         \}}}}}}}}}}}}})W                      x}?'<
--                        v}}}}}}}}}}}}}}}}/v#&%B  @@          Bj}}:.`
--                        :,}}}}}}}}}}}}}}}}}}}}}}}{{{1)(|/jnzr{}+"..-
--                        :.;}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}]l,;_c
--                        (.:}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}t
--                      &r_^']}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}+*
--                   Mt-I,,,^`[}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}"W
--               *\+;,,,,,,,,",}}}}}}}}}}}]??]]}}}}}}}}}}}}}}}]""*
--             c;,,,,:;+{rW8BBB!+}}}}}}}}}>,:;!}}}}}}}}}}}}-"^`"l\%
--             W:,,,?@         n'+}}}}}}}?:,,,:[}}}}}}}}}}}:.,,,+|f@
--              /,,,i8          ,"}}}}}}|vnrrrrt}}}}}}}}}}}"`,,,:1|\v@
--               xI,,;rB%%B     [:}}}}{u        c(}}}}}}}}},`,,,,;}||/8
--                @fl]trrrrr    *}}}}}t           &vf(}}}}}]`:,,,,,?||t
--                  @*rrrrrx    *}}}}})@              &/}}}}-nxj\{[)|||xc#
--                     Mrrrv    v}}}}}c                 u}}}}}}r   8t|||||8
--                      8nr*    x}}}}n                   j}}}}}v    Bj|||?t
--                        &B    r}}}\                    %}}}}>%     &_]}:u
--                              j}}}z                    _"~l`1    Bx<,,,;B
--                              njxt@                @z}"....!   z[;;;;:;}
--                           %MvnnnnM               *~"^^^``iB  B*xrrrffrrB
--                         Wunnnnnnn*             &cnnnnnnnv   @*z*****zz#
--                        &MWWWWWWMWB            WMWWWWWWMWB
------------------------------------------------------------------------------------------------------
-- AUTHOR: Badonn the Deer
-- LICENSE: MIT
-- REFERENCES: N/A
-- Did this code help you write your own mod? Consider donating to me at https://ko-fi.com/badonnthedeer!
-- I'm in financial need and every little bit helps!!
--
-- Have a problem or question? Reach me on Discord: badonn
------------------------------------------------------------------------------------------------------

local SledgeSafe = {};

--media\lua\server\BuildingObjects\ISPlace3DItemCursor.lua

-- C:\Program Files (x86)\Steam\steamapps\workshop\content\108600\

-- C:\Users\[user]\Zomboid\mods
-- C:\Users\[user]\Zomboid\Logs


SledgeSafe.getSafeHouseByLocation = function(objX, objY)
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


SledgeSafe.playerPartOfSafehouse = function(safehouse, player)
    local playerSafehouse = safehouse:alreadyHaveSafehouse(player);
    if playerSafehouse ~= nil
    then
        if playerSafehouse == safehouse
        then
            return true
        end
    end
    return false
end


local oldCanDestroy =  ISDestroyCursor.canDestroy
ISDestroyCursor.canDestroy = function(self, object)

    local canDestroy = oldCanDestroy(self, object);

    if canDestroy == true and isAdmin() == false
    then
        local square = getCell():getGridSquare(object:getX(), object:getY(), object:getZ())

        local safehouse = SledgeSafe.getSafeHouseByLocation(square:getX(), square:getY())

        if safehouse ~= nil
        then
            if safehouse:getOwner() == self.character:getUsername()
            then
                return true;
            elseif SledgeSafe.playerPartOfSafehouse(safehouse, self.character)
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
        end
    end
    return canDestroy;
end

local oldIsValidPlacement =  ISMoveableCursor.isValid( _square )
ISMoveableCursor.isValid = function(self, object)

    local isValid = oldIsValidPlacement(self, object);

    if isValid == true and isAdmin() == false
    then
        local square = getCell():getGridSquare(object:getX(), object:getY(), object:getZ())

        local safehouse = SledgeSafe.getSafeHouseByLocation(square:getX(), square:getY())

        if safehouse ~= nil
        then
            if safehouse:getOwner() == self.character:getUsername()
            then
                return true;
            elseif SledgeSafe.playerPartOfSafehouse(safehouse, self.character)
            then
                if SandboxVars.SledgeSafe.SafehouseMembersCanPlace
                then
                    return true;
                else
                    return false;
                end
            else
                return false;
            end
        end
    end
    return isValid;
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