(function() {
  var ContextCreator, elementList;

  elementList = getElementsList();

  ContextCreator = (function() {
    var addMissingAttributes, defaultColor, defaultText, imagePosition, intermediateSpace, textPosition;

    defaultColor = 'black';

    intermediateSpace = 3;

    textPosition = {
      y: 18
    };

    imagePosition = {
      y: 5
    };

    defaultText = function() {
      return {
        fontType: '15px Arial',
        fontColor: 'black'
      };
    };

    addMissingAttributes = function(customText) {
      var key, text, value;
      text = defaultText();
      for (key in customText) {
        value = customText[key];
        text[key] = value;
      }
      return text;
    };

    function ContextCreator(id, initialPosition) {
      if (initialPosition == null) initialPosition = 5;
      this.canvas = document.getElementById(id);
      this.context = this.canvas.getContext('2d');
      this.context.font = '15px Arial';
      this.position = initialPosition;
    }

    ContextCreator.prototype.incrementPosition = function(object) {
      return this.position += object.width + intermediateSpace;
    };

    ContextCreator.prototype.fillText = function(customText) {
      var metrics, text;
      text = addMissingAttributes(customText);
      this.context.fillStyle = text.fontColor;
      this.context.fillText(text.value, this.position, textPosition.y);
      metrics = this.context.measureText(text.value);
      return this.incrementPosition(metrics);
    };

    ContextCreator.prototype.fillPlainText = function(text) {
      return this.context.fillText(text, this.position, textPosition.y);
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
    var addElements, animate, canvas, currentPosition, delayedAnimation, index, message, refreshMessageList, startPosition, textWidth, toggleTicker, wrappedContext;
    index = 0;
    startPosition = 800;
    wrappedContext = new ContextCreator('ticker-with-plain-text', startPosition);
    canvas = wrappedContext.canvas;
    currentPosition = startPosition;
    message = '';
    toggleTicker = false;
    refreshMessageList = function() {
      var i, msg, _ref;
      msg = '';
      for (i = index, _ref = index + 14; index <= _ref ? i <= _ref : i >= _ref; index <= _ref ? i++ : i--) {
        msg += "AAPL +5" + i + " ";
      }
      return message = msg;
    };
    addElements = function() {
      return wrappedContext.fillPlainText(message);
    };
    refreshMessageList();
    addElements();
    textWidth = wrappedContext.context.measureText(message).width;
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
          currentPosition += textWidth;
          return refreshMessageList();
        }
      }
    };
    delayedAnimation = function() {
      return setInterval(animate, 33);
    };
    setTimeout(delayedAnimation, 2000);
    return $('.ticker-with-plain-text').find('button').click(function() {
      return toggleTicker = !toggleTicker;
    });
  });

}).call(this);
