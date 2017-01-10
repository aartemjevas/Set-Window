# Set-Window
Sets window position and size

```
    <#
        .SYNOPSIS
            Sets the window size and coordinates  of
            a process window.

        .DESCRIPTION
            Sets the window size and coordinates of
            a process window.

        .PARAMETER MainWindowHandle
            MainWindowHandle of the process

        .PARAMETER MonitorNumber
            The number of monitor you want to display window. First monitor is 0.

        .PARAMETER Position
            Describes window position and size. Available values:
            1. Fullscreen - full screen window
            2. HHalfLeft  - horizontal half screen left
            3. HHalfRight - horizontal half screen right
            4. VHalfTop   - vertical half screen top
            5. VHalfBot   - vertical half screen bot
            5. QTopRight  - 1/4 screen top right
            6. QTopLeft   - 1/4 screen top left
            7. QBotRight  - 1/4 screen bot right
            8. QBotLeft   - 1/4 screen bot left
        
        .PARAMETER SendF11
            Sends F11 keystroke to the window. Usefull when you want to put browser to fullscreen/kiosk mode.

        .EXAMPLE
            Get-Process notepad | set-window -MonitorNumber 1 -Position HHalfRight -Passthru

            ProcessName : notepad
            Handle      : 1245892
            Size        : 960,1040
            TopLeft     : 960,0
            BottomRight : 1920,1040

            Description
            -----------
            Set the coordinates on the window for the process notepad.exe

        .EXAMPLE 
             Get-Process chrome | Set-Window -MonitorNumber 0 -SendF11

            Description
            -----------
            Moves chrome to first monitor and makes it fullscreen.             
        
    #>
```
