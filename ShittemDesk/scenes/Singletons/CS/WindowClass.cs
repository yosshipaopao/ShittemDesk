using System;
using System.Runtime.InteropServices;

public partial class WindowClass
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    public struct WNDCLASSEX
    {
        [MarshalAs(UnmanagedType.U4)]
        public int cbSize;
        [MarshalAs(UnmanagedType.U4)]
        public int style;
        public WNDPROC<WindowProcedure> lpfnWndProc;
        public int cbClsExtra;
        public int cbWndExtra;
        public IntPtr hInstance;
        public IntPtr hIcon;
        public IntPtr hCursor;
        public IntPtr hbrBackground;
        public string lpszMenuName;
        public string lpszClassName;
        public IntPtr hIconSm;
    }

    public struct WNDPROC<TDelegate>
    {
        private readonly IntPtr ptr;

        public WNDPROC(IntPtr ptr)
        {
            this.ptr = ptr;
        }

        public static explicit operator WNDPROC<TDelegate>(TDelegate @delegate)
            => new(Marshal.GetFunctionPointerForDelegate(@delegate));

        public static implicit operator IntPtr(WNDPROC<TDelegate> wndproc)
        => wndproc.ptr;
    }

    public delegate IntPtr WindowProcedure(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);
}
