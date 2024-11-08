--
-- This will watch the configuration file
-- and reload it if anything changes. It
-- actually watches the configuration
-- directory.
--
hs.pathwatcher.new(os.getenv("HOME") .. "/.Hammerspoon/", hs.reload):start()

--
-- If the ipc program is not installed, then install it. This also enables the ipc
-- commands to work.
--
if hs.ipc.cliStatus() == false then
    hs.ipc.cliInstall()
end

--
-- Launch the AnyBar app for showing sleep
-- status.
--
hs.applescript.applescript(
    "tell application \"Alfred\" to run trigger \"Launch\" in workflow \"com.customct.AnyBar\" with argument \"9595\" ")

--
-- Set the default grid size and configuration.
--
hs.grid.GRIDWIDTH = 3
hs.grid.GRIDHEIGHT = 3
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

--
-- Global Variables
--
--		saved.win 		The window last moved.
--		saved.winframe The frame for the window before moving.
--
saved = {}
saved.win = {}
saved.winframe = {}

--
-- Function:		returnLast
--
-- Description:	Will return the last window moved to it's
--						original position.
--
function returnLast()
    if (saved.win ~= {}) then
        saved.win:setFrame(saved.winframe)
    end
end

--
-- Function:         nudgeRight
--
-- Description:      Move the current window to the right.
--
function nudgeRight()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    f.x = f.x + 10
    win:setFrame(f)
end

--
-- Function:         nudgeLeft
--
-- Description:      Move the current window to the left.
--
function nudgeLeft()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    f.x = f.x - 10
    win:setFrame(f)
end

--
-- Function:         nudgeUp
--
-- Description:      Move the current window to the up.
--
function nudgeUp()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    f.y = f.y - 10
    win:setFrame(f)
end

--
-- Function:         nudgeDown
--
-- Description:      Move the current window to the down.
--
function nudgeDown()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    f.y = f.y + 10
    win:setFrame(f)
end

--
-- Function:         centerWindow
--
-- Description:      Center the window in the screen
--
function centerWindow()
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    saved.win:centerOnScreen()
end

--
-- Function:         leftThirds
--
-- Description:      Move the current window to the left 1/3rd of the screen.
--
function leftThirds()
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.set(saved.win, {
        x = 0,
        y = 0,
        w = 1,
        h = 3
    }, hs.screen.mainScreen())
end

--
-- Function:         rightThirds
--
-- Description:      Move the current window to the right 2/3rds of the screen.
--
function rightThirds()
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.set(hs.window.focusedWindow(), {
        x = 1,
        y = 0,
        w = 2,
        h = 3
    }, hs.screen.mainScreen())
end

--
-- Function:         snapWindow
--
-- Description:      Move the current window to the closes area in the
--                   window matrix.
--
function snapWindow()
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.snap(hs.window.focusedWindow())
end

--
-- Set the hotkey to reload preferences (ie: this file)
--

--
-- Function:         cafftoggle
--
-- Description:      Toggle system caffeinate. If the
--                              AppBar workflow for Alfred is
-- 			  installed, then it will change the
--                             indicator to black for caff off,
--                             and red if caff is on.
--
function cafftoggle()
    hs.caffeinate.toggle("system")
    if hs.caffeinate.get("system") then
        hs.caffeinate.set("displayIdle", true, true)
        hs.caffeinate.set("systemIdle", true, true)
        hs.alert.show("Caff is enabled!", 3)
        hs.applescript.applescript(
            "tell application \"Alfred\" to run trigger \"SetGraphic\" in workflow \"com.customct.AnyBar\" with argument \"sleep_red|9595\" ")
    else
        hs.caffeinate.set("displayIdle", false, true)
        hs.caffeinate.set("systemIdle", false, true)
        hs.alert.show("Caff is disabled!", 3)
        hs.applescript.applescript(
            "tell application \"Alfred\" to run trigger \"SetGraphic\" in workflow \"com.customct.AnyBar\" with argument \"sleep_black|9595\" ")
    end
end

--
-- Function:		setgrid
--
-- Description:	This function sets the current window to
--						the specified grid location.
--
function setgrid(sx, sy, sw, sh)
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.set(hs.window.focusedWindow(), {
        x = sx,
        y = sy,
        w = sw,
        h = sh
    }, hs.screen.mainScreen())
end

--
-- Function:		leftHalfMove
--
-- Description:	This function moves the current window
-- 					to the left half of the screen.
--
function leftHalfMove()
    saveWidth = hs.grid.GRIDWIDTH
    saveHeight = hs.grid.GRIDHEIGHT
    hs.grid.GRIDWIDTH = 4
    hs.grid.GRIDHEIGHT = 4

    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.set(hs.window.focusedWindow(), {
        x = 0,
        y = 0,
        w = 2,
        h = 4
    }, hs.screen.mainScreen())

    hs.grid.GRIDWIDTH = saveWidth
    hs.grid.GRIDHEIGHT = saveHeight
end

