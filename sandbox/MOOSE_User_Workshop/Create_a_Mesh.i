[Mesh]
  [generated]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 1
    nx = 2
    ymin = -2
    ymax = 3
    ny = 3
    elem_type = 'TRI3'
  []
[]

[Outputs]
  exodus = true
  csv = true
[]