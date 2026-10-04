# HUD for iOS

A thin iOS app that shows the HUD's Next.js pages full screen on XR glasses
plugged into the phone over USB-C. The phone screen is the controller; for now
it only sets the address and shows what display is connected.

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

## Known gaps

- `next dev` blocks its own JavaScript for any origin other than localhost. The
  hello world page is HTML and CSS only so it works anyway. Pages that need
  client JavaScript will need that address in `allowedDevOrigins` in
  `next.config.ts`.
- No auth yet, and the dev server listens on every interface. Fine on a trusted
  network for a hello world, not for anything connected to an agent.
- Half SBS isn't handled. Viture glasses only have Full SBS.
