import shutil
import os
import json
import pathlib
import subprocess

targetTilesDirectory = 'tiles'
targetSlicesDirectory = 'slices'
targetGroupsDirectory = 'groups'

def initTargetFolder( outputDirectory: str ):
    if os.path.isdir(outputDirectory):
        shutil.rmtree(outputDirectory)

    os.mkdir(outputDirectory)
    os.mkdir(outputDirectory + '\\' + targetTilesDirectory)
    os.mkdir(outputDirectory + '\\' + targetSlicesDirectory)
    os.mkdir(outputDirectory + '\\' + targetGroupsDirectory)
    
def openTileSetProject( projectFile: str ):
    data = None
    if os.path.isfile(projectFile):
        with open(projectFile) as json_data:
            data = json.load(json_data)
    return data

def process( projectFile: str, outputDirectory: str, json ):
    for tileset in json['tilesets']:
        name = tileset['name']
        active = bool(tileset['active'])
        if ( active ):
            tile = tileset['tile']
            tileWidth = int(tile['width'])
            tileHeight = int(tile['height'])

            projectFilePath = pathlib.Path(projectFile)
            tileSetFilePath = f'{projectFilePath.parent}/{tileset["input"]}'
            print(f'Open \'{name}\' TileSet image from: {tileSetFilePath}')
            
            tilesDirectory = f'{outputDirectory}\\{targetTilesDirectory}\\{name}'
            slicesDirectory = f'{outputDirectory}\\{targetSlicesDirectory}\\{name}'
            groupsDirectory = f'{outputDirectory}\\{targetGroupsDirectory}\\{name}'
            os.mkdir(tilesDirectory)
            os.mkdir(slicesDirectory)
            os.mkdir(groupsDirectory)

            # magick input/magecity.png -crop 32x32 output/magecity32x32/magecity.png
            subprocess.run(["magick", tileSetFilePath, "-crop", f'{tileWidth}x{tileHeight}', f'{tilesDirectory}\\{tileset["name"]}.png'])
            
            print(f'Tile of \'{name}\' were built into: {tilesDirectory}')

            buildSlices(tileset['slices'], name, tilesDirectory, slicesDirectory, tileWidth, tileHeight, tileSetFilePath)
            buildGroups(tileset['groups'], name, tilesDirectory, groupsDirectory, tileWidth, tileHeight, tileSetFilePath)
            dropGarbages(tileset['garbage'], name, tilesDirectory)
            removeUnusedTiles(tileset['tiles'], name, tilesDirectory, tileWidth, tileHeight, tileSetFilePath)
        else:
            print(f'Skip \'{name}\' TileSet')

def buildSlices( json, tileSetName: str, tilesDirectory: str, slicesDirectory: str, tileWidth: int, tileHeight:int, tileSetFilePath: str):
    for slice in json:
        key = slice['key']
        name = slice['name']
        left = (slice['left'] - 1) * tileWidth
        top = (slice['top'] - 1) * tileHeight
        width = slice['width'] * tileWidth
        height = slice['height'] * tileHeight
        
        sliceFile = f'{slicesDirectory}\\{name}.png'
        print(f'Create \'{name}\' Slice image (key: {key}) into: {sliceFile}')

        # magick input/magecity.png -crop 96x64+96+128 +repage input/slice.png
        subprocess.run(["magick", tileSetFilePath, "-crop", f'{width}x{height}+{left}+{top}', "+repage", sliceFile])
        deletedIndices = removeTilesByIndices(slice['indices'], tilesDirectory, tileSetName)
        print(f'Related slice tiles were deleted: {deletedIndices}')

def buildGroups( json, tileSetName: str, tilesDirectory: str, groupsDirectory: str, tileWidth: int, tileHeight:int, tileSetFilePath: str):
    for group in json:
        key = group['key']
        name = group['name']
        width = group['width']
        
        groupFile = f'{groupsDirectory}\\{name}.png'
        print(f'Create \'{name}\' Group image (key: {key}) into: {groupFile}')

        # magick montage -mode concatenate -background none -geometry 32x32+0+0 -tile 3x input/group/floor-0.png input/group/floor-1.png input/group/floor-2.png input/group/floor-3.png input/group/floor-4.png input/group/floor-5.png output/floor.png
        commandData = ["magick", "montage", "-mode", "concatenate", "-background", "none", "-geometry", f'{tileWidth}x{tileHeight}+0+0', "-tile", f'{width}x']
        for tileIndex in group['indices']:
            commandData.append(f'{tilesDirectory}\\{tileSetName}-{tileIndex}.png')
        commandData.append(groupFile)
        subprocess.run(commandData)
        deletedIndices = removeTilesByIndices(group['indices'], tilesDirectory, tileSetName)
        print(f'Related group tiles were deleted: {deletedIndices}')

def removeUnusedTiles( json, tileSetName: str, tilesDirectory: str, tileWidth: int, tileHeight:int, tileSetFilePath: str):
    usedIndices = []
    for tile in json:
        usedIndices.extend(tile['indices'])
    deletedIndices = removeUnusedTilesByIndices(maxIndex=tileWidth * tileHeight, usedIndices= usedIndices, tilesDirectory= tilesDirectory, tileSetName=tileSetName)
    print(f'All other unused tiles were deleted: {deletedIndices}')

def dropGarbages( json, tileSetName:str , tilesDirectory:str ):
    indices = removeTilesByIndices(json['indices'], tilesDirectory, tileSetName)
    print(f'Garbage | Related tiles were deleted: {indices}')
    
def removeTilesByIndices( indices, tilesDirectory: str, tileSetName: str):
    result = []
    for index in indices:
        result.append(removeTileByIndex(index, tilesDirectory, tileSetName))
    return result

def removeTileByIndex( index: int, tilesDirectory: str, tileSetName: str):
    file = f'{tilesDirectory}\\{tileSetName}-{index}.png'
    os.remove(file)
    return index

def removeUnusedTilesByIndices( maxIndex: int, usedIndices: list[int], tilesDirectory: str, tileSetName: str):
    result = []
    for index in range(0, maxIndex):
        if index not in usedIndices:
            file = f'{tilesDirectory}\\{tileSetName}-{index}.png'
            tileFilePath = pathlib.Path(file)
            if tileFilePath.exists():
                os.remove(file)
                result.append(index)
    return result
