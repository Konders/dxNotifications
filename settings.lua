screenW, screenH = guiGetScreenSize()

font = dxCreateFont("assets/font.ttf", 10 ,false,"cleartype")
fontHeight = dxGetFontHeight( 1 ,font )

bgColor = tocolor( 31,31,31,204)
greenColor = tocolor(0,212,144,204)
whiteColor = tocolor(255,255,255,255)

--Notification Settings

--Максимальная ширина
nMax_width = 315
--На сколько пикселей отодвинуть уведомление от экрана
nScreen_offset = 30
--На сколько пикселей отодвинуть текст от тела уведомления
nText_padding = 60

--Задержка до того как уведомление уйдет за экран
nDelayMS = 3000
--Множитель задержки который прибавляется при каждом слове
nDelayMultiplier = 100