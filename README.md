# MoonRC - Reinforced Concrete Calculation Library

**MoonRC** is a comprehensive reinforced concrete calculation library written in **Moonbit**, providing functions for structural design and analysis of reinforced concrete elements according to concrete design standards.

---

## Features

### Flexural Capacity

* **Single Reinforced Sections**: Flexural capacity calculations for singly reinforced rectangular sections
* **Rebar Area Calculations**: Required reinforcement area for given bending moments
* **Compression Zone Analysis**: Relative compression zone height and reinforcement limits

---

### Shear Capacity

* **Concrete Shear Strength**: Shear capacity provided by concrete alone
* **Stirrup Contributions**: Shear capacity with transverse reinforcement
* **Shear Design**: Combined shear capacity calculations

---

### Axial Capacity

* **Axial Compression**: Capacity calculations for axially loaded compression members
* **Axial Tension**: Capacity calculations for axially loaded tension members
* **Stability Factors**: Slenderness and stability considerations

---

### Prestressed Concrete

* **Prestress Losses**: Anchorage deformation, elastic shortening, creep, shrinkage, and relaxation losses
* **Effective Prestress**: Net prestress after losses
* **Prestress Calculations**: Prestress force and stress calculations

---

### Serviceability

* **Deflection Calculations**: Beam deflection under uniform and point loads
* **Crack Width Control**: Crack width calculations and control
* **Reinforcement Ratios**: Minimum and maximum reinforcement ratio checks

---

### Structural Properties

* **Effective Height**: Clear span and effective depth calculations
* **Elastic Modulus Ratio**: Steel-to-concrete modulus ratio calculations
* **Section Properties**: Transformed section properties for composite analysis

---

## Usage

### Flexural Capacity

```moonbit
test "flexure capacity single rebar" {
  // Single reinforced rectangular section: b=200mm, h0=460mm, As=1256mm², fc=14.3MPa(C30), fy=360MPa
  // x = 360*1256/(1.0*14.3*200) = 158mm
  // M_u = 360*1256*(460-158/2) = 172.5 kN·m
  let m = flexure_capacity_single_rebar(200.0, 460.0, 1256.0, 14.3, 360.0)
  assert_eq(approx_equal(m / 1.0e6, 172.5, 5.0), true)

  // Required reinforcement area from compression zone height
  let as_req = flexure_capacity_from_x(200.0, 460.0, 158.0, 14.3)
  assert_eq(as_req > 0.0, true)
}
```

---

### Shear Capacity

```moonbit
test "shear capacity" {
  // Concrete shear capacity: b=200mm, h0=460mm, ft=1.43MPa, α_cv=0.7
  // V_c = 0.7*1.43*200*460 = 92.0 kN
  let vc = shear_capacity_concrete_only(200.0, 460.0, 1.43, 0.7)
  assert_eq(approx_equal(vc / 1000.0, 92.0, 1.0), true)

  // With stirrups: fyv=270MPa, Asv=50.3mm², s=150mm, n=2
  // V_s = 270*50.3*2*460/150 = 83.3 kN
  let vs_total = shear_capacity_with_stirrups(
    200.0, 460.0, 1.43, 0.7, 270.0, 50.3, 150.0, 2
  )
  assert_eq(vs_total > vc, true)
}
```

---

### Axial Capacity

```moonbit
test "axial compression" {
  // Axial compression: fc=14.3MPa, A=100000mm², fy'=360MPa, As'=1256mm², φ=0.9
  // N_u = 0.9*0.9*(14.3*100000 + 360*1256) = 1.58 MN
  let n = axial_compression_capacity(14.3, 100000.0, 360.0, 1256.0, 0.9)
  assert_eq(approx_equal(n / 1.0e6, 1.58, 0.1), true)

  // Stability factor
  let phi1 = stability_factor(10.0)
  assert_eq(phi1 < 1.0, true)
  let phi2 = stability_factor(5.0)
  assert_eq(phi2, 1.0)
}

test "axial tension" {
  // Axial tension: fy=360MPa, As=1256mm²
  // N_u = 360*1256 = 452.2 kN
  let n = axial_tension_capacity(360.0, 1256.0)
  assert_eq(approx_equal(n / 1000.0, 452.2, 1.0), true)
}
```

---

### Reinforcement Design

```moonbit
test "rebar ratio" {
  // Reinforcement ratio: As=1256mm², b=200mm, h0=460mm
  // ρ = 1256/(200*460) = 0.0137
  let rho = rebar_ratio(1256.0, 200.0, 460.0)
  assert_eq(approx_equal(rho, 0.0137, 0.0001), true)

  // Check minimum reinforcement ratio
  assert_eq(check_min_rebar_ratio(rho, 0.002), true)
  // Check maximum reinforcement ratio
  assert_eq(check_max_rebar_ratio(rho, 0.025), true)
}

test "effective height" {
  // Effective height: h=500mm, a_s=40mm
  // h0 = 500 - 40 = 460mm
  let h0 = effective_height(500.0, 40.0)
  assert_eq(h0, 460.0)
}
```

---

### Prestressed Concrete

