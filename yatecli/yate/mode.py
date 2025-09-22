import enum

class Mode(enum.Enum):
    clean = 'clean'
    tiles = 'tiles'
    split = 'split'
    build = 'build'
    generate = 'generate'

    def __str__(self):
        return self.value