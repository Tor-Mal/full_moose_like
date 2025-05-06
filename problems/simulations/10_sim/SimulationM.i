[Mesh]
   [./mesh]
     type = FileMeshGenerator
     file = SiC_JandR.e
   [../]
[]


[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
 [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./damage]
    order = FIRST
    family = LAGRANGE
    initial_condition = 0.0
    block = 'Ring'
  [../]

[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Functions]
  [./move_in_x]
    type = ParsedFunction
    expression = '0.01*t'  # Move right (+x), or use '-0.01*t' for left
  [../]

[]


[BCs]
  ### Move inner jaw in X direction ###
  [./move_red_x]
    type = FunctionDirichletBC
    variable = disp_x
    boundary = 'JawR'
    function = move_in_x
  [../]

  [./lock_red_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'JawR'
    value = 0
  [../]
  [./lock_red_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'JawR'
    value = 0
  [../]
  ### Fix the other Jaw in place ###

  [./fix_jawl_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'JawL'
    value = 0
  [../]
  [./fix_jawl_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'JawL'
    value = 0
  [../]
  [./fix_jawl_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'JawL'
    value = 0
  [../]

[]

[Kernels]
  [./x]
    type = ADStressDivergenceTensors
    variable = disp_x
    component = 0
  [../]
  [./y]
    type = ADStressDivergenceTensors
    variable = disp_y
    component = 1
  [../]
  [./z]
    type = ADStressDivergenceTensors
    variable = disp_z
    component = 2
  [../]

  [./damage_eq]
    type = ADAllenCahn
    variable = damage
    f_name = fracture_energy_density
    block = 'Ring'
  [../]

[]

[AuxKernels]
  [./stress_xx]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./stress_yy]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
  [./stress_xy]
    type = ADRankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
    execute_on = timestep_end
  [../]
  [./strain_xx]
    type = ADRankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./strain_yy]
    type = ADRankTwoAux
    rank_two_tensor = total_strain
    variable = strain_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
  [./strain_xy]
    type = ADRankTwoAux
    rank_two_tensor = total_strain
    variable = strain_xy
    index_i = 0
    index_j = 1
    execute_on = timestep_end
  [../]
[]


[Materials] #SiC values
  [./elasticity_tensor]
    type = ADComputeIsotropicElasticityTensor
    youngs_modulus = 410e9
    poissons_ratio = 0.14
    block = 'Ring JawR JawL'
  [../]

  [./strain]
    type = ADComputeGreenLagrangeStrain
  [../]
  [./stress]
    type = ADComputeLinearElasticStress
    block = 'Ring JawR JawL'
  [../]

  [./fracture_energy_density]
    type = ADDerivativeParsedMaterial
    expression = '1000 * damage^2'
    property_name = fracture_energy_density
    coupled_variables = 'damage'
    block = 'Ring'
 [../]

  [./L]
    type = ADGenericConstantMaterial
    prop_names = 'L'
    prop_values = 1.0
    block = 'Ring JawR JawL'
  [../]
[]
    
[Preconditioning]
  [./smp]
    type = SMP
    full = true
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  dt    = 0.01
  dtmin = 0.001
  dtmax = .1
  nl_abs_tol = 1e-8
  num_steps = 50000
[]

[Postprocessors]
  [./stress_xx]
    type = ElementAverageValue
    variable = stress_xx
    block = Ring
  [../]
  [./stress_yy]
    type = ElementAverageValue
    variable = stress_yy
    block = Ring
  [../]
  [./stress_xy]
    type = ElementAverageValue
    variable = stress_xy
    block = Ring
  [../]
  [./strain_xx]
    type = ElementAverageValue
    variable = strain_xx
    block = Ring
  [../]
  [./strain_yy]
    type = ElementAverageValue
    variable = strain_yy
    block = Ring
  [../]
  [./strain_xy]
    type = ElementAverageValue
    variable = strain_xy
    block = Ring
  [../]
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
  execute_on = 'INITIAL TIMESTEP_END'
  time_step_interval = 20
  [./checkpoint]
    type = Checkpoint
    time_step_interval = 10  # every 10 timesteps it will cerate S
  [../]

[]

[Contact]
  [./jawR_to_ring]
    primary = InnerRing
    secondary = JawR
    displacements = 'disp_x disp_y disp_z'
    penalty = 1e12
    normal_smoothing_distance = 1e-5
  [../]

  [./jawL_to_ring]
    primary = InnerRing
    secondary = JawL
    displacements = 'disp_x disp_y disp_z'
    penalty = 1e12
    normal_smoothing_distance = 1e-5
  [../]
[]

