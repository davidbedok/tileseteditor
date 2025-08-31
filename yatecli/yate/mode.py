import enum

class Mode(enum.Enum):
    split = 'split'
    build = 'build'

    def __str__(self):
        return self.value