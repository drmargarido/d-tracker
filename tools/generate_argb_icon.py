#!/usr/bin/python
# Simple program for printing an icon in ARGB format 
# so it can be added to X as icon
import gtk
from sys import argv, exit
from struct import pack, unpack

# really simple error handling
def err(msg=None):
	if msg:
		print msg
	exit(1)

# use GDK to load a graphics file into an array of pixels
pixmap = gtk.gdk.pixbuf_new_from_file(argv[1])
if not pixmap:
	err("Couldn't load pixmap")

pixels = pixmap.get_pixels_array()

# prop will contain an array of 32-bit integers
# starting with width, height, then pixel information
prop = []
prop += [len(pixels[0])]
prop += [len(pixels   )]

# pixel information is stored in the odd order: alpha, red, green, blue
for row in pixels:
	for p in row:
		p = p.tolist()
		if len(p) < 4:
			p += [255]
		p = p[3:] + p[:-1]
		argb = int(0)
		for i in range(len(p)):
			argb += p[i] << (8 * (len(p)-i-1))
		prop += unpack("i",pack("I",argb))

# Change the values to be unsigned
for i in xrange(len(prop)):
  prop[i] = prop[i] & 0xffffffff

print(prop)
