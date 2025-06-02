#
# A first attempt at mechanical contact
# https://mooseframework.inl.gov/modules/contact/tutorials/introduction/step01.html
#

[GlobalParams]
    displacements = 'disp_x disp_y'
[]
  
[Functions]
  [move_in_+x]
    type = ParsedFunction
    expression = '0.1*t'  # Move right (+x), or use '-0.01*t' for left
  []
  [move_in_-x]
    type = ParsedFunction
    expression = '-0.1*t'  # Move right (+x), or use '-0.01*t' for left
  []
[]

[Mesh]
  [mesh]
    type = FileMeshGenerator
    file = SiC_JandR.e
  []
  patch_update_strategy = iteration
  construct_side_list_from_node_list = true

[]


[Physics/SolidMechanics/QuasiStatic]
  [all]
    add_variables = true
    strain = FINITE
    generate_output = 'vonmises_stress'
  []
[]

[Contact]
  [jawR_to_ringR]
    primary = IRingR
    secondary = RJawR
    model = frictionless
    penalty = 410e8
    normalize_penalty = true
  []

  [jawL_to_ringL]
    primary = IRingL
    secondary = LJawL
    model = frictionless
    penalty = 410e8
    normalize_penalty = true
  []
[]

[BCs]
  [Move_jawR_x]
    type = FunctionDirichletBC
    boundary = 'LJawR'
    function = move_in_+x
    variable = disp_x
  []
  [Move_jawL_x]
    type = FunctionDirichletBC
    boundary = 'RJawL'
    function = move_in_-x
    variable = disp_x
  []
  [Fix_jaw_y]
    type = DirichletBC
    boundary = 'LJawR RJawL'
    variable = disp_y
    value = 0
  []
  # [Fix_jawL_x]
  #   type = DirichletBC
  #   boundary = 'RJawL'
  #   variable = disp_x
  #   value = 0
  # []
  # [Fix_jawL_y]
  #   type = DirichletBC
  #   boundary = 'RJawL'
  #   variable = disp_y
  #   value = 0
  # []
  [top_x]
    type = DisplacementAboutAxis
    boundary = 'RingSeam'
    function = '0'
    angle_units = degrees
    axis_origin = '0 0 0'
    axis_direction = '0 0 1.0'
    component = 0
    variable = disp_x
  []

[]

[Materials]
  
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 410e9
    poissons_ratio = 0.14
  []

  [stress]
    type = ComputeFiniteStrainElasticStress
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  line_search = none
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  end_time = 10
  dt = 0.1
  [Predictor]
    type = SimplePredictor
    scale = 1

  []

[]

[Outputs]
  exodus = true
  print_linear_residuals = false
  perf_graph = true
  time_step_interval = 1

[]