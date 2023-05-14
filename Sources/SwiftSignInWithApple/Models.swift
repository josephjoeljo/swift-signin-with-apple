//
//  File.swift
//  
//
//  Created by Joel Joseph on 5/7/23.
//

import JWTKit
import Foundation

/**
 WebValidationTokenRequest is based off of https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens
 */
public struct WebValidationTokenRequest {
    // ClientID is the "Services ID" value that you get when navigating to your "sign in with Apple"-enabled service ID
    let clientID: String

    // ClientSecret is secret generated as a JSON Web Token that uses the secret key generated by the WWDR portal.
    // It can also be generated using the GenerateClientSecret function provided in this package
    let clientSecret: String

    // Code is the authorization code received from your application’s user agent.
    // The code is single use only and valid for five minutes.
    let code: String

    // RedirectURI is the destination URI the code was originally sent to.
    // Redirect URLs must be registered with Apple. You can register up to 10. Apple will throw an error with IP address
    // URLs on the authorization screen, and will not let you add localhost in the developer portal.
    let redirectURI: String
}

/**
 AppValidationTokenRequest is based off of https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens
 */
public struct AppValidationTokenRequest {
    // ClientID is the package name of your app
    let clientID: String

    // ClientSecret is secret generated as a JSON Web Token that uses the secret key generated by the WWDR portal.
    // It can also be generated using the GenerateClientSecret function provided in this package
    let clientSecret: String

    // The authorization code received in an authorization response sent to your app. The code is single-use only and valid for five minutes.
    // Authorization code validation requests require this parameter.
    let code: String
    
    public init(clientID: String, clientSecret: String, code: String) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.code = code
    }
}

/**
 ValidationRefreshRequest is based off of https://developer.apple.com/documentation/signinwithapplerestapi/generate_and_validate_tokens
 */
public struct ValidationRefreshRequest {
    // ClientID is the "Services ID" value that you get when navigating to your "sign in with Apple"-enabled service ID
    let clientID: String

    // ClientSecret is secret generated as a JSON Web Token that uses the secret key generated by the WWDR portal.
    // It can also be generated using the GenerateClientSecret function provided in this package
    let clientSecret: String

    // RefreshToken is the refresh token given during a previous validation
    let refreshToken: String
}

/**
 RevokeAccessTokenRequest is based off https://developer.apple.com/documentation/sign_in_with_apple/revoke_tokens
 */
public struct RevokeAccessTokenRequest {
    // ClientID is the "Services ID" value that you get when navigating to your "sign in with Apple"-enabled service ID
    let clientID: String?

    // ClientSecret is secret generated as a JSON Web Token that uses the secret key generated by the WWDR portal.
    // It can also be generated using the GenerateClientSecret function provided in this package
    let clientSecret: String

    // AccessToken is the auth token given during a previous validation
    let accessToken: String
}

/**
  RevokeRefreshTokenRequest is based off https://developer.apple.com/documentation/sign_in_with_apple/revoke_tokens
 */
public struct RevokeRefreshTokenRequest {
    // ClientID is the "Services ID" value that you get when navigating to your "sign in with Apple"-enabled service ID
    var clientID: String

    // ClientSecret is secret generated as a JSON Web Token that uses the secret key generated by the WWDR portal.
    // It can also be generated using the GenerateClientSecret function provided in this package
    var clientSecret: String

    // RefreshToken is the refresh token given during a previous validation
    var refreshToken: String
}


/**
 ValidationResponse is based off of https://developer.apple.com/documentation/signinwithapplerestapi/tokenresponse
 */
public struct ValidationResponse: Codable {
    // (Reserved for future use) A token used to access allowed data. Currently, no data set has been defined for access.
    public let accessToken: String?

    // The type of access token. It will always be "bearer".
    public let tokenType: String?

    // The amount of time, in seconds, before the access token expires. You can revalidate with the "RefreshToken"
    public let expiresIn: Int?

    // The refresh token used to regenerate new access tokens. Store this token securely on your server.
    // The refresh token isn’t returned when validating an existing refresh token. Please refer to RefreshReponse below
    public let refreshToken: String?

    // A JSON Web Token that contains the user’s identity information.
    public let idToken: String?

    // Used to capture any error returned by the endpoint. Do not trust the response if this error is not nil
    public let error: String?

    // A more detailed precision about the current error.
    public let errorDescription: String?
    
    public init() {
        self.accessToken = ""
        self.tokenType = ""
        self.expiresIn = 0
        self.refreshToken = ""
        self.idToken = ""
        self.error = nil
        self.errorDescription = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case idToken = "id_token"
        case error 
        case errorDescription = "error_description"
    }
}

/**
 RefreshResponse is a subset of ValidationResponse returned by Apple
 */
public struct RefreshResponse: Codable {
    // (Reserved for future use) A token used to access allowed data. Currently, no data set has been defined for access.
    let accessToken: String?

