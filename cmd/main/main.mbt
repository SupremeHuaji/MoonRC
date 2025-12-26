///|
fn main {
  // 示例：计算单筋矩形截面受弯承载力
  // b=200mm, h0=460mm, As=1256mm², fc=14.3MPa(C30), fy=360MPa(HRB400)
  let m = @lib.flexure_capacity_single_rebar(200.0, 460.0, 1256.0, 14.3, 360.0)
  println("受弯承载力: \{m / 1.0e6} kN·m")

  // 示例：计算轴心受压承载力
  let n = @lib.axial_compression_capacity(14.3, 100000.0, 360.0, 1256.0, 0.9)
  println("轴心受压承载力: \{n / 1.0e6} MN")

  // 示例：计算配筋率
  let rho = @lib.rebar_ratio(1256.0, 200.0, 460.0)
  println("配筋率: \{rho * 100.0}%")
}
