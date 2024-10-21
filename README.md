# README

This is a simple event listener from Stripe webhooks. 

To run the aplication just execute 
```
rails s
```
It will start it on port 3000.

To test the webhooks you need your own account on Stripe, sorry, I don't share my credentials 😉. Just update rails credentials with your owrn secret_key and endpoint_secret, with the help of this command.
```
EDITOR=vi rails credentials:edit
```

You need to login via Stripe CLI. To send webhooks to localhost, you can run this command, it will redirect the requests to my event endpoint.
```
stripe listen --forward-to localhost:3000/webhooks/stripe/events
```
As a short-cut, there's a CLI triggers for every event, for example
```
stripe trigger customer.subscription.created
```

Have a good read there, any feedback is appreciated
