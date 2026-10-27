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

Two separate things build the app:

- **GitHub Actions** (`.github/workflows/ios.yml`) compiles it with signing off
  on every pull request that touches `ios/`, on GitHub's `xcode-27` macOS
  runner. It needs no Apple account.
- **Xcode Cloud** builds, signs and uploads to TestFlight. Apple handles the
  signing, so no keys or secrets live in GitHub. Its workflow is configured in
  Xcode and App Store Connect, not in this repository.

The Xcode project is generated rather than committed, so Xcode Cloud runs
`ci_scripts/ci_post_clone.sh` after cloning to install XcodeGen and generate it.

To set up Xcode Cloud, once, on a Mac with Xcode 27:

1. In App Store Connect, create the app with bundle ID `com.augeocorp.hud`.
2. Generate and open the project: `brew install xcodegen`, then `xcodegen` in
   this directory, then open `HUD.xcodeproj`.
3. In Xcode, Product, Xcode Cloud, Create Workflow. Sign in with your developer
   account and grant Xcode Cloud access to the GitHub repository. On the
   AugeoCorp organization this installs Apple's GitHub app, which needs an
   organization owner's approval.
4. In the workflow, set the start condition (for example, changes to `main`),
   add an Archive action for iOS, and add a TestFlight Internal Testing
   post-action with a group that includes you.
5. Install the TestFlight app on your phone.

Xcode Cloud sets its own build number on each build.

## Known gaps

- `next dev` refuses its hot reload connection from any origin other than
  localhost, so pages won't live-reload on the phone. Add the address to
  `allowedDevOrigins` in `next.config.ts` when that matters. Not yet checked
  whether page scripts load; the hello world page doesn't need them.
- No auth yet, and the dev server listens on every interface. Fine on a trusted
  network for a hello world, not for anything connected to an agent.
- Half SBS isn't handled. Viture glasses only have Full SBS.
