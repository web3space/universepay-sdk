# UniversePay API

* Integration manual
* Reviewed by UniversePay department in March 2019
* Approved by Tatjana Stasjuka, UniversePay CEO
* Version 1.2

--------------------------

## Get Started



## Install

`npm i universepay`


## Build API

```Javascript

const universepay = require('universepay');

const config = { 
    MERCHANT_SECRET : ""
    DOMAIN : ""
    URL_RETURN : ""
    URL_STATUS : ""
    MERCHANT_ID : ""
}

universepay(config, ({ test, prod } )=> {
    test.makeRequest(...)
});

```

