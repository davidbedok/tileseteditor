import shutil
import os
import json
import pathlib
import subprocess
import pyfiglet
import textwrap

from .mode import Mode

version = '1.0.0'

targetTilesDirectory = 'tiles'
targetSlicesDirectory = 'slices'
targetGroupsDirectory = 'groups'
targetFilesDirectory = 'files'

def yateHeader() -> str:
    figlet = pyfiglet.Figlet(font='block')
    return figlet.renderText('YATE CLI')

def cliDescription() -> str:
    return yateHeader() + textwrap.dedent('''\
    Yet Another TileSet Editor CLI is a utility for splitting or building TileSet images (*.png), based on the YATE project file (*.yate.json). This project file should refer to the source TileSet images (*.png) and TileGroup's tiles.
    Yet Another TileSet Editor: https://yetanothertileseteditor.qwaevisz.hu/
    Modes:
        clean    : Clean the target directory
        tiles    : clean + Generate output-size tiles from active tilesets and tilegroups 
        split    : tiles + Split active tilesets into slices, groups and tiles
        build    : tiles + Build the output tileset from active tilesets and tilegroups
        generate : Build only (tiles mode must be run before this)
    ''')

def printKeyValue(key:str, value:str, length:int = 13) -> str:
    return f'{key.ljust(length)}: {value}\n'

def welcome(mode: Mode, projectFile: str, outputDirectory: str, emptyTilePath: str) -> str:
    result = yateHeader()
    space = 3
    spaceDecor = ' ' * space
    title = f'Welcome to Yet Another TileSet Editor CLI {version}'
    decoration = '-' * (len(title) + space * 2) + '\n'
    result += f'{decoration}{spaceDecor}{title}{spaceDecor}\n{decoration}'
    result += printKeyValue('Project', projectFile)
    result += printKeyValue('Mode', mode.name)
    result += printKeyValue('Output', outputDirectory)
    result += printKeyValue('Empty tile', emptyTilePath)
    return result

def initTargetFolder( silent: bool, mode: Mode, outputDirectory: str ):
    if mode != Mode.generate:
        if os.path.isdir(outputDirectory):
            shutil.rmtree(outputDirectory)
        os.mkdir(outputDirectory)
        os.mkdir(outputDirectory + '\\' + targetTilesDirectory)
        os.mkdir(outputDirectory + '\\' + targetSlicesDirectory)
        os.mkdir(outputDirectory + '\\' + targetGroupsDirectory)
        if not silent:
            print(f'Target folder ({outputDirectory}) cleaned.')
    else:
        if not silent:
            print(f'Skip clean in {mode.name} mode')       
    
def openProject( silent: bool, mode: Mode, projectFile: str ):
    if mode != Mode.clean:
        project = None
        if os.path.isfile(projectFile):
            try:
                with open(projectFile) as json_data:
                    project = json.load(json_data)
            except json.decoder.JSONDecodeError:
                print(f'[Error] The given project file is not a valid json: {projectFile}')
                exit()
        if ( project == None ):
            print(f'[Error] YATE project file cannot be found here: {projectFile}')
            exit()
        else:
            try:
                result = f'Project found in {projectFile}\n'
                editor = project['editor']
                output = project['output']
                outputTile = output['tile']
                outputSize = output['size']
                result += printKeyValue('Name', f"{project['name']} v{project['version']}")
                result += printKeyValue('Editor', f"{editor['name']} v{editor['version']}")
                result += printKeyValue('Creator', f"{project['creator']}")
                result += printKeyValue('Output', f"{outputSize['width']} x {outputSize['height']} from {outputTile['width']}x{outputTile['height']} tile --> {output['file']}")
                for tileset in project['tilesets']:
                    result += printKeyValue('TileSet', f"({tileset['id']}) {tileset['name']}{'' if bool(tileset['active']) else ' (inactive)'}")
                for tilegroup in project['tilegroups']:
                    result += printKeyValue('TileGroup', f"({tilegroup['id']}) {tilegroup['name']}{'' if bool(tilegroup['active']) else ' (inactive)'}")
                if not silent:
                    print(result)
            except KeyError as e:
                print(f'[Error] The given project is not a valid YATE project file: {projectFile}')
                print(f'[Error] Attribute not found: {e}')
                exit()
        return project

