# Conventions

## Contents

- [Code Style](#code-style)
- [Commits, Branches and Pull Requests](#commits-branches-and-pull-requests)
- [Versioning](#versioning)

## Code Style

We follow the [Effective Dart code style](https://dart.dev/effective-dart/style).

Code should be formatted using `dart format` ([docs](https://dart.dev/tools/dart-format)).

## Commits, Branches and Pull Requests

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

## Versioning

Versions consist of a version name and a version code and are set in [version.yaml](../version.yaml).
Versions are automatically bumped and committed using the corresponding scripts in [tools](../tools) in the
delivery [workflows](#workflows) in the CI.

### Version Name

We use the [calver schema](https://calver.org) `YYYY.MM.PATCH` for versioning.
`PATCH` is a counter for the number of releases in the corresponding month starting with 0.

Examples:

- First versions of 2024: `2024.1.0`, `2024.1.1`, `2024.1.2`.
- First version of February 2024: `2024.2.0`.

### Version Code

An additional consecutive version code is used for unique identification in the app stores.
The version code has to be incremented for every new release uploaded to the stores.
