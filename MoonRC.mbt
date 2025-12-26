// MoonRC - 混凝土结构设计库
// 主模块：包含核心计算功能

// ==================== 受弯构件 - 正截面承载力 ====================

///|
/// 单筋矩形截面受弯承载力
/// M_u = α₁f_cbx(h₀ - x/2) = f_yA_s(h₀ - x/2)
/// 其中 x = f_yA_s / (α₁f_cb)
/// 参数: b - 截面宽度 (mm), h0 - 有效高度 (mm), as - 受拉钢筋面积 (mm²), fc - 混凝土抗压强度 (MPa), fy - 钢筋抗拉强度 (MPa)
/// 返回: 受弯承载力 (N·mm)
pub fn flexure_capacity_single_rebar(
  b : Double,
  h0 : Double,
  as_ : Double,
  fc : Double,
  fy : Double,
) -> Double {
  if b <= 0.0 || h0 <= 0.0 || as_ <= 0.0 || fc <= 0.0 || fy <= 0.0 {
    return 0.0
  }
  // 计算受压区高度 x = f_yA_s / (α₁f_cb)
  let x = fy * as_ / (ALPHA_1 * fc * b)
  // 检查是否超筋 (x > ξ_bh₀)
  let xi_b = 0.518 // HRB400, C50及以下
  if x > xi_b * h0 {
    return 0.0 // 超筋，返回0
  }
  // 计算承载力 M_u = f_yA_s(h₀ - x/2)
  fy * as_ * (h0 - x / 2.0)
}

///|
/// 单筋矩形截面受弯承载力 (简化公式，已知 x)
/// M_u = α₁f_cbx(h₀ - x/2)
pub fn flexure_capacity_from_x(
  b : Double,
  h0 : Double,
  x : Double,
  fc : Double,
) -> Double {
  if b <= 0.0 || h0 <= 0.0 || x <= 0.0 || fc <= 0.0 {
    return 0.0
  }
  ALPHA_1 * fc * b * x * (h0 - x / 2.0)
}

///|
/// 计算单筋矩形截面所需受拉钢筋面积
/// A_s = M / (f_y(h₀ - x/2))
/// 先求解 x，然后计算 A_s
/// 参数: m - 弯矩 (N·mm), b - 宽度 (mm), h0 - 有效高度 (mm), fc - 混凝土强度 (MPa), fy - 钢筋强度 (MPa)
/// 返回: 所需钢筋面积 (mm²)
pub fn flexure_required_rebar_area(
  m : Double,
  b : Double,
  h0 : Double,
  fc : Double,
  fy : Double,
) -> Double {
  if m <= 0.0 || b <= 0.0 || h0 <= 0.0 || fc <= 0.0 || fy <= 0.0 {
    return 0.0
  }
  // 求解 x: M = α₁f_cbx(h₀ - x/2)
  // 整理: x² - 2h₀x + 2M/(α₁f_cb) = 0
  let a_coeff = 1.0
  let b_coeff = -2.0 * h0
  let c_coeff = 2.0 * m / (ALPHA_1 * fc * b)
  let discriminant = square(b_coeff) - 4.0 * a_coeff * c_coeff
  if discriminant < 0.0 {
    return 0.0
  }
  let x1 = (-b_coeff - discriminant.sqrt()) / (2.0 * a_coeff)
  let x2 = (-b_coeff + discriminant.sqrt()) / (2.0 * a_coeff)
  let x = if x1 > 0.0 && x1 < h0 { x1 } else { x2 }
  // 检查是否超筋
  let xi_b = 0.518
  if x > xi_b * h0 {
    return 0.0 // 超筋
  }
  // 计算 A_s = α₁f_cbx / f_y
  ALPHA_1 * fc * b * x / fy
}

///|
/// 双筋矩形截面受弯承载力
/// M_u = α₁f_cbx(h₀ - x/2) + f_y'A_s'(h₀ - a_s')
/// 参数: b, h0, as, as_prime - 受拉和受压钢筋面积, fc, fy, fy_prime - 混凝土和钢筋强度, a_s_prime - 受压钢筋保护层厚度
pub fn flexure_capacity_double_rebar(
  b : Double,
  h0 : Double,
  as_ : Double,
  as_prime : Double,
  fc : Double,
  fy : Double,
  fy_prime : Double,
  a_s_prime : Double,
) -> Double {
  if b <= 0.0 || h0 <= 0.0 || fc <= 0.0 || fy <= 0.0 {
    return 0.0
  }
  // 计算受压区高度 x = (f_yA_s - f_y'A_s') / (α₁f_cb)
  let x = (fy * as_ - fy_prime * as_prime) / (ALPHA_1 * fc * b)
  if x <= 0.0 {
    return 0.0
  }
  // 检查是否超筋
  let xi_b = 0.518
  if x > xi_b * h0 {
    return 0.0
  }
  // 计算承载力
  ALPHA_1 * fc * b * x * (h0 - x / 2.0) + fy_prime * as_prime * (h0 - a_s_prime)
}

