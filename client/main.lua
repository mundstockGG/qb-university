local QBCore = exports['qb-core']:GetCoreObject()
local enrolledSubjects = {}

-- Function to load model
local function loadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
end

-- Spawn professors
CreateThread(function()
    for index, professor in ipairs(Config.Professors) do
        local pedModel = GetHashKey(professor.ped)
        
        -- Load the ped model
        loadModel(pedModel)
        
        -- Create the ped
        local ped = CreatePed(4, pedModel, professor.coords.x, professor.coords.y, professor.coords.z, professor.heading, false, true)
        
        -- Set ped properties
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        
        -- Print debug message
        print("Spawned professor: " .. professor.name .. " at coordinates: " .. tostring(professor.coords))
        
        -- Add target functionality using qb-target
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
        table.insert(elements, {
            label = "Enroll in " .. subject.name .. " ($" .. subject.inscriptionFee .. ")",
            value = i,
            action = "enroll"
        })
        
        table.insert(elements, {
            label = "Take Final Exam in " .. subject.name .. " ($" .. subject.examFee .. ")",
            value = i,
            action = "exam",
            disabled = not enrolledSubjects[professorIndex] or not enrolledSubjects[professorIndex][i]
        })
    end

    lib.registerContext({
        id = 'university_subjects',
        title = professor.name,
        options = elements,
        onSelect = function(option)
            if option.action == "enroll" then
                TriggerServerEvent('qb-university:enroll', professorIndex, option.value)
            elseif option.action == "exam" then
                TriggerServerEvent('qb-university:requestExam', professorIndex, option.value)
            end
        end
    })

    lib.showContext('university_subjects')
end)

RegisterNetEvent('qb-university:takeExam', function(professorIndex, subjectIndex)
    local professor = Config.Professors[professorIndex]
    local subject = professor.subjects[subjectIndex]
    local exam = subject.examQuestions

    lib.registerContext({
        id = 'university_exam',
        title = 'Final Exam - ' .. subject.name,
        options = {},
        onSelect = function(option)
            if option.value == exam.correct then
                TriggerServerEvent('qb-university:passExam', professorIndex, subjectIndex)
            else
                TriggerServerEvent('qb-university:failExam', professorIndex, subjectIndex)
            end
        end
    })

    for _, question in ipairs(exam) do
        table.insert(lib.contexts['university_exam'].options, {
            label = question.question,
            value = question.correct,
            options = question.options
        })
    end

    lib.showContext('university_exam')
end)

RegisterNetEvent('qb-university:enrollSuccess', function(professorIndex, subjectIndex)
    if not enrolledSubjects[professorIndex] then
        enrolledSubjects[professorIndex] = {}
    end
    enrolledSubjects[professorIndex][subjectIndex] = true
    QBCore.Functions.Notify("You have successfully enrolled in the subject.", "success")
end)

RegisterNetEvent('qb-university:examRequestFailed', function(message)
    QBCore.Functions.Notify(message, "error")
end)
