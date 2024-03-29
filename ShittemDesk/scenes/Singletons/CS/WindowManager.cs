using Godot;
using System;
using System.Text;

public partial class WindowManager : Node
{
    private int processID = System.Environment.ProcessId;
    private IntPtr settings_hwnd;
    private WallpaperWindow wallpaper_window;
    private TrayIcon trayIcon;

    [Signal] 
    public delegate void SettingsWindowVisibleChangedEventHandler(bool visible);
    private bool settings_window_visible = false;
    [Export]
    public bool SettingsWindowVisible
    {
        get => settings_window_visible;
        set
        {
            if(settings_window_visible != value)
            {

                if (value)
                {
                    User32.ShowWindow(settings_hwnd, User32.SW_SHOW);
                }
                else
                {
                    User32.ShowWindow(settings_hwnd, User32.SW_HIDE);
                }
                EmitSignal(SignalName.SettingsWindowVisibleChanged, value);
            }
            settings_window_visible = value;
        }
    }

    public override void _Ready()
    {
        wallpaper_window = GetNode<WallpaperWindow>("/root/WallpaperWindow");
        trayIcon = GetNode<TrayIcon>("/root/TrayIcon");
        DisplayServer.WindowSetTitle("ShittemChest");
        while (settings_hwnd == IntPtr.Zero) 
        {
            if (settings_hwnd == IntPtr.Zero)
            {

                User32.EnumWindows((hw, p) =>
                {
                    int processId;
                    User32.GetWindowThreadProcessId(hw, out processId);
                    if (processId != processID) return true;
                    var title = new StringBuilder(User32.GetWindowTextLength(hw) + 1);
                    User32.GetWindowText(hw, title, title.Capacity);
                    if (title.ToString() != "ShittemChest") return true;
                    settings_hwnd = hw;
                    return true;
                }, IntPtr.Zero);
                if (settings_hwnd != IntPtr.Zero) User32.ShowWindow(settings_hwnd, User32.SW_HIDE);
            }
        }
    }
    public override void _Notification(int what)
    {
        if (what == NotificationWMCloseRequest)
        {
            if (SettingsWindowVisible)
            {
                SettingsWindowVisible = false;
            }
            else
            {
                trayIcon.Kill();
                wallpaper_window.WallpaperVisible = false;
                GetTree().Quit();
            }
        }
    }
}
