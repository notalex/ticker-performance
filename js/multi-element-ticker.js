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

    return ContextCreator;

  })();

  $(function() {
    var addElements, animate, canvas, currentPosition, delayedAnimation, startPosition, textWidth, toggleTicker, wrappedContext;
    startPosition = 800;
    wrappedContext = new ContextCreator('multi-element-ticker', startPosition);
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
    animate = function() {
      if (toggleTicker) {
        currentPosition -= 1;
        wrappedContext.context.clearRect(0, 0, canvas.width, canvas.height);
        wrappedContext.position = currentPosition;
        addElements();
        if ((currentPosition + textWidth) < canvas.width) {
          wrappedContext.position = currentPosition + textWidth;
          addElements();
        }
        if (currentPosition < -textWidth) {
          return currentPosition += textWidth;
        }
      }
    };
    delayedAnimation = function() {
      return setInterval(animate, 33);
    };
    setTimeout(delayedAnimation, 2000);
    return $('.multi-element-ticker').find('button').click(function() {
      return toggleTicker = !toggleTicker;
    });
  });

}).call(this);
