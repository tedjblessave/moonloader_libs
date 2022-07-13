script_name("timecyc-24h-editor")
script_author("Guru_Guru")
script_url("https://gtaforums.com/topic/910061-in-game-24h-timecycle-editor/")

bEnable = true
AutoSaveTimer = 300000 -- ms
DarkTheme = false
AutoResize = false
Window = {
	PosX = 10,
	PosY = 10,
	SizeX = 150,
	SizeY = 320
}
InvertCamYAxis = true
InvertCamXAxis = false

local vkeys = require "vkeys"
local ffi = require "ffi"
local memory = require "memory"
local imgui = require "imgui"
local bit = require "bit"

local weather = {
	[0]  = "EXTRASUNNY_LA",
	[1]  = "SUNNY_LA",
	[2]  = "EXTRASUNNY_SMOG_LA",
	[3]  = "SUNNY_SMOG_LA",
	[4]  = "CLOUDY_LA",
	[5]  = "SUNNY_SF",
	[6]  = "EXTRASUNNY_SF",
	[7]  = "CLOUDY_SF",
	[8]  = "RAINY_SF",
	[9]  = "FOGGY_SF",
	[10] = "SUNNY_VEGAS",
	[11] = "EXTRASUNNY_VEGAS",
	[12] = "CLOUDY_VEGAS",
	[13] = "EXTRASUNNY_COUNTRYSIDE",
	[14] = "SUNNY_COUNTRYSIDE",
	[15] = "CLOUDY_COUNTRYSIDE",
	[16] = "RAINY_COUNTRYSIDE",
	[17] = "EXTRASUNNY_DESERT",
	[18] = "SUNNY_DESERT",
	[19] = "SANDSTORM_DESERT",
	[20] = "UNDERWATER",
	[21] = "EXTRACOLOURS_1",
	[22] = "EXTRACOLOURS_2"
}

