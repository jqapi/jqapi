# jQAPI - Alternative jQuery Documentation Browser

## What is this?

This is a alternative interface to browse the [Official jQuery Documentation](https://api.jquery.com). It was created to get out of your way of your development work - quickly find what you are looking for, easy on the eyes, and lightning fast.

## Commands

Run with `npm run [command]`

### `docs:update`

Clone the latest [official docs](https://github.com/jquery/api.jquery.com) in a git submodule.

### `docs:generate`

Generate the JSON navigation from the official docs' XML.

### `docs:copy`

Copy the resources, e.g. images

### `docs`

Run the above commands in series.

### `build`

Build the production site. Note that the `docs` command must be run before.

### `dev`

Start the development server. Note that the `docs` command must be run before.

### `preview`

Preview the production site.

### `test:update`

Run the tests and update the snapshots.

### `test`

Run the tests.

## Credits

- [Keyboard Icon](https://icon-icons.com/icon/keyboard/78941)
- [Magnifying Glass](https://icon-icons.com/pack/Neu-Interface/2469)
- All packages in [package.json](./package.json)
- All [contributors](https://github.com/jqapi/jqapi/graphs/contributors)
