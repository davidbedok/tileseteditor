import argparse
import textwrap
import sys
import yate.utils
import yate.mode

parser = argparse.ArgumentParser(
                    prog='yatecli',
                    formatter_class=argparse.RawDescriptionHelpFormatter,
                    description=yate.utils.cliDescription(),
                    epilog=f'example: {sys.argv[0]} --mode build --empty .\empty\empty_32x32.png --project example.yasp.json --target output'
)

parser.add_argument('-m', '--mode', help = 'Choose one of the supported option ()', type = yate.mode.Mode, choices=list(yate.mode.Mode), required = True, dest = 'mode')
parser.add_argument('-p', '--project', help = 'TileSet Project file (*.tsp.json)', required = True, dest = 'projectFile')
parser.add_argument('-t', '--target', help = 'Target directory for the output tile images (*.png)', required = True, dest = 'outputDirectory')
parser.add_argument('-e', '--empty', help = 'Location of the empty tile (*.png)', dest = 'emptyTilePath', default = None)
parser.add_argument('-s', '--silent', help = 'Silent mode (do not print out detailed steps)', dest = 'silent', action=argparse.BooleanOptionalAction, default = False)

args = parser.parse_args()

if not args.silent:
    print(yate.utils.welcome(args.mode, args.projectFile, args.outputDirectory, args.emptyTilePath))

yate.utils.initTargetFolder(args.silent, args.mode, args.outputDirectory)
project = yate.utils.openProject(args.silent, args.mode, args.projectFile)
yate.utils.process(args.silent, args.mode, args.projectFile, args.outputDirectory, args.emptyTilePath, project)
