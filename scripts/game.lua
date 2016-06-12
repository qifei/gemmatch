
require("config")
require("framework.init")

-- define global module
game = {}

function game.startup()
    CCFileUtils:sharedFileUtils():addSearchPath("res/")
    --display.addSpriteFramesWithFile(GAME_TEXTURE_DATA_FILENAME, GAME_TEXTURE_IMAGE_FILENAME)

    game.baoshi()
end

function game.exit()
    os.exit()
end

function game.baoshi()
    local GameScene = require("scenes.GameScene")
    display.replaceScene(GameScene.new())
end
