# Blueprint Writer Report

## Slug
weildivisor-doc-updates

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_WeilDivisor.tex

## Changes Made

- **Refactored "Lean signature scope" paragraph** on `def:divisor_closed_point` (L412–L446
  of the post-edit chapter). Replaced the old plan-style paragraph (which described a
  "typeclass-threaded promotion in the proof body" that the iter-174 Lean did not
  take) with the actual iter-174 junk-branch convention:
  - Signature `(P : C) (_hP : IsClosed ({P} : Set C))`.
  - Definition `if h : Order.coheight P = 1 then Finsupp.single ⟨P, h⟩ 1 else 0`
    (typeset as a `\begin{cases}` block).
  - Off-branch returns `0 ∈ Div(C)` (called out for the generic-point /
    higher-codim cases).
  - Consumer-side recovery routes through the two bridge equation lemmas
    (\Cref-referenced to the new lemma blocks below).
  - Intended-regime recovery via `ofClosedPoint_eq_single` plus the
    `IsClosed {P} ⟹ Order.coheight P = 1` chain on a 1-dim integral scheme,
    threaded inside the consumer rather than the signature.

- **Added lemma** `\lemma`/`\label{lem:ofClosedPoint_eq_single}`/`\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single}`
  (L449–L471). States `ofClosedPoint P _hP = Finsupp.single ⟨P, h⟩ 1` when
  `h : Order.coheight P = 1`. Proof sketch: unfold the dependent-`if` on the
  positive branch. `\uses{def:divisor_closed_point, def:prime_divisor}`.
  Mirrors the iter-174 Lean lemma `WeilDivisor.lean:186-189`.

- **Added lemma** `\lemma`/`\label{lem:ofClosedPoint_eq_zero}`/`\lean{AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero}`
  (L473–L496). States `ofClosedPoint P _hP = 0` when `Order.coheight P ≠ 1`.
  Proof sketch: unfold the dependent-`if` on the negative branch.
  `\uses{def:divisor_closed_point}`. Mirrors the iter-174 Lean lemma
  `WeilDivisor.lean:195-198`.

- **Added "Lean signature scope" paragraph** to `def:order_at_point` (L297–L377 of
  the post-edit chapter), per analogist `dvr-rationalmap-order` (iter-175
  api-alignment). Documents:
  - The iter-175 target signature
    `[IsIntegral X] [IsLocallyNoetherian X] (Y : X.PrimeDivisor)
    [Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)] (f : X.functionField) : ℤ`
    — no `f ≠ 0` hypothesis (junk-on-`f = 0`).
  - The Mathlib API path the body uses:
    - `Ring.ordFrac : K →*₀ ℤᵐ⁰` from
      `Mathlib.RingTheory.OrderOfVanishing.Basic` (Stacks `02MD`), with its
      typeclass premises (`CommRing` / `Nontrivial` / `IsNoetherianRing` /
      `Ring.KrullDimLE 1`) and the four named Mathlib instances that
      discharge them from `[IsIntegral X]` + `[IsLocallyNoetherian X]` on the
      stalk (`instIsDomainCarrierStalkCommRingCatPresheafOfIsIntegral`,
      `instIsFractionRingCarrierStalkCommRingCatPresheafFunctionField`,
      `instIsNoetherianRingCarrierStalkCommRingCatPresheafOfIsLocallyNoetherian`,
      plus the explicit-threaded `Ring.KrullDimLE 1` instance).
    - `WithZero.log : ℤᵐ⁰ → ℤ` from `Mathlib.Algebra.GroupWithZero.WithZero`
      as the `ℤᵐ⁰ → ℤ` projection with junk-on-zero (`log_zero`, `log_mul`).
      Notes the downstream `log_mul`/`log_one` identities are what
      `thm:principal_hom` will consume.
  - The junk-on-`f = 0` convention: `Ring.ordFrac 0 = 0 ∈ ℤᵐ⁰`,
    `WithZero.log 0 = 0`, hence `order Y 0 = 0`. No `f ≠ 0` hypothesis on
    the signature.
  - The in-tree gap-fill (Mathlib upstream opportunity): no direct bridge
    from `Order.coheight Y.point = 1` to
    `Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)`; Stacks `02IZ` /
    `005X` is the missing topological-to-prime-spectrum step. The
    Mathlib pieces `IsLocalization.AtPrime.ringKrullDim_eq_height` and
    `IsAffineOpen.isLocalization_stalk` are present; the topological
    coheight-height bridge is iter-175 in-tree workaround (explicit
    instance arg) with a future two-line Mathlib PR as the cleanup
    path.

