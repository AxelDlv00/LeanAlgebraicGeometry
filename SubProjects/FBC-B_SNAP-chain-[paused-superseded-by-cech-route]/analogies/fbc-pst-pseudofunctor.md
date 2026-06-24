# Analogy: `pst` ring-square pseudofunctoriality — mate-composition API for the conjugate dictionary

## Mode
api-alignment

## Slug
fbc-pst-pseudofunctor

## Iteration
009

## Question
(1) Do the blueprint's three named mate-composition lemmas
`iterated_mateEquiv_conjugateEquiv`, `conjugateEquiv_mateEquiv_vcomp`, `mateEquiv_conjugateEquiv_vcomp`
exist in current Mathlib (`Mathlib.CategoryTheory.Adjunction.Mates`); if not, what are the real lemmas
governing `conjugateEquiv`/`mateEquiv` composition across a vertical pasting / nested `Adjunction.comp`?
(2) What is Mathlib's idiom for the FOUNDATION sub-lemma (composition coherence of
`gammaPushforwardNatIso` under composition of ring maps), and is conjugating that coherence through the
mate-equivalence the Mathlib-aligned way to `pst` pseudofunctoriality — or is there a cleaner canonical
API (pseudofunctor / `mateEquiv_comp` / `conjugateEquiv` naturality bundle)?

## Project artifact(s)
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:689-696` — `pullback_spec_tilde_iso` (`pst`), built as
  `((conjugateIsoEquiv adjL adjR).symm (gammaPushforwardNatIso φ)).symm.app M`.
- `…:707-724` — proven brick `pullback_spec_tilde_iso_inv_unit_triangle` (uses `unit_conjugateEquiv_symm`;
  `hbridge : (conjugateEquiv adjL adjR).symm (gammaPushforwardNatIso φ).hom).app M = (pst φ M).inv` is `rfl`).
- `…:667-673` — `gammaPushforwardNatIso` (single-ring-map naturality only; no composition lemma).
- `…:1180-1257` — crux `pullback_spec_tilde_iso_ring_square_natural`, `sorry @ 1257` (hand-peeled route).
- blueprint `Cohomology_FlatBaseChange.tex:1912-1944` — seam4 `…_ring_square_mate_glue` (names the 3 lemmas).

## Decisions identified

### Decision 1: do the 3 blueprint-named mate-composition lemmas exist; is the seam4 recipe sound?

- **VERIFIED PRESENT in this project's pinned Mathlib (lean v4.30.0-rc2)** — all three `have := @…`
  elaborate with zero diagnostics; bp009's "loogle does NOT find them" is **FALSE** (they live under the
  `CategoryTheory.` namespace; a bare-name or stale search misses them):
  - `CategoryTheory.iterated_mateEquiv_conjugateEquiv`
    `((mateEquiv adj₄ adj₃) ((mateEquiv adj₁ adj₂) α)).natTrans = (conjugateEquiv (adj₁.comp adj₄) (adj₃.comp adj₂)) α`
    with `α : TwoSquare F₁ L₁ L₂ F₂`. **This is THE lemma** for `pst`: a conjugate over **composite**
    adjunctions (= `pst`'s `conjugateIsoEquiv adjL adjR`, since `adjL/adjR` are binary `Adjunction.comp`)
    equals the iterated single-step mate. Also `…_conjugateEquiv_symm` (the `.symm`/inverse direction —
    note it lands through `TwoSquare.equivNatTrans … .symm`, relevant since `pst` is the `.symm`).
  - `CategoryTheory.conjugateEquiv_mateEquiv_vcomp`
    `(mateEquiv adj₁ adj₃) (β.whiskerLeft α) = ((mateEquiv adj₂ adj₃) β).whiskerTop ((conjugateEquiv adj₁ adj₂) α)`.
  - `CategoryTheory.mateEquiv_conjugateEquiv_vcomp`
    `(mateEquiv adj₁ adj₃) (α.whiskerRight β) = ((mateEquiv adj₁ adj₂) α).whiskerBottom ((conjugateEquiv adj₂ adj₃) β)`.
- **CRITICAL CAVEAT — the `TwoSquare` refactor.** Current Mathlib's `mateEquiv` is
  `mateEquiv adj₁ adj₂ : TwoSquare G L₁ L₂ H ≃ TwoSquare R₁ H G R₂` — it consumes/produces **`TwoSquare`**,
  not bare `NatTrans`. `TwoSquare T L R B` is a (reducible) type for `T ⋙ R ⟶ L ⋙ B`; the bridge is
  `TwoSquare.equivNatTrans T L R B : TwoSquare T L R B ≃ (T ⋙ R ⟶ L ⋙ B)`. Extract the underlying
  NatTrans of an iterated mate with `.natTrans`. The whiskering ops in the `vcomp` lemmas
  (`.whiskerLeft/.whiskerTop/.whiskerRight/.whiskerBottom`) are **`TwoSquare` pasting ops, NOT
  `Functor.whiskerLeft` on NatTrans**. This is the most likely real cause of the 7-iter stall: the recipe
  was written against the OLD bare-NatTrans signatures, so a prover feeding bare `NatTrans` into the
  lemmas type-mismatches against `TwoSquare`.
- **Supporting API also present**: `conjugateEquiv_comp` (vertical comp of conjugates over the SAME pair,
  `@[reassoc (attr:=simp)]`), `conjugateEquiv_id`, `unit_conjugateEquiv`, `unit_conjugateEquiv_symm`
  (the brick's engine), `conjugateIsoEquiv` + `conjugateIsoEquiv_apply_hom/_apply_inv/_symm_apply_hom/
  _symm_apply_inv` (lift the iso-level cocycle to the hom-level `conjugateEquiv`).
- **Gap**: divergent-with-cost. Blueprint NAMES are correct (do NOT delete them); the recipe PROSE is
  stale (assumes pre-TwoSquare signatures). Inline crux uses a *different* hand-peeled `homEquiv.injective`
  route that never reaches the mate machinery — a parallel dead-end.
- **Verdict**: PROCEED on the names; ALIGN_WITH_MATHLIB on the recipe (must update to the `TwoSquare` API
  and route the crux through `iterated_mateEquiv_conjugateEquiv` instead of hand-peeling).

### Decision 2: foundation `gammaPushforwardNatIso` composition coherence — shape + is conjugate-through-mate the right route?

- **No pseudofunctor / no `mateEquiv_comp` (1-categorical) / no `conjugateEquiv` naturality bundle** exists
  in Mathlib for adjoint transposition. Searched: `Pseudofunctor.mateEquiv` (none); `"mateEquiv_comp"`
  (only `Bicategory.mateEquiv_comp_id_right`, bicategory-only, not applicable); `conjugateEquiv_comp_iso`
  (unknown identifier). The `iterated_mateEquiv_conjugateEquiv` family + the two `vcomp` lemmas +
  `conjugateEquiv_comp` + `conjugateIsoEquiv_apply_hom/inv` **IS** the canonical composition API — a set of
  equational coherence lemmas, not a bundled pseudofunctor. So conjugating the foundation coherence through
  the mate-equivalence is exactly the Mathlib-aligned route; there is nothing cleaner to reuse.
- **Foundation sub-lemma idiom**: state it as a `NatIso`/NatTrans **pasting equation** expressing
  `gammaPushforwardNatIso (φ ≫ ρ)` via `gammaPushforwardNatIso φ` and `gammaPushforwardNatIso ρ` glued
  through `pushforwardComp` (domain) and `restrictScalarsComp` (codomain). Every constituent is the
  identity on underlying carriers (same as `gammaPushforwardNatIso` itself, which is
  `NatIso.ofComponents … (by intro; ext; rfl)`), so the proof is **pointwise `rfl`** (`ext x; rfl` after
  `NatTrans.ext`/component reduction). This is cheap and is the same shape as the existing
  `gammaPushforwardNatIso`. For the ring-SQUARE crux: the square `inclR ≫ ρB = ρ ≫ inclR'` gives two equal
  composites, so apply the composition coherence to each side and glue by the `eqToIso`/`Subsingleton`
  of the ring-square equality — mirrors the blueprint's `chartBaseChangeGeometricComparison_mate` /
  `chartBaseChangeModuleReassoc_extendScalarsComp` legs.
