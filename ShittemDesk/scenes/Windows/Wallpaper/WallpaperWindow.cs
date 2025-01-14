using Godot;
using System;
using System.Drawing;
using System.Text;

public partial class WallpaperWindow : Window
{
    private int processID = System.Environment.ProcessId;
    private IntPtr workerw;
    private IntPtr wallpaper_hwnd;
    private System.Drawing.Image wallpaper_bitmap;

    [Signal]
    public delegate void WallpapaerVisibleChangedEventHandler(bool visible);
    private bool wallpaper_visible = false;
    [Export]
    public bool WallpaperVisible
    {
        get => wallpaper_visible;
        set
        {
            if (wallpaper_visible != value)
            {
                if (value)
                {
                    Visible = true;
                    User32.EnumWindows((hwnd, lParam) =>
                    {
                        var shell = User32.FindWindowEx(hwnd, IntPtr.Zero, "SHELLDLL_DefView", null);
                        if (shell != IntPtr.Zero)
                            workerw = User32.FindWindowEx(hwnd, IntPtr.Zero, "WorkerW", null);
                        return true;
                    }, IntPtr.Zero);
                    User32.EnumWindows((hw, p) =>
                    {
                        int processId;
                        User32.GetWindowThreadProcessId(hw, out processId);
                        if (processId != processID) return true;
                        var title = new StringBuilder(User32.GetWindowTextLength(hw) + 1);
                        User32.GetWindowText(hw, title, title.Capacity);
                        if (title.ToString() != Title) return true;
                        wallpaper_hwnd = hw;
                        return true;
                    }, IntPtr.Zero);
                    User32.ShowWindow(wallpaper_hwnd, User32.SW_HIDE);
                    User32.SetWindowLong(wallpaper_hwnd, User32.GWL_STYLE, User32.WS_CHILDWINDOW);
                    User32.SetWindowLong(wallpaper_hwnd, User32.GWL_EX_STYLE, User32.GetWindowLong(wallpaper_hwnd, -20) | User32.WS_EX_LAYERED | User32.WS_EX_NOACTIVATE);
                    //User32.SetLayeredWindowAttributes(wallpaper_hwnd, 0, 0, User32.LWA_ALPHA);
                    User32.ShowWindow(wallpaper_hwnd, User32.SW_SHOW);
                    User32.SetParent(wallpaper_hwnd,workerw);
                }
                else
                {
                    Visible = false;
                    var hdc = User32.GetDCEx(workerw, IntPtr.Zero, 0x403);
                    using (var graph = Graphics.FromHdc(hdc)) graph.DrawImage(wallpaper_bitmap, new PointF(0, 0));
                    User32.ReleaseDC(workerw, hdc);
                    wallpaper_hwnd = IntPtr.Zero;
                }
                EmitSignal(SignalName.WallpapaerVisibleChanged, value);
                ProcessMode = value ? ProcessModeEnum.Always : ProcessModeEnum.Disabled;
                wallpaper_visible = value;
            }
        }
    }
    public override void _Ready()
    {
        base._Ready();
        User32.SendMessageTimeout(User32.FindWindow("Progman", null), 0x052C, new IntPtr(0), IntPtr.Zero, 0x0, 1000, out var result);
        //while (workerw == IntPtr.Zero)
        {
            User32.EnumWindows((hwnd, lParam) =>
            {
                if(workerw == IntPtr.Zero)
                {
                    var shell = User32.FindWindowEx(hwnd, IntPtr.Zero, "SHELLDLL_DefView", null);
                    if (shell != IntPtr.Zero)
                        workerw = User32.FindWindowEx(hwnd, IntPtr.Zero, "WorkerW", null);
                }
                return true;
            }, IntPtr.Zero);
        }
        
        var hdcSrc = User32.GetDCEx(workerw, IntPtr.Zero, 0x403);
        var hdcDest = GDI32.CreateCompatibleDC(hdcSrc);
        var rect = User32.GetRect(workerw);
        var width = rect.right - rect.left;
        var height = rect.bottom - rect.top;
        var hBitmap = GDI32.CreateCompatibleBitmap(hdcSrc, width, height);
        var hOld = GDI32.SelectObject(hdcDest, hBitmap);
        GDI32.BitBlt(hdcDest, 0, 0, width, height, hdcSrc, 0, 0, GDI32.SRCCOPY);
        GDI32.SelectObject(hdcDest, hOld);
        GDI32.DeleteDC(hdcDest);
        User32.ReleaseDC(workerw, hdcSrc);
        wallpaper_bitmap = System.Drawing.Image.FromHbitmap(hBitmap);
        GDI32.DeleteObject(hBitmap);
    }
    public void DrawDesktop()
    {
        if (WallpaperVisible)
        {
            /*
            var hdcSrc = User32.GetDCEx(wallpaper_hwnd, IntPtr.Zero, 0x403);
            var hdcDest = User32.GetDCEx(workerw, IntPtr.Zero, 0x403); 
            var ScreenPos = DisplayServer.ScreenGetPosition();
            var ScreenSize = DisplayServer.ScreenGetSize();
            Size = ScreenSize;

            GDI32.BitBlt(hdcDest, 0, 0, 1920, 1080, hdcSrc, 0, 0, 0x00CC0020);
            //GDI32.BitBlt(hdcDest,ScreenPos.X, ScreenPos.Y, ScreenSize.X, ScreenSize.Y, hdcSrc, 0, 0, GDI32.SRCCOPY);
            //User32.ReleaseDC(wallpaper_hwnd, hdcSrc);
            //User32.ReleaseDC(workerw, hdcDest);

            GD.Print("wallp");
            GD.Print(hdcSrc);
            GD.Print(hdcDest);
            GD.Print(workerw);*/
        }
    }
}
