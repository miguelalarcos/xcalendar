xCalendar
=========

A simple and native calendar for Meteor.

Explanation
-----------

You have a demo [here](http://xcalendar.meteor.com). I would like to create a native Meteor and full calendar; help is welcome :)

This is the core template of xCalendar:
```html
<template name="xcalendarInner">
    {{#with top}}
        {{> xCalendarTop}}
    {{/with}}
    <table>
        {{#each head}}
            <th>{{> xCalendarHead}}</th>
        {{/each}}
        {{#each slot}}
            <tr>
                <td>{{> xCalendarLeft}}</td>
                {{#each day this}}
                    <td date="{{this}}" class="day-slot">
                        {{> xSlotTemplate}}
                    </td>
                {{/each}}
            </tr>
        {{/each}}
    </table>
    {{#each xevent this.calendarid}}
        <div class="xevent" _id="{{this._id}}" style="{{this.style}}">
            {{> xEventTemplate}}
        </div>
    {{/each}}
</template>
```

You have to implement the next templates ```xCalendarTop```, ```xCalendarHead```, ```xCalendarLeft```, ```xSlotTemplate``` and ```xEventTemplate```.

For example:

```html
<template name="xCalendarTop">
    {{>xCalendarButtonMinus}}
    {{>xCalendarButtonPlus}}
    {{>xCalendarButtonToday}}
    {{#if displayCancelReprogramming}}
        <a href="" id="cancelReprogramming">Cancel reprogramming</a>
    {{/if}}
    <span>
        <span class="title">{{this.calendar}}</span>
        <span><b>&nbsp;&nbsp;&nbsp;&nbsp;{{formatDateMonthYear this.date}}</b></span>
    </span>
</template>

<template name="xEventTemplate">
    <div class="patient-event">
        <b><a href="" class="delete-event" style="float: right">x</a></b>
        <span style="float: right">&nbsp;&nbsp;</span>
        <b><a href="" class="reprogramming-event" style="float: right">R</a></b>
        <div class="content-patient-event"><div><b>{{this.patient.nhc}}</b></div>{{this.patient.name}} {{this.patient.surname}}, {{sub this.text 25}}</div>
    </div>
    <div class="ui popup">
        <div class="header">{{this.patient.nhc}}, {{this.patient.name}}</div>
        <div class="content-popup">{{this.text}}</div>
    </div>
</template>
```

* ```xCalendarTop``` is passed *date* and *calendar* name.
* ```xCalendarHead``` is passed a moment object with the date of that day.
* ```xCalendarLeft``` is passed a text indicating the hour of the appointment, for example '08:30'
* ```xSlotTemplate``` is passed a moment object indicating the date of the slot
* ```xEventTemplate``` is passed the event object of the appointment.

You can use several templates already implemented:

```html
<template name="xCalendarButtonMinus">
    <button class="ui button" id="minusWeek"><i class="minus icon"></i></button>
</template>

<template name="xCalendarButtonPlus">
    <button class="ui button" id="plusWeek"><i class="plus icon"></i></button>
</template>

<template name="xCalendarButtonToday">
    <button class="ui button" id="xCalendarToday">Today</button>
</template>
```

You extend the event model with your additional fields thanks to ```xCalendar.attachEventSchema```. For example:

```coffee
xCalendar.attachEventSchema
  patientId:
    type: String
```

And this is to set the event helpers (you have to add the ```dburles:collection-helpers``` package):
```
xCalendar.setEventHelpers
  patient: ->
    patient.findOne(this.patientId)
```

Last, in server side you set the objects to retrieve with each event (you have to add the ```reywood:publish-composite``` package):

```coffee
xCalendar.publishWeekEvents [
  find: (event) -> patient.find event.patientId
  ]
```