```moonbit
test "prestress losses" {
  // Anchorage deformation loss: a=5mm, Es=200GPa, l=10000mm
  // σ_l1 = 5*200000/10000 = 100 MPa
  let loss1 = prestress_loss_anchorage(5.0, 200000.0, 10000.0)
  assert_eq(approx_equal(loss1, 100.0, 1.0), true)

  // Relaxation loss: ψ=0.05, σ_con=1395MPa
  // σ_l4 = 0.05*1395 = 69.75 MPa
  let loss4 = prestress_loss_relaxation(0.05, 1395.0)
  assert_eq(approx_equal(loss4, 69.75, 0.1), true)

  // Total prestress loss
  let total = total_prestress_loss(100.0, 50.0, 20.0, 70.0, 100.0)
  assert_eq(total, 340.0)

  // Effective prestress
  let sigma_pe = effective_prestress(1395.0, 340.0)
  assert_eq(sigma_pe, 1055.0)
}
```

---

### Deflection Calculations

```moonbit
test "deflection" {
  // Simply supported beam deflection (uniform load)
  let f1 = beam_deflection_uniform(10.0, 6.0, 1.5e13)
  assert_eq(f1 > 0.0 && f1 < 0.1, true)

  // Simply supported beam deflection (point load)
  let f2 = beam_deflection_point(50.0, 6.0, 1.5e13)
  assert_eq(f2 > 0.0, true)
}
```

---

### Section Analysis

```moonbit
test "elastic modulus ratio" {
  // Elastic modulus ratio: Es=200GPa, Ec=30GPa
  // α_E = 200/30 = 6.67
  let alpha_e = elastic_modulus_ratio(200.0, 30.0)
  assert_eq(approx_equal(alpha_e, 6.67, 0.1), true)

  // Transformed section area
  let a0 = transformed_area(100000.0, 6.67, 1256.0)
  assert_eq(approx_equal(a0, 108377.5, 10.0), true)
}

test "relative compression zone" {
  // Relative compression zone height: x=158mm, h0=460mm
  // ξ = 158/460 = 0.343
  let xi = relative_compression_zone_height(158.0, 460.0)
  assert_eq(approx_equal(xi, 0.343, 0.001), true)

  // Check reinforcement limits (ξ_b=0.518)
  assert_eq(is_over_reinforced(0.343, 0.518), false)
  assert_eq(is_over_reinforced(0.6, 0.518), true)
}
```

---

## Parameter Ranges

### Valid Input Ranges

* **Concrete Strength**: 10–50 MPa (compressive strength)
* **Steel Strength**: 200–500 MPa (yield strength)
* **Dimensions**: 100–2000 mm (section dimensions)
* **Reinforcement Ratio**: 0.002–0.04 (ρ)
* **Prestress**: 500–2000 MPa (initial prestress)

---

### Typical Concrete Design Values

* **C30 Concrete**: fc = 14.3 MPa, ft = 1.43 MPa
* **C40 Concrete**: fc = 19.1 MPa, ft = 1.71 MPa
* **HRB400 Steel**: fy = 360 MPa, Es = 200 GPa
* **HPB300 Steel**: fy = 270 MPa, Es = 200 GPa

---

## Testing

The project includes a comprehensive test suite covering all major functionalities:

```bash
moon test
```

### Test Coverage

* Flexural capacity calculations for singly reinforced sections
* Shear capacity with and without transverse reinforcement
* Axial compression and tension capacity calculations
* Prestressed concrete loss calculations
* Reinforcement ratio checks and design
* Deflection calculations for various load conditions
* Section analysis and transformed properties
* Serviceability limit state checks

---

## Technical Details

### Design Standards

* **GB 50010**: Code for Design of Concrete Structures
* **GB 50017**: Code for Design of Steel Structures
* **JGJ 92**: Technical Specification for Application of Prestressed Concrete
* **SI Units**: Consistent use of International System of Units

---

### Engineering Methods

* **Limit State Design**: Ultimate limit state and serviceability limit state design
* **Stress-Strain Analysis**: Nonlinear material behavior consideration
* **Section Analysis**: Transformed section method for composite analysis
* **Empirical Formulas**: Industry-standard correlation equations

---

### Applications

* **Building Structures**: Beams, columns, slabs, and foundations
* **Bridge Engineering**: Bridge decks, piers, and abutments
* **Precast Concrete**: Prestressed and precast concrete elements
* **Reinforced Concrete Design**: Structural element design and analysis
* **Construction Engineering**: Concrete mix design and quality control
* **Seismic Design**: Earthquake-resistant concrete structures
* **Infrastructure**: Tunnels, retaining walls, and underground structures

---

## Notes

1. **Units**: All calculations use SI units (millimeters for dimensions, MPa for stresses)
2. **Design Standards**: Functions follow Chinese concrete design codes (GB 50010)
3. **Safety Factors**: All capacity calculations include appropriate partial safety factors
4. **Material Models**: Bilinear stress-strain relationship for steel, parabolic-rectangular for concrete
5. **Reinforcement Limits**: Functions check minimum and maximum reinforcement ratios
6. **Serviceability**: Crack width and deflection limits per design codes
7. **Prestress Losses**: Comprehensive loss calculations for prestressed concrete
8. **Validation**: Results should be verified against established concrete design software

---

## Version Information

The current version (0.1.0) implements **core reinforced concrete calculation functions** including:

* Flexural capacity analysis for singly reinforced rectangular sections
* Shear capacity calculations with transverse reinforcement
* Axial capacity calculations for compression and tension
* Prestressed concrete design and loss calculations
* Reinforcement ratio design and checks
* Deflection and serviceability calculations
* Section analysis and transformed properties
* Design utilities and material property functions

The library is actively developed and aims to provide comprehensive coverage of reinforced concrete design while being optimized for MoonBit.
#   M o o n R C  
 