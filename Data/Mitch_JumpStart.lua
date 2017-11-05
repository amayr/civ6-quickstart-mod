local iScout = GameInfo.Units["UNIT_SCOUT"].Index
local iSettler = GameInfo.Units["UNIT_SETTLER"].Index
local iBuilder = GameInfo.Units["UNIT_BUILDER"].Index


function OnPlayerTurnActivated(player, bIsFirstTime)

	local currentTurn = Game.GetCurrentGameTurn();
	local SpawnTurn = 0;
	local playerUnits;	
	local adjacentPlot;
	local unitPlot;

	if currentTurn == GameConfiguration.GetStartTurn() then
		local pPlayer = Players[player]
				
		if pPlayer:IsMajor() or pPlayer:isHuman() then
		
			-- search for the settler and use its location
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
				
				lastPlot = AddSettlers(lastPlot, playerUnits)
				lastPlot = AddBuilders(lastPlot, playerUnits)
				lastPlot = AddScouts(lastPlot, playerUnits)
			end
		
		end

	end
	
end

function AddSettlers(plot, playerUnits)
	local lastPlot = plot;
	local numberOf = 0;
		
	if GameConfiguration.GetValue("NumberOfAdditionalSettlers") and GameConfiguration.GetValue("NumberOfAdditionalSettlers") >= 0 then 
		numberOf = GameConfiguration.GetValue("NumberOfAdditionalSettlers")
	end
	
	if numberOf > 0 then
		for i = 1, numberOf do	
			for direction = 1, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
				--adjacentPlot = Map.GetAdjacentPlot(lastPlot:GetX(), lastPlot:GetY(), direction);
				adjacentPlot = lastPlot;
				if (adjacentPlot ~= nil) and not (adjacentPlot:IsWater() or adjacentPlot:IsImpassable()) then
					break		
				end
			end
			pUnit = playerUnits:Create(iSettler, adjacentPlot:GetX(), adjacentPlot:GetY())	
			lastPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
		end	
	end
	return lastPlot;
end

function AddBuilders(plot, playerUnits)
	local lastPlot = plot;
	local numberOf = 0;

	if GameConfiguration.GetValue("NumberOfAdditionalBuilders") and GameConfiguration.GetValue("NumberOfAdditionalBuilders") >= 0 then 
		numberOf = GameConfiguration.GetValue("NumberOfAdditionalBuilders")
	end

	if numberOf > 0 then
		 for i = 1, numberOf do
			for direction = 1, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
				--adjacentPlot = Map.GetAdjacentPlot(lastPlot:GetX(), lastPlot:GetY(), direction);
				adjacentPlot = lastPlot;
				if (adjacentPlot ~= nil) and not (adjacentPlot:IsWater() or adjacentPlot:IsImpassable()) then
					break		
				end
			end
			pUnit = playerUnits:Create(iBuilder, adjacentPlot:GetX(), adjacentPlot:GetY())
			lastPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
		end
	end
	return lastPlot;
end

function AddScouts(plot, playerUnits)
	local lastPlot = plot;
	local numberOf = 0;
	
	if GameConfiguration.GetValue("NumberOfAdditionalScouts") and GameConfiguration.GetValue("NumberOfAdditionalScouts") >= 0 then 
		numberOf = GameConfiguration.GetValue("NumberOfAdditionalScouts")
	end
	
    if numberOf > 0 then
        for i = 1, numberOf do
            for direction = 1, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
                --adjacentPlot = Map.GetAdjacentPlot(lastPlot:GetX(), lastPlot:GetY(), direction);
				adjacentPlot = lastPlot;
                if (adjacentPlot ~= nil) and not (adjacentPlot:IsWater() or adjacentPlot:IsImpassable()) then
                   break		
				end
			end
			pUnit = playerUnits:Create(iScout, adjacentPlot:GetX(), adjacentPlot:GetY())
			lastPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY());
        end
    end
	return lastPlot;
end

			

function Initialize()
    --Events.PlayerTurnActivated.Add(OnPlayerTurnActivated);
	GameEvents.PlayerTurnStarted.Add(OnPlayerTurnActivated);

    --Events.LocalPlayerChanged.Add(OnPlayerTurnActivated);
	--Events.LocalPlayerTurnBegin.Add(OnPlayerTurnActivated);
end

Initialize();
