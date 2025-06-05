
[GlobalParams]
    displacements = 'disp_x disp_y disp_z'
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

[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    add_variables = true
    strain = FINITE
    generate_output = 'vonmises_stress'
    material_output_order = SECOND
  []
[]

[Contact]
  [jawR_to_ringR]
    primary = JawR
    secondary = InnerRingR
    model = frictionless
    penalty = 210e9
    normalize_penalty = true
  []

  [jawL_to_ringL]
    primary = JawL
    secondary = InnerRingL
    model = frictionless
    penalty = 210e9
    normalize_penalty = true
  []
[]

[BCs]
  [Move_jawR_x]
    type = FunctionDirichletBC
    boundary = 'JawR'
    function = move_in_+x
    variable = disp_x
  []
  [Move_jawL_x]
    type = FunctionDirichletBC
    boundary = 'JawL'
    function = move_in_-x
    variable = disp_x
  []
  [Fix_jaw_y]
    type = DirichletBC
    boundary = 'JawR JawL '
    variable = disp_y
    value = 0
  []
  [Fix_All_z]
    type = DirichletBC
    boundary = 'JawR JawL InnerRingL InnerRingR'
    variable = disp_z
    value = 0
  []
  [Fix_Ring_x]
    type = DirichletBC
    boundary = 'RingSeam'
    variable = disp_x
    value = 0
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
  dt = 0.01
  [Predictor]
    type = SimplePredictor
    scale = 1
  []

[]

[Postprocessors]
  [vonmises_stress_ave]
    type = ElementAverageValue
    variable = vonmises_stress
    block = 'RingR RingL'  # Or any block(s) you're interested in
  []
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
  perf_graph = true
  time_step_interval = 1

[]