# HUD for iOS

A thin iOS app that shows the HUD's Next.js pages full screen on XR glasses
plugged into the phone over USB-C. The phone screen is the controller; for now
it only sets the address and shows what display is connected.

Keep it thin. The app puts a web view on the glasses and remembers the address.
Everything else, including deciding between 2D and 3D, belongs in the page, so
an Android port stays small.

Needs iOS 27 (it uses `UISceneAccessory`, which iOS 27 requires to get a glasses
scene) and a phone with USB-C DisplayPort out: iPhone 15 or newer, not the 16e
or Air.

## Run it

1. Start the Next app on your computer: `npm run dev` from the repo root. It
   listens on every network interface.
2. Generate the Xcode project: `brew install xcodegen`, then `xcodegen` in this
   directory. The `.xcodeproj` is generated, so it isn't committed.
3. Open `HUD.xcodeproj`, pick your team under Signing, and run on the phone.
4. Enter your computer's address in the app, for example its Tailscale IP:
   `100.x.y.z:3000`.
5. Plug in the glasses. You'll see "Hello, world" with a 2D badge.
6. Switch the glasses to Full SBS 3D (Viture: double press the right button).
   The page sees a 32:9 window, draws once per eye, and the badge reads 3D.

The app logs every glasses display it gets, with its size and available modes,
under the `display` category of `com.augeocorp.hud` in Console. That's the first
thing to check if Full SBS doesn't show up as 3840×1080.

## CI and TestFlight

`.github/workflows/ios.yml` runs on changes under `ios/`, on GitHub's `xcode-27`
macOS runner (a preview label as of October 2026).

- **build** compiles the app with signing off. It needs no Apple account and
  runs on every pull request.
- **testflight** archives, signs and uploads to TestFlight on pushes to `main`,
  or when you run the workflow by hand from the Actions tab. It stays off until
  `APPLE_TEAM_ID` is set.

To turn on TestFlight, once you have a paid Apple Developer account:

1. In App Store Connect, create the app with bundle ID `com.augeocorp.hud`.
2. Under Users and Access, Integrations, create a team API key with the Admin
   role. Letting Xcode create signing certificates needs more than App Manager,
   as far as we know, not yet checked. Download the `.p8` file; it can only be
   downloaded once.
3. In the GitHub repository settings, add:
   - Variable `APPLE_TEAM_ID`: your 10-character team ID.
   - Secret `ASC_KEY_ID`: the key ID.
   - Secret `ASC_ISSUER_ID`: the issuer ID shown above the keys list.
   - Secret `ASC_KEY_P8`: the full contents of the `.p8` file.
4. Add yourself as an internal tester in TestFlight and install the TestFlight
   app on your phone.

Each upload uses the workflow run number as its build number. Xcode creates the
signing certificate and profile itself through the API key.

## Known gaps

- `next dev` refuses its hot reload connection from any origin other than
  localhost, so pages won't live-reload on the phone. Add the address to
  `allowedDevOrigins` in `next.config.ts` when that matters. Not yet checked
  whether page scripts load; the hello world page doesn't need them.
- No auth yet, and the dev server listens on every interface. Fine on a trusted
  network for a hello world, not for anything connected to an agent.
- Half SBS isn't handled. Viture glasses only have Full SBS.
