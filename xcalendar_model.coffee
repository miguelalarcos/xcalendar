@xevent = new Meteor.Collection "Events"
@event_schema = new SimpleSchema
  date:
    type: Date
  text:
    type: String
  calendarId:
    type: String
  clienteId:
    type: String

xevent.attachSchema(event_schema)


