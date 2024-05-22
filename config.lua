Config = {}

Config.Professors = {
    {
        ped = 'a_m_m_business_01',
        coords = vector3(-1667.9, 190.13, 60.86),
        heading = 19.6,
        name = "Profesor John Hammond",
        subjects = {
            {
                name = "Gestión de Transporte",
                inscriptionFee = 100,
                examFee = 50,
                certificateItem = "math_certificate",
                examQuestions = {
                    { question = "What is 2 + 2?", options = {"3", "4", "5"}, correct = 2 }
                }
            }
        }
    },
    {
        ped = 'a_f_m_bevhills_01',
        coords = vector3(-1573.95, 232.28, 57.85),
        heading = 31.81,
        name = "Profesora Brittney Barreto",
        subjects = {
            {
                name = "Aerodinámica del Vuelo",
                inscriptionFee = 150,
                examFee = 75,
                certificateItem = "physics_certificate",
                examQuestions = {
                    { question = "What is the speed of light?", options = {"300,000 km/s", "150,000 km/s", "450,000 km/s"}, correct = 1 }
                }
            }
        }
    }
}
