#!/usr/bin/python3
import tkinter
import tkinter.font
app = tkinter.Frame()
 
def width_and_height_calculator_in_pixel(txt, fontname, fontsize):
    font  = tkinter.font.Font(family=fontname, size=fontsize)
    return (font.measure(txt), font.metrics('linespace'))

#openscad default size is "10"
#25.4mm height will correspont to 100pt
#12pt would be 12x0.254mm height or 28px (for liberation mono)


print( width_and_height_calculator_in_pixel("AICM", "Liberation Mono", 12) )
