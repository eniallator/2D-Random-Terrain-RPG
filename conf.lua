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
    tps = 20
}
