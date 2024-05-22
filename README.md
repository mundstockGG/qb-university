# 🎓 QB-Core University Script
This is a QB-Core script for a university learning and quiz system in FiveM. The script spawns professors as NPCs at specified locations, allowing players to interact with them to enroll in subjects, gather learning materials, and take final exams. The script uses ox_lib for menu interactions and qb-target for targeting NPCs.

## Features
* Configurable professors and subjects <br>
* Interaction with professors through a targeting system <br>
* Menu display for enrolling in subjects and taking final exams <br>
* Payment system for enrollment and exams <br>
* Dynamic exam handling with configurable questions and answers <br>
* Awarding of certificates upon passing exams <br>

## Installation
Clone the repository into your FiveM resources folder:
```sh
git clone https://github.com/mundstockGG/qb-university.git
```

Ensure the following dependencies are installed and started in your server.cfg:
```sh
ensure qb-core
ensure ox_lib
ensure qb-target
```

Add the resource to your server.cfg:
```sh
ensure qb-university
```

## Configuration
Edit the config.lua file to configure professors, their locations, and the subjects they teach. Each subject can have its own inscription fee, exam fee, and certificate item.

Example Configuration:
```lua
Config = {}

Config.Professors = {
    {
        ped = 'a_m_m_business_01',
        coords = vector3(-1038.99, -2734.03, 20.17),
        heading = 328.53,
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
```

## Usage
* Spawning Professors: The script automatically spawns professors at the specified coordinates when the resource starts.
* Interacting with Professors: Use the qb-target system to interact with professors. When near a professor, the interaction menu will appear.
* Menu Options: Each professor will have two options:
* Enroll in Subject: Pay the inscription fee to receive learning materials.
* Take Final Exam: Pay the exam fee (only available if enrolled) and take the exam.
* Exams: Answer the questions in the final exam. If you pass, you will receive a certificate item. If you fail, you will need to re-enroll and pay the fees again to retake the exam.

## Development
Feel free to fork this repository and make your own modifications. Pull requests are welcome!

## License
This project is licensed under the MIT License.

