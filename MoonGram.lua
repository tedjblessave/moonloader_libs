--[[
    VERSION: 1.0.1
    MoonGram -> https://www.blast.hk/threads/123751/
    By -> TG: @tricksterlox
]]--

local effil      = require('effil')
local dkjson     = require('dkjson')
local multipart  = require('multipart-post')

local encoding   = require('encoding')
encoding.default = 'CP1251'
u8               = encoding.UTF8

local Telegram = {} 

local function telegramRequest(requestMethod, telegramMethod, requestParameters, requestFile, botToken, debugMode)
    --[[ Arguments Part ]]--
    --[[ Argument #1 (requestMethod) ]]--
    local requestMethod = requestMethod or 'POST'
    if (type(requestMethod) ~= 'string') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #1(requestMethod) Must Be String.')
    end
    if (requestMethod ~= 'POST' and requestMethod ~= 'GET' and requestMethod ~= 'PUT' and requestMethod ~= 'DETELE') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #1(requestMethod) Dont Have "%s" Request Method.', tostring(requestMethod))
    end
    --[[ Argument #2 (telegramMethod) ]]--
    local telegramMethod = telegramMethod or nil
    if (type(requestMethod) ~= 'string') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #2(telegramMethod) Must Be String.\nCheck: https://core.telegram.org/bots/api')
    end
    --[[ Argument #3 (requestParameters) ]]--
    local requestParameters = requestParameters or {}
    if (type(requestParameters) ~= 'table') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #3(requestParameters) Must Be Table.')
    end
    for key, value in ipairs(requestParameters) do
        if (#requestParameters ~= 0) then
            requestParameters[key] = tostring(value)
        else 
            requestParameters = {''}
        end
    end
    --[[ Argument #4 (botToken) ]]--
    local botToken = botToken or nil
    if (type(botToken) ~= 'string') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #4(botToken) Must Be String.')
    end
    --[[ Argument #5 (debugMode) ]]--
    local debugMode = debugMode or false
    if (type(debugMode) ~= 'boolean') then
        error('[MoonGram Error] In Function "telegramRequest", Argument #5(debugMode) Must Be Boolean.')
    end

    if (requestFile and next(requestFile) ~= nil) then
        local fileType, fileName = next(requestFile)
        local file = io.open(fileName, 'rb')
        if (file) then
            lua_thread.create(function ()
                requestParameters[fileType] = {
                    filename = fileName,
                    data = file:read('*a')
                }
            end)
            file:close()
        else
            requestParameters[file_type] = fileName
        end
    end

    local requestData = {
        ['method'] = tostring(requestMethod),
        ['url']    = string.format('https://api.telegram.org/bot%s/%s', tostring(botToken), tostring(telegramMethod))
    }

    local body, boundary = multipart.encode(requestParameters)

    --[[ Request Part ]]--
    local thread = effil.thread(function (requestData, body, boundary)
        local response = {}

        --[[ Include Libraries ]]--
        local channel_library_requests = require('ssl.https')
        local channel_library_ltn12    = require('ltn12')

        --[[ Manipulations ]]--
        local _, source = pcall(channel_library_ltn12.source.string, body)
        local _, sink   = pcall(channel_library_ltn12.sink.table, response)

        --[[ Request ]]--
        local result, _ = pcall(channel_library_requests.request, {
                ['url']     = requestData['url'],
                ['method']  = requestData['method'],
                ['headers'] = {
                    ['Accept']          = '*/*',
                    ['Accept-Encoding'] = 'gzip, deflate',
                    ['Accept-Language'] = 'en-us',
                    ['Content-Type']    = string.format('multipart/form-data; boundary=%s', tostring(boundary)),
                    ['Content-Length']  = #body
                },
                ['source']  = source,
                ['sink']    = sink
        })
        if (result) then
            return { true, response }
        else
            return { false, response }
        end
    end)(requestData, body, boundary)

    local result = thread:get(0)
    while (not result) do
        result = thread:get(0)
        wait(0)
    end
    --[[ Running || Paused || Canceled || Completed || Failed ]]--
    local status, error = thread:status()
    if (not error) then
        if (status == 'completed') then
            local response = dkjson.decode(result[2][1])
            --[[ result[1] = boolean ]]--
            if (result[1]) then
                return true, response
            else
                return false, response
            end
        elseif (status ~= 'running' and status ~= 'completed') then
            return false, string.format('[TelegramLibrary] Error; Effil Thread Status was: %s', tostring(status))
        end
    else
        return false, error
    end
    thread:cancel(0)
end

function Telegram:new(token, debugMode)
    local token = token or nil
    if (type(token) ~= 'string') then
        error('[TelegramLibrary] Method: "Telegram:new"; Arguments #1(token) must be string.')
    end
    local debugMode = debugMode or false
    if (type(debugMode) ~= 'boolean') then
        error('[TelegramLibrary] Method: "Telegram:new"; Arguments #2(debug_mode) must be boolean.')
    end
    local object = {
        ['token'] = tostring(token),
        ['debug_mode'] = debugMode
    }

    --[[
        Method: https://core.telegram.org/bots/api#sendmessage
        Parameters:                      Type:                   Required:
        1) chat_id                       Integer or String       Yes
        2) text                          String                  Yes
        3) parse_mode                    String                  Optional
        4) reply_to_message_id           Integer                 Optional
        5) disable_web_page_preview      Boolean                 Optional
        6) disable_notification          Boolean                 Optional
        7) reply_markup                  Table                   Optional   
    ]]--
    function object:sendMessage( chat_id, text, parse_mode, reply_to_message_id,
                                 disable_web_page_preview, disable_notification, 
                                 reply_markup
                               )
        if (chat_id == nil or text == nil) then
            error('[TelegramLibrary] Method: "SendMessage"; Arguments: chat_id and text must be required.')
        end
        if (type(chat_id) ~= 'number' and type(chat_id) ~= 'string') then
            error('[TelegramLibrary] Method: "SendMessage"; Argument #1(chat_id) must be integer or string.')
        end
        if (type(text) ~= 'string') then
            error('[TelegramLibrary] Method: "SendMessage"; Argument #2(text) must be string.')
        end
        local parse_mode = parse_mode or 'HTML'
        if (type(parse_mode) ~= 'string') then
            error('[TelegramLibrary] Method: "SendMessage"; Argument #3(parse_mode) must be string.')
        end
        if (tostring(parse_mode) ~= 'HTML' and tostring(parse_mode) ~= 'Markdown' and tostring(parse_mode) ~= 'MarkdownV2') then
            error(string.format('[TelegramLibrary] Method: "SendMessage"; Argument #3(parse_mode) dont have "%s" parse_mode.', tostring(parse_mode)))
        end

        local reply_to_message_id = reply_to_message_id or 0
        if (type(reply_to_message_id) ~= 'number') then
            error('[TelegramLibrary] Method: "SendMessage"; Argument #4(reply_to_message_id) must be integer.')
        end

        local disable_web_page_preview = disable_web_page_preview or false
        if (type(disable_web_page_preview) ~= 'boolean') then
            error('[TelegramLibrary] Method: "SendMessage"; Argument #5(disable_web_page_preview) must be boolean.')
        end

        local disable_notification = disable_notification or false
        if (type(disable_notification) ~= 'boolean') then
            error('[TelegramLibrary] Method: "SendMessage"; Argument #6(disable_notification) must be boolean.')
        end

        local empty_reply_markup = { ['inline_keyboard'] = { {  } } }
        local reply_markup = reply_markup or empty_reply_markup
        if (type(reply_markup) ~= 'table') then
            error('[TelegramLibrary] Method: "SendMessage"; Argument #7(reply_markup) must be table.')
        end

        local result, response = telegramRequest(
            'POST',
            'sendMessage',
            {
                ['chat_id'] = tostring(chat_id),
                ['text'] = tostring(u8:encode(text)),
                ['parse_mode'] = tostring(parse_mode),
                ['reply_to_message_id'] = tostring(reply_to_message_id),
                ['disable_web_page_preview'] = tostring(disable_web_page_preview),
                ['disable_notification'] = tostring(disable_notification),
                ['reply_markup'] = dkjson.encode(reply_markup)
            },
            _,
            tostring(self.token),
            self.debugMode
        )

        return result, response
    end
    
    --[[
        Method: https://core.telegram.org/bots/api#sendphoto
        Parameters:                      Type:                   Required:
        1) chat_id                       Integer or String       Yes
        2) photo                         InputFile or String     Yes
        3) caption                       String                  Optional
        4) parse_mode                    String                  Optional
        5) disable_notification          Boolean                 Optional
        6) reply_to_message_id           Integer                 Optional
        7) reply_markup                  Table                   Optional              
    ]]--
    function object:sendPhoto( chat_id, photo, caption,
                               parse_mode, reply_to_message_id, disable_notification,
                               reply_markup
                             )

        if (chat_id == nil or photo == nil) then
            error('[TelegramLibrary] Method: "SendPhoto"; Arguments: chat_id and photo must be required.')
        end
        if (type(chat_id) ~= 'number' and type(chat_id) ~= 'string') then
            error('[TelegramLibrary] Method: "SendPhoto"; Argument #1(chat_id) must be integer or string.')
        end
        if (type(photo) ~= 'string') then
            error('[TelegramLibrary] Method: "SendPhoto"; Argument #2(photo) must be string(File_Path or File_ID).')
        end
        local caption = caption or ''
        if (type(caption) ~= 'string') then
            error('[TelegramLibrary] Method: "SendPhoto"; Argument #3(reply_to_message_id) must be integer.')
        end

        local parse_mode = parse_mode or 'HTML'
        if (type(parse_mode) ~= 'string') then
            error('[TelegramLibrary] Method: "SendPhoto"; Argument #4(parse_mode) must be string.')
        end
        if (tostring(parse_mode) ~= 'HTML' and tostring(parse_mode) ~= 'Markdown' and tostring(parse_mode) ~= 'MarkdownV2') then
            error(string.format('[TelegramLibrary] Method: "SendPhoto"; Argument #4(parse_mode) dont have "%s" parse_mode.', tostring(parse_mode)))
        end

        local reply_to_message_id = reply_to_message_id or 0
        if (type(reply_to_message_id) ~= 'number') then
            error('[TelegramLibrary] Method: "SendPhoto"; Argument #5(reply_to_message_id) must be integer.')
        end

        local disable_notification = disable_notification or false
        if (type(disable_notification) ~= 'boolean') then
            error('[Telegram] Method: "SendPhoto"; Argument #6(disable_notification) must be boolean.')
        end
    
        local empty_reply_markup = { ['inline_keyboard'] = { {  } } }
        local reply_markup = reply_markup or empty_reply_markup
        if (type(reply_markup) ~= 'table') then
            error('[TelegramLibrary] Method: "SendPhoto"; Argument #7(reply_markup) must be table.')
        end

        local result, response = telegramRequest(
            'POST',
            'sendPhoto',
            {
                ['chat_id'] = tostring(chat_id),
                ['caption'] = tostring(u8:encode(caption)),
                ['parse_mode'] = tostring(parse_mode),
                ['disable_notification'] = tostring(disable_notification),
                ['reply_to_message_id'] = tostring(reply_to_message_id),
                ['reply_markup'] = dkjson.encode(reply_markup)
            },
            {
                ['photo'] = photo
            },
            tostring(self.token),
            self.debugMode
        )

        return result, response
    end

    --[[
        Method: https://core.telegram.org/bots/api#sendaudio
        Parameters:                      Type:                   Required:
        1) chat_id                       Integer or String       Yes
        2) audio                         InputFile or String     Yes
        3) caption                       String                  Optional
        4) parse_mode                    String                  Optional
        5) disable_notification          Boolean                 Optional
        6) reply_to_message_id           String                  Optional
        7) reply_markup                  Table                   Optional    
    ]]--
    function object:sendAudio( chat_id, audio, caption,
                               parse_mode, reply_to_message_id, disable_notification,
                               reply_markup
                             )

        if (chat_id == nil or audio == nil) then
            error('[TelegramLibrary] Method: "SendAudio"; Arguments: chat_id and audio must be required.')
        end
        if (type(chat_id) ~= 'number' and type(chat_id) ~= 'string') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #1(chat_id) must be integer or string.')
        end
        if (type(audio) ~= 'string') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #2(photo) must be string(File_Path or File_ID).')
        end
        local caption = caption or ''
        if (type(caption) ~= 'string') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #3(reply_to_message_id) must be integer.')
        end
        local parse_mode = parse_mode or 'HTML'
        if (type(parse_mode) ~= 'string') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #4(parse_mode) must be string.')
        end
        if (tostring(parse_mode) ~= 'HTML' and tostring(parse_mode) ~= 'Markdown' and tostring(parse_mode) ~= 'MarkdownV2') then
            error(string.format('[TelegramLibrary] Method: "SendAudio"; Argument #4(parse_mode) dont have "%s" parse_mode.', tostring(parse_mode)))
        end

        local reply_to_message_id = reply_to_message_id or 0
        if (type(reply_to_message_id) ~= 'number') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #5(reply_to_message_id) must be integer.')
        end

        local disable_notification = disable_notification or false
        if (type(disable_notification) ~= 'boolean') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #6(disable_notification) must be boolean.')
        end        
        
        local empty_reply_markup = { ['inline_keyboard'] = { {  } } }
        local reply_markup = reply_markup or empty_reply_markup
        if (type(reply_markup) ~= 'table') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #7(reply_markup) must be table.')
        end

        local result, response = telegramRequest(
            'POST',
            'sendAudio',
            {
                ['chat_id'] = tostring(chat_id),
                ['caption'] = tostring(u8:encode(caption)),
                ['parse_mode'] = tostring(parse_mode),
                ['disable_notification'] = tostring(disable_notification),
                ['reply_to_message_id'] = tostring(reply_to_message_id),
                ['reply_markup'] = dkjson.encode(reply_markup)
            },
            {
                ['audio'] = audio
            },
            tostring(self.token),
            self.debugMode
        )

        return result, response
    end

    --[[
        Method: https://core.telegram.org/bots/api#senddocument
        Parameters:                      Type:                   Required:
        1) chat_id                       Integer or String       Yes
        2) document                      InputFile or String     Yes
        3) caption                       String                  Optional
        4) parse_mode                    String                  Optional
        5) disable_notification          Boolean                 Optional
        6) reply_to_message_id           String                  Optional
        7) reply_markup                  Table                   Optional    
    ]]--
    function object:sendDocument( chat_id, document, caption,
                                  parse_mode, reply_to_message_id, disable_notification,
                                  reply_markup
                                )
        
        if (chat_id == nil or document == nil) then
            error('[TelegramLibrary] Method: "sendDocument"; Arguments: chat_id and audio must be required.')
        end
        if (type(chat_id) ~= 'number' and type(chat_id) ~= 'string') then
            error('[TelegramLibrary] Method: "sendDocument"; Argument #1(chat_id) must be integer or string.')
        end
        if (type(document) ~= 'string') then
            error('[TelegramLibrary] Method: "sendDocument"; Argument #2(document) must be string(File_Path or File_ID).')
        end
        local caption = caption or ''
        if (type(caption) ~= 'string') then
            error('[TelegramLibrary] Method: "sendDocument"; Argument #3(caption) must be string.')
        end

        local parse_mode = parse_mode or 'HTML'
        if (type(parse_mode) ~= 'string') then
            error('[TelegramLibrary] Method: "sendDocument"; Argument #4(parse_mode) must be string.')
        end
        if (tostring(parse_mode) ~= 'HTML' and tostring(parse_mode) ~= 'Markdown' and tostring(parse_mode) ~= 'MarkdownV2') then
            error(string.format('[TelegramLibrary] Method: "sendDocument"; Argument #4(parse_mode) dont have "%s" parse_mode.', tostring(parse_mode)))
        end

        local reply_to_message_id = reply_to_message_id or 0
        if (type(reply_to_message_id) ~= 'number') then
            error('[TelegramLibrary] Method: "sendDocument"; Argument #5(reply_to_message_id) must be integer.')
        end

        local disable_notification = disable_notification or false
        if (type(disable_notification) ~= 'boolean') then
            error('[TelegramLibrary] Method: "sendDocument"; Argument #6(disable_notification) must be boolean.')
        end        
        
        local empty_reply_markup = { ['inline_keyboard'] = { {  } } }
        local reply_markup = reply_markup or empty_reply_markup
        if (type(reply_markup) ~= 'table') then
            error('[TelegramLibrary] Method: "SendAudio"; Argument #7(reply_markup) must be table.')
        end

        local result, response = telegramRequest(
            'POST',
            'sendDocument',
            {
                ['chat_id'] = tostring(chat_id),
                ['caption'] = tostring(u8:encode(caption)),
                ['parse_mode'] = tostring(parse_mode),
                ['disable_notification'] = tostring(disable_notification),
                ['reply_to_message_id'] = tostring(reply_to_message_id),
                ['reply_markup'] = dkjson.encode(reply_markup)
            },
            {
                ['document'] = document
            },
            tostring(self.token),
            self.debug_mode
        )

        return result, response
    end

    --[[
        Method: customRequest
        Parameters:                      Type:                   Required:
        1) requestMethod                 String                  Yes
        2) telegramMethod                String                  Yes
        3) requestParameters             String                  Yes
        4) requestFile                   String                  Optional
    ]]--
    function object:customRequest( requestMethod, telegramMethod, 
                                   requestParameters, requestFile
                                 )
        
        local result, response = telegramRequest(
            requestMethod,
            telegramMethod,
            requestParameters,
            requestFile,
            tostring(self.token),
            self.debug_mode
        )
        
        return result, response
    end

    local keyboardMetatable = {}
    keyboardMetatable['__index'] = keyboardMetatable

    local keyboardButtons = {}
    keyboardButtons['__index'] = keyboardButtons

    function self:keyboardBuilder(keyboardType)
        if (type(keyboardType) ~= 'string') then
            error('[TelegramLibrary] Method: "keyboardBuilder"; Argument #1(keyboard) must be string.')
        end
        if (tostring(keyboardType) ~= 'inline_keyboard' and tostring(keyboardType) ~= 'keyboard') then
            error(string.format('[TelegramLibrary] Method: "keyboardBuilder"; Argument #1(keyboard) dont have "%s" keyboard type.', tostring(keyboardType)))
        end
        function keyboardMetatable:switch(buttons)
            if (self['inline_keyboard'] ~= nil) then
                table.insert(self['inline_keyboard'], buttons)
            else
                table.insert(self['keyboard'], buttons)
            end
            return self
        end
        return setmetatable({ [tostring(keyboardType)] = {} }, keyboardMetatable)
    end

    function self:keyboardButtonsBuilder(keyboardType)
        if (type(keyboardType) ~= 'string') then
            error('[TelegramLibrary] Method: "keyboardButtonsBuilder"; Argument #1(keyboard) must be string.')
        end
        if (tostring(keyboardType) ~= 'inline_keyboard' and tostring(keyboardType) ~= 'keyboard') then
            error(string.format('[TelegramLibrary] Method: "keyboardButtonsBuilder"; Argument #1(keyboard) dont have "%s" keyboard type.', tostring(keyboardType)))
        end

        if (tostring(keyboardType) == 'inline_keyboard') then
            function keyboardButtons:urlButton(label, url)
                table.insert(
                    self,
                    {
                        ['text'] = tostring(u8:encode(label)),
                        ['url'] = tostring(url)
                    }
                )
                return self
            end
            function keyboardButtons:callbackButton(label, callbackData)
                table.insert(
                    self,
                    {
                        ['text'] = tostring(u8:encode(label)),
                        ['callback_data'] = tostring(callbackData)
                    }
                )
                return self
            end
        else
            function keyboardButtons:button(label)
                table.insert(
                    self,
                    {
                        ['text'] = tostring(u8:encode(label))
                    }
                )
                return self
            end
        end
        return setmetatable({ }, keyboardButtons)
    end

    setmetatable(object, self)
    self.__index = self; return object
end

return Telegram