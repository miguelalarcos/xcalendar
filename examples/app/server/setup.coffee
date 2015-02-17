if patient.find().count() == 0
  patient.insert
    nhc: '1234'
    name: 'Miguel'
    surname: 'Alarcos'

  patient.insert
    nhc: '5678'
    name: 'María'
    surname: 'Hidalgo'

xcalendar.remove({})
if xcalendar.find().count() == 0
  xcalendar.insert
    name: 'calendar01'
    slotIni: '09:00'
    slotEnd: '12:00'
    duration: 30
    days: [1,2,4,5]

  xcalendar.insert
    name: 'calendar02'
    slotIni: '09:00'
    slotEnd: '15:00'
    duration: 60
    days: [0,1,2,3,4,5,6]