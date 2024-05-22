Config = {}

Config.Professors = {
    {
        ped = 'a_m_m_business_01',
        coords = vector3(-1667.9, 190.13, 61.76),
        heading = 19.6,
        name = "Professor John Doe",
        subjects = {
            {
                name = "Mathematics",
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
        coords = vector3(-1040.99, -2732.03, 20.17),
        heading = 150.0,
        name = "Professor Jane Smith",
        subjects = {
            {
                name = "Physics",
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
