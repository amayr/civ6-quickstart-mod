local numSettlers = 2  --------------------------------------------set number of extra starting settlers for player
local numScouts   = 1  --------------------------------------------set number of extra starting scouts
local numBuilders = 1 ---------------------------------------------set number of extra starting builders
-- local TechOne = GameInfo.Technologies["TECH_POTTERY"]; ------------set technology
-- local TechTwo = GameInfo.Technologies["TECH_ANIMAL_HUSBANDRY"]; ---set technology
-- local TechThree = GameInfo.Technologies["TECH_MINING"]; -----------set technology to start with less techs, local TechThree;
-- local PlayerGold = 100--------------------------------------------set gold
local iScout = GameInfo.Units["UNIT_SCOUT"].Index -----------------set unit
local iSettler = GameInfo.Units["UNIT_SETTLER"].Index -------------set unit
local iBuilder = GameInfo.Units["UNIT_BUILDER"].Index -------------set unit

function OnPlayerTurnActivated( player, bIsFirstTime )

	local currentTurn = Game.GetCurrentGameTurn();
	local SpawnTurn = 0;
	local playerUnits;	
	local adjacentPlot;
	local unitPlot;
		if currentTurn == GameConfiguration.GetStartTurn() then
		local pPlayer = Players[player]
			 playerUnits = pPlayer:GetUnits()
				for i, unit in playerUnits:Members() do
					local unitTypeName = UnitManager.GetTypeName(unit)
					if "LOC_UNIT_SETTLER_NAME" == unitTypeName then
						SpawnTurn = 1;
						unitPlot = Map.GetPlot(unit:GetX(), unit:GetY());		
					end
				end
			
			if SpawnTurn == 1 then
				local lastPlot = unitPlot;
				if numScouts > 0 then
					for i = 1, numScouts do
						for direction = 1, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
							adjacentPlot = Map.GetAdjacentPlot((lastPlot:GetX() + 1), lastPlot:GetY(), direction);
							if (adjacentPlot ~= nil) and not (adjacentPlot:IsWater() or adjacentPlot:IsImpassable()) then
								break		
							end
						end
						pUnit = playerUnits:Create(iScout, unitPlot:GetX(), unitPlot:GetY())
						lastPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
					end
				end
				if numSettlers > 0 then
					for i = 1, numSettlers do	
						for direction = 1, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
							adjacentPlot = Map.GetAdjacentPlot((lastPlot:GetX() ), lastPlot:GetY(), direction);
							if (adjacentPlot ~= nil) and not (adjacentPlot:IsWater() or adjacentPlot:IsImpassable()) then
								break		
							end
						end
						pUnit2 = playerUnits:Create(iSettler, adjacentPlot:GetX(), adjacentPlot:GetY())	
						lastPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
					end	
				end
				if numBuilders > 0 then
					 for i = 1, numBuilders do
						for direction = 1, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
							adjacentPlot = Map.GetAdjacentPlot(lastPlot:GetX(), lastPlot:GetY(), direction);
							if (adjacentPlot ~= nil) and not (adjacentPlot:IsWater() or adjacentPlot:IsImpassable()) then
								break		
							end
						end
						pUnit3 = playerUnits:Create(iBuilder, lastPlot:GetX(), lastPlot:GetY())
						lastPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
					end
				end
			end
			
		end
	

	
end
			


function Initialize()
Events.LocalPlayerChanged.Add( OnPlayerTurnActivated );
Events.PlayerTurnActivated.Add(OnPlayerTurnActivated);
end

Initialize();