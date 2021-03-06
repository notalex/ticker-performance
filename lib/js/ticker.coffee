class ContextCreator
  textPosition = { y: 18 }
  imagePosition = { y: 5 }

  constructor: (id, initialPosition = 5) ->
    @canvas = document.getElementById(id)
    @context = @canvas.getContext('2d')
    @context.font = '15px Arial'
    @position = initialPosition

  fillPlainText: (text) ->
    @context.fillText text, @position, textPosition.y

$ ->
  index = 0
  startPosition = 800
  wrappedContext = new ContextCreator('ticker-with-plain-text', startPosition)
  canvas = wrappedContext.canvas
  currentPosition = startPosition
  message = ''
  toggleTicker = false

  refreshMessageList = ->
    msg = ''
    for i in [index..(index + 14)]
      msg += "AAPL +5#{ i } "
    #index += 10
    message = msg

  addElements = ->
    wrappedContext.fillPlainText(message)

  refreshMessageList()
  addElements()
  textWidth = wrappedContext.context.measureText(message).width

  animate = ->
    if toggleTicker
      currentPosition -= 1
      
      # Erase the entire ticker so we can redraw the text at the new position
      wrappedContext.context.clearRect 0, 0, canvas.width, canvas.height
      
      # Draw the primary block at the current position
      wrappedContext.position = currentPosition
      addElements()
        
      # When currentPosition + textWidth becomes lesser than canvas width, the right side will be blank. Adding secondary block to right side here.
      # After this, everytime animate is called content will be added twice until currentPosition is reset.
      if (currentPosition + textWidth) < canvas.width
        wrappedContext.position = (currentPosition + textWidth)
        addElements()
      
      # When the primary block has completely moved to left, currentPosition is set to 0.
      # When elements are redrawn, the secondary block will be drawn from 0 onwards, making it now the primary block.
      if currentPosition < -textWidth
        currentPosition += textWidth
        refreshMessageList()

  delayedAnimation = ->
    setInterval animate, 33

  setTimeout delayedAnimation, 2000

  $('.ticker-with-plain-text').find('button').click ->
    toggleTicker = !toggleTicker
