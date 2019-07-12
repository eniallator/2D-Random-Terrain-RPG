function love.conf(t)
    t.window.resizable = true
    t.window.icon = 'assets/textures/icons/game-icon.png'
    t.title = '2D RPG'
    t.console = true
end

return {
    development = true,
    chunkSize = 16,
    minDimVisibleTiles = 20,
    tps = 20,
    initialScale = 30,
    zoomRate = 0.1,
    zoomLimits = {max = 105, min = 8}
}
