# MegaProcessor
A library and examples for the MegaProcessor (http://www.megaprocessor.com/)

## About
This is a project I intend to never finish! There's too much effort, for too little reward. So, I'm putting it here primarily as a backup to my private repo, and whatever educational value anyone can derive from it.

## The Library
Using the basic naming and ideas of my SGX library, I've provided a font drawing routine:

```
    ld.w    r2, #INT_RAM_START + 16;
    ld.w    r3, #TXT_MONA;
    jsr     sgx_graphics_Font_draw;

TXT_MONA equ $;
    db 4;
    db FONT_UC_M, FONT_LC_O, FONT_LC_N, FONT_LC_A;

```

and image blitter:

```
	// Prepare the image
	ld.w    r3, #IMG_MONA_LISA;
	jsr     sgx_graphics_DrawSurface_setFillTexture;

	// Draw the image
	ld.w    r2, #INT_RAM_START + 48;
	jsr     sgx_graphics_DrawSurface_fillPoint;
```

The format for the image is:

```
IMG_MONA_LISA        equ     $;
    db 4, 164;  // width of image (in bytes), height of image (in rows)
    db 0,0,0,0,0,128,3,0,0,240,15,0,0,248,63,0,0,252,127,0,0,230,126,0,0,6,254,0,0,2,252,0,0,2,248,1,0....
```


## Examples
There are three short examples using the MegaProcessor version of SGX.

* monalisa - draws a mono version of La Gioconda
* fontest - draws 32 characters from the embedded font
* minecraft - fills the display with a brick pattern

