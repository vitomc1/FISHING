script_author("VitoH")

script_version("0.1")
script_version_number(16)

local sampev = require 'lib.samp.events'
local textCoords = {x = nil, y = nil, z = nil}
local pecksCoin = 0
local pecksFish = {}

local fa5 = require("fAwesome5")
local fa 	= require "faIcons"
local effil = require 'effil'
local imgui = require "imgui"
local encoding = require "encoding"
encoding.default = "CP1251"
u8 = encoding.UTF8
local mainMenu = imgui.ImBool(false)

local rx, ry 				= getScreenResolution() -- // ������ ������

local takebait = false
local fishrod = false
local exithook = false
local exitrod = false

local myfloat = false
local myfloat2 = false
local cX = 0
local cY = 0

local fishs = {"������",
"�������",
"����",
"�����",
"���",
"���",
"���",
"�����",
"�����",
"������",
"����",
"�����",
"������",
"������",
"�����",
"Ѹ���",
"������� �����",
"�������",
"������",
"��������",
"�����",
"������� ����",
"������",
"���������� �����"}

active = imgui.ImBool(false)
local closedd = false
local closedd2 = false
local closedd3 = false
local fishHook = false
sellfish = imgui.ImBool(false)


local dlstatus = require('moonloader').download_status

function update()
  local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- ���� ����� �������� ��� ������ ��� ��������� ������
  downloadUrlToFile('https://raw.githubusercontent.com/vitomc1/FISHING/main/version.json', fpath, function(id, status, p1, p2) -- ������ �� ��� ������ ��� ���� ������� ������� � ��� � ���� ��� ����� ������ ����
    if status == dlstatus.STATUS_ENDDOWNLOADDATA then
    local f = io.open(fpath, 'r') -- ��������� ����
    if f then
      local info = decodeJson(f:read('*a')) -- ������
      updatelink = info.updateurl
      if info and info.latest then
        version = tonumber(info.latest) -- ��������� ������ � �����
        if version > tonumber(thisScript().version) then -- ���� ������ ������ ��� ������ ������������� ��...
          lua_thread.create(goupdate) -- ������
        else -- ���� ������, ��
          update = false -- �� ��� ����������
          sampAddChatMessage('[FISH]: {98FB98}���� ������ ������� ����������. ���������� �� ���������. ������: '..thisScript().version, -1)
        end
      end
    end
  end
end)
end
--���������� ���������� ������
--"[FISH]: {98FB98}����� �����. /gosmenu - �������� ����, /gos - �������� ���-�� �����, /gos [��������] [����]", -1
function goupdate()
sampAddChatMessage('[FISH]: {98FB98}���������� ����������. AutoReload ����� �������������. ����������...', -1)
sampAddChatMessage('[FISH]: {98FB98}������� ������: '..thisScript().version..". ����� ������: "..version, -1)
wait(300)
downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- ������ ��� ������ � latest version
  if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
		local _, id = sampGetPlayerIdByCharHandle(playerPed)
  sampAddChatMessage('[FISH]: {98FB98}���������� ���������!', -1)
  thisScript():reload()
end
end)
end

function main()
    while not isSampAvailable() do wait(0) end
		update()
		lua_thread.create(fishcd)
		sampRegisterChatCommand("gofish", function()
			active.v = not active.v
			sampAddChatMessage(active.v and "������ �����������!" or "������ ��������!", 0x098FB98)
		end)

		sampRegisterChatCommand("sellfish", function()
			sellfish.v = not sellfish.v
			sampAddChatMessage(sellfish.v and "���� ������� ��� ��������!" or "���� ������� ��� ���������!", 0x098FB98)
		end)

		sampRegisterChatCommand(
			"fishmenu",
			function()
				mainMenu.v = not mainMenu.v
			end
		)

		sampRegisterChatCommand("rodfish", function()
			lua_thread.create(function()
			active.v = true
			fishrod = true
			sampSendChat("/invex")
		end)
		end)
    while true do wait(0)
			imgui.Process = mainMenu.v

				if pecksCoin >= 4 then
					sampSendChat("/fish")
					pecksCoin = 0
				end



    end
end