--
-- Function:		rightHalfMove
--
-- Description:	This function moves the current window
-- 					to the right half of the screen.
--
function rightHalfMove()
    saveWidth = hs.grid.GRIDWIDTH
    saveHeight = hs.grid.GRIDHEIGHT
    hs.grid.GRIDWIDTH = 4
    hs.grid.GRIDHEIGHT = 4

    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.set(hs.window.focusedWindow(), {
        x = 2,
        y = 0,
        w = 2,
        h = 4
    }, hs.screen.mainScreen())

    hs.grid.GRIDWIDTH = saveWidth
    hs.grid.GRIDHEIGHT = saveHeight
end

--
-- Function:		topHalfMove
--
-- Description:	This function moves the current window
-- 			to the top half of the screen.
--
function topHalfMove()
    saveWidth = hs.grid.GRIDWIDTH
    saveHeight = hs.grid.GRIDHEIGHT
    hs.grid.GRIDWIDTH = 4
    hs.grid.GRIDHEIGHT = 4

    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.set(hs.window.focusedWindow(), {
        x = 0,
        y = 0,
        w = 4,
        h = 2
    }, hs.screen.mainScreen())

    hs.grid.GRIDWIDTH = saveWidth
    hs.grid.GRIDHEIGHT = saveHeight
end

--
-- Function:		bottomHalfMove
--
-- Description:	This function moves the current window
-- 			to the bottom half of the screen.
--
function bottomHalfMove()
    saveWidth = hs.grid.GRIDWIDTH
    saveHeight = hs.grid.GRIDHEIGHT
    hs.grid.GRIDWIDTH = 4
    hs.grid.GRIDHEIGHT = 4

    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.grid.set(hs.window.focusedWindow(), {
        x = 0,
        y = 2,
        w = 4,
        h = 2
    }, hs.screen.mainScreen())

    hs.grid.GRIDWIDTH = saveWidth
    hs.grid.GRIDHEIGHT = saveHeight
end

--
-- Function:	fullScreen
--
-- Description:	This function moves the current window
-- 			to cover the full screen.
--
function fullScreen()
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.window.focusedWindow():maximize()
end

--
-- Function:	minimize
--
-- Description:	This function moves the current window
-- 			to be minimized.
--
function minimize()
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.window.focusedWindow():minimize()
end

--
-- Function:        appsRunning
--
-- Description:     This function lists all applications running.
--
function appsRunning()
    apps = hs.application.runningApplications()
    for index, app in pairs(apps) do
        if app:kind() == 1 then
            print(app:title())
        end
    end
end

--
-- Function:	focus
--
-- Description:	This function will unminimize the given app.
--
function focus(app)
    hs.appfinder.appFromName(app):activate()
end

--
-- Function:	kill
--
-- Description:	This function will kill the given app.
--
function kill(app)
    hs.appfinder.appFromName(app):kill()
end

--
-- Function:	hide
--
-- Description:	This function will hide the given app.
--
function hide(app)
    hs.appfinder.appFromName(app):hide()
end

--
-- Function:	unhide
--
-- Description:	This function will unhide the given app.
--
function unhide(app)
    app = hs.appfinder.appFromName(app)
    app:unhide()
    app:activate()
end

--
-- Function:	zoom
--
-- Description:	This function moves the current window
-- 			to cover the full screen.
--
function zoom()
    saved.win = hs.window.focusedWindow()
    saved.winframe = saved.win:frame()
    hs.window.focusedWindow():toggleFullScreen()
end

--
-- Global Variables for the expose function
--
--	expose.wins 		A list of windows exposed
-- 	expose.size 		The number of windows in expose.wins
-- 	expose.winsSize	The frame for each window exposed
--								original location and size.
--	expose.sX		The size of the grid in the X for expose
--	expose.sY		The size of the grid in the Y for expose
--
expose = {}
expose.wins = {}
expose.size = 0
expose.winsSize = {}
expose.sX = 0
expose.sY = 0

--
-- Function:		exposeStart
--
-- Description:	This function starts a window expose. It
--              gets the name of the application to expose.
--
function exposeStart(appName)
    saveWidth = hs.grid.GRIDWIDTH
    saveHeight = hs.grid.GRIDHEIGHT
    app = hs.appfinder.appFromName(appName)
    app:activate(true)
    expose.wins = app:allWindows()
    expose.size = 0
    for Index, win in pairs(expose.wins) do
        expose.size = expose.size + 1
        expose.winsSize[Index] = win:frame()
    end
    if expose.size == 1 then
        expose.wins[1]:focus()
    else
        sX = math.ceil(math.sqrt(expose.size))
        sY = math.ceil(expose.size / sX)
        hs.grid.GRIDWIDTH = sX
        hs.grid.GRIDHEIGHT = sY
        for index, win in pairs(expose.wins) do
            index = index - 1
            iY = math.floor(index / sX)
            iX = index - (iY * sX)
            hs.grid.set(win, {
                x = iX,
                y = iY,
                w = 1,
                h = 1
            }, hs.screen.mainScreen())
        end
        expose.sX = sX
        expose.sY = sY
        hs.grid.GRIDWIDTH = saveWidth
        hs.grid.GRIDHEIGHT = saveHeight
    end
    print(expose.size)
