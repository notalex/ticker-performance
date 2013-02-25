window.getElementsList = ->
  range1 = [1..100]
  range2 = [200..1200]

  createRandomObject = (index) ->
    value1: "ABC#{ index }"
    value2: "#{ range1[Math.round(Math.random() * (range1.length - 1))] }%"
    value3: range2[Math.round(Math.random() * (range2.length - 1))]
    imageType: ['up', 'down', 'stable'][Math.round(Math.random() * 2)]
    unicode: ['▲', '►', '▼'][Math.round(Math.random() * 2)]
    
  [1..40].map createRandomObject
