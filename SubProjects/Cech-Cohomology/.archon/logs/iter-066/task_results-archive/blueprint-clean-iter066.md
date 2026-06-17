# Blueprint-clean report — iter-066

## Scope

Pass scoped to the regions edited by `comp-iter066`:
- `lem:open_immersion_pushforward_acyclic` (newly split lemma, lines ~9181–9324)
- `lem:open_immersion_pushforward_comp` (rewritten proof, lines ~9326–9423)
- `lem:slice_reverse_ring_map` φ'' codomain-bridge (corrected proof, lines ~10495–10526)
- CSI stale `% NOTE` region (`lem:pushPull_coprod_prod`, lines ~8473+)
- Two new `\mathlibok` anchors (`lem:isoSpec_scheme_mathlib`, `lem:ext_mapExactFunctor_mathlib`)

## Changes made

### 1. Removed `\operatorname{Iso.refl}` Lean identifier from proof prose (line 10514)

**Before:**
```
\(\mathrm{eqv}.\mathrm{inverse}\), is the identity isomorphism (\(\operatorname{Iso.refl}\)):
```

**After:**
```
\(\mathrm{eqv}.\mathrm{inverse}\), is the identity isomorphism:
```

`Iso.refl` is a Lean 4 term, not a mathematical notation. Removed the parenthetical containing it; the sentence reads correctly without it.

### 2. Replaced `(defeq)` Lean jargon with mathematical English (line 10522)

**Before:**
```
\(\varphi''\) is simply \(\operatorname{sliceStructureSheafHom}(\varphi.\mathrm{symm})\,V_i\) retyped
along the (defeq) corrected-inverse codomain.
```

**After:**
```
\(\varphi''\) is simply \(\operatorname{sliceStructureSheafHom}(\varphi.\mathrm{symm})\,V_i\) retyped
along the (definitionally equal) corrected-inverse codomain.
```

`defeq` is Lean/type-theory shorthand. Spelled out to "definitionally equal", consistent with the surrounding prose which already uses the phrase "definitional equality" and "definitionally equal".

## Label / cross-reference audit

All `\uses{}` and `\ref{}` in the edited blocks resolve to existing labels:

| Label | File | Status |
|---|---|---|
| `lem:affine_serre_vanishing` | CechHigherDirectImage.tex:3219 | ✓ |
| `lem:higher_direct_image_presheaf` | CechHigherDirectImage.tex:9007 | ✓ |
| `lem:sheafify_kills_locally_zero` | CechHigherDirectImage.tex:7137 | ✓ |
| `lem:isZero_presheafToSheaf_of_locally_isZero` | CechHigherDirectImage.tex:7204 | ✓ |
| `lem:ext_homcomplex_mathlib` | CechHigherDirectImage.tex:9087 | ✓ |
| `lem:isZero_presheafToSheaf_of_sections_locally_zero` | CechHigherDirectImage.tex:10883 | ✓ |
| `lem:pushforward_sections_functor` | CechHigherDirectImage.tex:9427 | ✓ |
| `lem:rightDerivedNatIso` | CechHigherDirectImage.tex:9518 | ✓ |
| `lem:sectionsFunctorCorepIso` | CechHigherDirectImage.tex:9491 | ✓ |
| `lem:affine_serre_vanishing_general_open` | CechHigherDirectImage.tex:9985 | ✓ |
| `lem:modules_isoSpec_ext_transport` | CechHigherDirectImage.tex:10785 | ✓ |
| `lem:isoSpec_scheme_mathlib` | CechHigherDirectImage.tex:9537 | ✓ |
| `lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero` | CechHigherDirectImage.tex:9112 | ✓ |
| `lem:ext_jShriekOU_eq_zero_of_specIso` | CechHigherDirectImage.tex:10838 | ✓ |
| `lem:injective_of_adjoint` | CechHigherDirectImage.tex:2531 | ✓ |
| `def:right_acyclic` | Cohomology_AcyclicResolution.tex:130 | ✓ |
| `lem:right_derived_vanishes_injective` | Cohomology_AcyclicResolution.tex:69 | ✓ |
| `lem:acyclic_resolution_computes_derived` | Cohomology_AcyclicResolution.tex:926 | ✓ |
| `lem:right_derived_injective_resolution` | Cohomology_AcyclicResolution.tex:47 | ✓ |
| `lem:right_derived_zero_iso_self` | Cohomology_AcyclicResolution.tex:81 | ✓ |
| `lem:scheme_pullbackPushforwardAdjunction_mathlib` | CechHigherDirectImage.tex:10395 | ✓ |
| `lem:restrictFunctorIsoPullback_mathlib` | CechHigherDirectImage.tex:8827 | ✓ |
| `lem:scheme_pushforwardComp_mathlib` | CechHigherDirectImage.tex:10411 | ✓ |
| `lem:cech_to_cohomology_on_basis` | CechHigherDirectImage.tex:6878 | ✓ |
| `lem:slice_structureSheaf_hom` | (in chapter) | ✓ |
| `lem:slice_overs_equiv_continuity` | (in chapter) | ✓ |

## Items left unchanged

- `% NOTE (review iter-065)` comment blocks in statement blocks of `lem:pushPull_coprod_prod`, `lem:pushforward_slice_two_adjunction`, `lem:pushforward_slice_pullback_iso`, `lem:pushforward_iso_preserves_qcoh` — these are LaTeX comments (not rendered proof prose) in the review agent's domain; left for the review agent to prune as they see fit.
- `\leanok` markers — untouched per instructions.
- `\mathlibok` markers on the two new anchors (`lem:isoSpec_scheme_mathlib` line 9539, `lem:ext_mapExactFunctor_mathlib` line 9553) — correct and untouched.
- All mathematical content in the new `lem:open_immersion_pushforward_acyclic` and its proof, and in `lem:open_immersion_pushforward_comp` — no Lean leakage found; prose is clean.

## Summary

Two Lean-syntax leaks in the φ'' codomain-bridge proof: `\operatorname{Iso.refl}` removed, `(defeq)` expanded to `(definitionally equal)`. All cross-references validated. No mathematical content altered.
