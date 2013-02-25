elementsList = getElementsList()

class ContextCreator
  defaultColor = 'black'
  intermediateSpace = 3
  textPosition = { y: 18 }
  imagePosition = { y: 5 }

  defaultText = ->
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

  fillText: (customText)->
    text = addMissingAttributes(customText)
    @context.fillStyle = text.fontColor
    @context.fillText text.value, @position, textPosition.y
    metrics = @context.measureText(text.value)
    @incrementPosition(metrics)

  addUnicode: (unicode) ->
    @context.fillStyle = 'darkBlue'
    @context.fillText unicode, @position, textPosition.y
    @incrementPosition({ width: 13 })

$ ->
  index = 0
  startPosition = 100
  wrappedContext = new ContextCreator('ticker-using-hidden-canvas-image', startPosition)
  context = wrappedContext.context
  canvas = wrappedContext.canvas
  currentPosition = startPosition
  toggleTicker = false
  secondaryImageData = ''
  addSecondaryData = true

  hiddenContext = new ContextCreator('hidden-canvas', 0)

  addElements = ->
    while hiddenContext.position < (hiddenContext.canvas.width - 100)
      element = elementsList.shift()
      hiddenContext.fillText({ value: element.value1 })
      hiddenContext.addUnicode(element.unicode)
      hiddenContext.fillText
        value: element.value2
        fontColor: 'red'
      hiddenContext.fillText
        value: element.value3
        fontColor: 'darkRed'
      hiddenContext.position += 5

  addElements()
  primaryBlockWidth = hiddenContext.position
  secondaryBlockWidth = hiddenContext.position
  primaryImageData = hiddenContext.context.getImageData(0, 0, primaryBlockWidth, canvas.height)

  addMoreElements = ->
    if addSecondaryData
      hiddenContext.context.clearRect 0, 0, hiddenContext.canvas.width, canvas.height
      hiddenContext.position = 0

      addElements()
      secondaryBlockWidth = hiddenContext.position
      secondaryImageData = hiddenContext.context.getImageData(0, 0, secondaryBlockWidth, canvas.height)

      addSecondaryData = false

  changeSecondaryToPrimary = ->
    primaryImageData = secondaryImageData
    primaryBlockWidth = secondaryBlockWidth

  animate =  ->
    if toggleTicker
      currentPosition -= 1

      wrappedContext.context.clearRect 0, 0, canvas.width, canvas.height
      context.putImageData(primaryImageData, currentPosition, 0)

      # When currentPosition + primaryBlockWidth becomes lesser than canvas width, the right side will be blank. Adding secondary block to right side here.
      # After this, everytime animate is called content will be added twice until currentPosition is reset.
      if (currentPosition + primaryBlockWidth) < canvas.width
        addMoreElements()
        context.putImageData(secondaryImageData, (currentPosition + primaryBlockWidth), 0)

      # When the primary block has completely moved to left, currentPosition is set to 0.
      # When elements are redrawn, the secondary block will be drawn from 0 onwards, making it now the primary block.
      if currentPosition < -primaryBlockWidth
        currentPosition += primaryBlockWidth
        changeSecondaryToPrimary()
        addSecondaryData = true

  delayedAnimation = ->
    setInterval animate, 33

  setTimeout delayedAnimation, 1000

  $('.ticker-using-hidden-canvas-image').find('button').click ->
    toggleTicker = !toggleTicker