function fishcd()
	while true do wait(4000)
		pecksCoin = 0
		--sampAddChatMessage("clear", -1)
	end
end

function sampev.onShowDialog(id, stytle, title, btn1, btn2, text)


	if active.v then
		if sellfish.v then
		if id == 8270 and sellfish.v then
			sampSendDialogResponse(8270, 1, 0, "")
		end
		if id == 8271 and sellfish.v then
			sampSendDialogResponse(8271, 1, 4, "")
		end
		if id == 8275 and sellfish.v then
			sampSendDialogResponse(8270, 1, 0, "")
		end

		local i = 0
		for item in text:gmatch("[^\r\n]+") do
			i = i + 1
			for key, val in pairs(fishs) do
		if item:find(val) ~= nil then
			sampSendDialogResponse(id, 1, i-1, "")
		end
		end
		sampSendDialogResponse(id, 0, 0, "")
	end

	if id == 8275 and sellfish.v then
		sampSendDialogResponse(8270, 0, 0, "")
	end

	if id == 8277 and sellfish.v then
		sampSendDialogResponse(8277, 1, 0, "")
	end
	if id == 8272 and sellfish.v then
		sampSendDialogResponse(8272, 1, 0, "")
	end

	if id == 8275 and sellfish.v then
		sampSendDialogResponse(8270, 0, 0, "")

	end
end


	if id == 1000 and takebait then
		local i = 0
		for item in text:gmatch("[^\r\n]+") do
			i = i + 1
				if item:find("��������.*") ~= nil then
					sampSendDialogResponse(id, 1, i-1, "")
					return false
				end
			end

		sampAddChatMessage("����������� ��������!", -1)

		return false

	end
	if id == 1001 and takebait then
		sampSendDialogResponse(1001, 1, 5, "")
		takebait = false
		myfloat = true
		closedd = true
		return false
	end
	if id == 1000 and closedd then
		sampSendDialogResponse(1000, 0, 0, "")
		sampSendChat("/fish")
		closedd = false
		myfloat = true
		return false
	end

	if id == 1000 and fishHook then
		local i = 0
		for item in text:gmatch("[^\r\n]+") do
			i = i + 1
			if item:find("���������� ������") ~= nil then
					sampSendDialogResponse(1000, 1, i-1, "")
			 		return false
			end
		end
		sampAddChatMessage("����������� ������!", -1)

		return false
	end
	if id == 1001 and fishHook then
		sampSendDialogResponse(1001, 1, 5, "")
		exithook = false
		fishHook = false
		takebait = true
		return false
	end
	if id == 999 then
		sampSendDialogResponse(999, 0, 0, "")
		exithook = true
		fishHook = false
		closedd2 = true
		return false
	end
	if exithook then
		sampSendDialogResponse(1001, 0, 0, "")
		exithook = false
		fishHook = false
		closedd2 = true
		return false
	end


if id == 1000 and fishrod then
	local i = 0
	for item in text:gmatch("[^\r\n]+") do
		i = i + 1
		if item:find("���� ����� ��� ������") ~= nil then
				sampSendDialogResponse(id, 1, i-1, "")
				return false
		end
	end
	sampAddChatMessage("������ ���", -1)
	fishHook = true
return false
end
if id == 1001 and fishrod then
	sampSendDialogResponse(1001, 1, 5, "")

	fishrod = false
fishHook = true
	return false
end
end
end




function sampev.onServerMessage(color, text)
	if active.v then
	local _, id = sampGetPlayerIdByCharHandle(playerPed)
	lua_thread.create(function()
		if text:find(sampGetPlayerNickname(id).." .* ������ � ����.") then
		myfloat = true
	end
	if text:find(sampGetPlayerNickname(id).." ������ .*") then
		local fishh = text:match(sampGetPlayerNickname(id).." ������ (.*)")
		cX = 0
		cY = 0
		sampAddChatMessage(fishh, -1)
		printStyledString("~w~+fish ~r~", 2000, 6)
			wait(100)
		takebait = true
		sampSendChat("/invex")
	end

	if text:find(sampGetPlayerNickname(id)..".*, �� ������ ��������� � ���� ������") then
		cX = 0
		cY = 0
		wait(100)
		fishHook = true
		sampSendChat("/invex")
	end
	if text:find(sampGetPlayerNickname(id).." .* ������ �� ���� ������ �� ������.") then
		cX = 0
		cY = 0
		wait(100)
		sampSendChat("/fish")
	end
	if text:find(sampGetPlayerNickname(id).." .* ����������� �� ���� .*, �� ���� ������������ � ������.") then
		cX = 0
		cY = 0
		takebait = true
		sampSendChat("/invex")
	end
end)
end
end