local CTimeCycle = {
	m_nAmbientRed 				= ffi.cast("unsigned char*", memory.getuint32(0x560C61)),
	m_nAmbientGreen 			= ffi.cast("unsigned char*", memory.getuint32(0x55F4D6)),
	m_nAmbientBlue 				= ffi.cast("unsigned char*", memory.getuint32(0x55F4E8)),
	m_nAmbientRed_Obj 			= ffi.cast("unsigned char*", memory.getuint32(0x55F4FA)),
	m_nAmbientGreen_Obj 		= ffi.cast("unsigned char*", memory.getuint32(0x55F50C)),
	m_nAmbientBlue_Obj 			= ffi.cast("unsigned char*", memory.getuint32(0x55F51E)),
	m_nSkyTopRed 				= ffi.cast("unsigned char*", memory.getuint32(0x55F531)),
	m_nSkyTopGreen 				= ffi.cast("unsigned char*", memory.getuint32(0x55F53D)),
	m_nSkyTopBlue 				= ffi.cast("unsigned char*", memory.getuint32(0x55F549)),
	m_nSkyBottomRed				= ffi.cast("unsigned char*", memory.getuint32(0x55F555)),
	m_nSkyBottomGreen 			= ffi.cast("unsigned char*", memory.getuint32(0x55F561)),
	m_nSkyBottomBlue 			= ffi.cast("unsigned char*", memory.getuint32(0x55F56D)),
	m_nSunCoreRed 				= ffi.cast("unsigned char*", memory.getuint32(0x55F579)),
	m_nSunCoreGreen 			= ffi.cast("unsigned char*", memory.getuint32(0x55F585)),
	m_nSunCoreBlue 				= ffi.cast("unsigned char*", memory.getuint32(0x55F591)),
	m_nSunCoronaRed 			= ffi.cast("unsigned char*", memory.getuint32(0x55F59D)),
	m_nSunCoronaGreen 			= ffi.cast("unsigned char*", memory.getuint32(0x55F5A9)),
	m_nSunCoronaBlue 			= ffi.cast("unsigned char*", memory.getuint32(0x55F5B5)),
	m_fSunSize 					= ffi.cast("unsigned char*", memory.getuint32(0x55F5C0)),
	m_fSpriteSize 				= ffi.cast("unsigned char*", memory.getuint32(0x55F5D2)),
	m_fSpriteBrightness 		= ffi.cast("unsigned char*", memory.getuint32(0x55F5E4)),
	m_nShadowStrength 			= ffi.cast("unsigned char*", memory.getuint32(0x55F5F7)),
	m_nLightShadowStrength		= ffi.cast("unsigned char*", memory.getuint32(0x55F603)),
	m_nPoleShadowStrength 		= ffi.cast("unsigned char*", memory.getuint32(0x55F60F)),
	m_fFarClip 					= ffi.cast("short*", memory.getuint32(0x55F61B)),
	m_fFogStart 				= ffi.cast("short*", memory.getuint32(0x55F62E)),
	m_fLightsOnGroundBrightness = ffi.cast("unsigned char*", memory.getuint32(0x55F640)),
	m_nLowCloudsRed 			= ffi.cast("unsigned char*", memory.getuint32(0x55F653)),
	m_nLowCloudsGreen 			= ffi.cast("unsigned char*", memory.getuint32(0x55F65F)),
	m_nLowCloudsBlue 			= ffi.cast("unsigned char*", memory.getuint32(0x55F66B)),
	m_nFluffyCloudsBottomRed 	= ffi.cast("unsigned char*", memory.getuint32(0x55F677)),
	m_nFluffyCloudsBottomGreen 	= ffi.cast("unsigned char*", memory.getuint32(0x55F683)),
	m_nFluffyCloudsBottomBlue 	= ffi.cast("unsigned char*", memory.getuint32(0x55F690)),
	m_fWaterRed 				= ffi.cast("unsigned char*", memory.getuint32(0x55F69C)),
	m_fWaterGreen 				= ffi.cast("unsigned char*", memory.getuint32(0x55F6B0)),
	m_fWaterBlue 				= ffi.cast("unsigned char*", memory.getuint32(0x55F6C3)),
	m_fWaterAlpha 				= ffi.cast("unsigned char*", memory.getuint32(0x55F6D6)),
	m_fPostFx1Red 				= ffi.cast("unsigned char*", memory.getuint32(0x55F6E9)),
	m_fPostFx1Green 			= ffi.cast("unsigned char*", memory.getuint32(0x55F6FC)),
	m_fPostFx1Blue 				= ffi.cast("unsigned char*", memory.getuint32(0x55F70F)),
	m_fPostFx1Alpha 			= ffi.cast("unsigned char*", memory.getuint32(0x55F725)),
	m_fPostFx2Red 				= ffi.cast("unsigned char*", memory.getuint32(0x55F73B)),
	m_fPostFx2Green 			= ffi.cast("unsigned char*", memory.getuint32(0x55F751)),
	m_fPostFx2Blue 				= ffi.cast("unsigned char*", memory.getuint32(0x55F767)),
	m_fPostFx2Alpha 			= ffi.cast("unsigned char*", memory.getuint32(0x55F77D)),
	m_fCloudAlpha 				= ffi.cast("unsigned char*", memory.getuint32(0x55F793)),
	m_nHighLightMinIntensity 	= ffi.cast("unsigned char*", memory.getuint32(0x55F7A9)),
	m_nWaterFogAlpha 			= ffi.cast("unsigned char*", memory.getuint32(0x55F7B8)),
	m_nDirectionalMult 			= ffi.cast("unsigned char*", memory.getuint32(0x55F7C7)),
	-- funcs
	Initialise 					= ffi.cast("void (__cdecl*)(void)", 0x5BBAC0)
}

-- CMouseControllerState, from Plugin-SDK
ffi.cdef([[
	struct CMouseControllerState {
		unsigned char lmb;
		unsigned char rmb;
		unsigned char mmb;
		unsigned char wheelUp;
		unsigned char wheelDown;
		unsigned char bmx1;
		unsigned char bmx2;
		char __align;
		float Z;
		float X;
		float Y;
	};
]])

local mouseState 	= ffi.cast("struct CMouseControllerState*", 0xB73418)
local CurrWeather 	= ffi.cast("short*", 0xC81320)
local NextWeather 	= ffi.cast("short*", 0xC8131C)
local Hours 		= ffi.cast("unsigned char*", 0xB70153)
local Minutes 		= ffi.cast("unsigned char*", 0xB70152)
local Seconds 		= ffi.cast("unsigned short*", 0xB70150)
local TimeScale 	= ffi.cast("unsigned int*", 0xB7015C)
local NUMWEATHERS 	= 23
-- local NUMHOURS 	= 8
local sx, sy = getScreenResolution()
local Im = {
	bMainWindowActive 	= imgui.ImBool(false),
	bLockClock 			= imgui.ImBool(false),
	bLockPlayerControl 	= imgui.ImBool(false),
	CurrWeather 		= imgui.ImInt(CurrWeather[0]),
	NextWeather 		= imgui.ImInt(NextWeather[0]),
}