- **Gap**: NEEDS_MATHLIB_GAP_FILL for the foundation lemma itself (project-local, pointwise rfl — Mathlib
  has no reusable pseudofunctor), but the surrounding transport machinery is fully Mathlib-aligned.
- **Verdict**: PROCEED (conjugate-through-mate is the right route) + NEEDS_MATHLIB_GAP_FILL (add the
  pointwise-rfl `gammaPushforwardNatIso` composition coherence as a project-local lemma).

## Recommendation
The blueprint's three named lemmas are **real and load-bearing** — keep them. The corrections needed before
re-dispatching a prover:

1. **Fix the recipe prose for the `TwoSquare` API.** Note in seam4 that (a) `mateEquiv` is valued in
   `TwoSquare`, (b) recover the bare NatTrans via `.natTrans` / `TwoSquare.equivNatTrans`, (c) the
   `vcomp` lemmas' whiskerings are `TwoSquare` ops. Without this a prover will type-mismatch bare NatTrans
   against `TwoSquare`.

2. **Route the crux through `iterated_mateEquiv_conjugateEquiv`, not hand-peeling.** `pst`'s defining
   `conjugateIsoEquiv adjL adjR` over the binary composites `adjL = tilde.adj.comp (ppAdj (Spec inclR))`,
   `adjR = extendRestrict.comp tilde.adj` is precisely a conjugate-over-composite-adjunctions; rewrite it
   to the iterated mate (lift iso→hom via `conjugateIsoEquiv_apply_hom/inv`, then apply
   `iterated_mateEquiv_conjugateEquiv`). The current inline proof at L1229-1257 hand-peels three
   `homEquiv.injective` layers and strands the goal as a unit-prefixed equation with no lemma to finish —
   abandon it.

3. **Add the foundation lemma** as a pointwise-`rfl` `gammaPushforwardNatIso` composition coherence
   (shape: `gammaPushforwardNatIso (φ≫ρ)` = pasting of the two single-map isos through `pushforwardComp` /
   `restrictScalarsComp`; proof `ext; rfl`). Each `pst` leg transposes to it via the proven brick
   `pullback_spec_tilde_iso_inv_unit_triangle`; the geometric leg transposes via `pushforwardComp`
   (`conjugateEquiv_mateEquiv_vcomp`), the algebraic leg via `restrictScalarsComp`
   (`mateEquiv_conjugateEquiv_vcomp`).

First moves for the build lane: in `…_ring_square_mate_glue`, after lifting to the hom level, `rw
[← iterated_mateEquiv_conjugateEquiv]` (or its `_symm`) on each `pst` factor to expose the iterated mate;
discharge the geometric/algebraic legs with the two `vcomp` lemmas; close on the `gammaPushforwardNatIso`
composition coherence by `ext; rfl`. Do not hand-peel `homEquiv`.
