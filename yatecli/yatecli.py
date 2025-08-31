import enum
import subprocess
import json
import os
import shutil
import argparse
import textwrap
import sys
import yate.utils

class Mode(enum.Enum):
    split = 'split'
    build = 'build'

    def __str__(self):
        return self.value

parser = argparse.ArgumentParser(
                    prog='Yet Another TileSet Editor CLI',
                    formatter_class=argparse.RawDescriptionHelpFormatter,
                    description=textwrap.dedent('''\
                    %(prog)s is a utility for splitting or building TileSet images (*.png), based on the YATE project file (*.tsp.json).
                    YATE TileSet Project file (*.tsp.json) should refer to the source TileSet images (*.png)
                    TileSet Editor: https://yetanothertileseteditor.qwaevisz.hu/
                    '''),
                    epilog=f'example: {sys.argv[0]} --mode split --project demo.tsp.json --target output'
)

parser.add_argument('-m', '--mode', help = 'Choose one of the supported option ()', type = Mode, choices=list(Mode), required = True, dest = 'mode')
parser.add_argument('-p', '--project', help = 'TileSet Project file (*.tsp.json)', required = True, dest = 'projectFile')
parser.add_argument('-t', '--target', help = 'Target directory for the output tile images (*.png)', required = True, dest = 'outputDirectory')
parser.add_argument('-e', '--empty', help = 'Location of the empty tile (*.png)', dest = 'emptyPath', default = None)

args = parser.parse_args()

print('Welcome to Yet Another TileSet Editor CLI');
print(f'Mode: {args.mode} Project: {args.projectFile} Output: {args.outputDirectory}')

yate.utils.initTargetFolder(args.outputDirectory)

project = yate.utils.openTileSetProject(args.projectFile)
if ( project == None ):
    print(f'YATE TileSet Project file cannot be found: {args.projectFile}')
    exit()

print(f'YATE TileSet Project found: {project["name"]} (YATE version: {project["editor"]["version"]})')

yate.utils.process(args.projectFile, args.outputDirectory, project)
