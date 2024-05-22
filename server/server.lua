local QBCore = exports['qb-core']:GetCoreObject()
local enrolledSubjects = {}

RegisterNetEvent('qb-university:enroll', function(professorIndex, subjectIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local professor = Config.Professors[professorIndex]
    local subject = professor.subjects[subjectIndex]
    
    if Player.Functions.RemoveMoney('cash', subject.inscriptionFee, 'University Enrollment') then
        if not enrolledSubjects[Player.PlayerData.citizenid] then
            enrolledSubjects[Player.PlayerData.citizenid] = {}
        end
        if not enrolledSubjects[Player.PlayerData.citizenid][professorIndex] then
            enrolledSubjects[Player.PlayerData.citizenid][professorIndex] = {}
        end
        enrolledSubjects[Player.PlayerData.citizenid][professorIndex][subjectIndex] = true
        TriggerClientEvent('qb-university:enrollSuccess', src, professorIndex, subjectIndex)
        TriggerClientEvent('QBCore:Notify', src, 'You have enrolled in ' .. subject.name, 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money for enrollment', 'error')
    end
end)

RegisterNetEvent('qb-university:requestExam', function(professorIndex, subjectIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local professor = Config.Professors[professorIndex]
    local subject = professor.subjects[subjectIndex]
    local playerId = Player.PlayerData.citizenid

    if enrolledSubjects[playerId] and enrolledSubjects[playerId][professorIndex] and enrolledSubjects[playerId][professorIndex][subjectIndex] then
        if Player.Functions.RemoveMoney('cash', subject.examFee, 'University Exam') then
            TriggerClientEvent('qb-university:takeExam', src, professorIndex, subjectIndex)
        else
            TriggerClientEvent('qb-university:examRequestFailed', src, 'Not enough money for the exam')
        end
    else
        TriggerClientEvent('qb-university:examRequestFailed', src, 'You are not enrolled in this subject')
    end
end)

RegisterNetEvent('qb-university:passExam', function(professorIndex, subjectIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local professor = Config.Professors[professorIndex]
    local subject = professor.subjects[subjectIndex]

    Player.Functions.AddItem(subject.certificateItem, 1)
    TriggerClientEvent('QBCore:Notify', src, 'You have passed the exam and received your certificate!', 'success')
end)

RegisterNetEvent('qb-university:failExam', function(professorIndex, subjectIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    TriggerClientEvent('QBCore:Notify', src, 'You have failed the exam. Please try again.', 'error')
end)
