#xevent.remove({})

if patient.find().count() == 0
  patient.insert
    nhc: '1234'
    name: 'Miguel'
    surname: 'Alarcos'

  patient.insert
    nhc: '5678'
    name: 'María'
    surname: 'Hidalgo'

if xcalendar.find().count() == 0
  xcalendar.insert
    name: 'calendar01'
    slotIni: '09:00'
    slotEnd: '12:00'
    duration: 30