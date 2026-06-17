# Strategy Critic Directive

## Slug
iter128

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician. The protected `nonempty_jacobianWitness`
in `Jacobian.lean:194` quantifies over an arbitrary curve `C : Over (Spec (.of k))` with
`[SmoothOfRelativeDimension 1 C.hom]`, `[IsProper C.hom]`, `[GeometricallyIrreducible C.hom]`
— no genus parameter, no $k$-rational-point hypothesis. The autonomous loop's end-state
target is **zero inline `sorry` in the project**, no named axioms.

## Strategy under review

(see STRATEGY.md at .archon/STRATEGY.md — paste contents below verbatim)

---

# Strategy

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only
on them. Importantly, `nonempty_jacobianWitness` quantifies over an
arbitrary curve `C : Over (Spec (.of k))` with `[SmoothOfRelativeDimension 1 C.hom]`
— no genus parameter, no $k$-rational-point hypothesis. Any sub-strategy
that depends on `C(k) ≠ ∅` (notably `C ≅ ℙ¹_k`) is mathematically false
on the protected signature (Brauer–Severi conics over `ℚ` are
counterexamples) and must be handled by base change.

## End-state (iter-121 pivot)

The end-state is **zero inline `sorry` in the project**. There are no
deferred tasks; every gap is on the active roadmap. The roadmap is
multi-month, decomposed into milestones M1, M2, M3 with sub-step
detail and per-step effort estimates.

## Decomposition: genus-stratified body of `nonempty_jacobianWitness`

```
theorem nonempty_jacobianWitness ... := by
  by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
  · exact ⟨genusZeroWitness C h⟩      -- closed by milestone M2
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩  -- closed by M3
```

## Current sorry inventory (iter-127, entering iter-128)

| Site | Status | Roadmap section |
|---|---|---|
| `Jacobian.lean:194` — `nonempty_jacobianWitness` | open; body to be restructured into genus case-split (iter-148+) | § Roadmap M2 (genus-0 arm) + M3 (positive-genus arm) |
| `Jacobian.lean:174` — `genusZeroWitness` | NEW iter-127 scaffold | § Roadmap M2 (M2.b row) |
| `RigidityKbar.lean:87` — `rigidity_over_kbar` | iter-126 scaffold; gated on shared cotangent-vanishing pile pieces (i)+(ii)+(iii), iter-128+ | § Roadmap M2 (M2.a row) + M2.body-pile (M2.d-alt renamed) |

## Roadmap

### M1 — EXCISED iter-126

7 declarations + 428 LOC excised from `Differentials.lean`. The bridge had zero in-tree consumers.
M1.d (`kaehler_quotient_localization_iso`) preserved standalone as Mathlib-PR candidate.

### M2 — Genus-0 witness sub-theorem `genusZeroWitness`

**Estimated cost (iter-127 revised).** 7–14 iter / 1350–2600 LOC for shared pile (pieces (i)+(ii)+(iii); piece (iv) deferred).
M2.c (Galois descent) and M2.c.aux (`geomIrred.exists_kalg_pt` PHANTOM) DROPPED iter-127 under the over-k path commitment.

**Decomposition (iter-127, over-k variant COMMITTED).**

- M2.a: Rigidity for morphisms from a smooth proper geomIrred curve of `genus = 0` to a smooth proper geomIrred group scheme `A`, over an arbitrary base field `k`. Iter-126 scaffold landed; body closure iter-138+ gated on shared pile.
- M2.b: Genus-0 witness for `Spec k`: `genusZeroWitness C h` returning `JacobianWitness C` with underlying scheme `Spec k`. Iter-127 scaffold landed; body closure iter-145+ gated on M2.a body.
- M2.d (RR path; NOT ACTIVE): genus-0 identification `C ≅ ℙ¹_k`. Not needed under over-k commitment; 15–25 iter / 3000–8000+ LOC (Serre duality dominates).
- M2.body-pile (renamed from M2.d-alt iter-127): pieces (i)+(ii)+(iii). Piece (iv) Serre duality DEFERRED.

