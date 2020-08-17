import glob
from PIL import Image

imgsize = 32

imgs = glob.glob("*.png")


lut = []
for i in range(0,3):
    for j in range(0,256):
        lut.append(j)
        #print(j)
for i in range(0,256):
    if i < 255: lut.append(0)
    else: lut.append(255)
print(len(lut))

for i in imgs:
    resimg = Image.open(i).convert("RGBA")
    resimg = resimg.point(lut)
    resimg.save(i)
    #resimg.show()
