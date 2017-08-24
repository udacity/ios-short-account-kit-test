# Account Kit Test App

An app for manually testing AccountKit authentication via authorization code. Here's a short excerpt from Facebook's documentation about using the AccountKit SDK and authorization code:

> An [short-lived] authorization code returned from the [AccountKit] SDK is intended to be passed to your server, which [should exchange] it for an access token. _--[Facebook Documentation](https://developers.facebook.com/docs/accountkit/accesstokens)_

## The Authentication Flow

The app only implements the first part of the AccountKit authentication flow via authorization code:

1. User starts login process by tapping "Login with Phone" button
2. User enters their phone number
3. Facebook sends a 6-digit code to user's phone number
4. User enters 6-digit code to complete the login process
5. A successful login creates an account (with Facebook's AccountKit Service), and passes back the account id and an associated authorization code

![successful accountkit login](https://d17h27t6h515a5.cloudfront.net/topher/2017/August/599f14df_account-kit-test-complete/account-kit-test-complete.png)

Once the authorization code is returned, you may use it to test your application server. Remember, your server is responsible for exchanging the short-level authorization code for a long-lived access token. The access token is required for making any future calls to Facebook's AccountKit API.

> **Note**: Facebook and Account Kit accounts are separate products. You cannot log in to Facebook via Account Kit. When somebody logs in via Account Kit you'll only have access to their phone number or email [via the access token]. If you'd like profile pictures, public profile, etc. you should use Facebook Login.

## How to Setup

Before you can use this app, you will need to become a Facebook developer and create your own Facebook application. [Facebook's documentation](https://developers.facebook.com/docs/accountkit/ios) describes how to sign-up for an account and create an application. Once your application is created, configure the following settings for AccountKit:

![proper accountkit settings](https://d17h27t6h515a5.cloudfront.net/topher/2017/August/599f14e1_account-kit-test-settings/account-kit-test-settings.png)
_^ Make sure to disable "Client Access Token Flow". This is what ensures the authorization code flow is used._

The last item to configure is the iOS app's `Info.plist` file. In this file, you need to specify some properties that identify your newly created Facebook application:

```xml
<plist version="1.0">
<dict>
  <key>FacebookAppID</key>
  <string>{YOUR-APP-ID}</string>
  <key>AccountKitClientToken</key>
  <string>{YOUR-ACCOUNT-KIT-CLIENT-TOKEN}</string>
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>ak{YOUR-APP-ID}</string>
      </array>
    </dict>
  </array>
  ...
</dict>
</plist>
```

If you feel like your stuck, then consult [Facebook's documentation](https://developers.facebook.com/docs/accountkit/ios) for full instructions.

## How to Test

The app allows you to simulate an AccountKit with your phone number. If you login successfully, the authorization code will be displayed in the middle of the main view. Use the "Copy to Clipboard" button to copy the code to your [Universal Clipboard](https://support.apple.com/kb/PH25168?viewlocale=en_AP&locale=en_AP). Once copied to the clipboard, you can paste the authorization code into your development environment (ex. Macbook Pro) for testing.
