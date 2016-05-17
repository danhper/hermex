# BuildyPush

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix


## Apple certificate

### .p12 -> .pem

openssl pkcs12 -in cert.p12 -out apple_push_notification.pem -nodes -clcerts

### .pem to key+cert

openssl pkey -in foo.pem -out foo-key.pem
openssl x509 -in foo.pem -out foo-cert.pem