///|
/// T形截面受弯承载力 (第一类T形，x ≤ h_f')
/// M_u = α₁f_cb_f'x(h₀ - x/2)
/// 参数: bf - 翼缘宽度, hf - 翼缘高度, b - 腹板宽度, h0 - 有效高度, as - 受拉钢筋面积, fc, fy
pub fn flexure_capacity_t_section_type1(
  bf : Double,
  hf : Double,
  b : Double,
  h0 : Double,
  as_ : Double,
  fc : Double,
  fy : Double,
) -> Double {
  if bf <= 0.0 || hf <= 0.0 || h0 <= 0.0 || as_ <= 0.0 || fc <= 0.0 || fy <= 0.0 {
    return 0.0
  }
  // 计算 x = f_yA_s / (α₁f_cb_f')
  let x = fy * as_ / (ALPHA_1 * fc * bf)
  // 第一类T形: x ≤ h_f'
  if x > hf {
    return 0.0 // 属于第二类T形
  }
  // 计算承载力
  ALPHA_1 * fc * bf * x * (h0 - x / 2.0)
}

///|
/// T形截面受弯承载力 (第二类T形，x > h_f')
/// M_u = α₁f_c[b_f'h_f'(h₀ - h_f'/2) + bx(h₀ - x/2)]
pub fn flexure_capacity_t_section_type2(
  bf : Double,
  hf : Double,
  b : Double,
  h0 : Double,
  as_ : Double,
  fc : Double,
  fy : Double,
) -> Double {
  if bf <= 0.0 ||
    hf <= 0.0 ||
    b <= 0.0 ||
    h0 <= 0.0 ||
    as_ <= 0.0 ||
    fc <= 0.0 ||
    fy <= 0.0 {
    return 0.0
  }
  // 计算 x
  let x = (fy * as_ - ALPHA_1 * fc * (bf - b) * hf) / (ALPHA_1 * fc * b)
  if x <= hf {
    return 0.0 // 属于第一类T形
  }
  // 检查是否超筋
  let xi_b = 0.518
  if x > xi_b * h0 {
    return 0.0
  }
  // 计算承载力
  ALPHA_1 * fc * (bf - b) * hf * (h0 - hf / 2.0) +
  ALPHA_1 * fc * b * x * (h0 - x / 2.0)
}

// ==================== 受弯构件 - 斜截面受剪承载力 ====================

///|
/// 矩形截面受剪承载力 (仅混凝土)
/// V_c = α_cv f_t b h₀
/// 参数: b - 宽度 (mm), h0 - 有效高度 (mm), ft - 混凝土抗拉强度 (MPa), alpha_cv - 系数
pub fn shear_capacity_concrete_only(
  b : Double,
  h0 : Double,
  ft : Double,
  alpha_cv : Double,
) -> Double {
  if b <= 0.0 || h0 <= 0.0 || ft <= 0.0 {
    return 0.0
  }
  alpha_cv * ft * b * h0
}

///|
/// 矩形截面受剪承载力 (混凝土 + 箍筋)
/// V = V_c + V_s = α_cv f_t b h₀ + f_yv A_sv h₀ / s
/// 参数: b, h0, ft, alpha_cv, fyv - 箍筋抗拉强度 (MPa), asv - 单肢箍筋面积 (mm²), s - 箍筋间距 (mm), n - 箍筋肢数
pub fn shear_capacity_with_stirrups(
  b : Double,
  h0 : Double,
  ft : Double,
  alpha_cv : Double,
  fyv : Double,
  asv : Double,
  s : Double,
  n : Int,
) -> Double {
  if b <= 0.0 || h0 <= 0.0 || ft <= 0.0 || s <= 0.0 {
    return 0.0
  }
  let vc = shear_capacity_concrete_only(b, h0, ft, alpha_cv)
  let vs = if s > 0.0 && asv > 0.0 && fyv > 0.0 {
    fyv * asv * n.to_double() * h0 / s
  } else {
    0.0
  }
  vc + vs
}

