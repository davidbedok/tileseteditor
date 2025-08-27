import subprocess
import json
import os
import shutil

def getLTWH( data ):
    result = {}
    if 'ltwh' in data:
        ltwhData = data['ltwh'].split(':')
        ltData = ltwhData[0].split('x')
        whData = ltwhData[1].split('x')
        result['left'] = int(ltData[0])
        result['top'] = int(ltData[1])
        result['width'] = int(whData[0])
        result['height'] = int(whData[1])
        # print(result)
    else:
        result = data
    return result

def removeTiles( sourceWidth, data, tilePath ):
    result = []
    for y in range(data['top'], data['top'] + data['height']):
        for x in range(data['left'], data['left'] + data['width']):
            index = (y - 1) * sourceWidth + (x - 1)
            result.append(removeTileByIndex(index, tilePath))
    return result

def removeTilesByIndices( indices, tilePath ):
    result = []
    for index in indices:
        result.append(removeTileByIndex(index, tilePath))
    return result

def removeTileByIndex( index, tilePath ):
    file = f"{tilePath}{index}.png"
    os.remove(file)
    # print(f'Deleted tile: {file}')
    return index

sourceDirectory = 'input'
targetDirectory = 'output'

targetTilesDirectory = 'tiles'
targetSlicesDirectory = 'slices'

if os.path.isdir(targetDirectory):
    shutil.rmtree(targetDirectory)

os.mkdir(targetDirectory)
os.mkdir(targetDirectory + '/' + targetTilesDirectory)
os.mkdir(targetDirectory + '/' + targetSlicesDirectory)

with open(sourceDirectory + "/input.json") as json_data:
    data = json.load(json_data)

tileWidth = data['tile']['width']
tileHeight = data['tile']['height']

tileRootPath = f"{targetDirectory}/{targetTilesDirectory}"

for source in data['sources']:
    # magick magecity.png -crop 32x32 magecity_32x32/magecity_32x32_%d.png
    sourceWidth = source['width']
    sourceHeight = source['height']
    tilesDirectory = targetDirectory + '/' + targetTilesDirectory
    subprocess.run(["magick", sourceDirectory + '/' + source['input'], "-crop", f'{tileWidth}x{tileHeight}', tilesDirectory + '/' + source['output'] + '%d.png'])
    print(f"Tiles created from {source['input']}: 0..{(sourceWidth*sourceHeight - 1)}")

    tilePath = f"{tileRootPath}/{source['output']}"
    for slice in source['slices']:
        width = slice['width'] * tileWidth
        height = slice['height'] * tileHeight
        left = (slice['left'] - 1) * tileWidth
        top = (slice['top'] - 1) * tileHeight
        targetPath = targetDirectory + '/' + targetSlicesDirectory + '/' + slice['output']
        targetFile = targetPath + 'slice.png'
        subprocess.run(["magick", sourceDirectory + '/' + source['input'], "-crop", f'{width}x{height}+{left}+{top}', targetFile])
        indices = removeTiles(sourceWidth = sourceWidth, data = getLTWH(slice), tilePath = tilePath)
        print(f'Crop {slice["output"]} from {source["input"]}: {width}x{height}+{left}+{top} | Deleted tiles: {indices}')

        subprocess.run(["magick", targetFile, "-crop", f'{slice["width"]}x{slice["height"]}@', tilesDirectory + '/' + slice['output'] + '%d.png'])
        # print(f"Sub tiles created from {slice['output']}: 0..{(slice['width']*slice['height'] - 1)}")

    garbageData = source['garbages']
    indices = removeTilesByIndices(indices = garbageData['indices'], tilePath = tilePath)
    print(f'Garbage | Deleted tiles by index: {indices}')
    for garbage in garbageData['slices']:
        indices = removeTiles(sourceWidth = sourceWidth, data = getLTWH(garbage), tilePath = tilePath)
        print(f'Garbage | Deleted tiles: {indices}')

    for group in source['groups']:
        
        for index in group['indices']:
            targetFile = f"{targetDirectory}/{targetTilesDirectory}/{group['output']}{index}.png"
            shutil.copyfile(f"{tilePath}{index}.png", targetFile)
        indices = removeTilesByIndices(indices = group['indices'], tilePath = tilePath)
        print(f'Create {group["output"]} group | Deleted tiles: {indices}')


target = data['target']

targetFiles = []
for tile in target['tiles']:
    targetFiles.append(f'{tileRootPath}/{tile}.png')

# print(targetFiles)
# targetFilesStr = ' '.join(targetFiles)
# command = ' '.join(["magick", "montage", "-mode", "concatenate", "-background", "none", "-geometry", f"{tileWidth}x{tileHeight}+0+0", "-tile", f"{target['width']}x", targetFilesStr, f"{targetDirectory}/{target['output']}"])
# print(command)

commandData = ["magick", "montage", "-mode", "concatenate", "-background", "none", "-geometry", f"{tileWidth}x{tileHeight}+0+0", "-tile", f"{target['width']}x"]
for targetFile in targetFiles:
    commandData.append(targetFile)
commandData.append(f"{targetDirectory}/{target['output']}")
subprocess.run(commandData)