    // The type of access token. It will always be "bearer".
    let tokenType: String?

    // The amount of time, in seconds, before the access token expires. You can revalidate with this token
    let expiresIn: Int?

    // Used to capture any error returned by the endpoint. Do not trust the response if this error is not nil
    let error: String?

    // A more detailed precision about the current error.
    let errorDescription: String?
}

/**
 RevokeResponse is based of https://developer.apple.com/documentation/sign_in_with_apple/revoke_tokens
 */
public struct RevokeResponse: Codable {
    // Used to capture any error returned by the endpoint
    let error: String?

    // A more detailed precision about the current error.
    let errorDescription: String?
}

/**
 For the JWT Payload we recieve from the apple servers and is based of https://developer.apple.com/documentation/sign_in_with_apple/sign_in_with_apple_rest_api/authenticating_users_with_sign_in_with_apple
 */
public struct AppleClaims: JWTPayload {
    public func verify(using signer: JWTKit.JWTSigner) throws {
        ()
    }
    /**
     The issuer registered claim identifies the principal that issues the identity token. Because Apple generates the token, the value is https://appleid.apple.com.
     */
    let iss: String
    
    /**
     The subject registered claim identifies the principal that’s the subject of the identity token. Because this token is for your app, the value is the unique identifier for the user.
     */
    let sub: String
    
    /**
     The audience registered claim identifies the recipient of the identity token. Because the token is for your app, the value is the client_id from your developer account.
     */
    let aud: String
    
    /**
     The issued at registered claim indicates the time that Apple issues the identity token, in the number of seconds since the Unix epoch in UTC.
     */
    let iat: Date
    
    /**
     The expiration time registered claim identifies the time that the identity token expires, in the number of seconds since the Unix epoch in UTC. The value must be greater than the current date and time when verifying the token.
     */
    let exp: Date
    
    /**
     A string for associating a client session with the identity token. This value mitigates replay attacks and is present only if you pass it in the authorization request.
     */
    let nonce: String?
    
    /**
     A Boolean value that indicates whether the transaction is on a nonce-supported platform. If you send a nonce in the authorization request, but don’t see the nonce claim in the identity token, check this claim to determine how to proceed. If this claim returns true, treat nonce as mandatory and fail the transaction; otherwise, you can proceed treating the nonce as optional.
     */
    let nonceSupported: Bool?
    
    /**
     A string value that represents the user’s email address. The email address is either the user’s real email address or the proxy address, depending on their private email relay service. This value may be empty for Sign in with Apple at Work & School users. For example, younger students may not have an email address.
     */
    let email: String?
    
    /**
     A string or Boolean value that indicates whether the service verifies the email. The value can either be a string ("true" or "false") or a Boolean (true or false). The system may not verify email addresses for Sign in with Apple at Work & School users, and this claim is "false" or false for those users.
     */
    let emailVerified: String?
    
    /**
     A string or Boolean value that indicates whether the email that the user shares is the proxy address. The value can either be a string ("true" or "false") or a Boolean (true or false).
     */
    let isPrivateEmail: String?
    
    /**
     An Integer value that indicates whether the user appears to be a real person. Use the value of this claim to mitigate fraud. The possible values are: 0 (or Unsupported), 1 (or Unknown), 2 (or LikelyReal). For more information, see ASUserDetectionStatus. This claim is present only in iOS 14 and later, macOS 11 and later, watchOS 7 and later, tvOS 14 and later. The claim isn’t present or supported for web-based apps.
     */
    let realUserStatus: Int?
    
    /**
     A string value that represents the transfer identifier for migrating users to your team. This claim is present only during the 60-day transfer period after you transfer an app.
     */
    let transferSub: String?
    
    public init(
            iss: String,
            sub: String,
            aud: String,
            iat: Date,
            exp: Date,
            nonce: String? = nil,
            nonceSupported: Bool? = nil,
            email: String? = nil,
            emailVerified: String? = nil,
            isPrivateEmail: String? = nil,
            realUserStatus: Int? = nil,
            transferSub: String? = nil
        ) {
            self.iss = iss
            self.sub = sub
            self.aud = aud
            self.iat = iat
            self.exp = exp
            self.nonce = nonce
            self.nonceSupported = nonceSupported
            self.email = email
            self.emailVerified = emailVerified
            self.isPrivateEmail = isPrivateEmail
            self.realUserStatus = realUserStatus
            self.transferSub = transferSub
        }
    
    
    enum CodingKeys: String, CodingKey {
        case iss
        case sub
        case aud
        case iat
        case exp
        case nonce
        case nonceSupported = "nonce_supported"
        case email
        case emailVerified = "email_verified"
        case isPrivateEmail = "is_private_email"
        case realUserStatus = "real_user_status"
        case transferSub = "transfer_sub"
    }
}