///|
/// 计算受剪所需箍筋面积
/// A_sv = (V - V_c) * s / (f_yv h₀ n)
pub fn shear_required_stirrup_area(
  v : Double,
  vc : Double,
  s : Double,
  fyv : Double,
  h0 : Double,
  n : Int,
) -> Double {
  if v <= vc || s <= 0.0 || fyv <= 0.0 || h0 <= 0.0 || n <= 0 {
    return 0.0
  }
  (v - vc) * s / (fyv * h0 * n.to_double())
}

// ==================== 受压构件 - 轴心受压 ====================

///|
/// 轴心受压承载力 (普通箍筋)
/// N_u = 0.9φ(f_c A + f_y' A_s')
/// 参数: fc - 混凝土强度 (MPa), a - 混凝土面积 (mm²), fy_prime - 受压钢筋强度 (MPa), as_prime - 受压钢筋面积 (mm²), phi - 稳定系数
pub fn axial_compression_capacity(
  fc : Double,
  a : Double,
  fy_prime : Double,
  as_prime : Double,
  phi : Double,
) -> Double {
  if fc <= 0.0 || a <= 0.0 || phi <= 0.0 {
    return 0.0
  }
  0.9 * phi * (fc * a + fy_prime * as_prime)
}

///|
/// 轴心受压承载力 (螺旋箍筋)
/// N_u = 0.9(f_c A_cor + f_y' A_s' + 2α f_yv A_ss0)
/// 参数: fc, acor - 核心混凝土面积, fy_prime, as_prime, fyv - 螺旋箍筋强度, ass0 - 螺旋箍筋换算面积, alpha - 系数
pub fn axial_compression_capacity_spiral(
  fc : Double,
  acor : Double,
  fy_prime : Double,
  as_prime : Double,
  fyv : Double,
  ass0 : Double,
  alpha : Double,
) -> Double {
  if fc <= 0.0 || acor <= 0.0 {
    return 0.0
  }
  0.9 * (fc * acor + fy_prime * as_prime + 2.0 * alpha * fyv * ass0)
}

///|
/// 稳定系数 (查表或经验公式)
/// 对于 l₀/b ≤ 8: φ = 1.0
/// 对于 l₀/b > 8: 简化公式 φ ≈ 1.177 - 0.021(l₀/b)
pub fn stability_factor(l0_over_b : Double) -> Double {
  if l0_over_b <= 8.0 {
    1.0
  } else if l0_over_b <= 34.0 {
    clamp(1.177 - 0.021 * l0_over_b, 0.0, 1.0)
  } else {
    0.0
  }
}

// ==================== 受压构件 - 偏心受压 ====================

///|
/// 大偏心受压承载力 (ξ ≤ ξ_b)
/// N_u = α₁f_cbx + f_y'A_s' - f_yA_s
/// M_u = α₁f_cbx(h₀ - x/2) + f_y'A_s'(h₀ - a_s') - N_u * e
pub fn eccentric_compression_large(
  b : Double,
  h0 : Double,
  as_ : Double,
  as_prime : Double,
  fc : Double,
  fy : Double,
  fy_prime : Double,
  a_s_prime : Double,
  e : Double,
) -> Double {
  if b <= 0.0 || h0 <= 0.0 || fc <= 0.0 {
    return 0.0
  }
  // 简化计算，假设已知受压区高度 x
  // 实际需要迭代求解
  let xi_b = 0.518
  let x = xi_b * h0 * 0.8 // 假设值
  let n = ALPHA_1 * fc * b * x + fy_prime * as_prime - fy * as_
  n
}

///|
/// 小偏心受压承载力 (ξ > ξ_b)
/// 简化公式
pub fn eccentric_compression_small(
  b : Double,
  h : Double,
  as_ : Double,
  as_prime : Double,
  fc : Double,
  fy : Double,
  fy_prime : Double,
  e : Double,
) -> Double {
  if b <= 0.0 || h <= 0.0 || fc <= 0.0 {
    return 0.0
  }
  // 简化计算
  let a_s = 40.0 // 假设值
  let h0 = h - a_s
  let n = 0.43 * fc * b * h + fy_prime * as_prime - fy * as_
  n
}