**Pile pieces, iter-127 over-k baseline:**
- **(i) Group-scheme cotangent triviality** (`AlgebraicGeometry.GrpObj.omega_free` / `omega_rank_eq_dim` PHANTOM). 800–1500 LOC / 5–10 iter. **iter-127 piece-(i) sub-decomposition staged 5 sub-lemmas in `RigidityKbar.tex`**: `lem:GrpObj_lieAlgebra` (i.a), `lem:GrpObj_lieAlgebra_finrank` (i.a rank), `lem:GrpObj_mulRight_globalises` (i.b functorial shear iso), `lem:GrpObj_omega_free` (i.c), `lem:GrpObj_omega_rank_eq_dim` (i.c rank). The natural iter-128 prover target is (i.a).
- **(ii) Scheme-level `df = 0 ⇒ factors-through-Spec k`** (`Scheme.Over.ext_of_diff_zero` PHANTOM). 250–500 LOC / 2–3 iter.
- **(iii) char-`p` Frobenius iteration** using **absolute** Frobenius `F_X` (intrinsic to `X`; no perfectness/alg-closure). 300–600 LOC / 2 iter.
- **(iv) Serre duality** DEFERRED as named gap; not needed under iter-127 over-k commitment.

**Over-k risks** (per iter-127 over-k analogist; revert option preserved):
- Piece (i) must use functorial shear iso, NOT pointwise translation.
- Piece (iii) must use absolute Frobenius `F_X`, NOT relative Frobenius `F_{Y/k}`.
- Revert option: 1 iter strategic backtrack + restoration of M2.c rows.

### M3 — Positive-genus witness sub-theorem `positiveGenusWitness`

100+ iter / 10000+ LOC per route. Route A (Picard via FGA, ~6500 LOC) preferred over Route B (Sym^n + Stein, ~9000 LOC). User hint iter-126 absorbed: "do the work, no axioms; ~6500–9000 LOC may not be that much for an AI". M3 stays off iter-by-iter critical path until M2 closes.

## Soundness rules

- **No new axioms.** Project-wide standing rule + iter-126 user hint reaffirmation.
- **No "deferred" framing.** Mathlib gaps decomposed into M1/M2/M3 with concrete sub-step estimates.
- **No phantom $k$-rational-point hypotheses** in the genus-0 witness; vacuity branch + over-k formulation handle the no-rational-point case.

## Sequencing (iter-127, over-k variant; iter-128 TRIPWIRE)

| Iter range | Lane | Output | Per-row iter cost |
|---|---|---|---|
| 125 | Rigidity refactor (DONE) | `Scheme.Over.ext_of_eqOnOpen` | 1 iter |
| 126 | M2.a scaffold + over-`k̄` analogist (DONE) | `rigidity_over_kbar` + cotangent-vanishing-pile analogist | 1 iter |
| 127 | M2.b scaffold + over-k commitment (DONE) | `genusZeroWitness` + over-k analogist OK_OVER_K + STRATEGY drop M2.c + blueprint expansions | 1 iter |
| **128 (THIS ITER)** | **META-PATTERN TRIPWIRE FIRES**: refactor scaffold for `AlgebraicGeometry.GrpObj.lieAlgebra` (piece (i.a)) in new file + prover dispatch on it | Breaks 3-consecutive plan-phase-only iters; resolves iter-127 progress-critic META-PATTERN CHURNING | 1 iter |
| 129–138 | Piece (i) body | 800–1500 LOC | 5–10 iter |
| 139–141 | Piece (ii) | 250–500 LOC | 2–3 iter |
| 142–143 | Piece (iii) | 300–600 LOC | 2 iter |
| 144–145 | M2.a body closure | 50–150 LOC | 1–2 iter |
| 146–147 | M2.b body closure | 100–200 LOC | 1–2 iter |
| 148+ | M2 closure | genus-stratified `nonempty_jacobianWitness` body | 2–4 iter |

