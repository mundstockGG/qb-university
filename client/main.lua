local QBCore = exports['qb-core']:GetCoreObject()
local enrolledSubjects = {}

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
                    label = "Habla con " .. professor.name,
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
            title = "Inscribirse para " .. subject.name .. " ($" .. subject.inscriptionFee .. ")",
            description = "Paga la matrícula para el curso de" .. subject.name,
            action = function()
                TriggerServerEvent('qb-university:enroll', professorIndex, i)
            end
        })

        table.insert(elements, {
            title = "Tomar Exámen Final de " .. subject.name .. " ($" .. subject.examFee .. ")",
            description = "Paga el costo del exámen final de " .. subject.name,
            action = function()
                TriggerServerEvent('qb-university:requestExam', professorIndex, i)
            end,
            disabled = not (enrolledSubjects[professorIndex] and enrolledSubjects[professorIndex][i])
        })
    end

    if #elements == 0 then
        print("No elements added to the menu.")
    else
        for _, element in ipairs(elements) do
            print("Menu element added: " .. element.title)
        end
    end

    lib.registerContext({
        id = 'university_subjects',
        title = professor.name,
        options = elements
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
