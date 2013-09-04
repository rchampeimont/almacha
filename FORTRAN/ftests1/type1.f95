module elementary_particle_module
    implicit none
    save
    type elementary_particle
        character(len=10) :: name
        real :: mass  ! in eV
        real :: charge ! in positrons charges
        integer :: double_spin ! how many half-spins
    end type
end module

program type1
    use elementary_particle_module
    implicit none
    type(elementary_particle) :: u, e

    print *, "begin program"

    u = elementary_particle("u quark", 2.4E9, 2.0/3.0, 1)

    e%name = "electron"
    e%charge = -1
    e%double_spin = 1
    e%mass = 0.511E9

    call print_particle(e)
    call print_particle(u)

    print *, "end program"
end program

subroutine print_particle(particle)
    use elementary_particle_module
    type(elementary_particle) :: particle

    print *, particle%name, particle%mass, particle%charge, real(particle%double_spin)/2.0
end subroutine
