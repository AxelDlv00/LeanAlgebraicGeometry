# Brick spec — deg-D2 campaign: the meromorphic bridge (W1–W4)

*Written 2026-07-15 (Fable orchestrator). Consumer: one Fable implementation agent.
The BINDING route is `informal/deg-d2-meromorphic-worksheet.md` (read FIRST, in full —
its T1 descoping, its D1 structural decision, its W1–W5 sub-bricks); this spec adds the
deliverable contract, staging, and protocol. W5 (classDeg + E-i..E-iii) is NOT in this
brick — it launches separately once W1–W4 land.*

## Mission

Under the RiemannRoch convention (`(K) [Field K] {X} [X.Over (Spec (CommRingCat.of K))]
[SmoothOfRelativeDimension 1 (X ↘ …)] [IsIntegral X] [QuasiCompact (X ↘ …)]` — check
each landed input's exact budget; `LocallyOfFiniteType` is a derived global instance,
never a hypothesis):

1. **W1 — meromorphic presentation.** A packaging (opaque structure or equivalent) of:
   a pointed cover, elements `f : ι → X.functionFieldˣ`, and the ratio property (on each
   overlap, `f i / f j` is the function-field image of the cocycle value `g i j`), plus
   `exists_meromorphicPresentation : ∀ L : X.CechPic, <presentation of L>`. Base-index
   trick per the worksheet; the germ-at-η embedding lemmas ("unit section ↦ unit of
   K(X)", section injectivity on an integral scheme) are part of the deliverable if not
   already landed — search `DivisorSheafZero.lean`/`OpenImmersionUnits.lean` first.
2. **W2 — the divisor of a presentation.** `presentationDivisor : … → X.CurveDivisor`
   via `ordZ` of the piece equation at each closed point: piece-independence (unit
   ratios have `ordZ = 0` at interior points), finite support (`ordZ_support_finite` +
   finite subcover from `[QuasiCompact]`). Use `CurveDivisor.single`/`toFinsupp`
   calculus (never raw `Finsupp.single` in +/−/• positions).
3. **W3 — the class law (THE HEART).** `divisorClass K (presentationDivisor P) = L`.
   Worksheet route: common refinement; the local **ord-matching ⇒ unit-ratio** lemma
   (two elements of `K(X)ˣ` with equal `ordZ` at every closed point of an open differ
   by a unit section — via `divisorSections` at `D = 0` / the landed pole-bound stalk
   lemma) as its OWN named deliverable; then `picClass_rescale`/`restrict`/
   `pullback`-calculus assembly. If the cocycle assembly stalls, the ord-matching lemma
   + a precise frontier is an acceptable staged landing.
4. **W4 — extraction.** `divisorClass K D = divisorClass K D' → ∃ f : X.functionFieldˣ,
   D - D' = Scheme.divOf (X ↘ Spec (CommRingCat.of K)) f`. Worksheet route: coboundary
   units glued INSIDE `K(X)ˣ` (D1 — literal equality of field elements), `divOf`
   bookkeeping.

All kernel-green, axiom-clean (`[propext, Classical.choice, Quot.sound]`), no sorry.

**Staged fallbacks, in order:** (1) full W1–W4; (2) W1–W3; (3) W1–W2 + the ord-matching
lemma of W3 + precise frontier; (4) largest green prefix. Never a red tree.

## Read first

1. `informal/deg-d2-meromorphic-worksheet.md` — BINDING (T1, D1, W1–W5, discipline).
2. `informal/degree-pic0-recon.md` §2.1–§2.3 (landed CechPic / LocalEquations /
   divisor-substrate API, verbatim).
3. `Picard/DivisorClass.lean`, `Picard/PointDivisor.lean`,
   `Picard/LocalEquationsPullback.lean` (the landed class calculus: `picClass`,
   `mul`/`rescale`/`restrict`, `divisorClass`, `pullback` — your W3 consumes these).
4. `RiemannRoch/DivisorSheafZero.lean` (germ-at-η machinery),
   `RiemannRoch/PrincipalDivisor.lean` (`ordZ`, `divOf`, `ordZ_support_finite`),
   `RiemannRoch/DivisorSheaf.lean` (pole-bound stalk lemmas).
5. The (C1)/χ in-tree exemplars for refinement work: `Picard/PicAffineCover.lean`
   (basic refinements), and the kernel-discipline sections of the two handoffs.

## Discipline (binding)

The worksheet's D1 is a PROOF-SHAPE INVARIANT: if any step is doing sheaf-level gluing
where a `K(X)ˣ` equality would do, stop and restate. All standing kernel/elaboration
rules (opaque defs for covers/presentations, named lemmas, no `rw`/`simp only ... at`
over concrete-tower hypotheses, restructure on kernel timeouts, doc-comments after
`set_option ... in`, `set_option autoImplicit false`). Files ≤ 500 lines (suggested:
`Picard/MeromorphicPresentation.lean` (W1–W2), `Picard/DivisorClassSurjective.lean`
(W3), `Picard/DivisorClassExtraction.lean` (W4) — reorganize freely). Search before
proving (lean_local_search/loogle/leansearch). ONE build at a time; do NOT run git or
commit; do NOT touch `Challenge.lean` or `blueprint/**`; wire imports into
`AlgebraicJacobian.lean` (re-read on staleness).

## Verification (FOREGROUND, non-negotiable)

Target + root `lake build` blocked to completion (paste tail); `lean_verify` (MCP — not
`lake env lean`) on `exists_meromorphicPresentation`, the W3 class law, the
ord-matching lemma, the W4 extraction, and every keystone — axioms exactly
`[propext, Classical.choice, Quot.sound]`; `grep -n -w sorry` on touched files (exits 1
on zero matches, no `&&`-chaining).

## Report format

Stage reached (full/staged, which) · files+lines · every public declaration with a
one-line statement · deviations from the worksheet route with reasons · build tail
verbatim · lean_verify outputs verbatim · frontier if staged · what W5's spec-writer
(classDeg, E-i..E-iii) must know: exact names/shapes of the surjectivity witness,
extraction lemma, and any presentation-level API worth consuming.
