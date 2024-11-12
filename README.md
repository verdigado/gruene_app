# Gruene App

## Conventions

### Code Style

We follow the [Effective Dart code style](https://dart.dev/effective-dart/style).

Code should be formatted using `dart format` ([docs](https://dart.dev/tools/dart-format)).

### Commits, Branches and Pull Requests

Branch names should be written using kebab-case and have the following schema:

```
<issue_key>-your-branch-name

1234-commit-message-documentation
```

Commit messages and PR names should have the following schema:
```
<issue_key>: Your commit message

1234: Add commit message documentation
```

See [this guide](https://github.com/erlang/otp/wiki/Writing-good-commit-messages) for a general reference on how to
write good commit messages.

## Environment variables
The application uses the following environment variables:

- `USE_LOGIN`: If set to `true`, the application will use the OIDC login. This variable is only a temporary solution to allow starting the app without IDP with secure connection. It will be removed later.
- `CLIENT_ID`: The client ID of the OIDC client.
- `ISSUER`: The issuer url of the identity provider.

You can copy the `.env.example` file to `.env` and fill in the values.   
Please note that it's not possible to use the OIDC login if issuer url does not have a secure connection.

