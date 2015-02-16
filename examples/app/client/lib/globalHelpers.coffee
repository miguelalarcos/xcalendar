UI.registerHelper 'formatDate', (date) ->
  mdate = moment(date)
  if mdate
    mdate.format('DD-MM-YYYY HH:mm')

UI.registerHelper 'formatDateMonthYear', (mdate) ->
  if mdate
    mdate.format('MMM-YYYY')

UI.registerHelper 'formatDateDay', (mdate) ->
  if mdate
    mdate.format('DD')