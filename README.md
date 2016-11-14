# mruby-simple-game-engine ![travis status](https://travis-ci.org/dabroz/mruby-simple-game-engine.svg) ![MIT license](https://img.shields.io/badge/license-MIT-blue.svg) [![Coverage Status](https://coveralls.io/repos/github/dabroz/mruby-simple-game-engine/badge.svg)](https://coveralls.io/github/dabroz/mruby-simple-game-engine)

![Game screenshot](http://i.imgur.com/AEftdwW.png)

This project is based on a talk I gave at Game Industry Conference 2016 in Poznań titled "*Why (m)ruby should be your next scripting language?*".

You can find slides PDF file from this talk in `/slides` directory.

This project implements a very basic component-based game engine. The backend is written in C++ and uses SFML for rendering. All game logic is in mruby scripts.

Bullet points:

### 1. C++ & mruby build pipeline

Ruby scripts are precompiled during the build process, and supplied as inline data (C header) to the game. In the release version this is all you need (unless you want modding support).

### 2. Dynamic reload

Engine uses `fswatch` pipe to monitor file changes. When a game script changes, it is dynamically parsed and reloaded. Parse (syntax) errors are caught and don't break the game.

Run the game, arrange the game window and your favorite editor and try experimenting with the `scripts/010_example.rb`.

### 3. Safe execution environment

Most exceptions are caught by the game scripts, voiding the game code in result. All other data is however retained. There are of course more sophisticated ways to sandbox the game code.

### 4. Ruby tools integration

Since the game code is Ruby, you can use usual Ruby tools to help you write it.

Run `rubocop` or `rspec` in the engine directory. Standard Ruby coverage testing is also included.

### 5. Tests

Game logic can get complicated really fast - you absolutely should test it. See `spec/` directory for examples.

### 6. Coroutines to handle game logic

Game logic is handled using coroutines, which are great to write complex logic quickly, using the language you already know. See `ai_controller` (`Brain`).

## INSTALL

Tested on OSX. You need SFML 2 libraries and `fswatch` program.

- OSX: `brew install sfml fswatch`

Then, to build mruby binaries and game scripts, and then run the game:

    rake run

## LICENSE

### Game code

Copyright Tomasz Dąbrowski, MIT License.
See LICENSE.txt

### data/font

Copyright Christian Robertson, Apache License.

See data/font/LICENSE.txt

https://fonts.google.com/specimen/Roboto

### data/background

Copyright Hyptosis, available under CC-BY 3.0.

See data/background/LICENSE.txt

http://opengameart.org/content/lots-of-free-2d-tiles-and-sprites-by-hyptosis

### data/sprite

Copyright Antifarea, available under CC-BY 3.0.

See data/sprite/LICENSE.txt

http://opengameart.org/content/antifareas-rpg-sprite-set-1-enlarged-w-transparent-background

Copyright Iwan Gabovitch, available under CC-BY-SA 3.0.

See data/sprite/LICENSE.txt

http://opengameart.org/content/pixel-art-contest-entry-top-hat-lolhat
