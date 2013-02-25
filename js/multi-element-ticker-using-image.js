// Generated by CoffeeScript 1.3.3
(function() {
  var ContextCreator, elementsList;

  elementsList = getElementsList();

  ContextCreator = (function() {
    var imagePosition, intermediateSpace, textPosition;

    intermediateSpace = 3;

    textPosition = {
      y: 18
    };

    imagePosition = {
      y: 5
    };

    function ContextCreator(id, initialPosition) {
      if (initialPosition == null) {
        initialPosition = 5;
      }
      this.canvas = document.getElementById(id);
      this.context = this.canvas.getContext('2d');
      this.context.font = '15px Arial';
      this.position = initialPosition;
    }

    ContextCreator.prototype.incrementPosition = function(object) {
      return this.position += object.width + intermediateSpace;
    };

    ContextCreator.prototype.fillText = function(text) {
      var metrics;
      this.context.fillText(text.value, this.position, textPosition.y);
      metrics = this.context.measureText(text.value);
      return this.incrementPosition(metrics);
    };

    ContextCreator.prototype.addImage = function(path) {
      var image;
      image = new Image();
      image.src = "assets/" + path;
      this.context.drawImage(image, this.position, imagePosition.y);
      return this.incrementPosition(image);
    };

    return ContextCreator;

  })();

  $(function() {
    var addElements, animate, canvas, context, currentPosition, data, delayedAnimation, index, previousTime, start, startPosition, textWidth, toggleTicker, wrappedContext;
    index = 0;
    startPosition = 100;
    wrappedContext = new ContextCreator('multi-element-ticker-using-image', startPosition);
    context = wrappedContext.context;
    canvas = wrappedContext.canvas;
    currentPosition = startPosition;
    toggleTicker = false;
    addElements = function() {
      var element, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = elementsList.length; _i < _len; _i++) {
        element = elementsList[_i];
        wrappedContext.fillText({
          value: element.value1
        });
        wrappedContext.addImage("" + element.imageType + "-arrow.png");
        wrappedContext.fillText({
          value: element.value2
        });
        wrappedContext.fillText({
          value: element.value3
        });
        _results.push(wrappedContext.position += 5);
      }
      return _results;
    };
    addElements();
    textWidth = wrappedContext.position;
    start = mozAnimationStartTime;
    previousTime = 0;
    data = context.getImageData(startPosition, 0, textWidth, canvas.height);
    animate = function(timestamp) {
      var progress;
      progress = timestamp - previousTime;
      previousTime = timestamp;
      if (progress > 15 && toggleTicker) {
        currentPosition -= 1;
        wrappedContext.context.clearRect(0, 0, canvas.width, canvas.height);
        context.putImageData(data, currentPosition, 0);
      }
      return mozRequestAnimationFrame(animate);
    };
    delayedAnimation = function() {
      previousTime = Date.now();
      return animate(previousTime);
    };
    setTimeout(delayedAnimation, 2000);
    return $('.multi-element-ticker-using-image').find('button').click(function() {
      return toggleTicker = !toggleTicker;
    });
  });

}).call(this);