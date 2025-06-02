#
# A first attempt at mechanical contact
# https://mooseframework.inl.gov/modules/contact/tutorials/introduction/step01.html
#

[GlobalParams]
    displacements = 'disp_x disp_y'
[]
  
[Mesh]
  [generated1]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 5
    ny = 20
    xmin =  -.7
    xmax = -.2
    ymax = 5
    bias_y = 0.9
    boundary_name_prefix = pillar1
  []

  [generated2]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 5
    ny = 20
    xmin = 0
    xmax = 0.5
    ymax = 5
    bias_y = 0.9
    boundary_name_prefix = pillar2
    boundary_id_offset = 4
  []

  [generated3]
    type = GeneratedMeshGenerator
    dim = 2
    nx = 5
    ny = 20
    xmin = .7
    xmax = 1.2
    ymax = 5
    bias_y = 0.9
    boundary_name_prefix = pillar3
    boundary_id_offset = 8
  []

  [collect_meshes]
    type = MeshCollectionGenerator
    inputs = 'generated1 generated2 generated3'
  []

  patch_update_strategy = iteration
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    add_variables = true
    strain = FINITE
    generate_output = 'vonmises_stress'
  []
[]

[Contact]
  [pillars1]
    primary = pillar1_right
    secondary = pillar2_left
    model = frictionless
    formulation = penalty
    penalty = 1e9
    normalize_penalty = true
  []
  [pillars2]
    primary = pillar2_right
    secondary = pillar3_left
    model = frictionless
    formulation = penalty
    penalty = 1e9
    normalize_penalty = true
  []
[]

[BCs]
  [bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'pillar1_bottom pillar2_bottom pillar3_bottom'
    value = 0
  []
  [bottom_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'pillar1_bottom pillar2_bottom pillar3_bottom'
    value = 0
  []
  [Pressure]
    [sides]
      boundary = 'pillar1_left pillar2_right pillar3_right'
      # we square time here to get a more progressive loading curve
      # (more pressure later on once contact is established)
      function = 1e4*t^2
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
    type = ComputeFiniteStrainElasticStress
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  line_search = none
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  end_time = 20
  dt = 0.5
  [Predictor]
    type = SimplePredictor
    scale = 1
  []
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
  perf_graph = true
[]