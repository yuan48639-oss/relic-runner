# SteamPipe Build Template

The files in this directory are Steamworks upload templates. Replace all angle-bracket placeholders before uploading.

Expected local export path:

```text
build/windows/RelicRunner.exe
```

Typical flow:

1. Export the Windows build from Godot.
2. Install the Steamworks SDK on the release machine.
3. Point the SteamPipe content directory at the exported `build/windows` folder.
4. Replace `<DEMO_APP_ID>` and `<WINDOWS_DEPOT_ID>` in the VDF files.
5. Run SteamPipe upload from the Steamworks SDK tools directory.

Do not commit Steam credentials or SteamPipe-generated logs.
