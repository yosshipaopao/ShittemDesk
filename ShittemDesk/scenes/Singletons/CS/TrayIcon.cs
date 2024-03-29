using Godot;
using H.NotifyIcon.Core;
using System.Drawing;

public partial class TrayIcon : Node
{
    private TrayIconWithContextMenu trayIcon;
    private WindowManager windowManager;
    public override void _Ready()
	{
        windowManager = GetNode<WindowManager>("/root/WindowManager");
        var icon = H.Resources.Icon_ico.AsStream();
        trayIcon = new TrayIconWithContextMenu
        {
            Icon = new Icon(icon).Handle,
            ToolTip = "Shittim Chest",
            ContextMenu = new H.NotifyIcon.Core.PopupMenu
            {
                Items = {
                    new PopupMenuItem("Exit", (_, _) =>
                    {
                        Callable.From(() =>
                            GetTree().Root.PropagateNotification((int)NotificationWMCloseRequest)
                        ).CallDeferred();
                    }),
                },
            }
        };
        trayIcon.MessageWindow.MouseEventReceived += (_, e) =>
        {
            if (e.MouseEvent.Equals(MouseEvent.IconLeftMouseDown))
            {
                Callable.From(() =>
                    windowManager.SettingsWindowVisible = !windowManager.SettingsWindowVisible
                ).CallDeferred();
            }
            if (e.MouseEvent.Equals(MouseEvent.IconRightMouseDown))
            {
                Callable.From(() =>
                    windowManager.SettingsWindowVisible = false
                ).CallDeferred();
            }
        };
        trayIcon.Create();
    }
    
    public void Kill()
    {
        trayIcon.Dispose();
    }
}