function main()

	if DarkTheme then ApplyCustomStyle() end

	if getModuleHandle("timecycle24.asi") ~= 0 or getModuleHandle("timecycle24") ~= 0 then
		NUMHOURS = 24
		bTimecyc24h = true
	else
		NUMHOURS = 8
		bTimecyc24h = false
	end

	local timerStop = AutoSaveTimer + getGameTimer()

	while bEnable do

		wait(0)

		if getGameTimer() >= timerStop and Im.bMainWindowActive.v then
			CTimeCycle.SaveToFile("timecyc_bak")
			timerStop = getGameTimer() + AutoSaveTimer
		end

		if isKeyDown(vkeys.VK_CONTROL) and isKeyJustPressed(vkeys.VK_T)
		then

			Im.bMainWindowActive.v = not Im.bMainWindowActive.v
			if Im.bMainWindowActive.v then
				Im.CurrWeather.v = CurrWeather[0]
				Im.NextWeather.v = NextWeather[0]
			else
				releaseWeather()
			end
			MakePlayerSafe(Im.bMainWindowActive.v)
		end


		
		if imgui.Process then			
			DragCameraAround()
		else
			-- 'cleanup'
			if Im.bLockClock.v then 
				CClock__Update(true) 
				Im.bLockClock.v = false
			end
			if Im.bLockPlayerControl then 
				lockPlayerControl(false) 
				Im.bLockPlayerControl.v = false
			end
		end
		
		imgui.Process = Im.bMainWindowActive.v
	end
end


function ApplyCustomStyle()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4

	style.WindowRounding = 2.0
	style.WindowTitleAlign = imgui.ImVec2(0.5, 0.84)
	style.ChildWindowRounding = 2.0
	style.FrameRounding = 2.0
	style.ItemSpacing = imgui.ImVec2(5.0, 4.0)
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 0
	style.GrabMinSize = 8.0
	style.GrabRounding = 1.0

	colors[clr.Text]                   = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]           = ImVec4(0.50, 0.50, 0.50, 1.00)
	colors[clr.WindowBg]               = ImVec4(0.06, 0.06, 0.06, 0.94)
	colors[clr.ChildWindowBg]          = ImVec4(1.00, 1.00, 1.00, 0.00)
	colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.ComboBg]                = colors[clr.PopupBg]
	colors[clr.Border]                 = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow]           = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg]                = ImVec4(0.16, 0.29, 0.48, 0.54)
	colors[clr.FrameBgHovered]         = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.FrameBgActive]          = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.TitleBg]                = ImVec4(0.04, 0.04, 0.04, 1.00)
	colors[clr.TitleBgActive]          = ImVec4(0.16, 0.29, 0.48, 1.00)
	colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.MenuBarBg]              = ImVec4(0.14, 0.14, 0.14, 1.00)
	colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.53)
	colors[clr.ScrollbarGrab]          = ImVec4(0.31, 0.31, 0.31, 1.00)
	colors[clr.ScrollbarGrabHovered]   = ImVec4(0.41, 0.41, 0.41, 1.00)
	colors[clr.ScrollbarGrabActive]    = ImVec4(0.51, 0.51, 0.51, 1.00)
	colors[clr.CheckMark]              = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.SliderGrab]             = ImVec4(0.24, 0.52, 0.88, 1.00)
	colors[clr.SliderGrabActive]       = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Button]                 = ImVec4(0.26, 0.59, 0.98, 0.40)
	colors[clr.ButtonHovered]          = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ButtonActive]           = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header]                 = ImVec4(0.26, 0.59, 0.98, 0.31)
	colors[clr.HeaderHovered]          = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive]           = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.Separator]              = colors[clr.Border]
	colors[clr.SeparatorHovered]       = ImVec4(0.26, 0.59, 0.98, 0.78)
	colors[clr.SeparatorActive]        = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip]             = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered]      = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive]       = ImVec4(0.26, 0.59, 0.98, 0.95)
	colors[clr.CloseButton]            = ImVec4(0.41, 0.41, 0.41, 0.50)
	colors[clr.CloseButtonHovered]     = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.CloseButtonActive]      = ImVec4(0.98, 0.39, 0.36, 1.00)
	colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram]          = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg]         = ImVec4(0.26, 0.59, 0.98, 0.35)
	colors[clr.ModalWindowDarkening]   = ImVec4(0.80, 0.80, 0.80, 0.35)
