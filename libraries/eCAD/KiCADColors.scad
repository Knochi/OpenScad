ledAlpha=0.1;
glassAlpha=0.39;

metalGreyPinCol=    [0.824, 0.820,  0.781];
metalGreyCol=       [0.298, 0.298,  0.298]; //metal Grey
metalCopperCol=     [0.7038,0.27048,0.0828]; //metal Copper
metalAluminiumCol=  [0.372322, 0.371574, 0.373173];
metalBronzeCol=     [0.714, 0.4284, 0.18144];
metalSilverCol=     [0.50754, 0.50754, 0.50754];
resblackBodyCol=    [0.082, 0.086,  0.094]; //resistor black body
darkGreyBodyCol=    [0.273, 0.273,  0.273]; //dark grey body
brownBodyCol=       [0.379, 0.270,  0.215]; //brown Body
lightBrownBodyCol=  [0.883, 0.711,  0.492]; //light brown body
pinkBodyCol=        [0.578, 0.336,  0.352]; //pink body
blueBodyCol=        [0.137, 0.402,  0.727]; //blue body
greenBodyCol=       [0.340, 0.680,  0.445]; //green body
orangeBodyCol=      [0.809, 0.426,  0.148]; //orange body
redBodyCol=         [0.700, 0.100,  0.050]; 
yellowBodyCol=      [0.832, 0.680,  0.066];
whiteBodyCol=       [0.895, 0.891,  0.813];
metalGoldPinCol=    [0.859, 0.738,  0.496];
blackBodyCol=       [0.148, 0.145,  0.145];
greyBodyCol=        [0.250, 0.262,  0.281];
lightBrownLabelCol= [0.691, 0.664,  0.598];
ledBlueCol=         [0.700, 0.100,  0.050, ledAlpha];
ledYellowCol=       [0.100, 0.250,  0.700, ledAlpha];
ledGreyCol=         [0.98,  0.840,  0.066, ledAlpha];
ledWhiteCol=        [0.895, 0.891, 0.813, ledAlpha];
ledgreyCol=         [0.27, 0.25, 0.27, ledAlpha];
ledBlackCol=        [0.1, 0.05, 0.1];
ledGreenCol=        [0.400, 0.700,  0.150, ledAlpha];
glassGreyCol=       [0.400769, 0.441922, 0.459091, glassAlpha];
glassGoldCol=       [0.566681, 0.580872, 0.580874, glassAlpha];
glassBlueCol=       [0.000000, 0.631244, 0.748016, glassAlpha];
glassGreenCol=      [0.000000, 0.75, 0.44, glassAlpha];
glassOrangeCol=     [0.75, 0.44, 0.000000, glassAlpha];
pcbGreenCol=        [0.07,  0.3,    0.12]; //pcb green
pcbBlackCol=        [0.16,  0.16,   0.16]; //pcb black
pcbBlue=            [0.07,  0.12,   0.3];
FR4darkCol=         [0.2,   0.17,   0.087]; //?
FR4Col=             [0.43,  0.46,   0.295]; //?



colorList=[
metalGreyPinCol,
metalGreyCol,
metalCopperCol,
metalAluminiumCol,
metalBronzeCol,
metalSilverCol,
resblackBodyCol,
darkGreyBodyCol,
brownBodyCol,
lightBrownBodyCol,
pinkBodyCol,
blueBodyCol,
greenBodyCol,
orangeBodyCol,
redBodyCol,
yellowBodyCol,
whiteBodyCol,
metalGoldPinCol,
blackBodyCol,
greyBodyCol,
lightBrownLabelCol,
ledBlueCol,
ledYellowCol,
ledGreyCol,
ledWhiteCol,
ledgreyCol,
ledBlackCol,
ledGreenCol,
glassGreyCol,
glassGoldCol,
glassBlueCol,
glassGreenCol,
glassOrangeCol,
pcbGreenCol,
pcbBlackCol,
pcbBlue,
FR4darkCol,
FR4Col
];

*testColors();
module testColors(){
    cubeSize=10;
    cubeDist=5;
    for (ix=[0:len(colorList)-1])
      color(colorList[ix]) translate([ix*(cubeDist+cubeSize),0,0]) cube(cubeSize,true);

}

//testcube
*color(blackBodyCol) cube(10,true);

