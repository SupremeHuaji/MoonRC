// MoonRC - 混凝土结构设计常量定义

// ==================== 数学常量 ====================

///|
/// 圆周率
pub const PI : Double = 3.141592653589793

///|
/// 浮点数比较精度
pub const EPSILON : Double = 1.0e-10

// ==================== 混凝土强度等级 (MPa) ====================

///|
/// C15 混凝土立方体抗压强度标准值
pub const FCK_C15 : Double = 15.0

///|
/// C20 混凝土立方体抗压强度标准值
pub const FCK_C20 : Double = 20.0

///|
/// C25 混凝土立方体抗压强度标准值
pub const FCK_C25 : Double = 25.0

///|
/// C30 混凝土立方体抗压强度标准值
pub const FCK_C30 : Double = 30.0

///|
/// C35 混凝土立方体抗压强度标准值
pub const FCK_C35 : Double = 35.0

///|
/// C40 混凝土立方体抗压强度标准值
pub const FCK_C40 : Double = 40.0

///|
/// C45 混凝土立方体抗压强度标准值
pub const FCK_C45 : Double = 45.0

///|
/// C50 混凝土立方体抗压强度标准值
pub const FCK_C50 : Double = 50.0

///|
/// C55 混凝土立方体抗压强度标准值
pub const FCK_C55 : Double = 55.0

///|
/// C60 混凝土立方体抗压强度标准值
pub const FCK_C60 : Double = 60.0

// ==================== 混凝土轴心抗压强度设计值 (MPa) ====================

///|
/// C15 轴心抗压强度设计值
pub const FC_C15 : Double = 7.2

///|
/// C20 轴心抗压强度设计值
pub const FC_C20 : Double = 9.6

///|
/// C25 轴心抗压强度设计值
pub const FC_C25 : Double = 11.9

///|
/// C30 轴心抗压强度设计值
pub const FC_C30 : Double = 14.3

///|
/// C35 轴心抗压强度设计值
pub const FC_C35 : Double = 16.7

///|
/// C40 轴心抗压强度设计值
pub const FC_C40 : Double = 19.1

///|
/// C45 轴心抗压强度设计值
pub const FC_C45 : Double = 21.1

///|
/// C50 轴心抗压强度设计值
pub const FC_C50 : Double = 23.1

///|
/// C55 轴心抗压强度设计值
pub const FC_C55 : Double = 25.3

///|
/// C60 轴心抗压强度设计值
pub const FC_C60 : Double = 27.5

// ==================== 混凝土轴心抗拉强度设计值 (MPa) ====================

///|
/// C15 轴心抗拉强度设计值
pub const FT_C15 : Double = 0.91

///|
/// C20 轴心抗拉强度设计值
pub const FT_C20 : Double = 1.10

///|
/// C25 轴心抗拉强度设计值
pub const FT_C25 : Double = 1.27

///|
/// C30 轴心抗拉强度设计值
pub const FT_C30 : Double = 1.43

///|
/// C35 轴心抗拉强度设计值
pub const FT_C35 : Double = 1.57

///|
/// C40 轴心抗拉强度设计值
pub const FT_C40 : Double = 1.71

///|
/// C45 轴心抗拉强度设计值
pub const FT_C45 : Double = 1.80

///|
/// C50 轴心抗拉强度设计值
pub const FT_C50 : Double = 1.89

///|
/// C55 轴心抗拉强度设计值
pub const FT_C55 : Double = 1.96

///|
/// C60 轴心抗拉强度设计值
pub const FT_C60 : Double = 2.04

// ==================== 钢筋强度设计值 (MPa) ====================

///|
/// HPB300 钢筋抗拉强度设计值
pub const FY_HPB300 : Double = 270.0

///|
/// HRB335 钢筋抗拉强度设计值
pub const FY_HRB335 : Double = 300.0

///|
/// HRB400 钢筋抗拉强度设计值
pub const FY_HRB400 : Double = 360.0

///|
/// HRB500 钢筋抗拉强度设计值
pub const FY_HRB500 : Double = 435.0

///|
/// HRB400 钢筋抗压强度设计值
pub const FYC_HRB400 : Double = 360.0

///|
/// HRB500 钢筋抗压强度设计值
pub const FYC_HRB500 : Double = 410.0

// ==================== 弹性模量 (GPa) ====================

///|
/// C20 混凝土弹性模量
pub const EC_C20 : Double = 25.5

///|
/// C25 混凝土弹性模量
pub const EC_C25 : Double = 28.0

///|
/// C30 混凝土弹性模量
pub const EC_C30 : Double = 30.0

///|
/// C35 混凝土弹性模量
pub const EC_C35 : Double = 31.5

///|
/// C40 混凝土弹性模量
pub const EC_C40 : Double = 32.5

///|
/// C45 混凝土弹性模量
pub const EC_C45 : Double = 33.5

///|
/// C50 混凝土弹性模量
pub const EC_C50 : Double = 34.5

///|
/// 钢筋弹性模量 (通用)
pub const ES : Double = 200.0

