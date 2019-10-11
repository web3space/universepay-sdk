require! {
    \superagent : { get, post }
    \./currencies.ls
    \./languages.ls
    \prelude-ls : { keys }
    \md5
}
currency-codes =
    currencies |> keys

language-codes =
    languages |> keys

urls =
    test: \https://universepay.online/sandbox/gateway/
    prod: \https://universepay.online/new/gateway/



uuidv4 = ->
  'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace //[xy]//g, (c) ->
    r = Math.random! * 16 .|. 0
    v = if c is 'x' then r else r .&. 3 .|. 8
    v.toString 16

build-make-request = ({ url, config })-> (body, cb)->
    return cb "Expected first argument, type object" if typeof! body isnt \Object
    return cb "Expected second argument, type function" if typeof! cb isnt \Function
    return cb "Expected body.amount -> Minor units, e.g. 1 for 0.01" if typeof! body.amount isnt \Number
    return cb "Expected body.currency -> Currency code in ISO 4217 : #{currency-codes}" if currency-codes.index-of(body.currency) is -1
    return cb "Expected body.language -> Language codes : #{language-codes}" if language-codes.index-of(body.language) is -1
    return cb "Expected body.cl_fname -> Client's first name (max length 200)" if typeof! body.cl_fname isnt \String or body.cl_fname.length > 200 
    return cb "Expected body.cl_lname -> Client's last name (max length 200)" if typeof! body.cl_lname isnt \String or body.cl_lname.length > 200 
    return cb "Expected body.cl_email -> Client's email (max length 200)" if typeof! body.cl_email isnt \String or body.cl_email.length > 200 
    return cb "Expected body.cl_country -> Country code in ISO 3166-1-alpha-2" if typeof! body.cl_country isnt \String or  body.cl_country.length isnt 2
    return cb "Expected body.cl_city -> City (max length 200)" if typeof! body.cl_city isnt \String or body.cl_city.length > 200
    return cb "Expected body.description -> Description of the transaction, visible to the client, e.g. description of the product (max length 200)" if typeof! body.description isnt \String or body.description.length > 200
    return cb "Expected body.psys -> Payment system alias. Empty for default or taken from the available payment systems list. (max length 200)" if typeof! body.psys isnt \String or body.psys.length > 200
    invoice = uuidv4!
    { MERCHANT_ID, MERCHANT_SECRET } = config
    hash = md5("#{body.amount}#{body.currency}#{MERCHANT_ID}#{MERCHANT_SECRET}")
    _cmd = \payment
    get_trans = 1
    request = { _cmd, get_trans, merchant_id: MERCHANT_ID, hash, invoice, ...body }
    err, res <- post url .type 'form' .send request .end
    console.log url, { _cmd, get_trans, merchant_id: MERCHANT_ID, hash, invoice, ...body }
    return cb err.text if err?
    return cb err.text if res.text.index-of('ERROR') > -1
    cb null, res.text

build-api = ({ name, config }, cb)->
    url = urls[name]
    return cb "#{name} url not found" if not url?
    make-request = build-make-request { url, config }
    cb null, { make-request }

module.exports = (config, cb)->
    return cb "MERCHANT_ID is required" if typeof! config.MERCHANT_ID isnt \String
    return cb "MERCHANT_SECRET is required" if typeof! config.MERCHANT_SECRET isnt \String
    err, test <- build-api { name: \test , config }
    return cb err if err?
    err, prod <- build-api { name: \prod , config }
    return cb err if err?
    cb null, { test, prod }
    