///|
/// 偏心距增大系数
/// η = 1 + (l₀/h)²ζ₁ζ₂ / (1400e_i/h₀)
/// 参数: l0 - 计算长度, h - 截面高度, h0 - 有效高度, ei - 初始偏心距, zeta1 - 系数1, zeta2 - 系数2
pub fn eccentricity_amplification_factor(
  l0 : Double,
  h : Double,
  h0 : Double,
  ei : Double,
  zeta1 : Double,
  zeta2 : Double,
) -> Double {
  if h <= 0.0 || h0 <= 0.0 || ei <= 0.0 {
    return 1.0
  }
  let term = square(l0 / h) * zeta1 * zeta2 / (1400.0 * ei / h0)
  1.0 + term
}

// ==================== 受拉构件 ====================

///|
/// 轴心受拉承载力
/// N_u = f_y A_s
pub fn axial_tension_capacity(fy : Double, as_ : Double) -> Double {
  if fy <= 0.0 || as_ <= 0.0 {
    return 0.0
  }
  fy * as_
}

///|
/// 偏心受拉承载力 (小偏心，e₀ < h/2 - a_s)
/// N_u = f_y A_s' (h₀ - a_s') / e'
pub fn eccentric_tension_small(
  h0 : Double,
  as_prime : Double,
  a_s_prime : Double,
  fy_prime : Double,
  e_prime : Double,
) -> Double {
  if h0 <= 0.0 || as_prime <= 0.0 || e_prime <= 0.0 || fy_prime <= 0.0 {
    return 0.0
  }
  fy_prime * as_prime * (h0 - a_s_prime) / e_prime
}

///|
/// 偏心受拉承载力 (大偏心，e₀ ≥ h/2 - a_s)
/// N_u = f_y A_s (h₀ - a_s') / e
pub fn eccentric_tension_large(
  h0 : Double,
  as_ : Double,
  a_s_prime : Double,
  fy : Double,
  e : Double,
) -> Double {
  if h0 <= 0.0 || as_ <= 0.0 || e <= 0.0 || fy <= 0.0 {
    return 0.0
  }
  fy * as_ * (h0 - a_s_prime) / e
}

// ==================== 受扭构件 ====================

///|
/// 纯扭承载力
/// T_u = 0.35 f_t W_t + 1.2√ζ f_yv A_st1 A_cor / s
/// 参数: ft - 混凝土抗拉强度, wt - 受扭塑性抵抗矩, fyv - 箍筋强度, ast1 - 单肢箍筋面积, acor - 核心面积, s - 间距, zeta - 配筋强度比
pub fn torsion_capacity_pure(
  ft : Double,
  wt : Double,
  fyv : Double,
  ast1 : Double,
  acor : Double,
  s : Double,
  zeta : Double,
) -> Double {
  if ft <= 0.0 || wt <= 0.0 || s <= 0.0 {
    return 0.0
  }
  let t1 = 0.35 * ft * wt
  let t2 = if zeta > 0.0 && ast1 > 0.0 && acor > 0.0 {
    1.2 * zeta.sqrt() * fyv * ast1 * acor / s
  } else {
    0.0
  }
  t1 + t2
}

///|
/// 矩形截面受扭塑性抵抗矩
/// W_t = b²(3h - b) / 6
pub fn torsion_plastic_modulus_rect(b : Double, h : Double) -> Double {
  if b <= 0.0 || h <= 0.0 {
    return 0.0
  }
  square(b) * (3.0 * h - b) / 6.0
}

// ==================== 裂缝宽度计算 ====================

///|
/// 最大裂缝宽度 (三级裂缝控制)
/// w_max = α_cr ψ σ_s / E_s * (1.9c_s + 0.08 d_eq / ρ_te)
/// 参数: alpha_cr - 构件受力特征系数, psi - 裂缝间纵向受拉钢筋应变不均匀系数, sigma_s - 钢筋应力, es - 钢筋弹性模量, cs - 保护层厚度, deq - 钢筋等效直径, rho_te - 有效配筋率
pub fn max_crack_width(
  alpha_cr : Double,
  psi : Double,
  sigma_s : Double,
  es : Double,
  cs : Double,
  deq : Double,
  rho_te : Double,
) -> Double {
  if es <= 0.0 || rho_te <= 0.0 {
    return 0.0
  }
  let term1 = 1.9 * cs + 0.08 * deq / rho_te
  alpha_cr * psi * sigma_s / es * term1
}