def process( silent: bool, mode: Mode, projectFile: str, outputDirectory: str, emptyTilePath: str, json ):
    projectFilePath = pathlib.Path(projectFile)
    if mode != Mode.clean:
        keyReferenceMap = {}

        for tileset in json['tilesets']:
            try:
                id = tileset['id']
                key = tileset['key']
                tileSetName = tileset['name']
                tileSetUnid = f'ts_{tileSetName}_id{id}_key{key}'
                active = bool(tileset['active'])
                if ( active ):
                    tileSetFileName = f'{tileSetName}_key{key}'
                    tile = tileset['tile']
                    tileWidth = int(tile['width'])
                    tileHeight = int(tile['height'])
                    image = tileset['image']
                    imageWidth = int(image['width'])
                    imageHeight = int(image['height'])
                    maxTileWidth = imageWidth // tileWidth
                    maxTileHeight = imageHeight // tileHeight
                    maxTiles = maxTileWidth * maxTileHeight

                    tileSetFilePath = f'{projectFilePath.parent}/{tileset["file"]}'
                    if not silent:
                        print(f'[{tileSetName}] open tileset image from: {tileSetFilePath}')
                    
                    tilesDirectory = f'{outputDirectory}\\{targetTilesDirectory}\\{tileSetUnid}'
                    slicesDirectory = f'{outputDirectory}\\{targetSlicesDirectory}\\{tileSetUnid}'
                    groupsDirectory = f'{outputDirectory}\\{targetGroupsDirectory}\\{tileSetUnid}'
                    keyReferenceMap[key] = { 'directory': tilesDirectory, 'file': tileSetFileName, 'tiles': maxTiles}
                    if mode != Mode.generate:
                        os.mkdir(tilesDirectory)
                        os.mkdir(slicesDirectory)
                        os.mkdir(groupsDirectory)

                        # magick input/magecity.png -crop 32x32 output/magecity32x32/magecity.png
                        subprocess.run(["magick", tileSetFilePath, "-crop", f'{tileWidth}x{tileHeight}', f'{tilesDirectory}\\{tileSetFileName}.png'])
                        if not silent:
                            print(f'[{tileSetName}] {maxTiles} tiles were created into: {tilesDirectory}')

                        if mode == Mode.split:
                            buildSlices(tileset['slices'], tileSetFileName, tilesDirectory, slicesDirectory, tileWidth, tileHeight, tileSetFilePath)
                            buildGroups(tileset['groups'], tileSetFileName, tilesDirectory, groupsDirectory, tileWidth, tileHeight, tileSetFilePath)
                            dropGarbages(tileset['garbage'], tileSetFileName, tilesDirectory)
                            removeUnusedTiles(tileset['tiles'], tileSetFileName, tilesDirectory, tileWidth, tileHeight, tileSetFilePath)
                    else:
                        if not silent:
                            print(f'[{tileSetName}] skip generation in {mode.name} mode')                       
                else:
                    if not silent:
                        print(f'[{tileSetName}] skip inactive tileset')
            except KeyError as e:
                    print(f'[Error] TileSet configuration is not supported: {tileset["name"]}')
                    print(f'[Error] Attribute not found: {e}')
                    exit()

        for tilegroup in json['tilegroups']:
            try:
                id = tilegroup['id']
                tileGroupName = tilegroup['name']
                tileGroupUnid = f'tg_{tileGroupName}_id{id}'
                active = bool(tilegroup['active'])
                if ( active ):
                    tile = tilegroup['tile']
                    tileWidth = int(tile['width'])
                    tileHeight = int(tile['height'])

                    tilesRootDirectory = f'{outputDirectory}\\{targetTilesDirectory}\\{tileGroupUnid}'
                    if mode != Mode.generate:
                        os.mkdir(tilesRootDirectory)
                    
                    for tilegroupfile in tilegroup['files']:
                        id = tilegroupfile['id']
                        key = tilegroupfile['key']
                        tileGroupFileUnid = f'tgf_id{id}_key{key}'
                        tileGroupFileName = f'{tileGroupName}_key{key}'
                        image = tilegroupfile['image']
                        imageWidth = int(image['width'])
                        imageHeight = int(image['height'])
                        maxTileWidth = imageWidth // tileWidth
                        maxTileHeight = imageHeight // tileHeight
                        maxTiles = maxTileWidth * maxTileHeight

                        tileGroupFilePath = f'{projectFilePath.parent}/{tilegroupfile["file"]}'
                        if not silent:
                            print(f'[{tileGroupName}] open image from: {tileGroupFilePath}')
                        
                        tilesDirectory = f'{tilesRootDirectory}\\{tileGroupFileUnid}'
                        keyReferenceMap[key] = { 'directory': tilesDirectory, 'file': tileGroupFileName, 'tiles': maxTiles}
                        if mode != Mode.generate:
                            os.mkdir(tilesDirectory)
                            
                            # magick input/magecity.png -crop 32x32 output/magecity32x32/magecity.png
                            subprocess.run(["magick", tileGroupFilePath, "-crop", f'{tileWidth}x{tileHeight}', f'{tilesDirectory}\\{tileGroupFileName}.png'])
                            if not silent:
                                print(f'[{tileGroupName}] {maxTiles} tiles were created into: {tilesDirectory}')
                        else:
                            if not silent:
                                print(f'[{tileGroupName}] skip generation in {mode.name} mode') 
                else:
                    if not silent:
                        print(f'[{tileGroupName}] skip inactive tilegroup')
            except KeyError as e:
                print(f'[Error] TileGroup configuration is not supported: {tilegroup["name"]}')
                print(f'[Error] Attribute not found: {e}')
                exit()

        if not silent:
            print('\nReference table for build..')
            for key in keyReferenceMap:
                print(f'{str(key).ljust(4)} --> dir:{keyReferenceMap[key]["directory"].ljust(50)} | file:{keyReferenceMap[key]["file"]} (tiles: {keyReferenceMap[key]["tiles"]})')
            print('\n')

        if mode == Mode.build or mode == Mode.generate:
            output = json['output']
            tileSetName = output['file']
            tile = output['tile']
            tileWidth = int(tile['width'])
            tileHeight = int(tile['height'])
            size = output['size']
            outputWidth = int(size['width'])
            outputHeight = int(size['height'])
            print(f'Building {outputWidth}x{outputHeight} output from {tileWidth}x{tileHeight} tiles')
            outputFile = f'{outputDirectory}\\{tileSetName}'
            buildOutput(output['data'], keyReferenceMap, emptyTilePath, tileWidth, tileHeight, outputWidth, outputHeight, outputFile)

