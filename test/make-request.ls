require! {
    \../api.ls : make-api
}

err, api <- make-api { MERCHANT_ID: "", MERCHANT_SECRET: "" }

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
    description: "Test Payment"
    psys: "Paypal"

err, data <- api.test.make-request(request)

console.log { err, data }