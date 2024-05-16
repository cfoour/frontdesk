Config = {}
Config.Dispatch = 'ps-dispatch' -- 'default' / 'ps-dispatch' / 'cd_dispatch'
Config.PoliceRequired = 1       -- How many PD Officers Required to request
Config.Cooldown = 3             -- Server cooldown for alerts ( Set in minutes )

Config.Locations = {
    police = {                                     -- Set this to the name of the job
        Required = 0,                                  -- How many players with this job are required to be online to make a request/alert
        zone = {                                       -- Polyzone Info
            name = 'Police front desk',                -- Name of the menu title
            coords = vec3(-351.34, -254.62, 35.07), -- Boxzone Coords
            heading = 98.7,                            -- Boxzone Heading
        },
        Menu = { -- Menu Info ( Set title, description, icon, event, and Event Type )
            [1] = { title = 'Assistance', description = 'Front desk support aid', icon = 'fas fa-hand', event = 'frontdesk:client:RequestAssistance', Args = 'assistance' },
            [2] = { title = 'Weapon License', description = 'Permission for firearms.', icon = 'fas fa-gun', event = 'frontdesk:client:RequestAssistance', Args = 'weaponlicense' },
            [3] = { title = 'Interview', description = 'Managerial oversight assistance', icon = 'fas fa-book-open', event = 'frontdesk:client:RequestAssistance', Args = 'interview' },
            [4] = { title = 'Supervisor', description = 'Applicant evaluation dialogues', icon = 'fas fa-crown', event = 'frontdesk:client:RequestAssistance', Args = 'supervisor' },
        }
    },

    ambulance = {
        Required = 0,
        zone = {
            name = 'Pillbox Front Desk',
            coords = vec3(310.898, -586.076, 42.267),
            heading = 167.80,
        },
        Menu = {
            [1] = { title = 'Assistance', description = '', icon = 'fas fa-hand', event = 'frontdesk:client:RequestAssistance', Args = 'assistance' },
            [2] = { title = 'Interview', description = '', icon = 'fas fa-book-open', event = 'frontdesk:client:RequestAssistance', Args = 'interview' },
            [3] = { title = 'Supervisor', description = '', icon = 'fas fa-crown', event = 'frontdesk:client:RequestAssistance', Args = 'supervisor' },
        }
    }
}
