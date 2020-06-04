# HttpUtility
HttpUtility is a light weight open source MIT license project which is helpful in making HTTP requests to the server. It uses URLSession to make requests to the API and returns the [Result enum](https://developer.apple.com/documentation/swift/result) containing the decoded object in case of success or a error incase of failure. Right now this utility only decodes JSON response returned by the server.

[![Build Status](https://travis-ci.com/codecat15/HttpUtility.svg?branch=master)](https://travis-ci.com/codecat15/HttpUtility)

# Purpose of usage
Most of the time iOS application just perform simple HTTP operations which include sending request to the server and getting a response and displaying it to the user. If your iOS app does that then you may use this utility which does not do too much of heavy lifting and just pushes your request to the server and returns you a decoded object.

# Using HttpUtility
## Introduction
HttpUtility can be used for basic http operations like get, post, put and delete. It uses [URLSession](https://developer.apple.com/documentation/foundation/urlsession) to perform operations and is just a wrapper around it. 

The best thing about this utility is that it takes a simple URL and returns you a decoded object if the request is successful and returns an error if the request fails. Say good bye to writing loops and custom code to parse JSON response.

Given are the some of the examples on how you can make use of this utility

1. [Get request](https://github.com/codecat15/HttpUtility#GET%20Request%20example)
2. [Post request](https://github.com/codecat15/HttpUtility#POST%20request%20example)
3. [Request with query string parameters](https://github.com/codecat15/HttpUtility#GET%20request%20with%20Query%20string%20parameters)
4. [Request with authentication token](https://github.com/codecat15/HttpUtility#Authentication%20Token)
5. [Customize JSONDecoder](https://github.com/codecat15/HttpUtility#Custom%20JSONDecoder)

## GET Request example

```swift
let requestUrl = URL(string: "http://demo0333988.mockable.io/Employees")
        let utility = HTTPUtility()
        utility.getData(requestUrl: requestUrl!, resultType: Employees.self) { (response) in
            switch response
           {
            case .success(let employee):
            // your code here to display data

            case .failure(let error):
            // your code here to handle error
            
           }
        }
```

## POST request example

```swift
let requestUrl = URL(string: "https://api-dev-scus-demo.azurewebsites.net/api/User/RegisterUser")
let registerUserRequest = RegisterUserRequest(firstName: "code", lastName: "cat15", email: "codecat15@gmail.com", password: "1234")
let registerUserBody = try! JSONEncoder().encode(registerUserRequest)

  let utiltiy = HttpUtility()
  utility.postData(requestUrl: requestUrl!, requestBody: registerUserBody, resultType: RegisterResponse.self) { (response) in
   switch response
    {
      case .success(let registerResponse):
       // your code here to display data
       
       case .failure(let error):
       // your code here to handle error
       
     }
```

## GET request with Query string parameters

```swift
let request = PhoneRequest(color: "Red", manufacturer: nil)

// using the extension to convert the encodable request structure to a query string url
let requestUrl = request.convertToQueryStringUrl(urlString:"https://api-dev-scus-demo.azurewebsites.net/api/Product/GetSmartPhone")

let utility = HttpUtility()
utility.getData(requestUrl: requestUrl!, resultType: PhoneResponse.self) { (response) in

    switch response
    {
    case .success(let phoneResponse):
    // your code here to display data
    
    case .failure(let error):
    // your code here to handle error
    
   }
}
```

## Authentication Token

```swift
let requestUrl = URL(string: "http://demo0333988.mockable.io/Employees")
let utility = HttpUtility(token: "your authentication token")
        utility.getData(requestUrl: requestUrl!, resultType: Employees.self) { (response) in
            switch response
           {
            case .success(let employee):
            // your code here to display data

            case .failure(let error):
            // your code here to handle error
            
           }
        }
```
if you are using a basic or a bearer token then make sure you put basic or bearer before your token starts

### Example: Basic token
```swift
let basicToken = "basic your_token"
let utility = HttpUtility(token: basicToken)
```

### Example: Bearer token
```
let bearerToken = "bearer your_token"
let utility = HttpUtility(token: bearerToken)
```

## Custom JSONDecoder 

At times it may happen that you may need to control the behaviour of the default [JSONDecoder](https://developer.apple.com/documentation/foundation/jsondecoder) being used to decode the JSON, for such scenarios the HTTPUtility provides a default init method where you can pass your own custom JSONDecoder and the HTTPUtility will make use of that Decoder and here's how you can do it

```swift
let customJsonDecoder = JSONDecoder()
customJsonDecoder.dateEncoding = .millisecondsSince1970
let utility = HttpUtility(WithJsonDecoder: customJsonDecoder)
```
## Token and Custom JSONDecoder
At times when you pass the token and the default JSONDecoder is just not enough, then you may use the init method of the utility to pass the token and a custom JSONDecoder both to make the API request and parse the JSON response

```swift
let customJsonDecoder = JSONDecoder()
customJsonDecoder.dateEncoding = .millisecondsSince1970
let utility = HttpUtility(token: "your_token", decoder: customJsonDecoder)

```

This utility is for performing basic tasks, and is currently evolving, 