// ==================== 设计参数 ====================

///|
/// 混凝土强度影响系数 (一般取 1.0)
pub const ALPHA_1 : Double = 1.0

///|
/// 混凝土强度影响系数 (C50及以下取 1.0)
pub const ALPHA_1_C50 : Double = 1.0

///|
/// 混凝土强度影响系数 (C50以上取 0.94)
pub const ALPHA_1_C80 : Double = 0.94

///|
/// 混凝土强度影响系数 β₁ (C50及以下取 0.8)
pub const BETA_1_C50 : Double = 0.8

///|
/// 混凝土强度影响系数 β₁ (C80取 0.74)
pub const BETA_1_C80 : Double = 0.74

///|
/// 相对界限受压区高度 ξ_b (HRB335, C50及以下)
pub const XI_B_HRB335_C50 : Double = 0.550

///|
/// 相对界限受压区高度 ξ_b (HRB400, C50及以下)
pub const XI_B_HRB400_C50 : Double = 0.518

///|
/// 相对界限受压区高度 ξ_b (HRB500, C50及以下)
pub const XI_B_HRB500_C50 : Double = 0.482

// ==================== 构造要求 ====================

///|
/// 最小配筋率 (受弯构件)
pub const RHO_MIN_FLEXURE : Double = 0.002

///|
/// 最小配筋率 (受压构件一侧)
pub const RHO_MIN_COMPRESSION_SIDE : Double = 0.002

///|
/// 最小配筋率 (轴心受压构件全部)
pub const RHO_MIN_AXIAL_COMPRESSION : Double = 0.0055

///|
/// 最大配筋率 (受弯构件，防止超筋)
pub const RHO_MAX_FLEXURE : Double = 0.025

///|
/// 最小保护层厚度 (一类环境，板)
pub const C_MIN_CLASS1_SLAB : Double = 15.0

///|
/// 最小保护层厚度 (一类环境，梁)
pub const C_MIN_CLASS1_BEAM : Double = 20.0

///|
/// 最小保护层厚度 (一类环境，柱)
pub const C_MIN_CLASS1_COLUMN : Double = 20.0

///|
/// 最小保护层厚度 (二类环境，板)
pub const C_MIN_CLASS2_SLAB : Double = 20.0

///|
/// 最小保护层厚度 (二类环境，梁)
pub const C_MIN_CLASS2_BEAM : Double = 25.0

///|
/// 最小保护层厚度 (二类环境，柱)
pub const C_MIN_CLASS2_COLUMN : Double = 25.0

// ==================== 裂缝控制 ====================

///|
/// 裂缝控制等级 - 一级 (严格要求不出现裂缝)
pub const CRACK_LEVEL_1 : Int = 1

///|
/// 裂缝控制等级 - 二级 (一般要求不出现裂缝)
pub const CRACK_LEVEL_2 : Int = 2

///|
/// 裂缝控制等级 - 三级 (允许出现裂缝)
pub const CRACK_LEVEL_3 : Int = 3

///|
/// 最大裂缝宽度限值 (一级环境，三级裂缝控制)
pub const W_MAX_CLASS1_LEVEL3 : Double = 0.3

///|
/// 最大裂缝宽度限值 (二级环境，三级裂缝控制)
pub const W_MAX_CLASS2_LEVEL3 : Double = 0.2

// ==================== 挠度控制 ====================

///|
/// 受弯构件挠度限值 (l₀ < 7m)
pub const DEFLECTION_LIMIT_LT7M : Double = 1.0 / 200.0

///|
/// 受弯构件挠度限值 (7m ≤ l₀ ≤ 9m)
pub const DEFLECTION_LIMIT_7_9M : Double = 1.0 / 250.0

///|
/// 受弯构件挠度限值 (l₀ > 9m)
pub const DEFLECTION_LIMIT_GT9M : Double = 1.0 / 300.0

// ==================== 单位换算 ====================

///|
/// MPa 转 Pa
pub const MPA_TO_PA : Double = 1000000.0

///|
/// GPa 转 Pa
pub const GPA_TO_PA : Double = 1000000000.0

///|
/// mm 转 m
pub const MM_TO_M : Double = 0.001

///|
/// m 转 mm
pub const M_TO_MM : Double = 1000.0

// ==================== 经验系数 ====================

///|
/// 矩形应力图系数 (C50及以下)
pub const ALPHA_1_RECT : Double = 1.0

///|
/// 矩形应力图系数 (C80)
pub const ALPHA_1_RECT_C80 : Double = 0.94

///|
/// 矩形应力图高度系数 (C50及以下)
pub const BETA_1_RECT : Double = 0.8

///|
/// 矩形应力图高度系数 (C80)
pub const BETA_1_RECT_C80 : Double = 0.74

///|
/// 受剪承载力系数 (一般构件)
pub const ALPHA_CV : Double = 0.7

///|
/// 受剪承载力系数 (集中荷载独立梁)
pub const ALPHA_CV_CONCENTRATED : Double = 1.75
