import subprocess
import json
import os
import shutil
import argparse
import textwrap
import sys
import tileset.utils

parser = argparse.ArgumentParser(
                    prog='TileSet Splitter',
                    formatter_class=argparse.RawDescriptionHelpFormatter,
                    description=textwrap.dedent('''\
                    %(prog)s is a utility for splitting TileSet images (*.png) into tiles, based on the project file (*.tsp.json) of the TileSet Editor.
                    TileSet Project file (*.tsp.json) should refer to the source TileSet images (*.png)
                    TileSet Editor: https://tileseteditor.qwaevisz.hu/
                    '''),
                    epilog=f'example: {sys.argv[0]} --project demo.tsp.json --target output'
)

parser.add_argument('-p', '--project', help = 'TileSet Project file (*.tsp.json)', required = True, dest = 'projectFile')
parser.add_argument('-t', '--target', help = 'Target directory for the output tile images (*.png)', required = True, dest = 'outputDirectory')

args = parser.parse_args()

print(f'Project: {args.projectFile}')
print(f'Output: {args.outputDirectory}')

tileset.utils.initTargetFolder(args.outputDirectory)

project = tileset.utils.openTileSetProject(args.projectFile)
if ( project == None ):
    print(f'TileSet Project file cannot be found: {args.projectFile}')
    exit()

print(f'TileSet Project found: {project["name"]} (TileSet Editor version: {project["editor"]["version"]})')

tileset.utils.buildTiles(args.projectFile, args.outputDirectory, project)
