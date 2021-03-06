---
---

define ['vector', 'keyboard', 'wheel'], (Vector, Keyboard, Wheel) ->
  class Camera
    PAN_SPEED: 1
    ROTATE_SPEED: 0.001
    ZOOM_SPEED: 0.001

    position: new Vector(0, 0)
    rotation: 0
    scale: 1

    update: (deltaTime) ->
      @_updateScale(deltaTime)
      @_updatePosition(deltaTime)
      @_updateRotation(deltaTime)

    _updateRotation: (deltaTime) ->
      @rotation += @ROTATE_SPEED * deltaTime if Keyboard.isDown 69
      @rotation -= @ROTATE_SPEED * deltaTime if Keyboard.isDown 81
      @rotation = ((@rotation%(Math.PI*2))+(Math.PI*2))%(Math.PI*2)

    _updateScale: (deltaTime) ->
      @scale *= 1 + @ZOOM_SPEED * deltaTime if Keyboard.isDown 88
      @scale *= 1 - @ZOOM_SPEED * deltaTime if Keyboard.isDown 90

    _updatePosition: (deltaTime) ->
      cos = @PAN_SPEED * deltaTime * Math.cos(@rotation) / @scale
      sin = @PAN_SPEED * deltaTime * Math.sin(@rotation) / @scale

      @position = @position.add new Vector(cos, -sin) if Keyboard.isDown 65
      @position = @position.add new Vector(sin, cos) if Keyboard.isDown 87
      @position = @position.add new Vector(-cos, sin) if Keyboard.isDown 68
      @position = @position.add new Vector(-sin, -cos) if Keyboard.isDown 83

      wheelOffset = Wheel.getOffset().multiply(deltaTime / @scale)
      x = wheelOffset.x * Math.cos(@rotation) + wheelOffset.y * Math.sin(@rotation)
      y = - wheelOffset.x * Math.sin(@rotation) + wheelOffset.y * Math.cos(@rotation)
      @position = @position.add new Vector(x, y)

    render: (context, canvas) ->
      width = window.innerWidth
      height = window.innerHeight

      canvas.width = width
      canvas.height = height

      context.translate width/2, height/2
      context.rotate @rotation
      context.scale @scale, @scale
      context.translate @position.x, @position.y