**Honest M2 closure estimate (iter-127, over-k variant): iter-143 to iter-157+.**

## References index

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |

## Blueprint summary

| Chapter | Topic |
|---|---|
| `AbelJacobi.tex` | Abel–Jacobi map; ofCurve, comp_ofCurve, exists_unique_ofCurve_comp via JacobianWitness |
| `Cohomology_MayerVietoris.tex` | MV LES for Čech cohomology of HModule (Genus.lean dep) |
| `Cohomology_SheafCompose.tex` | Composing sheaves; small utility chapter |
| `Cohomology_StructureSheafAb.tex` | Structure sheaf as additive sheaf (HModule support) |
| `Cohomology_StructureSheafModuleK.tex` | k-module structure sheaf; HModule carrier |
| `Differentials.tex` | Relative differentials presheaf; smooth_locally_free_omega; M1 excised, M1.d kaehler_quotient_localization_iso preserved |
| `Genus.tex` | `genus C := Module.finrank k (HModule k (toModuleKSheaf C) 1)` |
| `Jacobian.tex` | Jacobian / Albanese definitions, JacobianWitness structure, genus-stratified body of nonempty_jacobianWitness, def:genusZeroWitness block (iter-127 NEW) |
| `Modules_Monoidal.tex` | (orphan, not in content.tex) |
| `Picard_Functor.tex` | (orphan, not in content.tex; M3 Route A material) |
| `Picard_FunctorAb.tex` | (orphan) |
| `Picard_LineBundle.tex` | (orphan) |
| `Rigidity.tex` | `Scheme.Over.ext_of_eqOnOpen` (iter-125 refactor) |
| `RigidityKbar.tex` | `rigidity_over_kbar` (iter-126 scaffold); iter-127 piece-(i) sub-decomposition with 5 named lemma blocks staging iter-128 prover target `lem:GrpObj_lieAlgebra` |

## Prior critique status

iter-127 strategy-critic returned CHALLENGE: 5 routes challenged, 2 critical alternatives, 2 sound. All addressed via inline STRATEGY.md edits this iter:

1. M2.b vacuity binder verification — adopted (explicit binder verification + Jacobian.tex prose).
2. M2.c over-k urgency — adopted (over-k analogist dispatched same plan phase; M2.c DROPPED iter-127).
3. M2.d Serre-duality cost-accounting reconciliation — adopted (decomposition table reconciled; M2.d-alt → M2.body-pile rename).
4. M2.d-alt rename — adopted.
5. Critical alternative #1 (standalone scheme-level cotangent sheaf as Mathlib-PR target) — REBUTTED in STRATEGY.md (cites iter-126 user hint "do the work; shortest path among legitimate options"). **Asking for re-verification iter-128**: is the rebuttal still sound, or has new evidence emerged?
6. Critical alternative #2 (Serre duality as shared top-level dependency at 3000–8000 LOC) — adopted.
7. M1 (EXCISED iter-126) — SOUND. No re-action needed.
8. M3 — SOUND. No re-action needed.
9. M2.a scaffold — SOUND.

The iter-127 plan agent ALSO committed iter-128 as the META-PATTERN TRIPWIRE: refactor + prover dispatch on `AlgebraicGeometry.GrpObj.lieAlgebra` (piece (i.a)). This is the first prover-lane after 3 consecutive plan-phase-only iters (iter-125 Rigidity refactor + iter-126 M1 excise + M2.a scaffold + iter-127 M2.b scaffold + over-k commitment).

**Specifically ask:** is the iter-128 META-PATTERN TRIPWIRE prover target choice (piece (i.a), `lem:GrpObj_lieAlgebra`) sound? Is it the simplest realistically-prover-fillable target in the staged piece-(i) sub-decomposition? Are there better candidates the iter-127 plan-agent missed?
