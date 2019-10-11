require! {
    \../api.ls : make-api
}
err, api <- make-api { MERCHANT_ID: "780", MERCHANT_SECRET: 'ncd8bndX9#jnd8scD93sdow4SCFu9dshs9' }

return console.log { err } if err?

request =
    amount: 1
    currency: "UAH"
    language: "ENG"
    cl_fname: "Andrey"
    cl_lname: "Stehno"
    cl_email: "a.stegno@gmail.com"
    cl_country: "UA"
    cl_city: "Kiev"
    cl_dob: "2011-08-10"
    cl_wallet: "0x123"
    description: "Test Payment"
    psys: ""

err, data <- api.prod.make-request(request)

console.log { err, data }