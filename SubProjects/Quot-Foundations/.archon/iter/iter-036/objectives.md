# Iter 036 — Objectives detail

## Lane 1 — FBC-A (FlatBaseChange.lean) [fine-grained]

**Target:** close `base_change_mate_gstar_transpose` (decl @1999, sorry @~2125) via the conjugate-counit
`huce` remainder. NOT `_legs`/conj-2a (abandoned 5-iter stall), NOT element-`ext` (documented dead end).

- `huce` master identity already in scope at L2079 (`conjugateEquiv_counit_symm adjL adjR β.hom W`, landed
  & compiling, verified). Residual = three enumerated telescoping steps (one named lemma each, fine-grained):
  - (a) inner reindex `Γ_R(θ_in)=ρ` reproven INLINE from `…_legs_unitExpand`(@1317)/`…_gammaDistribute`(@1348)
    + `gammaMap_pushforwardComp_{hom,inv}_eq_id` + `base_change_mate_unit_value` + `pullbackPushforward_unit_comp`.
  - (b) one-generator close `extendScalars ψ (ρ) ≫ ε^alg = regroupEquiv.inv` on `r'⊗m ↦ (1⊗r')⊗m`.
  - (c) dictionary cancellation vs `huce`'s tilde-counit factors against `Θ_src`/`Θ_tgt`.
- In-file caveat: `set W` does not fold `ε_g`'s argument — stage via `conv`/`change`, not bare `rw`.
- Cascade on close: `section_identity`→`generator_trace`→`cancelBaseChange`→ affine obligation 2.
- Coverage cleanup: `private` on `isIso_unitToPushforwardObjUnit_of_isIso'`.

## Lane 2 — QUOT-Hfr (QuotScheme.lean) [mathlib-build]

**Target:** build `gammaPullbackTopIso` (section transport), then chain to `Hfr` and one-line gap1.

- Prefer natural-in-`V` form `Γ((pullback j).obj M, V) ≅ Γ(M, j(V))` for open immersion `j`; 3-step sketch
  in `lem:pullback_gamma_top_iso` (definitional Γ on `j^res`, `restrictFunctorIsoPullback`, apply `Γ(-,V)`).
- Chain to `Hfr` via P1's three pullbacks + `over_restrict_pullback_iso` + P1 `IsIso fromTildeΓ` +
  `isLocalizedModule_restrict_of_isIso_fromTildeΓ`; then instantiate the LANDED cover-form keystone
  `isLocalizedModule_basicOpen_descent_of_cover` ⟹ named descent + gap1 (`qcoh_affine_isIso_fromTildeΓ`)
  are one-liners.
- Coverage cleanup: `private` on `descent_overlap_agree`/`descent_smul_eq_zero`/`descent_surj`/
  `iSup_basicOpen_subtype_eq_top`/`res_comp`.

## Lane 3 — GR-existence (GrassmannianCells.lean) [mathlib-build, scaffold]

**Target:** build E1 (`existence_chart_factorization`) — the new decl this lane creates and proves.

- E1 = primary missing Mathlib API: factor `Spec K → scheme` through one chart `ι_I` (range ∋ image pt).
  First search for a direct `Scheme.OpenCover`/`IsOpenImmersion` lift API; fallback = topological-point +
  `Scheme.Hom.appLE`/stalk (blueprint Notes). Likely needs `backward.isDefEq.respectTransparency false`.
- mathlib-build no-sorry invariant: fully prove E1 or hand off a precise decomposition of the blocked
  sub-step. E2/E3/E4/`valuativeExistence_toSpecZ` are gated on E1 — scaffolded in a LATER iter, NOT given
  sorry stubs here (would violate the mode).
- Coverage cleanup: `private` on `rotMid`/`transitionInvImageMatrix`/`transitionInvPair`.

## Disposition pointers

- Pivot-then-revert rationale + critic dispositions: `iter/iter-036/plan.md`.
- Source verification of strategy-critic claims: confirmed in FlatBaseChange.lean L79–86, L2057,
  L2079, L2090–2124, L1317, L1348.