end

--
-- Function:		exposeStop
--
-- Description:	This function puts all the windows back to
--              their original location and focus' on the
--              window given by it's col, row address in the
--              expose.
--
function exposeStop(col, row)
    exWin = ""
    for Index, win in pairs(expose.wins) do
        win:setFrame(expose.winsSize[Index])
        if (Index == (expose.sX * row + col + 1)) then
            exWin = win
        end
    end
    exWin:focus()
end

--
-- Function:        runningApps
--
-- Description:     This function lists all applications running
--                  and visible from the AppBar.
--
function runningApps()
    apps = hs.application.runningApplications()
    for index, app in pairs(apps) do
        if app:kind() == 1 then
            wins = app:visibleWindows()
            size = 0
            for Index, win in pairs(wins) do
                size = size + 1
            end
            if size >= 1 then
                print(app:title())
            end
        end
    end
end

--- osexec(command[, with_user_env]) -> output, status, type, rc
--- Function
--- Runs a shell command and returns stdout as a string (may include a trailing newline), followed by true or nil indicating if the command completed successfully, the exit type ("exit" or "signal"), and the result code.
---
---  If `with_user_env` is `true`, then invoke the user's default shell as an interactive login shell in which to execute the provided command in order to make sure their setup files are properly evaluated so extra path and environment variables can be set.  This is not done, if `with_user_env` is `false` or not provided, as it does add some overhead and is not always strictly necessary.
function osexec(command, user_env)
    local f
    if user_env then
        f = io.popen(os.getenv("SHELL") .. " -l -i -c \"" .. command .. "\"", 'r')
    else
        f = io.popen(command, 'r')
    end
    local s = f:read('*a')
    local status, exit_type, rc = f:close()
    return s, status, exit_type, rc
end

--
-- Function:           setSize
--
-- Description:      Resize the current window by pixels and optionally
-- 			  set the position.
--
function setSize(width, height, x, y)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    f.w = width
    f.h = height
    if x ~= nil then
        f.x = x
    end
    if y ~= nil then
        f.y = y
    end
    win:setFrame(f)
end

--
-- Function:      shrinkWindow
--
-- Description:   Change the top, bottom, left or right side of the window
-- 				  smaller.
--
function shrinkWindow(top, bottom, left, right)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    if top ~= nil then
        f.h = f.h - top
        f.y = f.y + top
    end
    if bottom ~= nil then
        f.h = f.h - bottom
    end
    if left ~= nil then
        f.w = f.w - left
        f.x = f.x + left
    end
    if right ~= nil then
        f.w = f.w - right
    end
    win:setFrame(f)
end

--
-- Function:      growWindow
--
-- Description:   Change the top, bottom, left or right side of the window
-- 				  smaller.
--
function growWindow(top, bottom, left, right)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    if top ~= nil then
        f.h = f.h + top
        f.y = f.y - top
    end
    if bottom ~= nil then
        f.h = f.h + bottom
    end
    if left ~= nil then
        f.w = f.w + left
        f.x = f.x - left
    end
    if right ~= nil then
        f.w = f.w + right
    end
    win:setFrame(f)
end

--
-- Function:      maxHeightWindow
--
-- Description:   Change the top and height to the maximum without
--				  touching the width.
--
function maxHeightWindow()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    local sframe = hs.screen.mainScreen():frame()
    f.y = 0
    f.h = sframe.h - 20
    win:setFrame(f)
end

--
-- Function:      almostMaxindow
--
-- Description:   nearly maximize the window
function almostMaxindow()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    saved.win = win
    saved.winframe = saved.win:frame()
    local sframe = hs.screen.mainScreen():frame()
    f.y = 50
    f.x = 50
    f.h = sframe.h - 100
    f.w = sframe.w - 100
    win:setFrame(f)
end

function moveWindowToNextDisplay()
	local app = hs.window.focusedWindow()
	app:moveToScreen(app:screen():next())
end

function moveWindowToPreviousDisplay()
	local app = hs.window.focusedWindow()
	app:moveToScreen(app:screen():previous())
end

function moveWindowToRightDisplay()
	local app = hs.window.focusedWindow()
	app:moveOneScreenEast(false, true, 0.1)
end

function moveWindowToLeftDisplay()
	local app = hs.window.focusedWindow()
	app:moveOneScreenWest(false, true, 0.1)
end


--
-- Tell the user that the configuration file has been loaded.
--
hs.alert.show("Configuration by Custom Computer Tools is Loaded.")

--
-- Sleep for a second to make sure the AnyBar
-- Application is running.
--
os.execute("sleep 1")

--
-- Set the AnyBar application to the black sleep
-- graphic.
--
hs.applescript.applescript(
    "tell application \"Alfred\" to run trigger \"SetGraphic\" in workflow \"com.customct.AnyBar\" with argument \"sleep_black|9595\" ")

