BLACK = "BLACK"
RED = "RED"
GREEN = "GREEN"
CYAN = "CYAN"
RESET = "RESET"

# ANSI escape codes
COLORS = {
    BLACK => "\e[30m",
    RED => "\e[31m",
    GREEN => "\e[32m",
    CYAN => "\e[36m",
    RESET => "\e[0m"
}

HIDE_CURSOR = "\e[?25l"
SHOW_CURSOR = "\e[?25h"