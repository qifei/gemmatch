
local GameScene = class("GameScene", function()
    return display.newScene("GameScene")
end)
math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
local random = math.random

local GRAVITY         = -400
local GEM_MASS       = 100
local GEM_WIDTH     = 80
local GEM_HEIGHT     = 80
local GEM_FRICTION   = 0.8
local GEM_ELASTICITY = 0.8
local WALL_THICKNESS  = 100
local WALL_FRICTION   = 1.0
local WALL_ELASTICITY = 0.5

local totalScore = 0

local gemTypes = {"a", "b", "c", "d", "e", "f", "g"}
local hanzi = {"一", "二", "三", "四", "五", "六", "七", "八"}

local selA = nil
local selB = nil

local matrix = {}
for i=1,8 do
    matrix[i] = {}
    for j=1,8 do
        matrix[i][j] = nil
    end
end

--侦测相邻元素的参数只有一个，所以这个用来找两个，可是方法不对(废弃)
function detect2(a, b)
    local gemA = a
    local gemB = b

    local ax = gemA.gX
    local ay = gemA.gY
    local bx = gemB.gX
    local by = gemB.gY

    markGem(gemA, gemB)

    if (gemA.clear or gemB.clear) then
        clearAndRemove()
    else
        swapPosition(matrix[ax][ay], matrix[bx][by], true)
    end

end

