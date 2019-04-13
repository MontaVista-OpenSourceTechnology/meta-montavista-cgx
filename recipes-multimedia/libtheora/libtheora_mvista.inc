PR .= ".1"

PACKAGECONFIG ??= ""
PACKAGECONFIG[sdl] = "--enable-sdltest ac_cv_path_SDL_CONFIG="pkg-config sdl",--disable-sdltest ac_cv_path_SDL_CONFIG="no",libsdl,"
