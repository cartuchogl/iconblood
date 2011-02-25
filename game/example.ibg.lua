_local_game = {
  id = 10,
  environment = 1,
  level = 1,
  you_id = 1,
  squadrons = {
    {
      id = 13,
      name = "Nightmare Blood",
      player = {
        id = 1,
        alias = 'Player 1',
        email = "mail@example.com"
      },
      units = {
        {
          id = 2,
          position = { 0.06+0.4, 0.02+0.4 },
          exp = 13,
          level = 2,
          name = 'Steve Jobs.',
          name_unit = '003',
          faction_name = 'humans',
          cost = 1850,
          move = 20,
          force = 3,
          skill = 3,
          resistance = 3, --Porcentaje. 3 es 30 de vida
          intelligence = 3,
          agility = 3,
          primary = {
            id = 3,
            name = 'AK-45',
            cost = 250,
            damage = "10+2d6",
            clip = 32,
            total = 120,
            vshort = 10,
            vshort_bonus = 3,
            vshort_damage = '+1d6',
            short = 25,
            short_bonus = 1,
            short_damage = '+1d8',
            long = 60,
            long_bonus = 0,
            long_damage = 0,
            vlong = 90,
            vlong_bonus = -2,
            vlong_damage = '-1d4'
          },
          secondary = {
            id = 4,
            name = 'M1911 MEU',
            cost = 70,
            damage = "6+1d6",
            clip = 1,
            total = 2,
            vshort = 10,
            vshort_bonus = 5,
            vshort_damage = "+1d8",
            short = 25,
            short_bonus = 1,
            short_damage = "+1d4",
            long = 60,
            long_bonus = -2,
            long_damage = "-1d6",
            vlong = 90,
            vlong_bonus = -6,
            vlong_damage = "-1d10"
          },
          characteristics = {
            {name='runner',level=1}
          },
          habilities = {
            {name='run',level=1}
          },
          equip = {
            {name='bulletproof'}
          }
        },
        {
          id = 3,
          position = { 0.02+0.4, 0.02+0.4 },
          exp = 13,
          level = 2,
          name = 'John Romero',
          name_unit = '002',
          faction_name = 'humans',
          cost = 1250,
          move = 20,
          force = 3,
          skill = 3,
          resistance = 3,
          intelligence = 3,
          agility = 3,
          primary = {
            id = 3,
            name = 'AK-45',
            cost = 250,
            damage = "10+2d6",
            clip = 32,
            total = 120,
            vshort = 10,
            vshort_bonus = 3,
            vshort_damage = '+1d6',
            short = 25,
            short_bonus = 1,
            short_damage = '+1d8',
            long = 60,
            long_bonus = 0,
            long_damage = 0,
            vlong = 90,
            vlong_bonus = -2,
            vlong_damage = '-1d4'
          },
          secondary = {
            id = 4,
            name = 'M1911 MEU',
            cost = 70,
            damage = "6+1d6",
            clip = 1,
            total = 2,
            vshort = 10,
            vshort_bonus = 5,
            vshort_damage = "+1d8",
            short = 25,
            short_bonus = 1,
            short_damage = "+1d4",
            long = 60,
            long_bonus = -2,
            long_damage = "-1d6",
            vlong = 90,
            vlong_bonus = -6,
            vlong_damage = "-1d10"
          },
          characteristics = {
            {name='runner',level=1}
          },
          habilities = {
            {name='run',level=1}
          },
          equip = {
            {name='bulletproof'}
          }
        },
        {
          id = 4,
          position = { 0.02+0.4, -0.02+0.4 },
          exp = 13,
          level = 1,
          name = 'Mario Bros',
          name_unit = '003',
          faction_name = 'humans',
          cost = 1150,
          move = 12,
          force = 3,
          skill = 3,
          resistance = 3,
          intelligence = 3,
          agility = 3,
          primary = {
            id = 3,
            name = 'AK-45',
            cost = 250,
            damage = "10+2d6",
            clip = 32,
            total = 120,
            vshort = 10,
            vshort_bonus = 3,
            vshort_damage = '+1d6',
            short = 25,
            short_bonus = 1,
            short_damage = '+1d8',
            long = 60,
            long_bonus = 0,
            long_damage = 0,
            vlong = 90,
            vlong_bonus = -2,
            vlong_damage = '-1d4'
          },
          secondary = {
            id = 4,
            name = 'M1911 MEU',
            cost = 70,
            damage = "6+1d6",
            clip = 1,
            total = 2,
            vshort = 10,
            vshort_bonus = 5,
            vshort_damage = "+1d8",
            short = 25,
            short_bonus = 1,
            short_damage = "+1d4",
            long = 60,
            long_bonus = -2,
            long_damage = "-1d6",
            vlong = 90,
            vlong_bonus = -6,
            vlong_damage = "-1d10"
          },
          characteristics = {
            {name='runner',level=1}
          },
          habilities = {
            {name='run',level=1}
          },
          equip = {
            {name='bulletproof'}
          }
        },
        {
          id = 5,
          position = { 0.06+0.4, -0.02+0.4 },
          exp = 13,
          level = 1,
          name = 'Mark Zuckerberg',
          name_unit = '003',
          faction_name = 'humans',
          cost = 1000,
          move = 12,
          force = 3,
          skill = 3,
          resistance = 3,
          intelligence = 3,
          agility = 3,
          primary = {
            id = 3,
            name = 'AK-45',
            cost = 250,
            damage = "10+2d6",
            clip = 32,
            total = 120,
            vshort = 10,
            vshort_bonus = 3,
            vshort_damage = '+1d6',
            short = 25,
            short_bonus = 1,
            short_damage = '+1d8',
            long = 60,
            long_bonus = 0,
            long_damage = 0,
            vlong = 90,
            vlong_bonus = -2,
            vlong_damage = '-1d4'
          },
          secondary = {
            id = 4,
            name = 'M1911 MEU',
            cost = 70,
            damage = "6+1d6",
            clip = 1,
            total = 2,
            vshort = 10,
            vshort_bonus = 5,
            vshort_damage = "+1d8",
            short = 25,
            short_bonus = 1,
            short_damage = "+1d4",
            long = 60,
            long_bonus = -2,
            long_damage = "-1d6",
            vlong = 90,
            vlong_bonus = -6,
            vlong_damage = "-1d10"
          },
          characteristics = {
            {name='runner',level=1}
          },
          habilities = {
            {name='run',level=1}
          },
          equip = {
            {name='bulletproof'}
          }
        }  ,
          {
            id = 6,
            position = { 0.04+0.4, 0.0+0.4 },
            exp = 13,
            level = 1,
            name = 'Mourinho',
            name_unit = '001',
            faction_name = 'humans',
            cost = 1300,
            move = 10,
            force = 3,
            skill = 3,
            resistance = 4,
            intelligence = 3,
            agility = 3,
            primary = {
              id = 3,
              name = 'AK-45',
              cost = 50,
              damage = "10+2d6",
              clip = 32,
              total = 120,
              vshort = 10,
              vshort_bonus = 0,
              vshort_damage = 0,
              short = 30,
              short_bonus = 1,
              short_damage = 0,
              long = 60,
              long_bonus = 1,
              long_damage = 0,
              vlong = 90,
              vlong_bonus = -2,
              vlong_damage = "-1d4"
            },
            secondary = {
              id = 4,
              name = 'M1911 MEU',
              cost = 70,
              damage = "6+1d6",
              clip = 1,
              total = 2,
              vshort = 10,
              vshort_bonus = 5,
              vshort_damage = "+1d8",
              short = 25,
              short_bonus = 1,
              short_damage = "+1d4",
              long = 60,
              long_bonus = -2,
              long_damage = "-1d6",
              vlong = 90,
              vlong_bonus = -6,
              vlong_damage = "-1d10"
            },
            characteristics = {
              {name='runner',level=1}
            },
            habilities = {
              {name='run',level=1}
            },
            equip = {
              {name='bulletproof'}
            }
          }
        
      }},
      
      {
        id = 132,
        name = "Player 2",
        player = {
          id = 2,
          alias = 'Player 2',
          email = "mail@example.com"
        },
        units = {
          {
            id = 12,
            position = { 0.00-0.35, 0.02-0.35 },
            exp = 13,
            level = 3,
            name = 'Bill Gates',
            name_unit = '003',
            faction_name = 'humans',
            cost = 2250,
            move = 20,
            force = 3,
            skill = 3,
            resistance = 3,
            intelligence = 3,
            agility = 3,
            primary = {
              id = 1,
              name = 'M16',
              cost = 450,
              damage = "10+2d6",
              clip = 32,
              total = 120,
              vshort = 10,
              vshort_bonus = 0,
              vshort_damage = 0,
              short = 30,
              short_bonus = 1,
              short_damage = 0,
              long = 60,
              long_bonus = 1,
              long_damage = 0,
              vlong = 90,
              vlong_bonus = -2,
              vlong_damage = "-1d4"
            },
            secondary = {
              id = 2,
              name = 'Desert Eagle SE',
              cost = 120,
              damage = "6+1d6",
              clip = 1,
              total = 2,
              vshort = 10,
              vshort_bonus = 5,
              vshort_damage = "+1d8",
              short = 25,
              short_bonus = 1,
              short_damage = "+1d4",
              long = 60,
              long_bonus = -2,
              long_damage = "-1d6",
              vlong = 90,
              vlong_bonus = -6,
              vlong_damage = "-1d10"
            },
            characteristics = {
              {name='runner',level=1}
            },
            habilities = {
              {name='run',level=1}
            },
            equip = {
              {name='bulletproof'}
            }
          },
          {
            id = 13,
            position = { -0.04-0.35, 0.02-0.35 },
            exp = 13,
            level = 1,
            name = 'Sonic',
            name_unit = '001',
            faction_name = 'humans',
            cost = 2000,
            move = 20,
            force = 3,
            skill = 3,
            resistance = 3,
            intelligence = 3,
            agility = 3,
            primary = {
              id = 1,
              name = 'M16',
              cost = 450,
              damage = "10+2d6",
              clip = 32,
              total = 120,
              vshort = 10,
              vshort_bonus = 0,
              vshort_damage = 0,
              short = 30,
              short_bonus = 1,
              short_damage = 0,
              long = 60,
              long_bonus = 1,
              long_damage = 0,
              vlong = 90,
              vlong_bonus = -2,
              vlong_damage = "-1d4"
            },
            secondary = {
              id = 2,
              name = 'Desert Eagle SE',
              cost = 120,
              damage = "6+1d6",
              clip = 1,
              total = 2,
              vshort = 10,
              vshort_bonus = 5,
              vshort_damage = "+1d8",
              short = 25,
              short_bonus = 1,
              short_damage = "+1d4",
              long = 60,
              long_bonus = -2,
              long_damage = "-1d6",
              vlong = 90,
              vlong_bonus = -6,
              vlong_damage = "-1d10"
            },
            characteristics = {
              {name='runner',level=1}
            },
            habilities = {
              {name='run',level=1}
            },
            equip = {
              {name='bulletproof'}
            }
          },
          {
            id = 14,
            position = { -0.04-0.35, -0.02-0.35 },
            exp = 13,
            level = 1,
            name = 'John Carmack',
            name_unit = '001',
            faction_name = 'humans',
            cost = 1500,
            move = 12,
            force = 3,
            skill = 3,
            resistance = 3,
            intelligence = 3,
            agility = 3,
            primary = {
              id = 1,
              name = 'M16',
              cost = 450,
              damage = "10+2d6",
              clip = 32,
              total = 120,
              vshort = 10,
              vshort_bonus = 0,
              vshort_damage = 0,
              short = 30,
              short_bonus = 1,
              short_damage = 0,
              long = 60,
              long_bonus = 1,
              long_damage = 0,
              vlong = 90,
              vlong_bonus = -2,
              vlong_damage = "-1d4"
            },
            secondary = {
              id = 2,
              name = 'Desert Eagle SE',
              cost = 120,
              damage = "6+1d6",
              clip = 1,
              total = 2,
              vshort = 10,
              vshort_bonus = 5,
              vshort_damage = "+1d8",
              short = 25,
              short_bonus = 1,
              short_damage = "+1d4",
              long = 60,
              long_bonus = -2,
              long_damage = "-1d6",
              vlong = 90,
              vlong_bonus = -6,
              vlong_damage = "-1d10"
            },
            characteristics = {
              {name='runner',level=1}
            },
            habilities = {
              {name='run',level=1}
            },
            equip = {
              {name='bulletproof'}
            }
          },
          {
            id = 15,
            position = { 0.0-0.35, -0.02-0.35 },
            exp = 13,
            level = 2,
            name = 'Pep Guardiola',
            name_unit = '002',
            faction_name = 'humans',
            cost = 1400,
            move = 12,
            force = 3,
            skill = 3,
            resistance = 3,
            intelligence = 3,
            agility = 3,
            primary = {
              id = 1,
              name = 'M16',
              cost = 450,
              damage = "10+2d6",
              clip = 32,
              total = 120,
              vshort = 10,
              vshort_bonus = 0,
              vshort_damage = 0,
              short = 30,
              short_bonus = 1,
              short_damage = 0,
              long = 60,
              long_bonus = 1,
              long_damage = 0,
              vlong = 90,
              vlong_bonus = -2,
              vlong_damage = "-1d4"
            },
            secondary = {
              id = 2,
              name = 'Desert Eagle SE',
              cost = 120,
              damage = "6+1d6",
              clip = 1,
              total = 2,
              vshort = 10,
              vshort_bonus = 5,
              vshort_damage = "+1d8",
              short = 25,
              short_bonus = 1,
              short_damage = "+1d4",
              long = 60,
              long_bonus = -2,
              long_damage = "-1d6",
              vlong = 90,
              vlong_bonus = -6,
              vlong_damage = "-1d10"
            },
            characteristics = {
              {name='runner',level=1}
            },
            habilities = {
              {name='run',level=1}
            },
            equip = {
              {name='bulletproof'}
            }
          },
          {
            id = 16,
            position = { -0.02-0.35, 0.0-0.35 },
            exp = 13,
            level = 1,
            name = 'Linus Torvalds',
            name_unit = '003',
            faction_name = 'humans',
            cost = 1750,
            move = 10,
            force = 3,
            skill = 3,
            resistance = 4,
            intelligence = 3,
            agility = 3,
            primary = {
              id = 1,
              name = 'M16',
              cost = 450,
              damage = "10+2d6",
              clip = 32,
              total = 120,
              vshort = 10,
              vshort_bonus = 0,
              vshort_damage = 0,
              short = 30,
              short_bonus = 1,
              short_damage = 0,
              long = 60,
              long_bonus = 1,
              long_damage = 0,
              vlong = 90,
              vlong_bonus = -2,
              vlong_damage = "-1d4"
            },
            secondary = {
              id = 2,
              name = 'Desert Eagle SE',
              cost = 120,
              damage = "6+1d6",
              clip = 1,
              total = 2,
              vshort = 10,
              vshort_bonus = 5,
              vshort_damage = "+1d8",
              short = 25,
              short_bonus = 1,
              short_damage = "+1d4",
              long = 60,
              long_bonus = -2,
              long_damage = "-1d6",
              vlong = 90,
              vlong_bonus = -6,
              vlong_damage = "-1d10"
            },
            characteristics = {
              {name='runner',level=1}
            },
            habilities = {
              {name='run',level=1}
            },
            equip = {
              {name='bulletproof'}
            }
          }

        }
      }
        
        
    }
  }
