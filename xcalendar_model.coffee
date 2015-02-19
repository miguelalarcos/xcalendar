@xevent = new Meteor.Collection "xEvents"
basicEventSchema =
  date:
    type: Date
  calendarId:
    type: String

xCalendar.attachEventSchema = (schema) ->
  _.extend(schema, basicEventSchema)
  xevent.attachSchema(schema)

xCalendar.setEventHelpers = (helpers) ->
  xevent.helpers helpers

@xcalendar = new Meteor.Collection "xCalendar"
xCalendarSchema = new SimpleSchema
  name:
    type: String
  slotIni:
    type: String
    regEx: /^(00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23):[0-5][0-9]$/
  slotEnd:
    type: String
    regEx: /^(00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23):[0-5][0-9]$/
  duration:
    type: Number
  days:
    type: [Number]

xcalendar.attachSchema(xCalendarSchema)
