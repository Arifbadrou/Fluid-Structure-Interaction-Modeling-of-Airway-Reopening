// Use Gmsh’s built-in CAD kernel (simple + robust for this geometry)
SetFactory("Built-in");

// Geometry + mesh parameters
R  = 0.002;     // [m] airway radius (2 mm)
L  = 0.040;     // [m] airway length (40 mm)
lc = R/32;      // [m] target element size on the cross-section
nx = 800;       // number of layers along the x-direction (controls axial resolution)

// -----------------------------
// 2D cross-section (quarter disk in the Y–Z plane at x = 0)
// -----------------------------
Point(1) = {0, 0, 0, lc};   // center of the circle (origin)
Point(2) = {0, R, 0, lc};   // point on +Y axis
Point(3) = {0, 0, R, lc};   // point on +Z axis

Line(1)   = {1, 2};         // radial edge along +Y
Line(2)   = {1, 3};         // radial edge along +Z
Circle(3) = {2, 1, 3};      // circular arc from +Y to +Z, centered at Point(1)

// Define the closed boundary and create the 2D surface
Curve Loop(4)   = {1, 3, -2};
Plane Surface(5) = {4};

// Generate a structured quad mesh on the 2D surface
Recombine Surface{5};       // recombine triangles into quads (2D)

// -----------------------------
// 3D mesh: sweep/extrude the 2D quad surface to form a hexahedral volume
// -----------------------------
// Extrude along x from 0 to L with nx layers; recombine to get HEX elements
ex[] = Extrude {L, 0, 0} { Surface{5}; Layers{nx}; Recombine; };

// -----------------------------
// Physical groups (used to name patches in OpenFOAM / coupling interfaces)
// -----------------------------
Physical Volume("quarter_cylinder") = {ex[1]};  // the 3D fluid/solid domain

Physical Surface("inlet")      = {5};      // x = 0 face (original surface)
Physical Surface("outlet")     = {ex[0]};  // x = L face (extruded cap)

Physical Surface("interface")  = {ex[3]};  // curved cylindrical wall (FSI interface)
Physical Surface("symmetryXZ") = {ex[4]};  // symmetry plane (y = 0)
Physical Surface("symmetryXY") = {ex[2]};  // symmetry plane (z = 0)