///|
/// 裂缝间纵向受拉钢筋应变不均匀系数
/// ψ = 1.1 - 0.65 f_tk / (ρ_te σ_s)
pub fn crack_strain_uneven_coefficient(
  ftk : Double,
  rho_te : Double,
  sigma_s : Double,
) -> Double {
  if rho_te <= 0.0 || sigma_s <= 0.0 {
    return 1.0
  }
  clamp(1.1 - 0.65 * ftk / (rho_te * sigma_s), 0.2, 1.0)
}

///|
/// 有效配筋率
/// ρ_te = A_s / A_te
/// A_te = 0.5bh (受弯构件)
pub fn effective_rebar_ratio(as_ : Double, a_te : Double) -> Double {
  if a_te <= 0.0 {
    return 0.0
  }
  safe_div(as_, a_te, 0.0)
}

// ==================== 挠度计算 ====================

///|
/// 受弯构件短期刚度
/// B_s = E_s A_s h₀² / [1.15ψ + 0.2 + 6α_E ρ / (1 + 3.5γ_f')]
/// 参数: es, as_, h0, psi, alpha_e - 弹性模量比, rho - 配筋率, gamma_f_prime - 翼缘系数
pub fn short_term_stiffness(
  es : Double,
  as_ : Double,
  h0 : Double,
  psi : Double,
  alpha_e : Double,
  rho : Double,
  gamma_f_prime : Double,
) -> Double {
  if es <= 0.0 || as_ <= 0.0 || h0 <= 0.0 {
    return 0.0
  }
  let denom = 1.15 * psi +
    0.2 +
    6.0 * alpha_e * rho / (1.0 + 3.5 * gamma_f_prime)
  es * as_ * square(h0) / denom
}

///|
/// 受弯构件长期刚度
/// B = M_k / [M_q(θ - 1) + M_k] * B_s
/// 参数: mk - 标准组合弯矩, mq - 准永久组合弯矩, theta - 考虑荷载长期作用的系数, bs - 短期刚度
pub fn long_term_stiffness(
  mk : Double,
  mq : Double,
  theta : Double,
  bs : Double,
) -> Double {
  if mk <= 0.0 || bs <= 0.0 {
    return 0.0
  }
  let denom = mq * (theta - 1.0) + mk
  mk / denom * bs
}

///|
/// 简支梁挠度 (均布荷载)
/// f = 5qL⁴ / (384B)
pub fn beam_deflection_uniform(q : Double, l : Double, b : Double) -> Double {
  if b <= 0.0 || l <= 0.0 {
    return 0.0
  }
  5.0 * q * pow4(l) / (384.0 * b)
}

///|
/// 简支梁挠度 (集中荷载)
/// f = PL³ / (48B)
pub fn beam_deflection_point(p : Double, l : Double, b : Double) -> Double {
  if b <= 0.0 || l <= 0.0 {
    return 0.0
  }
  p * cube(l) / (48.0 * b)
}

// ==================== 配筋率计算 ====================

///|
/// 配筋率
/// ρ = A_s / (b h₀)
pub fn rebar_ratio(as_ : Double, b : Double, h0 : Double) -> Double {
  if b <= 0.0 || h0 <= 0.0 {
    return 0.0
  }
  safe_div(as_, b * h0, 0.0)
}

///|
/// 检查最小配筋率
pub fn check_min_rebar_ratio(rho : Double, rho_min : Double) -> Bool {
  rho >= rho_min
}

///|
/// 检查最大配筋率 (防止超筋)
pub fn check_max_rebar_ratio(rho : Double, rho_max : Double) -> Bool {
  rho <= rho_max
}

// ==================== 构造要求 ====================

///|
/// 计算有效高度
/// h₀ = h - a_s
pub fn effective_height(h : Double, a_s : Double) -> Double {
  if h <= a_s {
    return 0.0
  }
  h - a_s
}

///|
/// 计算保护层厚度 (考虑箍筋直径)
/// c_actual = c_nominal - d_stirrup
pub fn actual_cover_thickness(c_nominal : Double, d_stirrup : Double) -> Double {
  max(0.0, c_nominal - d_stirrup)
}

///|
/// 计算钢筋重心到边缘距离 (单排)
/// a_s = c + d/2
pub fn rebar_centroid_distance(c : Double, d : Double) -> Double {
  c + d / 2.0
}