def buildSlices( json, tileSetFileName: str, tilesDirectory: str, slicesDirectory: str, tileWidth: int, tileHeight:int, tileSetFilePath: str):
    for slice in json:
        id = slice['id']
        name = slice['name']
        left = (slice['left'] - 1) * tileWidth
        top = (slice['top'] - 1) * tileHeight
        width = slice['width'] * tileWidth
        height = slice['height'] * tileHeight
        
        sliceFile = f'{slicesDirectory}\\{name}.png'
        print(f'Create \'{name}\' Slice image (id: {id}) into: {sliceFile}')

        # magick input/magecity.png -crop 96x64+96+128 +repage input/slice.png
        subprocess.run(["magick", tileSetFilePath, "-crop", f'{width}x{height}+{left}+{top}', "+repage", sliceFile])
        deletedIndices = removeTilesByIndices(slice['indices'], tilesDirectory, tileSetFileName)
        print(f'Related slice tiles were deleted: {deletedIndices}')

def buildGroups( json, tileSetFileName: str, tilesDirectory: str, groupsDirectory: str, tileWidth: int, tileHeight:int, tileSetFilePath: str):
    for group in json:
        id = group['id']
        name = group['name']
        width = group['width']
        
        groupFile = f'{groupsDirectory}\\{name}.png'
        print(f'Create \'{name}\' Group image (id: {id}) into: {groupFile}')

        # magick montage -mode concatenate -background none -geometry 32x32+0+0 -tile 3x input/group/floor-0.png input/group/floor-1.png input/group/floor-2.png input/group/floor-3.png input/group/floor-4.png input/group/floor-5.png output/floor.png
        commandData = ["magick", "montage", "-mode", "concatenate", "-background", "none", "-geometry", f'{tileWidth}x{tileHeight}+0+0', "-tile", f'{width}x']
        for tileIndex in group['indices']:
            commandData.append(f'{tilesDirectory}\\{tileSetFileName}-{tileIndex}.png')
        commandData.append(groupFile)
        subprocess.run(commandData)
        deletedIndices = removeTilesByIndices(group['indices'], tilesDirectory, tileSetFileName)
        print(f'Related group tiles were deleted: {deletedIndices}')

