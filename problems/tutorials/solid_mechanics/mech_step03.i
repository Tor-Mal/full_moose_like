#
# Initial single block mechanics input
# https://mooseframework.inl.gov/modules/solid_mechanics/tutorials/introduction/step01.html
#

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Functions]
  [applied_pressure_function]
    type = ParsedFunction
    value = 1e7*t
  []
[]

[Mesh]
  [generated]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 20
    ny = 20
    xmax = 2
    ymax = 1
  []


  [block1]
    type = SubdomainBoundingBoxGenerator
    input       = generated
    block_id    = 1
    bottom_left = '0 0 0'
    top_right   = '1 1 0'
  []

  [block2]
    type = SubdomainBoundingBoxGenerator
    input       = generated
    block_id    = 1
    bottom_left = '1 0 0'
    top_right   = '2 1 0'
  []
[]

[Physics]
    [SolidMechanics]
        [QuasiStatic]
            [all]
                add_variables = true
                strain = FINITE
                use_automatic_differentiation = true
            []
        []
    []
[]

[BCs]
  [bottom_x]
    type = ADDirichletBC
    variable = disp_x
    boundary = bottom
    value = 0
  []
  [bottom_y]
    type = ADDirichletBC
    variable = disp_y
    boundary = bottom
    value = 0
  []
  [Pressure]
    [top]
      boundary = top
      # function = applied_pressure_function 
      use_automatic_differentiation = true
    []
  []
[]

[Materials]
  [elasticity]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 1e8
    poissons_ratio = 0.3
  []
  [stress]
    type = ADComputeFiniteStrainElasticStress
  []
[]

[Preconditioning]
   [SMP]
     type = SMP
     full = true
   []
[]

[Executioner]
  type = Transient
  # we chose a direct solver here
  solve_type = NEWTON
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  end_time = 5
  dt = 1
[]

[Outputs]
  exodus = true
[]
