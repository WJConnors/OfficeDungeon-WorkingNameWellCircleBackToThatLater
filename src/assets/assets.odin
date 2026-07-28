package assets

import rl "vendor:raylib"

import "core:os"
import "core:fmt"
import "core:strings"

Load_error :: enum {
    None = 0,
    cstring_failure,
    image_load_failure
}

loader :: proc(filename: string) -> (rl.Image, Load_error) {
    c_filename, err := strings.clone_to_cstring(filename)
    if err != nil {
        return {}, .cstring_failure
    }
    defer delete(c_filename)

    image := rl.LoadImage(c_filename)
    if !rl.IsImageValid(image) {
        return {}, .image_load_failure
    }
    return image, nil
}

main :: proc() {
    if len(os.args) < 2 {
        fmt.println("Usage: assets <filename>")
        return
    }

    spritesheet, err := loader(os.args[1])
    if err != nil {
        fmt.println(err)
        return
    }
    defer rl.UnloadImage(spritesheet)

    fmt.println(spritesheet.width, spritesheet.height)
}