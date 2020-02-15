notifications = {}
addEvent( "callNotification",true)
addEvent( "onPreNotificationRender",true)
addEvent( "onNotificationRendered",true)

local create_play= true
addEventHandler( "onPreNotificationRender", localPlayer, function() create_play = false end)
addEventHandler( "onNotificationRendered", localPlayer, function(object)
    for k,v in pairs(notifications) do 
        if v.id == object or not v.id then  table.remove( notifications, k ) end
    end
    create_play = true
    if #notifications > 0 then 
        notifications[1].start()
    end
end)

function createNotification(text)
    if not create_play then 
        if notifications[#notifications].text == text then return end
    end
    table.insert( notifications,  Notification:new(text,create_play))
end

addEventHandler( "callNotification", localPlayer, createNotification )