Function Set-Window {
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
        
    #>
    [OutputType('System.Automation.WindowInfo')]
    [cmdletbinding()]
    Param (
        [parameter( Position=0,
                    Mandatory=1,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$True)]
        [IntPtr]$MainWindowHandle,
        [int]$MonitorNumber = 0,
        [validateset("Fullscreen",
                     "HHalfLeft",
                     "HHalfRight",
                     "VHalfTop",
                     "VHalfBot",
                     "QTopRight",
                     "QTopLeft",
                     "QBotRight",
                     "QBotLeft")]
        [string]$Position = "Fullscreen",
        [switch]$SendF11,
        [switch]$Passthru
    )
    Begin {
        Try{
            [void][Window]
        } Catch {
        Add-Type @"
              using System;
              using System.Runtime.InteropServices;
              public class Window {
                [DllImport("user32.dll")]
                [return: MarshalAs(UnmanagedType.Bool)]
                public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

                [DllImport("User32.dll")]
                public extern static bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);

                [DllImport("user32.dll")]
                public static extern bool SetForegroundWindow(IntPtr hWnd);
              }
              public struct RECT
              {
                public int Left;        // x position of upper-left corner
                public int Top;         // y position of upper-left corner
                public int Right;       // x position of lower-right corner
                public int Bottom;      // y position of lower-right corner
              }
"@
        
        }
        try {
            [void][System.Windows.Forms.Screen]
        } catch {
            Add-Type -AssemblyName System.Windows.Forms
        }
    }
    Process {
        $Screen = [System.Windows.Forms.Screen]
        switch ($Position)
        {
            "Fullscreen" 
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.X
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Y
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height
            }
            "HHalfLeft"
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.X
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Y
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height 
            }
            "HHalfRight"
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Left + 
                         ($Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2)
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Y
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height            
            }
            "VHalfTop"
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.X
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Y 
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height /2          
            }
            "VHalfBot"
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.X
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Height / 2
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height / 2                
            }
            "QTopRight"
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Left + 
                         ($Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2)
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Y
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height / 2                
            }
            "QTopLeft"
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Left
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Y
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height /2             
            }
            "QBotRight"
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Left + 
                         ($Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2)
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Height /2
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height /2             
            }
            "QBotLeft" 
            {
                $X =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Left
                $Y =      $Screen::AllScreens[$MonitorNumber].WorkingArea.Height /2
                $Width =  $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Width / 2
                $Height = $Screen::AllScreens[$MonitorNumber].WorkingArea.Size.Height /2             
            }
        }
        $Return = [window]::SetForegroundWindow($MainWindowHandle)            
        If ($Return) 
        {
            $Return = [Window]::MoveWindow($MainWindowHandle, $x, $y, $Width, $Height,$True)                    
        }
        if ($Return -and $SendF11)
        {
            [System.Windows.Forms.SendKeys]::SendWait('{F11}')
            [System.Windows.Forms.SendKeys]::Flush()
        } 
        If ($PSBoundParameters.ContainsKey('Passthru')) 
        {
            $Rectangle = New-Object RECT
            $Return = [Window]::GetWindowRect($MainWindowHandle,[ref]$Rectangle)
            If ($Return) 
            {
                $Height = $Rectangle.Bottom - $Rectangle.Top
                $Width = $Rectangle.Right - $Rectangle.Left
                $Size =        New-Object System.Management.Automation.Host.Size -ArgumentList $Width, $Height
                $TopLeft =     New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Left, $Rectangle.Top
                $BottomRight = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Right, $Rectangle.Bottom
                If ($Rectangle.Top -lt 0 -AND $Rectangle.Left -lt 0) 
                {
                    Write-Warning "Window is minimized! Coordinates will not be accurate."
                }
                $Object = [pscustomobject]@{
                    ProcessName = $(Get-Process | Where-Object {$_.MainWindowHandle -eq $MainWindowHandle}).Name
                    Handle = $MainWindowHandle
                    Size = $Size
                    TopLeft = $TopLeft
                    BottomRight = $BottomRight
                }
                $Object.PSTypeNames.insert(0,'System.Automation.WindowInfo')
                $Object            
            }
        }
    }
}