def removeUnusedTiles( json, tileSetFileName: str, tilesDirectory: str, tileWidth: int, tileHeight:int, tileSetFilePath: str):
    usedIndices = []
    for tile in json:
        usedIndices.extend(tile['indices'])
    deletedIndices = removeUnusedTilesByIndices(maxIndex=tileWidth * tileHeight, usedIndices= usedIndices, tilesDirectory= tilesDirectory, tileSetFileName=tileSetFileName)
    print(f'All other unused tiles were deleted: {deletedIndices}')

def dropGarbages( json, tileSetFileName:str , tilesDirectory:str ):
    indices = removeTilesByIndices(json['indices'], tilesDirectory, tileSetFileName)
    print(f'Garbage | Related tiles were deleted: {indices}')
    
def removeTilesByIndices( indices, tilesDirectory: str, tileSetFileName: str):
    result = []
    for index in indices:
        result.append(removeTileByIndex(index, tilesDirectory, tileSetFileName))
    return result

def removeTileByIndex( index: int, tilesDirectory: str, tileSetFileName: str):
    file = f'{tilesDirectory}\\{tileSetFileName}-{index}.png'
    os.remove(file)
    return index

def removeUnusedTilesByIndices( maxIndex: int, usedIndices: list[int], tilesDirectory: str, tileSetFileName: str):
    result = []
    for index in range(0, maxIndex):
        if index not in usedIndices:
            file = f'{tilesDirectory}\\{tileSetFileName}-{index}.png'
            tileFilePath = pathlib.Path(file)
            if tileFilePath.exists():
                os.remove(file)
                result.append(index)
    return result

def buildOutput( json, keyReferenceMap: map, emptyTilePath: str, tileWidth: int, tileHeight: int, outputWidth: int, outputHeight: int, outputFile: str):
    tiles = []
    if emptyTilePath is None:
        print(f'[Error] Empty tile file must be specified for build')
        exit()
    if not os.path.isfile(emptyTilePath):
        print(f'[Error] Empty tile file not found here: {emptyTilePath}')
        exit()

    for row in json:
        for column in row:
            key = column['key']
            index = column['index']
            if key != -1:
                if key in keyReferenceMap:
                    keyRefValue = keyReferenceMap[key] # FIXME can be tilegroup too
                    tileFileName = f'{keyRefValue["file"]}-{index}' if keyRefValue["tiles"] > 1 else f'{keyRefValue["file"]}'
                    tiles.append(f'{keyRefValue["directory"]}\\{tileFileName}.png')
                else:
                    print(f'[Error] Unknown key in reference: {key}')
                    print(f'[Error] Maybe not all the used tileset/tilegroup is active.')
                    exit()
            else:
                tiles.append(f'{emptyTilePath}')

    # magick montage -mode concatenate -background none -geometry 32x32+0+0 -tile 3x input/group/floor-0.png input/group/floor-1.png input/group/floor-2.png input/group/floor-3.png input/group/floor-4.png input/group/floor-5.png output/floor.png
    commandData = ["magick", "montage", "-mode", "concatenate", "-background", "none", "-geometry", f'{tileWidth}x{tileHeight}+0+0', "-tile", f'{outputWidth}x']
    for tileImageFilePath in tiles:
        commandData.append(tileImageFilePath)
    commandData.append(outputFile)
    subprocess.run(commandData)
        
