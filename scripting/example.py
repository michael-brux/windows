import os
import platform
import sys
import time
import win32api
import win32con
import win32gui
import win32process
import psutil
import ctypes

def get_os_info():
    """Gets operating system information."""
    print("--- Operating System Information ---")
    print(f"  OS Name: {platform.system()}")
    print(f"  OS Version: {platform.release()}")
    print(f"  OS Architecture: {platform.machine()}")
    print(f"  Processor: {platform.processor()}")
    print(f"  Python Version: {sys.version}")


def get_system_uptime():
    """Gets the system uptime."""
    print("\n--- System Uptime ---")
    uptime_seconds = win32api.GetTickCount() / 1000.0
    days = int(uptime_seconds // (24 * 3600))
    hours = int((uptime_seconds % (24 * 3600)) // 3600)
    minutes = int((uptime_seconds % 3600) // 60)
    seconds = int(uptime_seconds % 60)
    print(f"  System Uptime: {days} days, {hours} hours, {minutes} minutes, {seconds} seconds")


def get_current_user():
    """Gets the current user's username."""
    print("\n--- Current User ---")
    username = os.getlogin()
    print(f"  Username: {username}")


def get_window_titles():
    """Gets a list of open window titles."""
    print("\n--- Open Window Titles ---")
    def callback(hwnd, hwnds):
        if win32gui.IsWindowVisible(hwnd):
            title = win32gui.GetWindowText(hwnd)
            if title:
                hwnds.append(title)
        return True

    open_windows = []
    win32gui.EnumWindows(callback, open_windows)
    for title in open_windows:
        print(f"  - {title}")


def get_process_info():
    """Gets information about running processes."""
    print("\n--- Running Processes ---")
    for proc in psutil.process_iter(['pid', 'name', 'username']):
        try:
            process_info = proc.info
            print(f"  PID: {process_info['pid']}, Name: {process_info['name']}, User: {process_info['username']}")
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass


def show_message_box():
    """Shows a simple message box."""
    print("\n--- Showing Message Box ---")
    win32api.MessageBox(None, "Hello from Python on Windows 11!", "Python Message", win32con.MB_OK | win32con.MB_ICONINFORMATION)
    print("  Message box closed.")

def get_screen_resolution():
    """Gets the screen resolution."""
    print("\n--- Screen Resolution ---")
    user32 = ctypes.windll.user32
    width = user32.GetSystemMetrics(0)
    height = user32.GetSystemMetrics(1)
    print(f"  Screen Resolution: {width} x {height}")

def main():
    """Main function to run the examples."""
    print("Running Windows 11 Pro Specific Examples with Python...")

    get_os_info()
    get_system_uptime()
    get_current_user()
    get_screen_resolution()
    get_window_titles()
    get_process_info()
    show_message_box()

    print("\nFinished running examples.")


if __name__ == "__main__":
    main()
