Notification = {}
function Notification:new(text,playByDefault)
    local obj = {}
    obj.playByDefault = playByDefault or false

    obj.id = math.random( 0,50000)
    obj.text = text
    obj.delay = 0
    obj.start_tick = getTickCount()
    obj.width = dxGetTextWidth(obj.text:gsub("#%x%x%x%x%x%x", ""),1,font)
    obj.animation_offset = screenW + 10
    obj.opened = false
    obj.closing = false
    obj.strings = {}
    function obj:clientRender()
        if not obj.opened then 
            --Задежка в тиках
            if getTickCount() - obj.start_tick >= 10 then
                --Если позиция анимации не дошла до окончательной, продолжаем двигатся
                if obj.animation_offset >= obj.x then
                    obj.start_tick = getTickCount(  )
                    obj.animation_offset = obj.animation_offset - 20
                --если позиция анимации больше или равна окончательной позиции - делаем нотификейшн открытым
                elseif obj.animation_offset <= obj.x then
                    obj.opened = true
                end
            end
        end
        --Задержка перед закрытием уведомления
        if getTickCount() - obj.start_tick >= obj.delay and obj.opened then 
            obj.closing = true
        end
        if obj.closing then 
            --Засовываем шторку пока она не вышла за пределы экрана
            if obj.animation_offset < screenW + 10 then 
                obj.animation_offset = obj.animation_offset + 20
            else 
                --Если шторка за экраном, то кидаем ивент и удаляем рендер
                triggerEvent( "onNotificationRendered", root, obj.id )
                removeEventHandler( "onClientRender", getRootElement(), obj.clientRender )
                self = nil
            end
        end
        
        dxDrawRectangle( obj.animation_offset, screenH * 0.3 , obj.width + nText_padding, fontHeight * 2 + ((#obj.strings - 1) * 20),bgColor, true)
        dxDrawRectangle( obj.animation_offset, screenH * 0.3 - 3, obj.width + nText_padding, 3 ,greenColor, true)

        for i=0,#obj.strings - 1 do
            dxDrawText( obj.strings[i + 1], obj.animation_offset + nText_padding / 2, screenH * 0.3 + fontHeight/2 + i * 20,obj.animation_offset + nMax_width - nText_padding ,screenH, tocolor(255,255,255,255),1,font, "left", "top", false,false,true,true)
        end
    end
    function obj:initRender()
        local buffer = ""
        local word_list = split( obj.text, " " )
        obj.delay = #word_list * nDelayMultiplier + nDelayMS
        for k,v in pairs(word_list) do
            local spacer = " "
            if buffer == "" then spacer = "" end
            if dxGetTextWidth( buffer:gsub("#%x%x%x%x%x%x", "")..spacer..v:gsub("#%x%x%x%x%x%x", ""),1,font) <= nMax_width then
                buffer = buffer..spacer..v
                if v == "\n" then 
                    table.insert(obj.strings,buffer)
                    buffer = ""
                end
                if word_list[#word_list] == v then table.insert(obj.strings,buffer) end

            elseif word_list[#word_list] == v then 
                table.insert(obj.strings,buffer)
                buffer = v
                table.insert(obj.strings,buffer)
            else
                table.insert( word_list, k, v )
                table.insert( obj.strings, buffer )
                buffer = ""
            end

        end
            --Выставляем изначальную ширину
            obj.width = dxGetTextWidth(obj.strings[1]:gsub("#%x%x%x%x%x%x", ""),1,font)
            --Ищем максимальную ширину и выставляем ее
            for k,v in pairs(obj.strings) do
                local local_width = dxGetTextWidth(v:gsub("#%x%x%x%x%x%x", ""),1,font)
                if local_width >= obj.width then obj.width = local_width end
            end
        obj.x = screenW - nScreen_offset - nText_padding - obj.width
        if obj.playByDefault then 
            obj.start()
        end
    end
    function obj:start()
        triggerEvent( "onPreNotificationRender", root, obj.id )
        playSound("assets/sound.mp3")
        addEventHandler( "onClientRender", getRootElement(), obj.clientRender)
    end
    obj:initRender()
    setmetatable(obj, self)
    self.__index = self
    return obj
end