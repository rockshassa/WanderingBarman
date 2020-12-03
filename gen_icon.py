#created by rockshassa

import os, sys, fnmatch, json, shutil
from PIL import Image

class XCAssetImage: #represents a 'slice' of an asset (a single PNG file + its metadata)
    def __init__(self,imageObject, filename):

        #preserve the original metadata for this image, so that we can include when we write our new icon set
        self.origData = imageObject

        #save the size for when we need to create this slice
        #it comes in as '60x60' so we need to parse it out
        #NOTE: assumes all images are square
        size = imageObject['size']
        self.size = float(size.split('x').pop(0))

        #save the scale to assist in creating this slice
        #comes in as '2x'
        scale = imageObject['scale']
        self.scale = int(scale.split('x').pop(0))

        #format the size nicely and compute this slice's filename
        prettySize = ''.join(str(self.size).split('.'))

        self.filename = filename+'_'+prettySize+'_'+str(self.scale)+'x.png'

    def to_json(self):

        #start with the original data, and modify the bits we know about
        jsonDict = self.origData

        prettySize = str(self.size).split('.')
        if len(prettySize) >= 2 and int(prettySize[1]) == 0:
            prettySize = prettySize[0]
        else:
            prettySize = str(self.size)

        jsonDict['size'] = prettySize+'x'+prettySize
        jsonDict['filename'] = self.filename
        jsonDict['scale'] = str(self.scale)+'x'
        
        return jsonDict

#mark - Filesystem utility functions 

def emptyDir(directory):
    for root, dirs, files in os.walk(directory):
        for f in files:
            os.unlink(os.path.join(root, f))
        for d in dirs:
            shutil.rmtree(os.path.join(root, d))

def findFiles(projectPath):
    
    pattern = 'AppIcon.appiconset'

    results = []

    for root, dirnames, filenames in os.walk(projectPath):

        for directory in dirnames:
            if pattern in directory:
                fullPath = os.path.join(root, directory)
                results.append(fullPath)

    print 'found paths: ' + str(results)
    return results

#create and write image based on metadata
def makeImage(source_img,asset):
    try:
        pixels = asset.size*asset.scale
        size = (pixels,pixels)
        source_img.thumbnail(size)
        source_img.save(asset.filename, "PNG")
        print 'created image for size ' + str(size)
    except IOError:
        print 'cannot create image for size ' + str(size)

#read in the iconset's metadata and create XCAssetImage objects from it
def generate_assets(filename, iconsetPath):

    contentsPath = iconsetPath + '/Contents.json'

    print contentsPath

    contents = open(contentsPath, 'r')

    spec = json.load(contents)
    
    prettyPrint(spec)

    assets = []
    
    for imageObject in spec['images']:

        asset = XCAssetImage(imageObject, filename)
        assets.append(asset)

    return assets

def prettyPrint(jsonObj):
    print json.dumps(jsonObj,sort_keys=True,indent=4,separators=(',', ': '))

def writeContents(assets):
    jsonDict = {}

    #Xcode adds an info dict on theirs, I guess we should too
    jsonDict['info'] = {
                        'version' : 1,
                        'author' : 'nick'
                        }

    images = []
    for a in assets:
        images.append(a.to_json())

    jsonDict['images'] = images

    prettyPrint(jsonDict)

    with open('Contents.json', 'w') as outfile:
        json.dump(jsonDict, outfile)

def main():

    #intended invocation:
    #python app_icon.py <imagename (relative to script location)> <project path>
    #python app_icon.py DBAppIcon2.png /Users/niko/Documents/DuncansBurgers
    argsList = sys.argv

    #grab our command line arguments
    path = os.getcwd()
    imgName = "logo.png"
    fileName = os.path.splitext(imgName)[0]

    #find our targets (iphone, ipad, watch, etc.)
    allIconSets = findFiles(path)

    source_img = Image.open(imgName)

    for iconSet in allIconSets:

        print 'processing ' + iconSet

        #figure out what we need to make
        assets = generate_assets(fileName, iconSet)

        #clear out our workspace
        emptyDir(iconSet)

        #move into the workspace before writing our images to disk
        os.chdir(iconSet)

        if 'WatchKit' in iconSet:
            #this results in the alpha channel being stripped from the image, a requirement for watch apps
            #convert produces a new image, does not modify the original
            imageToResize = source_img.convert("RGB")
        else:
            imageToResize = source_img.copy()

        for a in assets:
            img = imageToResize.copy()
            makeImage(img,a)

        writeContents(assets)

if __name__ == '__main__':
    main()