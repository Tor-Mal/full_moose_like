
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
    generate_output = 'strain_xx strain_yy strain_zz strain_xy strain_xz strain_yz vonmises_stress'
    material_output_order = SECOND
  []
[]

[Contact]
  [jawR_to_ringR]
    primary = SSJawR
    secondary = SSInnerRingR
    model = frictionless
    penalty = 210e9
    normalize_penalty = true
  []

  [jawL_to_ringL]
    primary = SSJawL
    secondary = SSInnerRingL
    model = frictionless
    penalty = 210e9
    normalize_penalty = true
  []
[]

[BCs]
  [Move_jawR_x]
    type = FunctionDirichletBC
    boundary = 'SSJawR'
    function = move_in_+x
    variable = disp_x
  []
  [Move_jawL_x]
    type = FunctionDirichletBC
    boundary = 'SSJawL'
    function = move_in_-x
    variable = disp_x
  []
  [Fix_jaw_y]
    type = DirichletBC
    boundary = 'SSJawR SSJawL '
    variable = disp_y
    value = 0
  []
  [Fix_All_z]
    type = DirichletBC
    boundary = 'SSJawR SSJawL SSInnerRingL SSInnerRingR'
    variable = disp_z
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
  # [Predictor]
  #   type = SimplePredictor
  #   scale = 1
  # []
[]

[Postprocessors]
  [vonmises_stress_ave]
    type = ElementAverageValue
    variable = vonmises_stress
    block = 'VRingR VRingL'  # Or any block(s) you're interested in
  []

  [strain_xx]
    type = ElementAverageValue
    variable = strain_xx
  []
  [strain_yy]
    type = ElementAverageValue
    variable = strain_yy
  []
  [strain_zz]
    type = ElementAverageValue
    variable = strain_zz
  []
  [strain_xy]
    type = ElementAverageValue
    variable = strain_xy
  []
  [strain_yz]
    type = ElementAverageValue
    variable = strain_yz
  []
  [strain_xz]
    type = ElementAverageValue
    variable = strain_xz
  []

  [max_strain_xx]
    type = ElementExtremeValue
    variable = strain_xx
    value_type = max
  []
  [max_strain_xy]
    type = ElementExtremeValue
    variable = strain_xy
    value_type = max
  []
  [max_strain_xz]
    type = ElementExtremeValue
    variable = strain_xz
    value_type = max
  []
  [max_strain_yy]
    type = ElementExtremeValue
    variable = strain_yy
    value_type = max
  []
  [max_strain_yz]
    type = ElementExtremeValue
    variable = strain_yz
    value_type = max
  []
  [max_strain_zz]
    type = ElementExtremeValue
    variable = strain_zz
    value_type = max
  []





[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
  perf_graph = true
  time_step_interval = 1

[]