///|
/// 计算钢筋重心到边缘距离 (双排)
/// a_s = c + d + s_v/2
pub fn rebar_centroid_distance_double_row(
  c : Double,
  d : Double,
  s_v : Double,
) -> Double {
  c + d + s_v / 2.0
}

// ==================== 预应力混凝土 ====================

///|
/// 预应力损失 - 张拉端锚具变形损失
/// σ_l1 = a E_s / l
/// 参数: a - 锚具变形值 (mm), es - 钢筋弹性模量 (MPa), l - 张拉端到锚固端距离 (mm)
pub fn prestress_loss_anchorage(a : Double, es : Double, l : Double) -> Double {
  if l <= 0.0 {
    return 0.0
  }
  a * es / l
}

///|
/// 预应力损失 - 摩擦损失
/// σ_l2 = σ_con (1 - e^(-(μθ + kx)))
/// 参数: sigma_con - 张拉控制应力, mu - 摩擦系数, theta - 转角 (rad), k - 局部偏差系数, x - 距离
pub fn prestress_loss_friction(
  sigma_con : Double,
  mu : Double,
  theta : Double,
  k : Double,
  x : Double,
) -> Double {
  if sigma_con <= 0.0 {
    return 0.0
  }
  let exponent = -(mu * theta + k * x)
  // e^x 近似: 1 + x + x²/2 + x³/6
  let exp_approx = 1.0 +
    exponent +
    square(exponent) / 2.0 +
    cube(exponent) / 6.0
  sigma_con * (1.0 - exp_approx)
}

///|
/// 预应力损失 - 温差损失
/// σ_l3 = 2Δt E_s α
/// 参数: delta_t - 温差 (°C), es - 弹性模量, alpha - 线膨胀系数
pub fn prestress_loss_temperature(
  delta_t : Double,
  es : Double,
  alpha : Double,
) -> Double {
  2.0 * delta_t * es * alpha
}

///|
/// 预应力损失 - 钢筋松弛损失
/// σ_l4 = ψ σ_con
/// 参数: psi - 松弛系数, sigma_con - 张拉控制应力
pub fn prestress_loss_relaxation(psi : Double, sigma_con : Double) -> Double {
  psi * sigma_con
}

///|
/// 预应力损失 - 混凝土收缩徐变损失
/// σ_l5 = (45 + 280 σ_pc / f_cu') / (1 + 15ρ)
/// 参数: sigma_pc - 预应力筋合力点处混凝土法向应力, fcu_prime - 施加预应力时混凝土立方体抗压强度, rho - 配筋率
pub fn prestress_loss_shrinkage_creep(
  sigma_pc : Double,
  fcu_prime : Double,
  rho : Double,
) -> Double {
  if fcu_prime <= 0.0 {
    return 0.0
  }
  (45.0 + 280.0 * sigma_pc / fcu_prime) / (1.0 + 15.0 * rho)
}

///|
/// 总预应力损失
pub fn total_prestress_loss(
  loss1 : Double,
  loss2 : Double,
  loss3 : Double,
  loss4 : Double,
  loss5 : Double,
) -> Double {
  loss1 + loss2 + loss3 + loss4 + loss5
}

///|
/// 有效预应力
/// σ_pe = σ_con - σ_l
pub fn effective_prestress(sigma_con : Double, sigma_l : Double) -> Double {
  max(0.0, sigma_con - sigma_l)
}

// ==================== 辅助函数 ====================

///|
/// 计算相对受压区高度
/// ξ = x / h₀
pub fn relative_compression_zone_height(x : Double, h0 : Double) -> Double {
  if h0 <= 0.0 {
    return 0.0
  }
  safe_div(x, h0, 0.0)
}

///|
/// 判断是否超筋
pub fn is_over_reinforced(xi : Double, xi_b : Double) -> Bool {
  xi > xi_b
}

///|
/// 判断是否少筋
pub fn is_under_reinforced(rho : Double, rho_min : Double) -> Bool {
  rho < rho_min
}

///|
/// 计算换算截面面积
/// A₀ = A_c + α_E A_s
pub fn transformed_area(ac : Double, alpha_e : Double, as_ : Double) -> Double {
  ac + alpha_e * as_
}

///|
/// 计算弹性模量比
/// α_E = E_s / E_c
pub fn elastic_modulus_ratio(es : Double, ec : Double) -> Double {
  if ec <= 0.0 {
    return 0.0
  }
  es / ec
}
