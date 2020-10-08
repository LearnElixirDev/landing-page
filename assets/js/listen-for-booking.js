const isCalendlyEvent = ({data: {event}}) => event && event.indexOf('calendly') === 0

export const listenForBooking = () => window.addEventListener( 'message', (e) => {
  if (isCalendlyEvent(e)) {
    console.log(e)
  }
})