function detectAll(a, b)
    local gemA = a
    local gemB = b
    local m = false

    local clear = false

    for i=1,#matrix do
        for j=1,#matrix[i] do
            local g = matrix[i][j]
            if #matrix[i]<8 then
                print("长度是："..#matrix[i])
                m = true
            end
            if (i>1 and i<8) then
                local gL = matrix[i-1][j]
                local gR = matrix[i+1][j]
                if (gL ~= nil and gR ~= nill) then
                    if (gL.gemType == g.gemType and g.gemType == gR.gemType) then
                        gL.clear = true
                        g.clear = true
                        gR.clear = true
                        clear = true
                    end
                end
                
            end

            if (j>1 and j<8) then
                local gT = matrix[i][j+1]
                local gB = matrix[i][j-1]
                if (gT~=nil and gB~=nil) then
                    if (gT.gemType == g.gemType and g.gemType == gB.gemType) then
                        gT.clear = true
                        g.clear = true
                        gB.clear = true
                        clear = true
                    end
                end
                
            end
        end
    end

    if clear then
        clearAndRemove()
    elseif m then
        fillGrid()
    elseif (gemA~=nil) then
        swapPosition(gemA, gemB, true)
    else
        --nothing happend
    end


end

--只侦测相邻的元素(未使用)
function findGem(agem)
    local gemA = agem
    local agx = gemA.gemX
    local agy = gemA.gemY

    local ax1 = agx
    local ax2 = agx
    local ay1 = agy
    local ay2 = agy

    local clearReady = false

    --横向查找
    local i = 1
    while (agx+i<9) do
        if (matrix[agx+i][agy].gemType == matrix[agx+i-1][agy].gemType) then
            ax2 = agx+i
        else
            print("ax2: "..ax2)
            break
        end
        i = i+1
    end

    local j = 1
    while (agx-j>0) do
        if (matrix[agx-j][agy].gemType==matrix[agx-j+1][agy].gemType) then
            ax1 = agx-j
        else
            print("ax1: "..ax1)
            break
        end
        j = j+1
    end

    if (ax2 - ax1 >=2) then
        for i=0,ax2-ax1 do
            matrix[ax1+i][agy].clear = true
            if (matrix[ax1+i][agy].clear==true) then
            end
        end
        clearReady = true
    end

    --竖向查找
    local k = 1
    while (agy+k<9) do
        if (matrix[agx][agy+k].gemType==matrix[agx][agy+k-1].gemType) then
            ay2 = agy+k
        else
            break
        end
        k = k+1
    end

    local l = 1
    while (agy-l>0) do
        if (matrix[agx][agy-l].gemType==matrix[agx][agy-l+1].gemType) then
            ay1 = agy-l
        else
            break
        end
        l = l+1
    end

    if (ay2 - ay1 >=2) then
        for i=0,ay2-yEnd1 do
            matrix[agx][ay1+i].clear = true
        end
        clearReady = true
    end

    return clearReady
end

--标记两个交换位置的元素和他们的相邻的元素(未使用)
function markGem(agem, bgem)
    local gemA = agem
    local agx = gemA.gemX
    local agy = gemA.gemY

    local ax1 = agx
    local ax2 = agx
    local ay1 = agy
    local ay2 = agy

    local gemB = bgem
    local bgx = gemB.gemX
    local bgy = gemB.gemY

    local bx1 = bgx
    local bx2 = bgx
    local by1 = bgy
    local by2 = bgy

    local clearReady = false

    --横向查找 A
    local i = 1
    while (agx+i<9) do
        if (matrix[agx+i][agy].gemType == matrix[agx+i-1][agy].gemType) then
            ax2 = agx+i
        else
            print("ax2: "..ax2)
            break
        end
        i = i+1
    end

    local j = 1
    while (agx-j>0) do
        if (matrix[agx-j][agy].gemType==matrix[agx-j+1][agy].gemType) then
            ax1 = agx-j
        else
            print("ax1: "..ax1)
            break
        end
        j = j+1
    end

    if (ax2 - ax1 >=2) then
        for i=0,ax2-ax1 do
            matrix[ax1+i][agy].clear = true
            if (matrix[ax1+i][agy].clear==true) then
            end
        end
        clearReady = true
    end

    --竖向查找 A
    local k = 1
    while (agy+k<9) do
        if (matrix[agx][agy+k].gemType==matrix[agx][agy+k-1].gemType) then
            ay2 = agy+k
        else
            break
        end
        k = k+1
    end

    local l = 1
    while (agy-l>0) do
        if (matrix[agx][agy-l].gemType==matrix[agx][agy-l+1].gemType) then
            ay1 = agy-l
        else
            break
        end
        l = l+1
    end

    if (ay2 - ay1 >=2) then
        for i=0,ay2-yEnd1 do
            matrix[agx][ay1+i].clear = true
        end
        clearReady = true
    end

    --横向查找 B
    local i = 1
    while (bgx+i<9) do
        if (matrix[bgx+i][bgy].gemType == matrix[bgx+i-1][bgy].gemType) then
            bx2 = bgx+i
        else
            print("bx2: "..bx2)
            break
        end
        i = i+1
    end

    local j = 1
    while (bgx-j>0) do
        if (matrix[bgx-j][bgy].gemType==matrix[bgx-j+1][bgy].gemType) then
            bx1 = bgx-j
        else
            print("bx1: "..bx1)
            break
        end
        j = j+1
    end

    if (bx2 - bx1 >=2) then
        for i=0,bx2-bx1 do
            matrix[bx1+i][bgy].clear = true
            if (matrix[bx1+i][bgy].clear==true) then
            end
        end
        clearReady = true
    end

    --竖向查找 B
    local k = 1
    while (bgy+k<9) do
        if (matrix[bgx][bgy+k].gemType==matrix[bgx][bgy+k-1].gemType) then
            by2 = bgy+k
        else
            break
        end
        k = k+1
    end

    local l = 1
    while (bgy-l>0) do
        if (matrix[bgx][bgy-l].gemType==matrix[bgx][bgy-l+1].gemType) then
            by1 = bgy-l
        else
            break
        end
        l = l+1
    end

    if (by2 - by1 >=2) then
        for i=0,by2-by1 do
            matrix[bgx][by1+i].clear = true
        end
        clearReady = true
    end

    return clearReady

end


function clearAndRemove()

    -- local m = 1
    -- while m <= #matrix do
    --     local n = 1
    --     while n <= #matrix[m] do
    --         local g = matrix[m][n]
    --         if g.clear then
    --             g:disappear()
    --         end
    --         n = n+1
    --     end
    --     m = m+1
    -- end
    local removed = false

    for i=1,#matrix do
        for j=1,#matrix[i] do
            --local t = matrix[i]
            local g = matrix[i][j]
            if (g.clear == true) then
                g:disappear()
            end
        end
    end

    local ix = 1
    while ix <= #matrix do
        local j = 1
        while j <= #matrix[ix] do
            local g = matrix[ix][j]
            if g.clear then
                --g:disappear()
                removed = true
                table.remove(matrix[ix], j)
            else
                j = j+1
            end
        end
        ix = ix+1
    end

    arrangeMatrix()

end

function arrangeMatrix()
    local moved = false

    for i=1,#matrix do
        for j=1,#matrix[i] do
            local g = matrix[i][j]
            if (i==8 and j==#matrix[8]) then
                g.gemX = i
                g.gemY = j
                moved = ture
                transition.execute(matrix[i][j].gemSprite, CCMoveTo:create(0.2, CCPoint(i*80-40, j*80-40)), {
                    easing = "in",
                    onComplete = function()
                        detectAll()
                    end,
                })
            elseif (g.gemX~=i or g.gemY~=j) then
                g.gemX = i
                g.gemY = j
                moved = ture
                g:drop()
            end
            
        end
    end

    -- local i = 1
    -- while i <= #matrix do
    --     local j = 1
    --     while j <= #matrix[i] do
    --         local g = matrix[i][j]
    --         if (g.gemX~=i or g.gemY~=j) then
    --             g.gemX = i
    --             g.gemY = j
    --             moved = ture
    --             --g:drop()
    --         end
            
    --         j = j+1

    --         -- if (i==8 and j==#matrix[i]) then
    --         --     detectAll()
    --         -- end
    --     end
    --     i = i+1
    -- end

    -- local m = 1
    -- while m <= #matrix do
    --     local n = 1
    --     while n <= #matrix[m] do
    --         local g = matrix[m][n]
    --         g:drop()
            
    --         n = n+1

    --         if (m==8 and n==#matrix[m]) then
    --             detectAll()
    --         end
    --     end
    --     m = m+1
    -- end

    GameScene:score()
    
end

--填充已经消除的空位
function fillGrid()
    for i=1,#matrix do
        local need = 8 - #matrix[i]
        while need>0 do
            local gt = gemTypes[random(7)]
            local y = 8-need+1
            local g = Gem:new{gemType=gt, gemX=i, gemY=y, selected = false, clear=false}
            table.insert(matrix[i], g)
            need = need -1
        end
        if i==8 then
            arrangeMatrix()
        end
    end
end

--宝石类的构造函数
Gem = {}
function Gem:new(p)
    local obj = p
    if (obj == nil) then
        obj = {gemType = "a", gemX = 0, gemY = 0, selected = false, clear = false}
    end
    obj.gemSprite = display.newSprite("gem_"..obj.gemType..".png", obj.gemX*80-40, obj.gemY*80-40)
    --obj.box = obj.gemSprite:getBoundingBox()
    local label = ui.newTTFLabel({
        text = tostring(hanzi[obj.gemX])..tostring(obj.gemY),
        size = 28,
        align = ui.TEXT_ALIGN_LEFT
    })
    label:setAnchorPoint(CCPoint(0,0))
    --obj.gemSprite:addChild(label)

    grid:addChild(obj.gemSprite)

    self.__index = self
    return setmetatable(obj, self)
end

function Gem:disappear()
    totalScore = totalScore + 10
    local dsp = CCSpawn:createWithTwoActions(
        CCScaleTo:create(0.2, 0.2),
        CCFadeOut:create(0.2)
    )
    local seq = transition.sequence({
        dsp,
        onComplete = function()
            self.gemSprite:removeSelf()
        end,
    })
    self.gemSprite:runAction(seq)
end

function Gem:drop()
    --print("self.gemX: "..self.gemX)
    --print("self.gemY: "..self.gemY)
    local drop = CCMoveTo:create(0.2, CCPoint(self.gemX*80-40, self.gemY*80-40))
    self.gemSprite:runAction(drop)
end

--交换两个相邻宝石的位置
function swapPosition(a, b, r)
    if a==nil then
        return
    end

    local gemA = a
    local gemB = b
    local rstr = r or false
    local ax = gemA.gemX
    local ay = gemA.gemY
    local at = gemA.gemType
    local bx = gemB.gemX
    local by = gemB.gemY
    local bt = gemB.gemType

    matrix[ax][ay] = gemB
    matrix[ax][ay].gemX = ax
    matrix[ax][ay].gemY = ay
    --matrix[ax][ay].gemType = bt
    matrix[bx][by] = gemA
    matrix[bx][by].gemX = bx
    matrix[bx][by].gemY = by
    --matrix[bx][by].gemType = at

    selA = nil
    selB = nil

    if (aX == bX or aY == bY) then
        transition.execute(matrix[ax][ay].gemSprite, CCMoveTo:create(0.4, CCPoint(ax*80-40, ay*80-40)), {
            easing = "in",
        })
        transition.execute(matrix[bx][by].gemSprite, CCMoveTo:create(0.4, CCPoint(bx*80-40, by*80-40)), {
            easing = "in",
            onComplete = function()
                if rstr then
                    return
                else
                    detectAll(matrix[ax][ay], matrix[bx][by])
                end
            end,
        })
    end
    
end

--程序主函数
function GameScene:ctor()

    local bgLayer = display.newColorLayer(ccc4(255, 255, 255, 40))
    self:addChild(bgLayer)

    local bg = display.newSprite("background.jpg", display.cx, display.cy)
    self:addChild(bg)

    grid = display.newSprite("grid.png", display.cx, display.cy)
    self:addChild(grid)

    self.sm = display.newSprite("sm.png", -600, -600)
    grid:addChild(self.sm, 10)
    self.gridBox = grid:getBoundingBox()

    scoreLabel = ui.newBMFontLabel({
        text = "0",
        font = "font.fnt",
        x = display.cx,
        y = display.top - 320,
        align = ui.TEXT_ALIGN_CENTER,
    })
    self:addChild(scoreLabel)

    GameScene:initGame()

    local btnNewGame = cc.ui.UIPushButton.new("btn_newgame.png")
    btnNewGame:setPosition(ccp(display.cx-150, 280))
    self:addChild(btnNewGame)

    btnNewGame:onButtonClicked(function(event)
        GameScene:initGame()
    end)

    local btnExit = cc.ui.UIPushButton.new("btn_exit.png")
    btnExit:setPosition(ccp(display.cx+150, 280))
    self:addChild(btnExit)

    btnExit:onButtonClicked(function(event)
        game.exit()
    end)

    -- local btn1 = cc.ui.UIPushButton.new("gem_a.png")
    -- btn1:setPosition(ccp(display.cx-100, 200))
    -- self:addChild(btn1)

    -- btn1:onButtonClicked(function(event)
    --     print("btn Show")
    --     show()
    -- end)

    -- local btn2 = cc.ui.UIPushButton.new("gem_d.png")
    -- btn2:setPosition(ccp(display.cx+100, 200))
    -- self:addChild(btn2)

    -- btn2:onButtonClicked(function(event)
    --     print("btn arrangeMatrix")
    --     arrangeMatrix()
    -- end)

end

function GameScene:onTouch(event, x, y)
    local gx
    local gy
    if event == "began" then
        local p = CCPoint(x, y)
        if self.gridBox:containsPoint(p) then
            gx = math.ceil((x-160)/80)
            gy = math.ceil((y-400)/80)
            if (selA ~= nil) then
                local a = math.abs(selA.gemX - gx) + math.abs(selA.gemY - gy)
                if a==1 then
                    selB = matrix[gx][gy]
                    swapPosition(selA, selB)
                    self.sm:setPosition(CCPoint(-600, -600))
                    self.sm:setOpacity(0)
                elseif a>1 then
                    selA = matrix[gx][gy]
                    self.sm:setPosition(CCPoint(gx*80-40, gy*80-40))
                end
            else
                selA = matrix[gx][gy]
                self.sm:setPosition(CCPoint(gx*80-40, gy*80-40))
                self.sm:setOpacity(160)
            end

        end
        return true
    elseif event ~= "moved" then
        --self.state = "IDLE"
    end
end

function GameScene:onEnter()
    local cLayer = CCLayerColor:create(ccc4(255, 255, 255, 0), 640, 640)
    cLayer:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        return self:onTouch(event.name, event.x, event.y)
    end)
    cLayer:setTouchEnabled(true)
    cLayer:setTouchSwallowEnabled(false)
    grid:addChild(cLayer)

end

-- 初始化游戏，随机填充宝石矩阵
function GameScene:initGame()
    -- local ix = 1
    -- while ix <= #matrix do
    --     local j = 1
    --     while j <= #matrix[ix] do
    --         local g = matrix[ix][j]
    --         g.gemSprite:removeSelf()
    --         table.remove(matrix[ix], j)
    --         j = j+1
    --     end
    --     ix = ix+1
    -- end

    for i=1,8 do
        for j=1,8 do
            local gt = gemTypes[random(7)]
            if (matrix[i][j]) then
                matrix[i][j].gemSprite:removeSelf()
            end
            matrix[i][j] = Gem:new{gemType=gt, gemX=i, gemY=j, selected = false, clear=false}
        end
    end

    totalScore = 0
    scoreLabel:setString("欢 迎")

    fixGrid()

end

--检查矩阵，保证不要出现三个相同元素出现在一条直线上
function fixGrid()
    --matrix[4][1].gemSprite:removeSelf()
    --matrix[4][1] = Gem:new{gemType="e", gemX=4, gemY=1, selected = false, clear=false}
    --matrix[4][1].gemSprite = display.newSprite("gem_e.png", 4*80-40, 1*80-40)
    -- local newImg = CCTextureCache:sharedTextureCache():addImage("gem_e.png")
    -- matrix[4][1].gemSprite:setTexture(newImg)

    for m=1,8 do
        for n=1,8 do
            local g = matrix[m][n].gemType
            if (m>1 and m<8) then
                local gL = matrix[m-1][n].gemType
                local gR = matrix[m+1][n].gemType
                if (gL==g and g==gR) then
                    local C = ""
                    local index = nil
                    local cs = {"a", "b", "c", "d", "e", "f", "g"}
                    for i=1,7 do
                        if (gemTypes[i]==g) then
                            index=i
                        end
                    end
                    table.remove(cs, index)
                    c = cs[random(6)]
                    matrix[m][n].gemType = c
                    matrix[m][n].gemSprite:removeSelf()
                    matrix[m][n] = Gem:new{gemType=c, gemX=m, gemY=n, selected = false, clear=false}
                end
            end

            if (n>1 and n<8) then
                local gT = matrix[m][n-1].gemType
                local gB = matrix[m][n+1].gemType
                if (gT==g and g==gB) then
                    local C = ""
                    local index = nil
                    local cs = {"a", "b", "c", "d", "e", "f", "g"}
                    for i=1,7 do
                        if (gemTypes[i]==g) then
                            index=i
                        end
                    end
                    table.remove(cs, index)
                    c = cs[random(6)]
                    matrix[m][n].gemType = c
                    matrix[m][n].gemSprite:removeSelf()
                    matrix[m][n] = Gem:new{gemType=c, gemX=m, gemY=n, selected = false, clear=false}
                end
            end
        end
    end

end

function GameScene:score()
    --scoreLabel:setString("You've earned "..totalScore.." scores")
    scoreLabel:setString("你的分数是 "..totalScore.." 分")
end

function show()
    dump(matrix[4])
end

return GameScene
