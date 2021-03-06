
local StarAwardPopupScene = class("StarAwardPopupScene", cc.load("mvc").ViewBase)
StarAwardPopupScene.NEXTSCENE = "battle/ChapterScene"
StarAwardPopupScene.RESOURCE_FILENAME = "Scene/GetRewardPanel.csb"
local sceneData=_REQUIRE "battle/ChapterSceneData"
function StarAwardPopupScene:onCreate()
    --    release_print("========= WinPopupScene create");
    local data = self.args[1]
    local index = self.args[2]
    local canGet = self.args[3]
    local Panel_BattleResults=self:getResourceNode():getChildByName("Panel_BattleResults")
    Panel_BattleResults:setTouchEnabled(true)
    local Panel_C=Panel_BattleResults:getChildByName("Panel_C")
    local Panel_Center=Panel_C:getChildByName("Panel_Center")
    local Panel_B=Panel_BattleResults:getChildByName("Panel_B")
    Panel_B:setTouchEnabled(true)
    Panel_B:addTouchEventListener(function(sender,eventType)
        if eventType ==2 then
            self:sceneBack(function()
                self:removeDlgNoAction()
            end)
        end
    end
    )
    SCREEN_SCALE_BG(Panel_B)
    local scrollView=Panel_Center:getChildByName("ScrollView_1")
    local node=self:createNode("Nodes/Node_item_cacha.csb")
    local item =  node:getChildByName("Panel_Object")
    local contentSize =item:getContentSize()
    self.space = 5
    local rewardList = data.rewardList
    local num = #rewardList
    local col =4
    local sSize=cc.size(scrollView:getInnerContainerSize().width,math.max(scrollView:getContentSize().height,(contentSize.height+self.space)*math.ceil(num/col)));
    cclog("sssss"..sSize.width)
    scrollView:setInnerContainerSize(sSize)
    local contentWidth = contentSize.width
    local colSpace = 20
    local startX = (scrollView:getContentSize().width - (contentWidth + colSpace) * col)/2
    for i=1,num do
        local newItem = item:clone()
        --newItem:setAnchorPoint(cc.p(0,0))
        newItem:setTouchEnabled(true);
        newItem:addTouchEventListener(function(sender,eventType)
            if eventType ==2 then
                self:showDlg("common/PropsPopScene", {id = rewardList[i]["value"], type = rewardList[i]["type"]})
            end
        end
        )
        local index = i-1
        newItem:setTag(index);
        scrollView:addChild(newItem)
        self:initItemCacha(newItem,{id = rewardList[i]["value"], type = rewardList[i]["type"], num = rewardList[i]["content"]})
        local x = startX + (contentWidth + colSpace)/2 + (index % col) * (contentWidth + colSpace)
        --local x = (sSize.width/col)/2+sSize.width/col*(index%col)
        --local t = math.floor(index/2)
        local y=sSize.height-(contentSize.height+self.space)*math.floor(index/col)-contentSize.height/2
        newItem:setPosition(cc.p(x,y))
    end
    
--    local Button_Back=Panel_Top:getChildByName("Button_Back")
--    
--    Button_Back:setVisible(true)
--    Button_Back:addTouchEventListener(function(sender,eventType)
--        if  eventType == 2 then
--            self:removeDlgNoAction()
--
--        end
--    end)
    
    
    local Button_Confirm=Panel_Center:getChildByName("Button_1")
    local Button_Cancel=Panel_Center:getChildByName("Button_Cancel")
    Button_Cancel:addTouchEventListener(function(sender,eventType)
        if eventType ==2 then
            self:sceneBack(function()
                self:removeDlgNoAction()
            end)
            
        end
    end
    )
    Button_Confirm:setBright(canGet==true)
    Button_Confirm:addTouchEventListener(function(sender,eventType)
        if  eventType == 2 then
            if canGet==true then
                helper_pve:openSelectAreaTreasuresBox(index, function(sucess,data)
                    if sucess then
                        PopMsg.getInstance():flashShow(LANG("领取成功! "))
                        self.dlgCallBack({cmd="openTreasure",index = index})
                        self:removeDlgNoAction()
                    end
                end)
            else
                PopMsg.getInstance():flashShow(LANG("尚未达到领取条件，无法领取。 "))
            end
            

        end
    end)
    
    
end

return StarAwardPopupScene
