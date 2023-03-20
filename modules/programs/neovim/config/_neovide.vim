if exists("g:neovide")
    let g:transparent_enabled = v:false
    let g:neovide_transparency = 0.85
    set winblend=50 pumblend=50
    let g:neovide_cursor_vfx_mode = "pixiedust"
    let g:neovide_cursor_vfx_opacity = 300.0
    let g:neovide_cursor_vfx_particle_density = 10
    let g:neovide_cursor_vfx_particle_lifetime = 2
    let g:neovide_cursor_vfx_particle_speed = 30

    let g:neovide_confirm_quit = v:true
endif