/* From KiCAD wrl file
Shape { //metalGreyPin
    appearance Appearance {material DEF PIN-01 Material {
        ambientIntensity 0.271
        diffuseColor 0.824 0.820 0.781
        specularColor 0.328 0.258 0.172
        emissiveColor 0.0 0.0 0.0
        shininess 0.70
        transparency 0.0
        }
    }
}
Shape { metal grey 
    appearance Appearance {material DEF MET-01 Material {
        ambientIntensity 0.249999
        diffuseColor 0.298 0.298 0.298
        specularColor 0.398 0.398 0.398
        emissiveColor 0.0 0.0 0.0
        shininess 0.056122
        transparency 0.0
        }
    }
}
Shape { metal gold pin
    appearance Appearance {material DEF PIN-02 Material {
        ambientIntensity 0.379
        diffuseColor 0.859 0.738 0.496
        specularColor 0.137 0.145 0.184
        emissiveColor 0.0 0.0 0.0
        shininess 0.40
        transparency 0.0
        }
    }
}
Shape { //black body
    appearance Appearance {material DEF IC-BODY-EPOXY-04 Material {
        ambientIntensity 0.293
        diffuseColor 0.148 0.145 0.145
        specularColor 0.180 0.168 0.160
        emissiveColor 0.0 0.0 0.0
        shininess 0.35
        transparency 0.0
        }
    }
}
Shape { //res black body
    appearance Appearance {material DEF RES-SMD-01 Material {
        diffuseColor 0.082 0.086 0.094
        emissiveColor 0.000 0.000 0.000
        specularColor 0.066 0.063 0.063
        ambientIntensity 0.638
        transparency 0.0
        shininess 0.3
        }
    }
}
Shape { //grey Body
    appearance Appearance {material DEF IC-BODY-EPOXY-01 Material {
        ambientIntensity 0.117
        diffuseColor 0.250 0.262 0.281
        specularColor 0.316 0.281 0.176
        emissiveColor 0.0 0.0 0.0
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape {  dark grey body
    appearance Appearance {material DEF CAP-CERAMIC-05 Material {
        ambientIntensity 0.179
        diffuseColor 0.273 0.273 0.273
        specularColor 0.203 0.188 0.176
        emissiveColor 0.0 0.0 0.0
        shininess 0.15
        transparency 0.0
        }
    }
}
Shape { brown body
    appearance Appearance {material DEF CAP-CERAMIC-06 Material {
        ambientIntensity 0.453
        diffuseColor 0.379 0.270 0.215
        specularColor 0.223 0.223 0.223
        emissiveColor 0.0 0.0 0.0
        shininess 0.15
        transparency 0.0
        }
    }
}
Shape { light brown body
    appearance Appearance {material DEF RES-THT-01 Material {
        ambientIntensity 0.149
        diffuseColor 0.883 0.711 0.492
        specularColor 0.043 0.121 0.281
        emissiveColor 0.0 0.0 0.0
        shininess 0.40
        transparency 0.0
        }
    }
}
Shape { blue body
    appearance Appearance {material DEF PLASTIC-BLUE-01 Material {
        ambientIntensity 0.565
        diffuseColor 0.137 0.402 0.727
        specularColor 0.359 0.379 0.270
        emissiveColor 0.0 0.0 0.0
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape { green body
    appearance Appearance {material DEF PLASTIC-GREEN-01 Material {
        ambientIntensity 0.315
        diffuseColor 0.340 0.680 0.445
        specularColor 0.176 0.105 0.195
        emissiveColor 0.0 0.0 0.0
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape { orange body
    appearance Appearance {material DEF PLASTIC-ORANGE-01 Material {
        ambientIntensity 0.284
        diffuseColor 0.809 0.426 0.148
        specularColor 0.039 0.102 0.145
        emissiveColor 0.0 0.0 0.0
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape { red body
    appearance Appearance {material DEF RED-BODY Material {
        ambientIntensity 0.683
        diffuseColor 0.700 0.100 0.050
        emissiveColor 0.000 0.000 0.000
        specularColor 0.300 0.400 0.150
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF CAP-CERAMIC-02 Material {
        ambientIntensity 0.683
        diffuseColor 0.578 0.336 0.352
        specularColor 0.105 0.273 0.270
        emissiveColor 0.0 0.0 0.0
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF PLASTIC-YELLOW-01 Material {
        ambientIntensity 0.522
        diffuseColor 0.832 0.680 0.066
        specularColor 0.160 0.203 0.320
        emissiveColor 0.0 0.0 0.0
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF PLASTIC-WHITE-01 Material {
        ambientIntensity 0.494
        diffuseColor 0.895 0.891 0.813
        specularColor 0.047 0.055 0.109
        emissiveColor 0.0 0.0 0.0
        shininess 0.25
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF IC-LABEL-01 Material {
        ambientIntensity 0.082
        diffuseColor 0.691 0.664 0.598
        specularColor 0.000 0.000 0.000
        emissiveColor 0.0 0.0 0.0
        shininess 0.01
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF LED-RED Material {
        ambientIntensity 0.789
        diffuseColor 0.700 0.100 0.050
        emissiveColor 0.000 0.000 0.000
        specularColor 0.300 0.400 0.150
        shininess 0.125
        transparency 0.10
        }
    }
}
Shape {
    appearance Appearance {material DEF LED-GREEN Material {
        ambientIntensity 0.789
        diffuseColor 0.400 0.700 0.150
        emissiveColor 0.000 0.000 0.000
        specularColor 0.600 0.300 0.100
        shininess 0.05
        transparency 0.10
        }
    }
}
Shape {
    appearance Appearance {material DEF LED-BLUE Material {
        ambientIntensity 0.789
        diffuseColor 0.100 0.250 0.700
        emissiveColor 0.000 0.000 0.000
        specularColor 0.500 0.600 0.300
        shininess 0.125
        transparency 0.10
        }
    }
}
Shape {
    appearance Appearance {material DEF LED-YELLOW Material {
        ambientIntensity 0.522
        diffuseColor 0.98 0.840 0.066
        specularColor 0.160 0.203 0.320
        emissiveColor 0.0 0.0 0.0
        shininess 0.125
        transparency 0.10
        }
    }
}
Shape {
    appearance Appearance {material DEF LED-WHITE Material {
        ambientIntensity 0.494
        diffuseColor 0.895 0.891 0.813
        specularColor 0.047 0.055 0.109
        emissiveColor 0.0 0.0 0.0
        shininess 0.125
        transparency 0.10
        }
    }
}
Shape {
    appearance Appearance {material DEF LED-GREY Material {
        ambientIntensity 0.494
        diffuseColor 0.27 0.25 0.27
        specularColor 0.5 0.5 0.6
        emissiveColor 0.0 0.0 0.0
        shininess 0.35
        transparency 0.10
        }
    }
}
Shape {
    appearance Appearance {material DEF LED-BLACK Material {
        ambientIntensity 0.494
        diffuseColor 0.1 0.05 0.1
        specularColor 0.6 0.5 0.6
        emissiveColor 0.0 0.0 0.0
        shininess 0.5
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF GLASS-19 Material {
        ambientIntensity 2.018212
        diffuseColor 0.400769 0.441922 0.459091
        specularColor 0.573887 0.649271 0.810811
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.127273
        transparency 0.37
        }
    }
}
Shape {
    appearance Appearance {material DEF GLASS-29 Material {
        ambientIntensity 0.234375
        diffuseColor 0.566681 0.580872 0.580874
        specularColor 0.617761 0.429816 0.400140
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.072727
        transparency 0.38
        }
    }
}
Shape {
    appearance Appearance {material DEF GLASS-13 Material {
        ambientIntensity 0.250000
        diffuseColor 0.000000 0.631244 0.748016
        specularColor 0.915152 0.915152 0.915152
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.642424
        transparency 0.39
        }
    }
}
Shape {
    appearance Appearance {material DEF GLASS-GREEN Material {
        ambientIntensity 0.250000
        diffuseColor 0.000000 0.75 0.44
        specularColor 0.915152 0.915152 0.915152
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.642424
        transparency 0.39
        }
    }
}
Shape {
    appearance Appearance {material DEF GLASS-ORANGE Material {
        ambientIntensity 0.250000
        diffuseColor 0.75 0.44 0.000000
        specularColor 0.915152 0.915152 0.915152
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.642424
        transparency 0.39
        }
    }
}
Shape {
    appearance Appearance {material DEF BOARD-GREEN-02 Material {
        ambientIntensity 1
        diffuseColor 0.07 0.3 0.12
        specularColor 0.07 0.3 0.12
        emissiveColor 0.0 0.0 0.0
        shininess 0.40
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF BOARD-BLUE-01 Material {
        ambientIntensity 1
        diffuseColor 0.07 0.12 0.3
        specularColor 0.07 0.12 0.3
        emissiveColor 0.0 0.0 0.0
        shininess 0.40
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF BOARD-BLACK-03 Material {
        ambientIntensity 1
        diffuseColor 0.16 0.16 0.16
        specularColor 0.16 0.16 0.16
        emissiveColor 0.0 0.0 0.0
        shininess 0.40
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF MET-ALUMINUM Material {
        ambientIntensity 0.256000
        diffuseColor 0.372322 0.371574 0.373173
        specularColor 0.556122 0.554201 0.556122
        emissiveColor 0.0 0.0 0.0
        shininess 0.127551
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF MET-BRONZE Material {
        ambientIntensity 0.022727
        diffuseColor 0.714 0.4284 0.18144
        specularColor 0.393548 0.271906 0.166721
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.2
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF MET-SILVER Material {
        ambientIntensity 0.022727
        diffuseColor 0.50754 0.50754 0.50754
        specularColor 0.508273 0.508273 0.508273
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.4
        transparency 0.0
        }
    }
}
Shape {
    appearance Appearance {material DEF MET-COPPER Material {
        ambientIntensity 0.022727
        diffuseColor 0.7038 0.27048 0.0828
        specularColor 0.780612 0.37 0.000000
        emissiveColor 0.000000 0.000000 0.000000
        shininess 0.2
        transparency 0.0
        }
    }
}
*/