end


function imgui.OnDrawFrame()
	if Im.bMainWindowActive.v then

		local i = NUMWEATHERS * CTimeCycle.GetCurrentHourTimeId() + CurrWeather[0]
		Im.Update()
	
		CurrWeather[0] = Im.CurrWeather.v
		NextWeather[0] = Im.NextWeather.v

		imgui.SetNextWindowPos(imgui.ImVec2(Window.PosX, Window.PosY),imgui.Cond.FirstUseEver)

		if not AutoResize then
			imgui.SetNextWindowSize(imgui.ImVec2(Window.SizeX * (sx/648) , Window.SizeY * (sy/448)), imgui.Cond.FirstUseEver)
			imgui.Begin("Timecyc "..NUMHOURS.."h Editor", Im.bMainWindowActive, nil)
		else
			imgui.Begin("Timecyc "..NUMHOURS.."h Editor", Im.bMainWindowActive, imgui.WindowFlags.AlwaysAutoResize)
		end



		if imgui.Checkbox("Stop Clock", Im.bLockClock) then
			CClock__Update(not Im.bLockClock.v)
		end
		imgui.SameLine()
		if imgui.Checkbox("Lock Player Control", Im.bLockPlayerControl) then
			lockPlayerControl(Im.bLockPlayerControl.v)
		end
	
		if imgui.Combo("Current Weather", Im.CurrWeather, weather, #weather) then
			CurrWeather[0] = Im.CurrWeather.v
		end

		if imgui.Combo("Next Weather", Im.NextWeather, weather, #weather) then
			NextWeather[0] = Im.NextWeather.v
		end

		if imgui.SliderInt("Hours", Im.Hours, 0, 23, "%.0f") then Hours[0] = Im.Hours.v end

		if imgui.SliderInt("Minutes", Im.Mins, 0, 59, "%.0f") then Minutes[0] = Im.Mins.v end

		if imgui.ColorEdit3("Ambient", Im.AmbRGB) then
			CTimeCycle.m_nAmbientRed[i], CTimeCycle.m_nAmbientGreen[i], CTimeCycle.m_nAmbientBlue[i] = (imgui.ImColor(Im.AmbRGB)):GetRGBA()
		end

		if imgui.ColorEdit3("Ambient Obj", Im.AmbObjRGB) then
			CTimeCycle.m_nAmbientRed_Obj[i], CTimeCycle.m_nAmbientGreen_Obj[i], CTimeCycle.m_nAmbientBlue_Obj[i] = (imgui.ImColor(Im.AmbObjRGB)):GetRGBA()
		end

		if imgui.ColorEdit3("Sky Top", Im.SkyTopRGB) then
			CTimeCycle.m_nSkyTopRed[i], CTimeCycle.m_nSkyTopGreen[i], CTimeCycle.m_nSkyTopBlue[i] = (imgui.ImColor(Im.SkyTopRGB)):GetRGBA()
		end

		if imgui.ColorEdit3("Sky Bottom", Im.SkyBottomRGB) then
			CTimeCycle.m_nSkyBottomRed[i], CTimeCycle.m_nSkyBottomGreen[i], CTimeCycle.m_nSkyBottomBlue[i] = (imgui.ImColor(Im.SkyBottomRGB)):GetRGBA()
		end

		if imgui.ColorEdit3("Sun Core", Im.SunCoreRGB) then
			CTimeCycle.m_nSunCoreRed[i], CTimeCycle.m_nSunCoreGreen[i], CTimeCycle.m_nSunCoreBlue[i] = (imgui.ImColor(Im.SunCoreRGB)):GetRGBA()
		end

		if imgui.ColorEdit3("Sun Corona", Im.SunCoronaRGB) then
			CTimeCycle.m_nSunCoronaRed[i], CTimeCycle.m_nSunCoronaGreen[i], CTimeCycle.m_nSunCoronaBlue[i] = (imgui.ImColor(Im.SunCoronaRGB)):GetRGBA()
		end

		if imgui.SliderInt("Sun Size", Im.SunSz, 0, 127) then
			CTimeCycle.m_fSunSize[i] = Im.SunSz.v
		end

		if imgui.SliderInt("Sprite Size", Im.SpriteSz, 0, 127) then
			CTimeCycle.m_fSpriteSize[i] = Im.SpriteSz.v
		end

		if imgui.InputInt("Sprite Brightness", Im.SpriteBrght, 1, 10) then
			CTimeCycle.m_fSpriteBrightness[i] = Im.SpriteBrght.v
		end

		if imgui.SliderInt("Shadows Strength", Im.ShadowStr, 0, 255) then
			CTimeCycle.m_nShadowStrength[i] = Im.ShadowStr.v
		end

		if imgui.SliderInt("Pole Shadows Strength", Im.PoleShadowStr, 0, 255) then
			CTimeCycle.m_nPoleShadowStrength[i] = Im.PoleShadowStr.v
		end

		if imgui.SliderInt("Light Shadows Strength", Im.LightShadowStrength, 0, 255) then
			CTimeCycle.m_nLightShadowStrength[i] = Im.LightShadowStrength.v
		end

		if imgui.InputInt("Far Clip", Im.FarClip, 1, 10) then
			CTimeCycle.m_fFarClip[i] = Im.FarClip.v
		end

		if imgui.InputInt("Fog Start", Im.FogStart, 1, 10) then
			CTimeCycle.m_fFogStart[i] = Im.FogStart.v
		end

		if imgui.SliderInt("Light On Ground Brightness", Im.LightsOnGroundBrightness, 0, 255) then
			CTimeCycle.m_fLightsOnGroundBrightness[i] = Im.LightsOnGroundBrightness.v
		end

		if imgui.ColorEdit3("Low Clouds", Im.LowCloudsRGB) then
			CTimeCycle.m_nLowCloudsRed[i], CTimeCycle.m_nLowCloudsGreen[i], CTimeCycle.m_nLowCloudsBlue[i] = (imgui.ImColor(Im.LowCloudsRGB)):GetRGBA()
		end
		if imgui.ColorEdit3("Fluffy Clouds", Im.FluffyCloudsBotttomRGB) then
			CTimeCycle.m_nFluffyCloudsBottomRed[i], CTimeCycle.m_nFluffyCloudsBottomGreen[i], CTimeCycle.m_nFluffyCloudsBottomBlue[i] = (imgui.ImColor(Im.FluffyCloudsBotttomRGB)):GetRGBA()
		end

		if imgui.ColorEdit4("Water", Im.WaterRGBA) then
			CTimeCycle.m_fWaterRed[i], CTimeCycle.m_fWaterGreen[i], CTimeCycle.m_fWaterBlue[i], CTimeCycle.m_fWaterAlpha[i] = (imgui.ImColor(Im.WaterRGBA)):GetRGBA()
		end

		if imgui.ColorEdit4("PostFx1", Im.PostFx1RGBA) then
			CTimeCycle.m_fPostFx1Red[i], CTimeCycle.m_fPostFx1Green[i], CTimeCycle.m_fPostFx1Blue[i], CTimeCycle.m_fPostFx1Alpha[i] = (imgui.ImColor(Im.PostFx1RGBA)):GetRGBA()
		end

		if imgui.ColorEdit4("PostFx2", Im.PostFx2RGBA) then
			CTimeCycle.m_fPostFx2Red[i], CTimeCycle.m_fPostFx2Green[i], CTimeCycle.m_fPostFx2Blue[i], CTimeCycle.m_fPostFx2Alpha[i] = (imgui.ImColor(Im.PostFx2RGBA)):GetRGBA()
		end

		if imgui.SliderInt("CloudAlpha", Im.CloudAlpha, 0, 255) then
			CTimeCycle.m_fCloudAlpha[i] = Im.CloudAlpha.v
		end

		if imgui.SliderInt("HighLightMinIntensity", Im.HighLightMinIntensity, 0 ,255) then
			CTimeCycle.m_nHighLightMinIntensity[i] = Im.HighLightMinIntensity.v
		end

		if imgui.SliderInt("WaterFogAlpha", Im.WaterFogAlpha, 0, 255) then
			CTimeCycle.m_nWaterFogAlpha[i] = Im.WaterFogAlpha.v
		end
		if imgui.SliderInt("DirectionalMult", Im.DirectionalMult, 0, 255) then
			CTimeCycle.m_nDirectionalMult[i] = Im.DirectionalMult.v
		end

		if imgui.Button("Save Timecyc") then
			CTimeCycle.SaveToFile("timecyc")
			printStringNow("Timecyc created!", 1000)
		end

		imgui.SameLine()

		if imgui.Button("Reset Timecyc") then
			CTimeCycle.Initialise()
		end

		imgui.End()
	end
end


function Im.Update()

	local i = NUMWEATHERS * CTimeCycle.GetCurrentHourTimeId() + CurrWeather[0]

	Im.Hours 					= imgui.ImInt(Hours[0])
	Im.Mins 					= imgui.ImInt(Minutes[0])
	Im.Seconds 					= imgui.ImInt(Seconds[0])
	Im.TimeScale 				= imgui.ImInt(TimeScale[0])
	Im.AmbRGB 					= (imgui.ImColor(CTimeCycle.m_nAmbientRed[i], CTimeCycle.m_nAmbientGreen[i], CTimeCycle.m_nAmbientBlue[i])):GetVec4()
	Im.AmbObjRGB 				= (imgui.ImColor(CTimeCycle.m_nAmbientRed_Obj[i], CTimeCycle.m_nAmbientGreen_Obj[i], CTimeCycle.m_nAmbientBlue_Obj[i])):GetVec4()
	Im.SkyTopRGB 				= (imgui.ImColor(CTimeCycle.m_nSkyTopRed[i], CTimeCycle.m_nSkyTopGreen[i], CTimeCycle.m_nSkyTopBlue[i])):GetVec4()
	Im.SkyBottomRGB 			= (imgui.ImColor(CTimeCycle.m_nSkyBottomRed[i], CTimeCycle.m_nSkyBottomGreen[i], CTimeCycle.m_nSkyBottomBlue[i])):GetVec4()
	Im.SunCoreRGB 				= (imgui.ImColor(CTimeCycle.m_nSunCoreRed[i], CTimeCycle.m_nSunCoreGreen[i], CTimeCycle.m_nSunCoreBlue[i])):GetVec4()
	Im.SunCoronaRGB 			= (imgui.ImColor(CTimeCycle.m_nSunCoronaRed[i], CTimeCycle.m_nSunCoronaGreen[i], CTimeCycle.m_nSunCoronaBlue[i])):GetVec4()
	Im.SunSz 					= imgui.ImInt(CTimeCycle.m_fSunSize[i])
	Im.SpriteSz 				= imgui.ImInt(CTimeCycle.m_fSpriteSize[i])
	Im.SpriteBrght 				= imgui.ImInt(CTimeCycle.m_fSpriteBrightness[i])
	Im.ShadowStr 				= imgui.ImInt(CTimeCycle.m_nShadowStrength[i])
	Im.PoleShadowStr 			= imgui.ImInt(CTimeCycle.m_nPoleShadowStrength[i])
	Im.LightShadowStrength 		= imgui.ImInt(CTimeCycle.m_nLightShadowStrength[i])
	Im.FarClip 					= imgui.ImInt(CTimeCycle.m_fFarClip[i])
	Im.FogStart 				= imgui.ImInt(CTimeCycle.m_fFogStart[i])
	Im.LightsOnGroundBrightness = imgui.ImInt(CTimeCycle.m_fLightsOnGroundBrightness[i])
	Im.LowCloudsRGB 			= (imgui.ImColor(CTimeCycle.m_nLowCloudsRed[i], CTimeCycle.m_nLowCloudsGreen[i], CTimeCycle.m_nLowCloudsBlue[i])):GetVec4()
	Im.FluffyCloudsBotttomRGB 	= (imgui.ImColor(CTimeCycle.m_nFluffyCloudsBottomRed[i], CTimeCycle.m_nFluffyCloudsBottomGreen[i], CTimeCycle.m_nFluffyCloudsBottomBlue[i])):GetVec4()
	Im.WaterRGBA 				= (imgui.ImColor(CTimeCycle.m_fWaterRed[i], CTimeCycle.m_fWaterGreen[i], CTimeCycle.m_fWaterBlue[i], CTimeCycle.m_fWaterAlpha[i])):GetVec4()
	Im.PostFx1RGBA 				= (imgui.ImColor(CTimeCycle.m_fPostFx1Red[i], CTimeCycle.m_fPostFx1Green[i], CTimeCycle.m_fPostFx1Blue[i], CTimeCycle.m_fPostFx1Alpha[i])):GetVec4()
	Im.PostFx2RGBA 				= (imgui.ImColor(CTimeCycle.m_fPostFx2Red[i], CTimeCycle.m_fPostFx2Green[i], CTimeCycle.m_fPostFx2Blue[i], CTimeCycle.m_fPostFx2Alpha[i])):GetVec4()
	Im.CloudAlpha 				= imgui.ImInt(CTimeCycle.m_fCloudAlpha[i])
	Im.HighLightMinIntensity 	= imgui.ImInt(CTimeCycle.m_nHighLightMinIntensity[i])
	Im.WaterFogAlpha 			= imgui.ImInt(CTimeCycle.m_nWaterFogAlpha[i])
	Im.DirectionalMult 			= imgui.ImInt(CTimeCycle.m_nDirectionalMult[i])
end


-- Timecyc Stuff
function CTimeCycle.GetCurrentHourTimeId()
	local h = Hours[0]
	local id = nil
	if bTimecyc24h then return h end

	if h < 5 then  id = 0 end
	if h == 5 then  id = 1 end
	if h == 6 then  id = 2 end
	if 7 <= h and h < 12 then  id = 3 end
	if 12 <= h and h < 19 then  id = 4 end
	if h == 19 then  id = 5 end
	if h == 20 or h == 21 then  id = 6 end
	if h == 22 or h == 23 then  id = 7 end
	return id
end


function CTimeCycle.SaveToFile(filename)
	local timecycdat = io.open(getWorkingDirectory().."/"..filename .. ".dat", "w")
	local tc = CTimeCycle
	-- timecycdat:write("// TimeCycle created using Timecyc24h Editor\n// Be sure to check "..URL.." for updates!\n")

	for w = 0, NUMWEATHERS - 1 do
		timecycdat:write("//\n" .. "///////////////////////////////////////////" .. weather[w] .. " \n" .. "//\n")

		for h = 0, NUMHOURS - 1 do
			local i = NUMWEATHERS * h + w

			if bTimecyc24h then
				if (h >= 12) then
					if (h == 12) then
						timecycdat:write("// Midday \n")
					else
						timecycdat:write("// " .. (h - 12) .. "PM \n")
					end
				else
					if h == 0 then
						timecycdat:write("// Midnight \n")
					else
						timecycdat:write("// " .. h .. "AM \n")
					end
				end
			else
				if h == 0 then timecycdat:write("// Midnight\n") end
				if h == 1 then timecycdat:write("// 5 AM\n") end
				if h == 2 then timecycdat:write("// 6 AM\n") end
				if h == 3 then timecycdat:write("// 7 AM\n") end
				if h == 4 then timecycdat:write("// Midday\n") end
				if h == 5 then timecycdat:write("// 7 PM\n") end
				if h == 6 then timecycdat:write("// 8 PM\n") end
				if h == 7 then timecycdat:write("// 10 PM\n") end
			end


			-- timecycdat:write("// "..j.." \n")

			if (h == 0 or h == 12 and not bTimecyc24h) then
				timecycdat:write("//\tAmb\t\t\t\t\tAmb_Obj \t\t\t\tDir \t\t\t\t\tSky top\t\t\t\tSky bot\t\t\t\tSunCore\t\t\tSunCorona\t\t\tSunSz\t\tSprSz\tSprBght\t\tShdw\t\t\tLightShd\t\t\tPoleShd\t\t\tFarClp\t\t\tFogSt\t\t\tLightOnGround\t\t\tLowCloudsRGB\t\t\tBottomCloudRGB\t\t\tWaterRGBA\t\t\tAlpha1    RGB1\t\t\tAlpha2    RGB2\t\t\tCloudAlpha\t\t\tIntensityLimit\t\t\tWaterFogAlpha\t\t\tDirMult \n")
			end
			timecycdat:write(
				string.format(
					"\t%d %d %d \t\t" .. -- AmbRGB
					"\t%d %d %d \t\t" .. -- AmbObjRGB
					"\t%d %d %d \t\t" .. -- DirRGB (unused?)
					"\t%d %d %d \t\t" .. -- SkyTopRGB
					"\t%d %d %d \t\t" .. -- SkyBotRGB
					"\t%d %d %d \t\t" .. -- SunCore RGB
					"\t%d %d %d \t\t" .. -- SunCorona RGB
					"\t%.1f\t\t%.1f\t\t%.1f\t\t" .. -- SunSz, SpriteSz, SpriteBrightness
					"\t%d %d %d\t\t" .. -- ShadStrenght, LightShadStreght, PoleShadStrenght
					"\t%.1f\t\t%.1f\t\t%.1f\t\t" .. -- fFarClip, fFogStart, fLightsOnGroundBrightness
					"\t%d %d %d\t\t" .. -- LowCloudsRGB
					"\t%d %d %d\t\t" .. -- FluffyCloudsRGB
					"\t%d %d %d %d\t\t" .. -- WaterRGBA
					"\t%d %d %d %d\t\t" .. -- PostFx1ARGB
					"\t%d %d %d %d\t\t" .. -- PostFx2ARGB
					"\t%d\t%d\t%d\t%.2f\t\t\n", -- CloudAlpha HiLiMinIntensity WaterFogAlpha DirectionalMult
					tc.m_nAmbientRed[i], tc.m_nAmbientGreen[i],	tc.m_nAmbientBlue[i],
					tc.m_nAmbientRed_Obj[i], tc.m_nAmbientGreen_Obj[i],	tc.m_nAmbientBlue_Obj[i],
					255, 255, 255,
					tc.m_nSkyTopRed[i],	tc.m_nSkyTopGreen[i], tc.m_nSkyTopBlue[i],
					tc.m_nSkyBottomRed[i], tc.m_nSkyBottomGreen[i],	tc.m_nSkyBottomBlue[i],
					tc.m_nSunCoreRed[i],tc.m_nSunCoreGreen[i],tc.m_nSunCoreBlue[i],
					tc.m_nSunCoronaRed[i], tc.m_nSunCoronaGreen[i], tc.m_nSunCoronaBlue[i],
					(tc.m_fSunSize[i] - 0.5) / 10.0,(tc.m_fSpriteSize[i] - 0.5) / 10.0,(tc.m_fSpriteBrightness[i] - 0.5) / 10.0,
					tc.m_nShadowStrength[i],tc.m_nLightShadowStrength[i],tc.m_nPoleShadowStrength[i],
					tc.m_fFarClip[i],tc.m_fFogStart[i],	(tc.m_fLightsOnGroundBrightness[i] - 0.5) / 10.0,
					tc.m_nLowCloudsRed[i],tc.m_nLowCloudsGreen[i],tc.m_nLowCloudsBlue[i],
					tc.m_nFluffyCloudsBottomRed[i],tc.m_nFluffyCloudsBottomGreen[i],tc.m_nFluffyCloudsBottomBlue[i],
					tc.m_fWaterRed[i],tc.m_fWaterGreen[i],tc.m_fWaterBlue[i],tc.m_fWaterAlpha[i],
					tc.m_fPostFx1Alpha[i],tc.m_fPostFx1Red[i],tc.m_fPostFx1Green[i],tc.m_fPostFx1Blue[i],
					tc.m_fPostFx2Alpha[i],tc.m_fPostFx2Red[i],tc.m_fPostFx2Green[i],tc.m_fPostFx2Blue[i],
					tc.m_fCloudAlpha[i],tc.m_nHighLightMinIntensity[i],	tc.m_nWaterFogAlpha[i],	tc.m_nDirectionalMult[i] / 100.0
				)
			)
		end
	end
	io.close(timecycdat)
end


function CClock__Update(bool)
	if bool then
		memory.write(0x53BFBD, 0xFF0F4EE8, 4, false)
		memory.write(0x53BFC1, 0xFF, 1, false)
		setTimeOfDay(Hours[0], Minutes[0])
	else
		memory.fill(0x53BFBD, 0x90, 5, false)
	end
end


function CPlayerData_bCanBeDamaged(bool)
	local CPlayerData = memory.getuint32( getCharPointer(PLAYER_PED) + 0x480)
	local CPlayerData__m_dwPlayerFlags = memory.getuint32(CPlayerData + 0x34)
	
	if bool then
		CPlayerData__m_dwPlayerFlags = bit.bor(CPlayerData__m_dwPlayerFlags, 0x10)
	else
		CPlayerData__m_dwPlayerFlags = bit.band(CPlayerData__m_dwPlayerFlags, 0xFFFFFFEF)
	end

	memory.setuint32( CPlayerData + 0x34, CPlayerData__m_dwPlayerFlags )
end


function DragCameraAround()
	local dragDelta = imgui.GetMouseDragDelta(1) -- 0 - LMB , 1 - RMB
	if InvertCamYAxis then
		mouseState.Y = -dragDelta.y / 10
	else
		mouseState.Y = dragDelta.y / 10
	end

	if InvertCamXAxis then
		mouseState.X = -dragDelta.x / 10
	else
		mouseState.X = dragDelta.x / 10
	end
end


function MakePlayerSafe(bool)
	-- exactly the same but without touching pads.
	if bool then
		memory.fill(0x56E89D, 0x90, 7)
	else
		memory.write(0x56E89D, 0x010E8F80, 4)
		memory.write(0x56E89D + 0x3, 0x20000001, 4)
	end

	setPlayerControl(PLAYER_HANDLE, not bool)
end