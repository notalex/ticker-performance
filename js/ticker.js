(function() {
  var Context2d, elementList;

  elementList = getElementsList();

  Context2d = (function() {
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

    function Context2d(id, initialPosition) {
      if (initialPosition == null) initialPosition = 5;
      this.canvas = document.getElementById(id);
      this.context = this.canvas.getContext('2d');
      this.position = initialPosition;
    }

    Context2d.prototype.incrementPosition = function(object) {
      return this.position += object.width + intermediateSpace;
    };

    Context2d.prototype.fillText = function(customText) {
      var metrics, text;
      text = addMissingAttributes(customText);
      this.context.font = text.fontType;
      this.context.fillStyle = text.fontColor;
      this.context.fillText(text.value, this.position, textPosition.y);
      metrics = this.context.measureText(text.value);
      return this.incrementPosition(metrics);
    };

    Context2d.prototype.fillPlainText = function(text) {
      this.context.font = defaultText().fontType;
      return this.context.fillText(text, this.position, textPosition.y);
    };

    Context2d.prototype.addImage = function(path) {
      var image;
      image = new Image();
      image.src = "assets/" + path;
      this.context.drawImage(image, this.position, imagePosition.y);
      return this.incrementPosition(image);
    };

    return Context2d;

  })();

  $(function() {
    var addElements, animate, canvas, fun, pos, px, startPosition, textWidth, toggleTicker, value, wrappedContext;
    startPosition = 200;
    wrappedContext = new Context2d('ticker-with-plain-text', startPosition);
    canvas = wrappedContext.canvas;
    value = 'This is one large piece of long text which has no breaking parts in it. Its just text and nothing else. The more content that is aded, teh more crapier it gets. So lets get it on';
    addElements = function(elements) {
      return wrappedContext.fillPlainText(value);
    };
    addElements(elementList);
    px = 1;
    pos = startPosition;
    textWidth = wrappedContext.context.measureText(value).width;
    animate = function() {
      var funy;
      if (toggleTicker) {
        pos -= px;
        wrappedContext.context.clearRect(0, 0, canvas.width, canvas.height);
        wrappedContext.position = pos;
        addElements(elementList);
        if ((pos + textWidth) < canvas.width) {
          wrappedContext.position = pos + textWidth;
          addElements(elementList);
        }
        if (pos < -textWidth) {
          pos += textWidth;
          funy = function() {
            return addElements(elementList);
          };
          return setTimeout(funy, 1000);
        }
      }
    };
    toggleTicker = false;
    fun = function() {
      return setInterval(animate, 33);
    };
    setTimeout(fun, 2000);
    return $('.ticker-with-plain-text').find('button').click(function() {
      return toggleTicker = !toggleTicker;
    });
  });

}).call(this);
