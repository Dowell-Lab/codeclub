# Tips for Working from Home

## Resources we already have available

- Lab Keybase
  - Best for getting in touch with people right away
  - Secure and end-to-end encrypted
  - Chat with people, ask questions, or send files
- Email lists
  - Best for announcements and lab-wide questions
  - `dnalab@lists.colorado.edu`
  - `dowelllab@lists.colorado.edu`
- Zoom
  - Best for collaborating directly
  - Voice is a lot higher bandwidth than text
  - Everyone has an account through CU
  - Turn off video when at all possible 

## Tips for home offices

- Try to maintain good ergonomics
- Headphones are a blessing for getting some peace and quiet

## Miscellaneous advice

- You're going to be on the internet a lot, it's probably a good idea
  to use an adblocker to save bandwidth and your sanity. uBlock
  *origin* is a state-of-the-art open source ad-blocker.
  - [uBlock Origin for Firefox](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - [uBlock Origin for Chrome](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en)


## Working with FIJI (technical)

Given that the VPN is likely overloaded, there are a few things you
can do:

- In your vimrc (`~/.vimrc`), set the following. This tells vim to
  only update the screen when absolutely needed, which can help speed
  up vim for things like pasting in text or macros.

```
set ttyfast ; Tell vim to get more characters at once
set lazyredraw ; Only refresh the screen when absolutely needed
```

- In your ssh config, set 'Compression yes' for FIJI related
  connections. This compresses your connection and uses less
  bandwidth. It should be more responsive when the VPN is under heavy
  load.

```
Host fiji*
    Compression yes
```
