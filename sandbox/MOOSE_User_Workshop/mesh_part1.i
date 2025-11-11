[Mesh]
    [bulk]
    type = GeneratedMeshGenerator
    dim = 2
    
    ymax = 9.7
    xmax = 6.5
    
    ny = 10
    nx = 7

    []
[]

[Variables]
    [Place_holder]
        order = FIRST
        family = LAGRANGE
        initial_condition = 0.0
        block = 0
    []

[]

[Kernels]

    [KernalPlaceholder]
        variable = Place_holder
        block = 0
        type = ADBodyForce
    []

[]

[Executioner]
    type = Transient
    solve_type = NEWTON
    dt    = 1
    num_steps = 1
    nl_abs_tol = 10
[]

[Outputs]
    exodus = true
    csv = true
    execute_on = 'INITIAL'

[]