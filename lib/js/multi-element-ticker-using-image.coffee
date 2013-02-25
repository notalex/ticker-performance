elementsList = getElementsList()

class ContextCreator
  intermediateSpace = 3
  textPosition = { y: 18 }
  imagePosition = { y: 5 }

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

  addImage: (path) ->
    image = new Image()
    image.src = "assets/#{ path }"
    @context.drawImage(image, @position, imagePosition.y)
    @incrementPosition(image)

$ ->
  index = 0
  startPosition = 100
  wrappedContext = new ContextCreator('multi-element-ticker-using-image', startPosition)
  context = wrappedContext.context
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

  start = mozAnimationStartTime
  previousTime = 0
  data = context.getImageData(startPosition, 0, textWidth, canvas.height)

  animate = (timestamp) ->
    progress = timestamp - previousTime
    previousTime = timestamp

    if progress > 15 and toggleTicker
      currentPosition -= 1

      wrappedContext.context.clearRect 0, 0, canvas.width, canvas.height
      context.putImageData(data, currentPosition, 0)

    mozRequestAnimationFrame(animate)

  delayedAnimation = ->
    previousTime = Date.now()
    animate(previousTime)

  setTimeout delayedAnimation, 2000

  $('.multi-element-ticker-using-image').find('button').click ->
    toggleTicker = !toggleTicker
