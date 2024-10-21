# README

This is a simple event listener from Stripe webhooks. 

To run the aplication just execute 
```
rails s
```
It will start it on port 3000.

To test the webhooks you need your own account on Stripe, sorry, I don't share my credentials 😉. Just update rails credentials with your owrn secret_key and , executing this command
```
EDITOR=vi rails credentials:edit
```
