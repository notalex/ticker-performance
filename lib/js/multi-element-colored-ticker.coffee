elementsList = getElementsList()

class ContextCreator
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
    @context.font = '15px Arial'
    @position = initialPosition

  incrementPosition: (object) ->
    @position += (object.width + intermediateSpace)

  fillText: (text)->
    @context.fillText text.value, @position, textPosition.y
    metrics = @context.measureText(text.value)
    @incrementPosition(metrics)

  fillPlainText: (text) ->
    @context.fillText text, @position, textPosition.y

  addImage: (path) ->
    image = new Image()
    image.src = "assets/#{ path }"
    @context.drawImage(image, @position, imagePosition.y)
    @incrementPosition(image)

$ ->
  index = 0
  startPosition = 800
  wrappedContext = new ContextCreator('multi-element-colored-ticker', startPosition)
  canvas = wrappedContext.canvas
  currentPosition = startPosition
  toggleTicker = false

  addElements = ->
    for element in elementsList
      wrappedContext.fillText({ value: element.value1 })
      wrappedContext.addImage("#{ element.imageType }-arrow.png")
      wrappedContext.fillText
        value: element.value2
      wrappedContext.fillText
        value: element.value3
      wrappedContext.position += 5

  addElements()
  textWidth = wrappedContext.position

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

  delayedAnimation = ->
    setInterval animate, 33

  setTimeout delayedAnimation, 2000

  $('.multi-element-colored-ticker').find('button').click ->
    toggleTicker = !toggleTicker
