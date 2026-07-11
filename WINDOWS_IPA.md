# Build and install Renlyst using only Windows

This route uses a free GitHub-hosted Mac to compile the app. The downloaded IPA is unsigned; AltServer signs it with your free Apple Account during installation.

## 1. Build the IPA on GitHub

1. Create a free GitHub account and a new repository. A public repository has free standard Actions usage; a private GitHub Free repository has a monthly minutes allowance, with macOS minutes charged at GitHub's macOS multiplier.
2. Upload or push this entire project, including `.github/workflows/build-unsigned-ipa.yml`.
3. Open the repository on GitHub and select **Actions → Build unsigned Renlyst IPA → Run workflow**.
4. When the run finishes, open it and download the **Renlyst-unsigned-IPA** artifact.
5. Extract the downloaded ZIP and copy `Renlyst.ipa` into this project folder if you want it stored beside the Xcode project.

Do not put an Apple Account password, certificate, or provisioning profile into the GitHub workflow. Signing happens locally on Windows.

## 2. Install from Windows

1. Download and install iTunes and iCloud directly from Apple, not the Microsoft Store versions.
2. Download AltServer for Windows from `https://altstore.io/`, install it, and run it as Administrator.
3. Connect and unlock the iPhone, trust the computer, then enable Developer Mode under **Settings → Privacy & Security → Developer Mode**.
4. Install AltStore from the AltServer tray icon.
5. Hold **Shift** while clicking the AltServer tray icon, choose **Sideload .ipa…**, and select `Renlyst.ipa`.
6. The free signing profile expires after seven days. Keep AltServer available for refreshes or reinstall weekly.

Free Apple Accounts allow only three active sideloaded apps per device. AltStore itself normally uses one of those slots.
