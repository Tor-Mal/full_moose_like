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
    nx = 100
    ny = 100
    xmax = 2
    ymax = 1
  []
[]

[Physics]
    [SolidMechanics]
        [QuasiStatic]
            [all]
                add_variables = true
            []
        []
    []
[]

[BCs]
  [bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0
  []
  [bottom_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0
  []
  [Pressure]
    [top]
      boundary = top
      function = applied_pressure_function
    []
  []
[]

[Materials]
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e9
    poissons_ratio = 0.3
  []
  [stress]
    type = ComputeLinearElasticStress
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
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  end_time = 5
  dt = 1
[]

[Outputs]
  exodus = true
[]
