local QBCore = exports['qb-core']:GetCoreObject()

local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

CreateThread(function()
    for index, professor in ipairs(Config.Professors) do
        local pedModel = GetHashKey(professor.ped)
        
        loadModel(pedModel)
        
        local ped = CreatePed(4, pedModel, professor.coords.x, professor.coords.y, professor.coords.z, professor.heading, false, true)
        
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        print("Spawned professor: " .. professor.name .. " at coordinates: " .. tostring(professor.coords))
        
        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    type = "client",
                    event = "qb-university:openMenu",
                    icon = "fas fa-graduation-cap",
                    label = "Talk to " .. professor.name,
                    professorIndex = index
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent('qb-university:openMenu', function(data)
    local professorIndex = data.professorIndex
    local professor = Config.Professors[professorIndex]
    local elements = {}

    for i, subject in ipairs(professor.subjects) do
        table.insert(elements, {label = subject.name, value = i})
    end

    lib.registerContext({
        id = 'university_subjects',
        title = professor.name,
        options = elements,
        onSelect = function(option)
            local subject = professor.subjects[option.value]
            TriggerServerEvent('qb-university:enroll', professorIndex, option.value)
        end
    })

    lib.showContext('university_subjects')
end)

RegisterNetEvent('qb-university:takeExam', function(professorIndex, subjectIndex)
    local professor = Config.Professors[professorIndex]
    local subject = professor.subjects[subjectIndex]
    local exam = {
        -- Define the exam questions and options here
    }

    table.insert(exam, {question = "What is 2 + 2?", options = {"3", "4", "5"}, correct = 2})

    lib.registerContext({
        id = 'university_exam',
        title = 'Final Exam - ' .. subject.name,
        options = exam,
        onSelect = function(option)
            if option.value == exam.correct then
                TriggerServerEvent('qb-university:passExam', professorIndex, subjectIndex)
            else
                TriggerServerEvent('qb-university:failExam', professorIndex, subjectIndex)
            end
        end
    })

    lib.showContext('university_exam')
end)
