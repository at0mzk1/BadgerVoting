--------------------
--- BadgerVoting ---
--------------------

voteOptions = {}
voteNames = {}
voteInProgress = false
prefix = '^6[^5Votaciones Presidenciales^6]^r '
numChoices = 0;
RegisterCommand('startVote', function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, "Elecciones.Commands.startVote") then 
		-- Can start one
		if not voteInProgress then 
			voteOptions = {}
			voteNames = {}
			numChoices = 0;
			votedAlready = {}
			-- No current vote in progress, they can start one
			-- /startVote <seconds> <options>
			-- /startVote 30 Los-Santos Sandy-Shores Grapeseed
			if #args > 2 then 
				if tonumber(args[1]) ~= nil then 
					-- It's a number of seconds for voting
					local secs = tonumber(args[1]);
					voteInProgress = true;
					TriggerClientEvent('chatMessage', -1, prefix .. '^3Las votaciones presidenciales han iniciado. Las votaciones estaran activas por ^18 ^3horas para elegir el nuevo presidente.')
					for i=2, #args do 
						TriggerClientEvent('chatMessage', -1, '^6[^7' .. args[i] .. '^6]^3: /vote ' .. (i - 1))
						numChoices = numChoices + 1;
						voteOptions[(i - 1)] = 0;
						voteNames[(i - 1)] = args[i];
					end
					Wait(secs * 1000);
					local highestVoteCount = voteOptions[1]
					local highestVoteName = voteNames[1]
					for i=1, numChoices do 
						if voteOptions[i] > highestVoteCount then 
							highestVoteCount = voteOptions[i]
							highestVoteName = voteNames[i]
						end
					end
					TriggerClientEvent('chatMessage', -1, prefix .. 
						'^3Las votaciones han terminado, el nuevo presidente es ^1' .. highestVoteName .. ' ^3con un total de ^1' .. highestVoteCount .. ' ^3votos')
					voteInProgress = false;
				else 
					-- Not a valid number supplied
					sendMsg(source, '^1ERROR: Esa opcion de voto no es valida.')
				end
			else 
				-- Not enough arguments, need at least 2 choices
				sendMsg(source, '^1ERROR: Debes poner como minimo 2 opciones... /startVote <segundos> Presidente1 Presidente2')
			end
		end
	end
end)

function sendMsg(src, msg) 
	TriggerClientEvent('chatMessage', src, prefix .. msg);
end
function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
votedAlready = {}
RegisterCommand('vote', function(source, args, rawCommand)
	if voteInProgress then 
		if not has_value(votedAlready, source) then 
			if #args > 0 then 
				if tonumber(args[1]) ~= nil then 
					-- It's a number 
					voteOptions[tonumber(args[1])] = voteOptions[tonumber(args[1])] + 1;
					sendMsg(source, '^3El voto ha sido depositado con exito :)')
					table.insert(votedAlready, source);
				else 
					-- It's not a number 
					sendMsg(source, '^1ERROR: Esa opcion de voto es invalida.')
				end
			else
				-- They did not supply enough arguments 
				sendMsg(source, '^1ERROR: Debes poner una opcion: /vote <id>')
			end
		else 
			-- Already voted 
			sendMsg(source, '^1ERROR: Ya votaste tigueraso ;)')
		end
	else 
		-- There is no vote in progress 
		sendMsg(source, '^1ERROR: No hay votacion en progreso actualmente :(')
	end
end)