# Mathlib-analogist directive — QUOT graded-quotient Decomposition pathology (iter-016)

## Mode: api-alignment

## Context
This is a follow-up to your iter-014 consult `analogies/quot-graded-module-api.md`
(read it). That consult recommended building G1–G5: unbundled `DirectSum.Decomposition`
on a homogeneous submodule (G1), on a quotient module `M ⧸ p` (G2), a `GradedRing` on a
quotient ring `R ⧸ I` (G3), regrading over `R/(x)` (G4), `Module.Finite` transfer (G5).
The iter-015 prover landed G1 (as two ambient-`M` lemmas) + D5, all axiom-clean, but
hit a HARD blocker on G2–G4.

## The blocker (verified, reproduced minimally)
Any goal whose TYPE involves `DirectSum.IsInternal`, `Submodule.map_iSup`, or `iSup`
over a family valued in `Submodule R ↥p` (subtype module) or `Submodule R (M ⧸ p)`
(quotient module) sends the elaborator into a runaway `isDefEq`/`whnf` reduction
(reducing `DirectSum.coeLinearMap` / `coeAddMonoidHom` over the subtype/quotient).
Confirmed via minimal hypothesis-only repros looping at 200k AND 2,000,000 heartbeats —
effectively non-terminating, NOT merely slow. Specifically:
- `DirectSum.isInternal_submodule_of_iSupIndep_of_iSup_eq_top hi hs` with `hi hs`
  hypotheses about `fun i => (ℳ i).comap p.subtype` → isDefEq timeout.
- Even *stating* `⨆ i, (ℳ i).map p.mkQ = ⊤` (family in `Submodule R (M ⧸ p)`) → whnf
  timeout when the proof touches `Submodule.map_iSup`.
G1 was rescued by restating in the ambient `M` (`iSupIndep (fun i => ℳ i ⊓ p)` and
`⨆ i, (ℳ i ⊓ p) = p`), never forming a Decomposition on `↥p`.

## Project artifacts to read
- `analogies/quot-graded-module-api.md` (your prior consult).
- `AlgebraicJacobian/Picard/QuotScheme.lean`:
  - the `IsRatHilb` power-series toolkit (`IsRatHilb`, `.ofDiffEq`, `.bump`, ...,
    ~lines 425-612), axiom-clean. `ofDiffEq` is the inductive-step engine; it consumes
    `hC' : IsRatHilb hC d`, `hK' : IsRatHilb hK d` and a degreewise difference identity
    and produces `IsRatHilb hM (d+1)`.
  - namespace `AlgebraicGeometry.GradedModule`: the landed G1 ambient lemmas
    `homogeneousSubmodule_inf_iSupIndep`, `homogeneousSubmodule_iSup_inf_eq`, and
    `degreewise_finrank_diff` (D5).
- `blueprint/src/chapters/Picard_QuotScheme.tex`: `lem:gradedHilbertSerre_rational`
  (~line 347, the Stacks 00K1 induction on the number of degree-1 generators) and
  `subsec:gradedModuleApi` (~line 753, the G1–G5 + D5 blocks).

## Questions (please answer all three)
1. **Tame encoding.** Is there a Mathlib-canonical or Mathlib-idiomatic way to build a
   `DirectSum.Decomposition` (or `GradedRing`/`GradedModule`) on a quotient/subtype
   carrier that AVOIDS the `coeLinearMap`/`coeAddMonoidHom` whnf runaway? Candidates the
   prover named but did not pursue: a hand-built `decompose'` fed to
   `DirectSum.Decomposition.ofLinearMap` / `decomposeLinearEquiv` (so `IsInternal`-as-
   `Bijective` whnf is never forced); `irreducible_def` / `set_option` wrappers around
   the quotient grading family; transporting the ambient grading through a thin
   `LinearEquiv ↥p ≃ ⨁` only at the very end. Does Mathlib do any of these for a derived
   carrier? Cite the file/decl.
2. **Hilbert-function-level restatement (the prover's recommended pivot).** The prover
   proposes re-stating `gradedModule_hilbertSeries_rational`'s inductive HYPOTHESIS to
   quantify over the *Hilbert function* `n ↦ dim_κ Mₙ` (a property of the degreewise
   κ-dimensions) rather than over the graded-module OBJECT, so the IH applied to `C` and
   `K` needs only that their Hilbert functions are `IsRatHilb` — fed from D5 + the
   ambient-`M` G1 + `IsRatHilb.ofDiffEq`, never constructing a `Decomposition` on a
   quotient module. Your iter-014 Q3 answer (the "avoidance route does NOT collapse the
   sub-build") assumed the IH still ranges over graded-module objects. Re-evaluate with
   the IH itself restated: is there a SOUND induction whose statement is purely about
   degreewise dimension functions (e.g. quantify over: a Noetherian graded ring generated
   by `r` degree-1 elements, a f.g. graded module, and conclude its `n ↦ dim_κ Mₙ` is
   `IsRatHilb`) that lets the inductive step feed C, K WITHOUT a quotient-module
   Decomposition object? Concretely: to instantiate the IH on `C = M/xM` over `R/(x)`,
   what is the MINIMAL structure on `C` that must actually be built — and can it be the
   ambient-`M` grading data + κ-dimension bookkeeping rather than a `Decomposition (M⧸p)`?
3. **Which route collapses G2–G5?** Between (1) and (2), which removes the most blocked
   work, and what is the residual build list (name the decls / their shapes) under the
   chosen route?

## Output
Your verdict (PROCEED / ALIGN_WITH_MATHLIB / NEEDS_MATHLIB_GAP_FILL) plus a concrete,
ordered residual build list for the QUOT graded-rationality lane under the recommended
route. Update/extend `analogies/quot-graded-module-api.md` (or write a new
`analogies/quot-hilbert-function-route.md`) with the rationale.
