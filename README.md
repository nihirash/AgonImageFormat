# Simple graphics format for Agon computers

This format tries reduce file sizes and make it easy to use/load from any source(network, sd card etc).

## Image converter

It uses Python 3 with PIL library.

It can convert PNG, Jpeg and whatever PIL supports - just call it:

```
./img2agonimg.py botan.jpg botan.agi
```

And if image fits to buffer of VDP you'll got resulting file

## Example of loading file

Example of usage included as `agi-view` mos application(you can put it to `/bin` directory and use as command).

You can specify file name to it - and it will shows you image.

Some test images are included in `test/` directory.