## Cross-references introduced
- `\Cref{lem:ofClosedPoint_eq_single}` and `\Cref{lem:ofClosedPoint_eq_zero}`
  inside the rewritten "Lean signature scope" paragraph on
  `def:divisor_closed_point` — both labels point to the new lemma blocks
  added immediately after the definition.
- `\uses{def:divisor_closed_point, def:prime_divisor}` on
  `lem:ofClosedPoint_eq_single` — both targets exist in this same chapter.
- `\uses{def:divisor_closed_point}` on `lem:ofClosedPoint_eq_zero` — target
  in this chapter.
- `\uses{def:divisor_closed_point}` on the two new lemma proof blocks.
- `\Cref{thm:principal_hom}` inside the new `def:order_at_point` Lean
  signature scope paragraph — target in this chapter (already pinned).

## References consulted
- `analogies/dvr-rationalmap-order.md` — iter-175 api-alignment report from
  the `mathlib-analogist dvr-rationalmap-order` consult; supplied the
  `Ring.ordFrac` + `WithZero.log` recipe, the four named stalk-typeclass
  instances, the Stacks `02IZ` / `02MD` pointers, and the in-tree
  gap-fill recommendation that the writer translated into the
  `def:order_at_point` Lean-scope paragraph.
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (lines 140–198, esp.
  `ofClosedPoint` L178–L181, `ofClosedPoint_eq_single` L186–L189,
  `ofClosedPoint_eq_zero` L195–L198, `order` L140–L142) — read to confirm
  the iter-174 junk-branch shape and the bridge-lemma names that the
  blueprint must now pin.

No external textbook citations added (both edits document project-bespoke
Lean encoding choices, not external theorem statements); no
`% SOURCE:` / `% SOURCE QUOTE:` lines added on the new blocks per the
project-bespoke convention. The existing
Hartshorne citation on `def:divisor_closed_point` and `def:order_at_point`
remains unchanged.

## Macros needed (if any)
None. The added LaTeX uses standard `\Div`, `\Cref`, `\begin{cases}`,
`\texttt`, `\bigl/\bigr`, `\langle/\rangle`, all already in the project's
preamble (the chapter already uses `\Div`, `\Cl`, `\ord`, `\codim` upstream
and renders cleanly).

## Reference-retriever dispatches (if any)
None. The directive named `analogies/dvr-rationalmap-order.md` as the
only mid-session dependency and that file landed on disk before this
writer started.

## Notes for Plan Agent

- The new lemma blocks `lem:ofClosedPoint_eq_single` and
  `lem:ofClosedPoint_eq_zero` mirror Lean lemmas with already-closed bodies
  (one-line `simp` proofs) at `WeilDivisor.lean:186-189` and
  `WeilDivisor.lean:195-198`. The deterministic `sync_leanok` phase will
  pick these up on its next walk and add `\leanok` to both. The writer
  refrained from adding `\leanok` per the descriptor.
- The new `def:order_at_point` Lean-signature-scope paragraph documents
  the iter-175 *target* signature, not the iter-172 file-skeleton signature
  currently in `WeilDivisor.lean:140-142` (which lacks the
  `[IsLocallyNoetherian X]` and `[Ring.KrullDimLE 1 _]` instance
  arguments). The prover lane on `RationalMap.order` should refactor the
  signature to match the blueprint pin when implementing the body; the
  prover-side directive should call this out explicitly so the prover does
  not interpret the existing signature as frozen.
- The blueprint pins both new lemma names
  (`AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single` and
  `…ofClosedPoint_eq_zero`) inside the `\lean{...}` slots of the new blocks.
  These names already exist in the Lean file (iter-174), so the
  blueprint-doctor's pinned-decl graph will resolve them on the next pass.
- The "in-tree gap-fill" paragraph in `def:order_at_point` names Stacks
  tags `02IZ` and `005X` for the topological coheight-height bridge that
  Mathlib is missing. This is a clean upstream opportunity (two-line PR)
  but not iter-175 blocking — the explicit `[Ring.KrullDimLE 1 _]` instance
  threading is the workaround. The plan agent may want to log a future
  Mathlib-upstream item from this.

## Strategy-modifying findings
None. The edits document encoding choices already locked in by the
iter-174 Lean (junk-branch on `ofClosedPoint`) and the iter-175 analogist
recommendation (`Ring.ordFrac` + `WithZero.log` for `order`); they do
not surface a strategy-level change.
