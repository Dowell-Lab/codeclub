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
  - A quick voice conversation is often much quicker when trying to
    clarify things.
  - Everyone has an account through CU
  - Turn off video when at all possible to save bandwidth
- Overleaf
  - Now is an awesome time to work on that manuscript you've been
    procrastinating on. If you want to use LaTeX, we have a lab
    overleaf account that Robin can create large projects on.
  - Overleaf is basically Microsoft Word for LaTeX, and has all the
    tools you might expect. We had a great experience using it for
    TFEA.
- Google Drive / Docs
  - This is always an option for spreadsheets and presentations
  - If you're feeling brave, please let me know and you can help
    contribute to the nascent repository!

## Tips for home offices

- Keep a routine if you can. Without a regular schedule the days can
  all start to blend together.
- Go outside! Walk around and get some fresh air if you're starting to
  have a hard time focusing. Make sure to keep appropriate social distance.
- If possible, have a workspace that you use just for work. This might
  be difficult for everyone living in small apartments (myself
  included).
- Try to maintain good ergonomics at your desk. It might be
  comfortable to work from a couch, but it could wreck your posture.
- Headphones are a blessing for getting some peace and quiet.
- Have a stopping point for your day. Whether you start early or end
  late, define a time where you'll be done working and do things for
  yourself instead.
- *Stay Hydrated*. Keep a water bottle or glass of water by your work
  area.

## Tips for Zoom Meetings

- If you can use them, headphones can make it easier to understand
  people even when network conditions are bad.
- In Zoom settings you can disable video and mute audio automatically
  for any call you enter. This is a good idea.
- If you're using video, you can set a custom background in the
  settings. I like to use NASA space pictures.

## Technical tips for Working with FIJI

Given that the VPN is likely overloaded, there are a few things you
can do:

- Since residential connections are often much faster on download than
  upload, try to keep things on FIJI and do processing there before
  pulling them down to look at. If you try to upload a large file it
  will take a while to complete.

- You can do a ton of analysis with a counts table for DESeq2 even on
  your local machine. You can do differential expression analysis,
  gsea, and all sorts of other statistical plots that could be
  informative. Plus, the files are tiny and easy to move around.

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

- When using rsync to push and pull large things, enable compression
  by adding the `-z` flag to your commands. Compression should help
  speed up your transfers and save bandwidth over the VPN.

- Try to use fiji-viz if you want to view huge files. So far I've had
  painfully slow experiences pulling files from FIJI to look at on my
  local computer, unless they're very small.

- If you're on Linux, you can set up
  [ocproxy](https://github.com/cernekee/ocproxy), which routes CU's
  VPN (using openconnect) through a proxy. This lets you use the VPN
  only for things that you want to use it for, and keeps the rest of
  your traffic going through your home network at its normal speed.
  Add the magical invocation below to your ssh configuration to route
  ssh connections to FIJI through the VPN proxy only when you're not
  on campus.

```
Match Host fiji* !exec "ping -c 1 -W 0.5 fiji.colorado.edu &> /dev/null"
    ProxyCommand nc -X 5 -x 127.0.0.1:9052 %h %p
    Compression yes
```

  Unfortunately I don't know how you would do this on a windows
  system. It might work on Macs, but I don't have experience with how
  to make that work.

## Miscellaneous advice

- You're going to be on the internet a lot, it's probably a good idea
  to use an adblocker to save bandwidth and your sanity. uBlock
  *origin* is the state-of-the-art and also open source.
  - [uBlock Origin for Firefox](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - [uBlock Origin for Chrome](https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm?hl=en)
- Now that we're all primarily working on analysis projects, you're
  probably spending a lot of time looking at scripts. Lots of people
  I've talked to like Visual Studio Code, which is freely available
  and easy to install on all platforms. Find details [here](https://code.visualstudio.com/)
