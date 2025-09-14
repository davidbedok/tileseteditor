import enum

class Mode(enum.Enum):
    clean = 'clean'
    tiles = 'tiles'
    split = 'split'
    build = 'build'
    magic = 'magic'

    def __str__(self):
        return self.value