function sampev.onCreate3DText(id, color, position, distance, testLOS, attPid, attVid, text)
	if myfloat then
	for _, obj in pairs(getAllObjects()) do
			if getObjectModel(obj) == 18865 then
					local resultCoordsObject = { getObjectCoordinates(obj) }
					if resultCoordsObject[1] then
							--sampAddChatMessage(resultCoordsObject[2].." "..resultCoordsObject[3].." object", -1)
							myfloat = false
							cX = resultCoordsObject[2]
							cY = resultCoordsObject[3]
						end
					end
				end
			end
	local _, id = sampGetPlayerIdByCharHandle(playerPed)
			if text:find("o") then
				oX = position.x
				oY = position.y
				oZ = position.z
				--sampAddChatMessage(oX.." "..oY.." "..oZ, -1)
					if cX == oX and cY == oY then
		--sampAddChatMessage(oX.." "..oY.." 3dtext", -1)
		pecksCoin = pecksCoin + 1

end
end
end

function imgui.OnDrawFrame()
	if mainMenu.v then
		imgui.SetNextWindowSize(imgui.ImVec2(370, 300))
		imgui.SetNextWindowPos(imgui.ImVec2(rx / 2, ry / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
			imgui.Begin(u8(" GOS Checker | Trinity GTA"), mainMenu, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
			imgui.BeginChild("#UP_PANEL", imgui.ImVec2(355, 35), true)
			if imgui.Checkbox(u8'�������� �����������?', active) then

				end
			imgui.EndChild()
			if active.v then
				imgui.BeginChild("#SETTINGS_other", imgui.ImVec2(355, 220), true)
				imgui.Text(u8"�������� �������:")
				imgui.BeginChild("#SETTINGS_FLOAT", imgui.ImVec2(335, 100), true)
				imgui.Text("1) ")
				imgui.SameLine()
			if imgui.Button(u8"����� ������ + ��������� �����������", imgui.ImVec2(250, 24)) then
				fishrod = true
				sampSendChat("/invex")
			end
			imgui.SameLine()
			imgui.Button("(?)", imgui.ImVec2(25, 20))
			imgui.Hint(u8("�����������, ���� �� �� ������� � ����� ������, ����� �� ������, ������ ��� ������� ���"))


			imgui.Text("2) ")
			imgui.SameLine()
			if imgui.Button(u8"������ ������", imgui.ImVec2(250, 24)) then

				fishHook = true
				sampSendChat("/invex")
			end
			imgui.SameLine()
			imgui.Button("(?)", imgui.ImVec2(25, 20))
			imgui.Hint(u8("�����������, ���� ��� ������� � ����� ������, ����������� �������� ������ ������� ���"))


			imgui.Text("3) ")
			imgui.SameLine()
			if imgui.Button(u8"������ ��������", imgui.ImVec2(250, 24)) then

				takebait = true
				sampSendChat("/invex")
			end
			imgui.SameLine()
			imgui.Button("(?)", imgui.ImVec2(25, 20))
			imgui.Hint(u8("�����������, ���� ��� ����� ������, �������� ������� ���"))

			imgui.EndChild()
			imgui.Text("")
			imgui.Text(u8"������� ���� ������� ����:")
			imgui.BeginChild("#SETTINGS_sellfish", imgui.ImVec2(335, 40), true)
			if sellfish.v then
			if imgui.Button(u8"���� ������� ����, ���������?", imgui.ImVec2(250, 24)) then
				sellfish.v = false
			end
		else
			if imgui.Button(u8"���� ������� ����, ��������?", imgui.ImVec2(250, 24)) then
				sellfish.v = true
			end
		end
			imgui.SameLine()
			imgui.Button("(?)", imgui.ImVec2(25, 20))
			imgui.Hint(u8("���� ������� ����, ������ �������� � NPC, ������� �� alt"))
imgui.EndChild()
			imgui.EndChild()
		else
			imgui.Text(u8"^ ^ ^ ��� ������ ���������� �������� ������")
		end

		imgui.End()
	end
end

function imgui.Hint(text, delay)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5 -- �������� ���������
        if os.clock() >= go_hint then
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.GetStyle().Colors[imgui.Col.ButtonHovered])
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextUnformatted(text)
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar()
        end
    end
end

function darkgreentheme()
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildWindowRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    colors[clr.Text]                   = ImVec4(0.90, 0.90, 0.90, 1.00)
    colors[clr.TextDisabled]           = ImVec4(0.60, 0.60, 0.60, 1.00)
    colors[clr.WindowBg]               = ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[clr.ChildWindowBg]          = ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 1.00)
    colors[clr.Border]                 = ImVec4(0.70, 0.70, 0.70, 0.40)
    colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
    colors[clr.FrameBg]                = ImVec4(0.15, 0.15, 0.15, 1.00)
    colors[clr.FrameBgHovered]         = ImVec4(0.19, 0.19, 0.19, 0.71)
    colors[clr.FrameBgActive]          = ImVec4(0.34, 0.34, 0.34, 0.79)
    colors[clr.TitleBg]                = ImVec4(0.00, 0.69, 0.33, 0.80)
    colors[clr.TitleBgActive]          = ImVec4(0.00, 0.74, 0.36, 1.00)
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.69, 0.33, 0.50)
    colors[clr.MenuBarBg]              = ImVec4(0.00, 0.80, 0.38, 1.00)
    colors[clr.ScrollbarBg]            = ImVec4(0.16, 0.16, 0.16, 1.00)
    colors[clr.ScrollbarGrab]          = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.00, 1.00, 0.48, 1.00)
    colors[clr.ComboBg]                = ImVec4(0.20, 0.20, 0.20, 0.99)
    colors[clr.CheckMark]              = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.SliderGrab]             = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.SliderGrabActive]       = ImVec4(0.00, 0.77, 0.37, 1.00)
    colors[clr.Button]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ButtonHovered]          = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.ButtonActive]           = ImVec4(0.00, 0.87, 0.42, 1.00)
    colors[clr.Header]                 = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.HeaderHovered]          = ImVec4(0.00, 0.76, 0.37, 0.57)
    colors[clr.HeaderActive]           = ImVec4(0.00, 0.88, 0.42, 0.89)
    colors[clr.Separator]              = ImVec4(1.00, 1.00, 1.00, 0.40)
    colors[clr.SeparatorHovered]       = ImVec4(1.00, 1.00, 1.00, 0.60)
    colors[clr.SeparatorActive]        = ImVec4(1.00, 1.00, 1.00, 0.80)
    colors[clr.ResizeGrip]             = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.ResizeGripHovered]      = ImVec4(0.00, 0.76, 0.37, 1.00)
    colors[clr.ResizeGripActive]       = ImVec4(0.00, 0.86, 0.41, 1.00)
    colors[clr.CloseButton]            = ImVec4(0.00, 0.82, 0.39, 1.00)
    colors[clr.CloseButtonHovered]     = ImVec4(0.00, 0.88, 0.42, 1.00)
    colors[clr.CloseButtonActive]      = ImVec4(0.00, 1.00, 0.48, 1.00)
    colors[clr.PlotLines]              = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.PlotLinesHovered]       = ImVec4(0.00, 0.74, 0.36, 1.00)
    colors[clr.PlotHistogram]          = ImVec4(0.00, 0.69, 0.33, 1.00)
    colors[clr.PlotHistogramHovered]   = ImVec4(0.00, 0.80, 0.38, 1.00)
    colors[clr.TextSelectedBg]         = ImVec4(0.00, 0.69, 0.33, 0.72)
    colors[clr.ModalWindowDarkening]   = ImVec4(0.17, 0.17, 0.17, 0.48)
end
darkgreentheme()
