// MoonRC - 工具函数

// ==================== 基本数学运算 ====================

///|
/// 计算平方
pub fn square(x : Double) -> Double {
  x * x
}

///|
/// 计算立方
pub fn cube(x : Double) -> Double {
  x * x * x
}

///|
/// 计算四次方
pub fn pow4(x : Double) -> Double {
  let x2 = x * x
  x2 * x2
}

///|
/// 计算绝对值
pub fn abs(x : Double) -> Double {
  if x < 0.0 {
    -x
  } else {
    x
  }
}

///|
/// 计算最大值
pub fn max(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
/// 计算最小值
pub fn min(a : Double, b : Double) -> Double {
  if a < b {
    a
  } else {
    b
  }
}

///|
/// 安全除法，分母为零时返回默认值
pub fn safe_div(num : Double, den : Double, fallback : Double) -> Double {
  if abs(den) <= EPSILON {
    fallback
  } else {
    num / den
  }
}

///|
/// 判断两个浮点数是否近似相等
pub fn approx_equal(a : Double, b : Double, tolerance : Double) -> Bool {
  abs(a - b) < tolerance
}

///|
/// 判断浮点数是否接近零
pub fn is_zero(x : Double) -> Double {
  abs(x)
}

///|
/// 限制值在范围内
pub fn clamp(value : Double, min_val : Double, max_val : Double) -> Double {
  if value < min_val {
    min_val
  } else if value > max_val {
    max_val
  } else {
    value
  }
}

// ==================== 几何计算 ====================

///|
/// 圆形面积
pub fn circle_area(r : Double) -> Double {
  PI * square(r)
}

///|
/// 矩形面积
pub fn rect_area(width : Double, height : Double) -> Double {
  width * height
}

///|
/// 梯形面积
pub fn trapezoid_area(a : Double, b : Double, h : Double) -> Double {
  (a + b) * h / 2.0
}

// ==================== 插值 ====================

///|
/// 线性插值
pub fn lerp(a : Double, b : Double, t : Double) -> Double {
  a + (b - a) * t
}

///|
/// 线性插值表查找
pub fn linear_interpolate(
  x_values : Array[Double],
  y_values : Array[Double],
  x : Double,
) -> Double {
  let n = x_values.length()
  if n == 0 {
    return 0.0
  }
  if n == 1 {
    return y_values[0]
  }
  if x <= x_values[0] {
    return y_values[0]
  }
  if x >= x_values[n - 1] {
    return y_values[n - 1]
  }
  let mut i = 0
  while i < n - 1 {
    if x >= x_values[i] && x <= x_values[i + 1] {
      let t = (x - x_values[i]) / (x_values[i + 1] - x_values[i])
      return lerp(y_values[i], y_values[i + 1], t)
    }
    i = i + 1
  }
  y_values[n - 1]
}
