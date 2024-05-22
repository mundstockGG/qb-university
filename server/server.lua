local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-university:enroll', function(professorIndex, subjectIndex)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local professor = Config.Professors[professorIndex]
    local subject = professor.subjects[subjectIndex]
    
    if Player.Functions.RemoveMoney('cash', subject.inscriptionFee, 'University Enrollment') then
        TriggerClientEvent('QBCore:Notify', src, 'You have enrolled in ' .. subject.name, 'success')
        TriggerClientEvent('qb-university:takeExam', src, professorIndex, subjectIndex)
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough money for enrollment', 'error')
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
