# This cmake file will be dropped at the root of the openlibm repository
# folder and need to be the more generic as possible to support further
# update of the original project
cmake_minimum_required(VERSION 3.5)

## fetch source files

file(
    GLOB
    VXOPENLIBM_SOURCES

    # BDS-specific sources
    bsdsrc/b_exp.c
    bsdsrc/b_log.c
    bsdsrc/b_tgamma.c

    # arch-specific sources
    sh3eb/fenv.c

    # common sources
    src/common.c
    src/e_acos.c
    src/e_acosf.c
    src/e_acosh.c
    src/e_acoshf.c
    src/e_asin.c
    src/e_asinf.c
    src/e_atan2.c
    src/e_atan2f.c
    src/e_atanh.c
    src/e_atanhf.c
    src/e_cosh.c
    src/e_coshf.c
    src/e_exp.c
    src/e_expf.c
    src/e_fmod.c
    src/e_fmodf.c
    src/e_hypot.c
    src/e_hypotf.c
    src/e_j0.c
    src/e_j0f.c
    src/e_j1.c
    src/e_j1f.c
    src/e_jn.c
    src/e_jnf.c
    src/e_lgamma.c
    src/e_lgamma_r.c
    src/e_lgammaf.c
    src/e_lgammaf_r.c
    src/e_log.c
    src/e_log10.c
    src/e_log10f.c
    src/e_log2.c
    src/e_log2f.c
    src/e_logf.c
    src/e_pow.c
    src/e_powf.c
    src/e_remainder.c
    src/e_remainderf.c
    src/e_rem_pio2.c
    src/e_rem_pio2f.c
    src/e_sinh.c
    src/e_sinhf.c
    src/e_sqrt.c
    src/e_sqrtf.c
    src/k_cos.c
    src/k_exp.c
    src/k_expf.c
    src/k_rem_pio2.c
    src/k_sin.c
    src/k_tan.c
    src/k_cosf.c
    src/k_sinf.c
    src/k_tanf.c
    src/s_asinh.c
    src/s_asinhf.c
    src/s_atan.c
    src/s_atanf.c
    src/s_carg.c
    src/s_cargf.c
    src/s_cbrt.c
    src/s_cbrtf.c
    src/s_ceil.c
    src/s_ceilf.c
    src/s_copysign.c
    src/s_copysignf.c
    src/s_cos.c
    src/s_cosf.c
    src/s_csqrt.c
    src/s_csqrtf.c
    src/s_erf.c
    src/s_erff.c
    src/s_exp2.c
    src/s_exp2f.c
    src/s_expm1.c
    src/s_expm1f.c
    src/s_fabs.c
    src/s_fabsf.c
    src/s_fdim.c
    src/s_floor.c
    src/s_floorf.c
    src/s_fmax.c
    src/s_fmaxf.c
    src/s_fmin.c
    src/s_fminf.c
    src/s_fpclassify.c
    src/s_frexp.c
    src/s_frexpf.c
    src/s_ilogb.c
    src/s_ilogbf.c
    src/s_isinf.c
    src/s_isfinite.c
    src/s_isnormal.c
    src/s_isnan.c
    src/s_log1p.c
    src/s_log1pf.c
    src/s_logb.c
    src/s_logbf.c
    src/s_modf.c
    src/s_modff.c
    src/s_nextafter.c
    src/s_nextafterf.c
    src/s_nexttowardf.c
    src/s_remquo.c
    src/s_remquof.c
    src/s_rint.c
    src/s_rintf.c
    src/s_round.c
    src/s_roundf.c
    src/s_scalbln.c
    src/s_scalbn.c
    src/s_scalbnf.c
    src/s_signbit.c
    src/s_signgam.c
    src/s_sin.c
    src/s_sincos.c
    src/s_sinf.c
    src/s_sincosf.c
    src/s_tan.c
    src/s_tanf.c
    src/s_tanh.c
    src/s_tanhf.c
    src/s_tgammaf.c
    src/s_trunc.c
    src/s_truncf.c
    src/s_cpow.c
    src/s_cpowf.c
    src/w_cabs.c
    src/w_cabsf.c

    # common non-WINNT specific
    src/s_nan.c

    # common C99 long double functions
    src/s_copysignl.c
    src/s_fabsl.c
    src/s_llrintl.c
    src/s_lrintl.c
    src/s_modfl.c

    # common C99 complex function
    src/s_ccosh.c
    src/s_ccoshf.c
    src/s_cexp.c
    src/s_cexpf.c
    src/s_cimag.c
    src/s_cimagf.c
    src/s_conj.c
    src/s_conjf.c
    src/s_cproj.c
    src/s_cprojf.c
    src/s_creal.c
    src/s_crealf.c
    src/s_csinh.c
    src/s_csinhf.c
    src/s_ctanh.c
    src/s_ctanhf.c
    src/s_cacos.c
    src/s_cacosf.c
    src/s_cacosh.c
    src/s_cacoshf.c
    src/s_casin.c
    src/s_casinf.c
    src/s_casinh.c
    src/s_casinhf.c
    src/s_catan.c
    src/s_catanf.c
    src/s_catanh.c
    src/s_catanhf.c
    src/s_clog.c
    src/s_clogf.c
)

## generate the project

project(openlibm LANGUAGES C ASM)
include_directories(include/ src/ sh3eb/ bsdsrc/)
add_compile_options(
    -D__sh3__=1
    -DASSEMBLER
    -D__BSD_VISIBLE
    -Wno-implicit-function-declaration
    -Wall
    -Wextra
    -fPIC
    -ffreestanding
    -nostdlib
    -m3
    -mb
    -std=c99
    -fno-gnu89-inline
    -fno-builtin
    -O3
)
add_library(openlibm ${VXOPENLIBM_SOURCES})

## install configuration

set_target_properties(openlibm PROPERTIES OUTPUT_NAME "m")
install(DIRECTORY include/ DESTINATION include)
install(TARGETS openlibm DESTINATION lib)
