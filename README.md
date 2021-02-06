# HttpUtility

HttpUtility is a light weight open source MIT license project which is helpful in making HTTP requests to the server. It uses URLSession to make requests to the API and returns the [Result enum](https://developer.apple.com/documentation/swift/result) containing the decoded object in case of success or a error incase of failure. Right now this utility only decodes JSON response returned by the server.

[![Build Status](https://travis-ci.com/codecat15/HttpUtility.svg?branch=master)](https://travis-ci.com/codecat15/HttpUtility) [![Twitter](https://img.shields.io/badge/twitter-@codecat15-blue.svg?style=flat)](https://twitter.com/codecat15)

# Purpose of usage

Most of the time iOS application just perform simple HTTP operations which include sending request to the server and getting a response and displaying it to the user. If your iOS app does that then you may use this utility which does not do too much of heavy lifting and just pushes your request to the server and returns you a decoded object.

# Installation

## CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate HttpUtility into your Xcode project using CocoaPods, specify it in your Podfile:

```
pod 'HttpUtility', '~> 1.1'
```

# Using HttpUtility

## Introduction

HttpUtility can be used for basic http operations like get, post, put and delete. It uses [URLSession](https://developer.apple.com/documentation/foundation/urlsession) to perform operations and is just a wrapper around it.

The best thing about this utility is that it takes a simple URL and returns you a decoded object if the request is successful and returns an error if the request fails. Say good bye to writing loops and custom code to parse JSON response.

Given are the some of the examples on how you can make use of this utility

1. [Get request](https://github.com/codecat15/HttpUtility#get-request-example)
2. [Post request](https://github.com/codecat15/HttpUtility#post-request-example)
3. [Request with query string parameters](https://github.com/codecat15/HttpUtility#get-request-with-query-string-parameters)
4. [Request with MultiPartFormData](https://github.com/codecat15/HttpUtility#post-request-with-multipartformdata)
5. [Request with authentication token](https://github.com/codecat15/HttpUtility#authentication-token)
6. [Customize JSONDecoder in the Utility](https://github.com/codecat15/HttpUtility#token-and-custom-jsondecoder)
7. [HUNetworkError](https://github.com/codecat15/HttpUtility/tree/multipart-form-data-format#hunetworkerror)

## GET Request example

```swift
let requestUrl = URL(string: "http://demo0333988.mockable.io/Employees")
 let request = HURequest(url: requestUrl!, method: .get)
        let utility = HTTPUtility.shared
        utility.request(huRequest: request, resultType: Employees.self) { (response) in
            switch response
           {
            case .success(let employee):
            // code to handle the response

            case .failure(let error):
            // your code here to handle error

           }
        }
```

## POST request example

The httpUtility has an extra parameter "requestBody" where you should attach the data that you have to post to the server, in the given example the RegisterUserRequest is a struct inheriting from the [Encodable protocol](https://developer.apple.com/documentation/swift/encodable)

```swift
let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/User/RegisterUser")
let registerUserRequest = RegisterUserRequest(firstName: "code", lastName: "cat15", email: "codecat15@gmail.com", password: "1234")
let registerUserBody = try! JSONEncoder().encode(registerUserRequest)
let request = HURequest(url: requestUrl!, method: .post, requestBody: registerUserBody)

  let utiltiy = HttpUtility.shared
  utility.request(huRequest: request, resultType: RegisterResponse.self) { (response) in
   switch response
    {
      case .success(let registerResponse):
       // code to handle the response

       case .failure(let error):
       // your code here to handle error

     }
```

## GET request with Query string parameters

```swift
let request = PhoneRequest(color: "Red", manufacturer: nil)

// using the extension to convert the encodable request structure to a query string url
let requestUrl = request.convertToQueryStringUrl(urlString:"https://api-dev-scus-demo.azurewebsites.net/api/Product/GetSmartPhone")

let request = HURequest(url: requestUrl!, method: .get)
let utility = HttpUtility.shared
utility.request(huRequest: request, resultType: PhoneResponse.self) { (response) in

    switch response
    {
    case .success(let phoneResponse):
   // code to handle the response

    case .failure(let error):
    // your code here to handle error

   }
}
```

## POST request with MultiPartFormData

```swift

let utility = HttpUtility.shared
let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/TestMultiPart")

// your request model struct should implement the encodable protocol
let requestModel = RequestModel(name: "Bruce", lastName: "Wayne")

let multiPartRequest = HUMultiPartRequest(url: requestUrl!, method: .post, request: requestModel)

utility.requestWithMultiPartFormData(multiPartRequest: multiPartRequest, responseType: TestMultiPartResponse.self) { (response) in
            switch response
            {
            case .success(let serviceResponse):
                // code to handle the response

            case .failure(let error):
                // code to handle failure
            }
        }
```

## Authentication Token

```swift
let token = "your_token"
let utility = HttpUtility.shared
utility.authenticationToken = token
```

if you are using a basic or a bearer token then make sure you put basic or bearer before your token starts

### Example: Basic token

```swift
let basicToken = "basic your_token"
let utility = HttpUtility.shared
utility.authenticationToken = basicToken
```

### Example: Bearer token

```swift
let bearerToken = "bearer your_token"
let utility = HttpUtility.shared
utility.authenticationToken = bearerToken
```

## Custom JSONDecoder

At times it may happen that you may need to control the behaviour of the default [JSONDecoder](https://developer.apple.com/documentation/foundation/jsondecoder) being used to decode the JSON, for such scenarios the HTTPUtility provides a default init method where you can pass your own custom JSONDecoder and the HTTPUtility will make use of that Decoder and here's how you can do it

```swift
let customJsonDecoder = JSONDecoder()
customJsonDecoder.dateEncoding = .millisecondsSince1970
let utility = HttpUtility.shared
utility.customJsonDecoder = customJsonDecoder
```

## Token and Custom JSONDecoder

At times when you pass the token and the default JSONDecoder is just not enough, then you may use the init method of the utility to pass the token and a custom JSONDecoder both to make the API request and parse the JSON response

```swift
let utility = HttpUtility.shared
let customJsonDecoder = JSONDecoder()
customJsonDecoder.dateEncoding = .millisecondsSince1970

let bearerToken = "bearer your_token"

utility.customJsonDecoder = customJsonDecoder
utility.authenticationToken = bearerToken

```

## HUNetworkError

The HUNetworkError structure provides in detail description beneficial for debugging purpose, given are the following properties that will be populated in case an error occurs

1. ##### Status: ##### This will contain the HTTPStatus code for the request (200)

2. ##### ServerResponse: ##### This will be the JSON string of the response you received from the server. (not to be confused with error parameter) on error if server returns the error JSON data that message will be decoded to human readable string.

3. ##### RequestUrl: ##### The request URL that you just called.

4. ##### RequestBody: ##### If you get failure on POST request this property would contain a string representation of the HTTPBody that was sent to the server.

5. ##### Reason: ##### This property would contain the debug description from the error closure parameter.

This utility is for performing basic tasks, and is currently evolving, but if you have any specific feature in mind then please feel free to drop a request and I will try my best to implement it
