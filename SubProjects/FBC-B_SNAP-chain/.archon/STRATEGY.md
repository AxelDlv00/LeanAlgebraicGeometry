# Strategy

## Goal

Close the `sorry`-bearing nodes of two Čech-independent (i=0) legs extracted from the parent
*Quot-Foundations* `thm:fga_pic_representability` cone, then merge back:

- **FBC-B** — `lem:affine_base_change_pushforward` + `thm:flat_base_change_pushforward` +
  `thm:fbcb_global_direct` (the i=0 base-change map `g^* f_* F ⟶ f'_* g'^* F` is an isomorphism).
- **SNAP** — `lem:sectionGradedRing_gcommSemiring` + `lem:sectionGradedModule_gmodule`: the H⁰
  graded ring `Γ_*(X,L) = ⊕_{n≥0} Γ(X, L^{⊗n})`.

End-state: zero project `sorry` in the 71-node closure, zero project axioms, kernel-only axioms.
Names/labels are the parent's so finished work merges back unchanged.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| FBC-B i=0 via Stacks 02KH(2) equalizer | ACTIVE‖ | 2–4 | ~250–500 | flat preserves finite equalizer (`tensorEqLocusEquiv`, in Mathlib) | residue = fork assembly for `baseChangeGammaPullbackEquiv` + discharge 2 frozen named legs |
| SNAP — section graded ring | ACTIVE‖ | 1–3 | ~120–300 | `DirectSum.Ring` assembly | builds the H⁰ object `Γ_*(X,L)`; residue = cast-coherence + graded assembly |

## Completed

| Phase | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|
| FBC RegroupHelper | ~120 | `Cohomology_RegroupHelper` | `regroupEquiv` `(A⊗_R R')⊗_A M ≅ R'⊗_R M` | `eT` identity-bridge + `TensorProduct.induction_on` beats transparent diamonds | `erw [TensorProduct.zero_tmul]` for zero-branch |
| FBC affine lemma + global infra | ~? | `FlatBaseChange.lean`, `FlatBaseChangeGlobal.lean` | `pullback_spec_tilde_iso` (01I9); `eqLocus` H⁰-equalizer; `baseChangeGammaEquiv`; element-level `gammaResA`/`leftRes`/`rightRes`/`gammaTopEquivEqLocus` | element-level equalizer presentation | A-linear "build-ahead" pins retired (phantom nodes) |
| SNAP tensor crux + chain | ~? | `SectionGradedRing.lean` | `isIso_sheafification_whiskerRight_unit`; `tensorObjAssoc`; `tensorPowAdd` axiom-clean | `W.whiskerRight`@`ModuleCat (ULift ℤ)` + `modToAb` + coequalizer descent (NOT stalks) | instance synth flaky in long `≪≫` — pass `@asIso _ _ _ _ f h`; `whiskerRightIso` iso-arg breaks `(C:=MonoidalPresheaf X)` |

## Routes

The two legs run in parallel (independent files: `Cohomology/*` vs `Picard/SectionGradedRing.lean`).

**FBC route — DIRECT Stacks 02KH(2) equalizer (mate framing ABANDONED).** The i=0 iso assembles from
the finite-affine-cover H⁰-equalizer + per-chart affine module base change — NO mate keystone
`_legs_conj`. Inputs DONE: `eqLocus` H⁰-equalizer, `pullback_spec_tilde_iso` (01I9),
`baseChangeGammaEquiv`. Capstone `baseChangeGammaPullbackEquiv` (`Γ(X,F)⊗_A B ≃ₗ[B] Γ(X',F')`); residue
= fork assembly + discharge the 2 frozen named legs from it. The retained `base_change_mate_*`
declarations in `FlatBaseChange.lean` are dead off-path apparatus — kept only as **riders** because
proved legs still reference their signatures; do not re-attempt the mate route, trim once the named
legs land via the direct route.

**SNAP route.** Crux `IsIso(sheafification.map(η_P ▷ Q))`, associator, `tensorPowAdd` all CLOSED
axiom-clean. Remaining: cast-coherence (`sectionMul_coherent`) → graded assembly
(`gcommSemiring`/`gmodule`). Produces the H⁰ graded ring `Γ_*(X,L)`. Full `MonoidalCategory
(SheafOfModules)` NOT needed; stalkwise / "presheaf+Γ-at-end" routes are DEAD.

## Mathlib gaps & new material

Gaps to fill:
- FBC-B: fork assembly for `baseChangeGammaPullbackEquiv` (`tensorEqLocusEquiv` is in Mathlib, verified).

New project material:
- `FlatBaseChangeGlobal.lean` element-level equalizer presentation (`baseChangeGammaEquiv`; capstone
  `baseChangeGammaPullbackEquiv` via `restrictScalars` along `B → groundRing X'`).
- `SectionGradedRing.lean` graded comm-semiring + module assembly for `Γ_*(X,L)`.
