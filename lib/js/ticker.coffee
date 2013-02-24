elementList = getElementsList()

class Context2d
  defaultColor = 'black'
  intermediateSpace = 3
  textPosition = { y: 18 }
  imagePosition = { y: 5 }

  defaultText = ->
    fontType: '15px Arial'
    fontColor: 'black'

  addMissingAttributes = (customText) ->
    text = defaultText()
    for key, value of customText
      text[key] = value
    text

  constructor: (id, initialPosition = 5) ->
    @canvas = document.getElementById(id)
    @context = @canvas.getContext('2d')
    @position = initialPosition

  incrementPosition: (object) ->
    @position += (object.width + intermediateSpace)

  fillText: (customText)->
    text = addMissingAttributes(customText)
    @context.font = text.fontType
    @context.fillStyle = text.fontColor
    @context.fillText text.value, @position, textPosition.y
    metrics = @context.measureText(text.value)
    @incrementPosition(metrics)

  fillPlainText: (text) ->
    @context.font = defaultText().fontType
    @context.fillText text, @position, textPosition.y

  addImage: (path) ->
    image = new Image()
    image.src = "assets/#{ path }"
    @context.drawImage(image, @position, imagePosition.y)
    @incrementPosition(image)

$ ->
  startPosition = 200
  wrappedContext = new Context2d('ticker-with-plain-text', startPosition)
  canvas = wrappedContext.canvas
  value = 'This is one large piece of long text which has no breaking parts in it. Its just text and nothing else. The more content that is aded, teh more crapier it gets. So lets get it on'

  addElements = (elements)->
    wrappedContext.fillPlainText(value)

  addElements elementList

  px = 1
  pos = startPosition

  textWidth = wrappedContext.context.measureText(value).width

  animate = ->
    if toggleTicker
      pos -= px
      
      # Erase the entire ticker so we can redraw the text at the new position
      wrappedContext.context.clearRect 0, 0, canvas.width, canvas.height
      
      # Draw the primary block at the current position
      wrappedContext.position = pos
      addElements elementList
        
      # When pos + textWidth becomes lesser than canvas width, the right side will be blank. Adding secondary block to right side here.
      # After this, everytime animate is called content will be added twice until pos is reset.
      if (pos + textWidth) < canvas.width
        wrappedContext.position = (pos + textWidth)
        addElements elementList
      
      # When the primary block has completely moved to left, pos is set to 0.
      # When elements are redrawn, the secondary block will be drawn from 0 onwards, making it now the primary block.
      if pos < -textWidth
        pos += textWidth
        funy = ->
          addElements elementList
        setTimeout funy, 1000

  toggleTicker = false
  fun = ->
    setInterval animate, 33

  setTimeout fun, 2000

  $('.ticker-with-plain-text').find('button').click ->
    toggleTicker = !toggleTicker
