# Strategy Critic Report

## Slug
iter146

## Iteration
146

## Routes audited

### Route: M1 — Bridge: presheaf ↔ algebra-Kähler form (EXCISED iter-126)

- **Goal-alignment**: PASS — excise is well-justified (zero in-tree consumers; the standalone M1.d utility stays as in-tree project material per the iter-144 user-hint reframing).
- **Mathematical soundness**: PASS — nothing to prove; the route is dropped from active scope.
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none.
- **Effort honesty**: reasonable — M1 has zero remaining LOC commitment; M1.d is preserved as optional utility.
- **Verdict**: SOUND.

### Route: M2 — Genus-0 witness via cotangent-vanishing rigidity (over-k + chart-algebra pivot)

- **Goal-alignment**: PASS — the route correctly identifies `genusZeroWitness` as the genus-0 arm of the genus-stratified body restructure, with the C(k)=∅ branch handled by vacuity of the `isAlbaneseFor : ∀ P, IsAlbanese …` quantifier. The frozen signature is respected.
- **Mathematical soundness**: PARTIAL — the chart-Čech Mayer–Vietoris computation invoked to establish `H^0(C, Ω_{C/k}^{⊕n}) = 0` is mathematically correct (forgetful functor `OC-mod → k-Vec` preserves global sections, and chart-local vanishing + MV gives global vanishing), and the iter-145 Q3 honest disclaimer in § Soundness rules (L441–446) is internally consistent. However, the claim that the cotangent-Mayer–Vietoris derives "from existing project infrastructure" by routing the existing `Cohomology_MayerVietoris.tex` machinery "through the cotangent sheaf" is hand-wavy: the project's MV infrastructure is built for `Scheme.toModuleKSheaf` (sheaves of k-modules); the cotangent variant requires constructing `Ω_{C/k}^{⊕n}` as a sheaf of k-modules via forgetful and verifying MV remains acyclic on the chart cover. The strategy bundles this verification into "piece (ii) chart-algebra (β-core)" at 150–300 LOC, which feels light if any of that infrastructure-routing-via-forgetful-functor is non-trivial. Not a fatal soundness issue; an honest scoping risk.
- **Sunk-cost reasoning detected**: no (the iter-145 excise discharged the iter-141 preservation-of-bundled pattern; over-k commitment is honestly framed as "operationally defaulted" with retained revert wiring).
- **Phantom prerequisites**: none — `Algebra.IsPushout`, `RingHom.iterateFrobenius_comm`, `Ideal.IsLocalRing.CotangentSpace`, `Algebra.IsStandardSmoothOfRelativeDimension` all VERIFIED in mathlib `b80f227`.
- **Effort honesty**: reasonable for the chart-algebra envelope (600–1050 LOC over 5 sub-pieces), with the explicit mid-iter inflation tripwire at >1050 LOC. The (β-core) 150–300 LOC entry is the most LOC-fragile sub-piece and warrants the watchpoint.
- **Verdict**: CHALLENGE (see Q3-related concern below and the "old framing" stale-text issue).

### Route: Chart-algebra piece (ii) PIN-path-(b) (iter-146 fires first prover lane on 3 of 5 sub-pieces)

- **Goal-alignment**: PASS — piece (ii) is the load-bearing M2.a body consumer; chart-algebra route closes the `df = 0` derivation chain.
- **Mathematical soundness**: PASS — the (α)+(β)+algebra-core+integrally-closed+scheme-lift decomposition is honestly drawn from Stacks-tag-shaped chart-algebra arguments; the iter-145 Q3 framing distinction (cohomological content invoked via chart-Čech MV; named Serre duality NOT invoked) is mathematically defensible. The 5 named declarations scaffolded with `: True := sorry` placeholders correctly defer signature commitment to the iter-146+ prover lane (the iter-128 wrong-signature cautionary tale is respected).
- **Sunk-cost reasoning detected**: no.
- **Phantom prerequisites**: none — all named Mathlib references VERIFIED.
- **Effort honesty**: reasonable (the 600–1050 LOC envelope is concretely sub-bucketed). The (β-core) 150–300 LOC budget bundles MV-on-`Ω_C` routing through forgetful-to-k-Vec; this is the most LOC-fragile slot but the mid-iter inflation tripwire is wired.
- **Verdict**: SOUND.

### Route: M3 — Positive-genus witness via Route A (Picard scheme via FGA, COMMITTED iter-144)

- **Goal-alignment**: PASS — Route A produces the Albanese variety as Pic⁰ of the curve; the protected signature is respected.
- **Mathematical soundness**: PASS — Hilbert + Quot + identity-component is the canonical FGA route; the iter-145 AUDIT_STABLE refresh (`mathlib-analogist-m3-route-a-refresh-iter145`) returned within ±20% of the iter-123 estimate.
- **Sunk-cost reasoning detected**: no — Route B is preserved as historical alternative only, with explicit DROPPED iter-144 labelling.
- **Phantom prerequisites**: none flagged; the iter-145 audit refresh confirmed `IsQuasicoherent` + `IsLocallyNoetherian` typeclasses + `IsFinitePresentation (M : SheafOfModules R)` exist in `b80f227`, partially crediting against A1.
- **Effort honesty**: reasonable — 6070 LOC midpoint over multi-year wall-clock, decomposed into A1 (3775 LOC) + A2 (1320 LOC) + A3 (975 LOC).
- **Verdict**: SOUND.

## Format compliance

- **Size**: **701 lines / 132,572 bytes** — **over budget**, ~3× the line cap (250) and ~11× the byte cap (~12 KB).
- **Headings**: **FAIL** — none of the canonical headings (`## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`) are present in canonical form. Actual top-level headings:
  - `## Project goal` (renamed; canonical is `## Goal`)
  - `## End-state (iter-121 pivot)` (extra; not in canonical set)
  - `## Decomposition: genus-stratified body of ‹nonempty_jacobianWitness›` (extra)
  - `## Current sorry inventory (iter-127)` (extra)
  - `## Roadmap` (extra; canonical would put route content under `## Routes`)
  - `## What ships unconditionally (current snapshot)` (extra)
  - `## What ships against the genus case-split (current snapshot)` (extra)
  - `## Soundness rules` (extra; explicitly named as a violation in the spec)
  - `## Mathlib gap inventory (live, iter-145)` (renamed; canonical is `## Mathlib gaps & new material`)
  - `## Sequencing (current snapshot, iter-127)` (extra)
  - Missing entirely: `## Phases & estimations` table, `## Routes`, `## Open strategic questions`.
- **Per-iter narrative detected**: yes — pervasively. Representative phrases verbatim:
  - "**Iter-127 strategic update (over-k path COMMITTED)**" (L168)
  - "**Iter-129 must-fix on iter-128 close**" (L489)
  - "**`Classical.choose`-chain body shape under Replacement (B) — RESOLVED iter-131**" (L590)
  - "**Iter-138 reframing to ‹operationally defaulted, bounded revert cost preserved›**" (L584)
  - The Sequencing table contains a per-iter-row breakdown from iter-125 → iter-157+ (L531–551).
- **Accumulation detected**: yes — multiple completed / excised routes still occupy substantial space:
  - § Roadmap M1 (EXCISED iter-126) occupies L97–159 (~60 lines of decision narrative).
  - M2.c, M2.c.aux rows still in the M2 decomposition table marked "**DROPPED iter-127**" (L218–219).
  - M2.d (RR path; NOT ACTIVE) still occupies a table row (L220).
  - Route B (DROPPED iter-144) preserved as historical alternative at L320–342 (~22 lines).
  - The full iter-127 → iter-145 decision-block accumulation (Direct over-k rigidity defense, ground (i) STRUCK, ground (iii) DEMOTED, iter-138 reframing, iter-139 §519 auto-flag, iter-141 decoupling correction) spans L561–588 (~28 lines of decision history).
  - Fibre-free 4-axis scorecard (L596–605, evaluated iter-133 and now obsolete under chart-algebra DESCOPE of pieces (i.b)+(i.c)).
- **Table discipline**: FAIL — there is NO `## Phases & estimations` table with the canonical columns Phase | Status | Iters left | LOC | Key Mathlib needs | Risks. Multiple ad-hoc tables exist (sorry inventory at L86–94, M2 decomposition at L214–221, Sequencing at L531–551), each with bespoke columns.
- **Appendix sections**: yes — the "Direct over-k rigidity — COMMITTED iter-127" block (L561+), "Iter-138 reframing", "Iter-141 decoupling correction" all function as Historical-Decisions / Considered-Alternatives appendices despite being inline.
- **Format verdict**: **NON-COMPLIANT.**

## Alternative routes (suggested)

### Alternative: Forgetful-to-k-modules verification for cotangent Mayer–Vietoris

- **What it looks like**: Before piece (ii) (β-core) prover dispatch, write a small Mathlib-shaped helper that exhibits `Ω_{C/k}^{⊕n}` as a sheaf of k-modules via the forgetful `OC-mod → k-Vec` and verifies that the project's existing `Cohomology_MayerVietoris.tex` Mayer–Vietoris infrastructure transports across that forgetful step. This is the "cohomological content" half of the Q3 disclaimer at L441–446 of STRATEGY.md. Estimated 30–80 LOC standalone.
- **Why it might be cheaper or sounder**: The strategy currently bundles this forgetful-then-MV routing inside the chart-algebra (β-core) 150–300 LOC envelope. If the forgetful step needs any non-trivial infrastructure (cohomology of the forgetful functor of sheaves, MV-on-restricted-sheaf-categories, etc.), the (β-core) envelope could blow out and the iter-145 Q3 honesty-disclaimer's "derives from existing project infrastructure" claim would prove optimistic. Pre-verifying it as a standalone helper de-risks piece (ii) and provides a tight LOC re-estimate.
- **What the current strategy may have rejected**: Probably packaging — bundling it into (β-core) gives a single named target instead of two; the strategy nowhere argues this is a "free composition" from existing infra.
- **Severity of the omission**: minor (the bundling is plausible if the forgetful step is genuinely free; the strategy's mid-iter inflation tripwire at >1050 LOC catches the failure mode, just later than necessary).

### Alternative: Symmetric blueprint-pointer-chapter discipline

- **What it looks like**: Either (a) excise `AlgebraicJacobian_Cotangent_GrpObj.tex` (the pointer chapter is mostly stale after iter-145's bundled-route excise of 5 declarations from `Cotangent/GrpObj.lean`; piece (i.a) content is documented in main chapters) and similarly do not introduce one for `Cotangent/ChartAlgebra.lean`; OR (b) introduce a parallel `AlgebraicJacobian_Cotangent_ChartAlgebra.tex` pointer chapter that lists the 5 chart-algebra scaffolds with `\input` from `content.tex`, restoring blueprint-structure symmetry. The current state — one pointer chapter for GrpObj (with 5 stale `\item`s per the directive) and zero for ChartAlgebra (whose content lives in a RigidityKbar.tex subsection) — is structurally asymmetric.
- **Why it might be cheaper or sounder**: Either fix is small (~20–40 LOC of blueprint edits). Option (a) is cleaner because it reduces blueprint LOC; option (b) restores discipline at the cost of LOC. Choice (a) is also consistent with the iter-145 Q7 excise philosophy ("git history IS the audit record").
- **What the current strategy may have rejected**: The iter-145 chart-algebra-skeleton dispatch took the path of least resistance (no new pointer chapter), perhaps because the chart-algebra content is a single subsection in RigidityKbar.tex rather than a standalone chapter. But the symmetric corrective wasn't taken either (deleting the now-mostly-stale GrpObj pointer chapter).
- **Severity of the omission**: minor (pedagogical / structural; not load-bearing on any prover lane).

### Alternative: Stage Q5 size compaction unbundled (multiple smaller restructure edits rather than one bundled iter)

- **What it looks like**: Rather than a single iter-146 OR iter-147 bundled compaction, split the work into ≥2 smaller restructure edits across consecutive iters:
  1. Iter-146 (this iter): excise the per-iter-narrative blocks (Direct over-k rigidity decision chain L561–588; Classical.choose-chain RESOLVED iter-131 block L590; Replacement (B′) iter-131 block L592; Fibre-free 4-axis scorecard L594–605; ℙ¹-hedge iter-138 RESOLVED block L607–609; standalone cotangent sheaf iter-129 block L611–629; iter-130 strategy-critic Q2 deferred-bridge L623–627; iter-133 resolution L629). Estimated ~250 LOC of pure-history excise. Target post-edit: ~450 lines.
  2. Iter-147: introduce the canonical skeleton (`## Goal`, `## Phases & estimations` table, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`) and reshape remaining content into those sections. Estimated ~150 LOC of structural compaction. Target post-edit: ~250–300 lines.
- **Why it might be cheaper or sounder**: A single bundled compaction has high cognitive load (the plan agent must simultaneously decide what to delete, what to relocate to `STRATEGY-history.md`, AND restructure into canonical headings). Unbundling separates "delete per-iter narrative" (a mechanical excise) from "restructure to canonical skeleton" (a content-judgment task). Lower per-iter risk of accidentally deleting load-bearing content. Also: iter-146 has fresh capacity (the chart-algebra prover lane is the iter's main thrust) for the mechanical excise; iter-147 inherits a smaller file to restructure.
- **What the current strategy may have rejected**: The directive notes the planner's intent is "one bundled compaction relocating iter-127→iter-136 decision blocks + Route B historical detail to a `STRATEGY-history.md` archive". The bundling rationale is presumably to avoid leaving STRATEGY.md in an intermediate state for one iter. Counterpoint: the file is currently in a 3×-over-budget state; an intermediate sub-3×-but-still-over-budget state for one iter is no worse.
- **Severity of the omission**: minor (the unbundled approach is a recommendation, not a fix-or-die requirement). Either bundled or unbundled is acceptable IF it lands within iter-147.

## Sunk-cost flags

(None detected at the strategic-route level — the iter-145 excise discharged the iter-141 preservation-of-bundled pattern, and the iter-138 "operationally defaulted" reframing is honestly named as switching-cost-driven rather than positive defense. However, the **format accumulation** itself is sunk-cost-shaped: holding onto the iter-127 through iter-141 decision chains "for traceability" within STRATEGY.md is exactly the pattern the canonical-skeleton rule was designed to prevent. Treat this as a format-level sunk-cost — it lands under Must-fix-this-iter via the NON-COMPLIANT format verdict.)

## Prerequisite verification

- `Algebra.IsPushout` (`Mathlib.RingTheory.IsTensorProduct`): **VERIFIED** — class + supporting lemmas (`comm`, `symm`, `equiv`, `comp_iff`) all present.
- `RingHom.iterateFrobenius_comm` (`Mathlib.Algebra.CharP.Frobenius`): **VERIFIED** — exact name match.
- `Ideal.IsLocalRing.CotangentSpace` (`Mathlib.RingTheory.Ideal.Cotangent`): **VERIFIED** — exists as an `abbrev`; the strategy's `IsLocalRing.CotangentSpace` is a namespace-shortened reference to this.
- `Algebra.IsStandardSmoothOfRelativeDimension` (`Mathlib.RingTheory.Smooth.StandardSmooth`): **VERIFIED** — class + `iff_of_isStandardSmooth` in `StandardSmoothCotangent.lean`.
- `Algebra.IsStandardSmooth.free_kaehlerDifferential` (named in strategy at L510): **RENAMED-OR-DERIVED** — exact name not found, but the result type is reachable via `Algebra.IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth` in `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean`. The strategy's named reference is therefore not strictly a phantom but should be re-cited under its actual Mathlib name when the iter-146+ piece (ii) prover lane consults it. Minor lint, not a phantom-prerequisite blocker.
- `PresheafOfModules` (`Mathlib.Algebra.Category.ModuleCat.Presheaf`): **VERIFIED** — structure exists; specific operations (`pullback`, `isoMk`) referenced in strategy were not surfaced by direct prefix search but the parent structure is present, and the iter-137 `kaehler-tensorequiv-presheafpullback-iter137` analogist verified them in context.
- `Mathlib.Algebra.CharP.Frobenius`: **VERIFIED** by file presence (via `RingHom.iterateFrobenius_comm` match).
- `Mathlib.AlgebraicGeometry.Hilbert.Representability`: **MISSING** (the strategy correctly labels this as "doesn't exist" at L304; not a phantom — it's an honestly-named M3 Route A target gap).
- `AlgebraicGeometry.Scheme.absoluteFrobenius`: **MISSING** in `b80f227` (the strategy correctly labels this as PHANTOM; under chart-algebra this is now DESCOPED, so no blocking dependency remains).

No phantom-prerequisite blockers detected.

## Must-fix-this-iter

- **Format: NON-COMPLIANT** — STRATEGY.md must be restructured in-place this iter, with the three most impactful deviations being:
  1. **Size**: 701 lines / 132,572 bytes (~3×/~11× over budget). Per-iter narrative blocks at L561–629 (~70 lines of iter-128/129/130/131/133/138 decision history) are the largest pure-excise targets; the iter-145 chart-algebra disposition block at L631–664 retains relevance but should compress.
  2. **Headings**: none of the canonical headings are present in canonical form. Restructure into `## Goal`, `## Phases & estimations`, `## Routes`, `## Open strategic questions`, `## Mathlib gaps & new material`.
  3. **Table discipline**: no `## Phases & estimations` table with the canonical columns. Introduce one; absorb the per-route LOC/iter estimates currently scattered across the M2 decomposition table + the Sequencing table.
  Per-iter narrative and per-iter decision-chain content move to `iter/iter-NNN/plan.md` sidecars or `STRATEGY-history.md` archive as the directive's intended compaction-direction names.
- **Route M2: CHALLENGE** — the M2 decomposition section (L161–228, esp. the M2 table at L214–221 and the M2.body-pile row at L221) still describes the iter-127 over-k pile (pieces (i)+(ii)+(iii); 1850–3600 LOC across 9–20 iter) as the active critical path. The iter-144 chart-algebra pivot at L631–653 DESCOPES pieces (i.b)+(i.c)+(iii) and INFLATES piece (ii) to 600–1050 LOC, but the M2 section text was not updated. A fresh mathematician reading top-to-bottom encounters the (now stale) iter-127 framing first and the iter-144 pivot only after L631. **Planner must reconcile**: either (a) rewrite the M2 decomposition table + body-pile row to reflect chart-algebra as the active route (with the bundled route excised entirely, consistent with the iter-145 in-tree-disposition excise of 5 bundled declarations), OR (b) record an explicit rebuttal naming why the legacy text is retained for one more iter. Strong preference for (a) — leaving the old framing in place perpetuates the iter-141 preservation-of-bundled pattern at the textual-disposition level.

## Overall verdict

A fresh mathematician would approve the *strategic content* of the iter-145 chart-algebra pivot — the over-k commitment is honestly framed, the iter-145 Q3 framing distinction (cohomological content invoked via chart-Čech MV; named Serre duality NOT) is internally consistent post-absorption, the iter-145 Q7 excise discharged the artefact-disposition-level sunk-cost pattern, the M3 Route A audit refresh stabilised the route on current data, and the iter-150 symmetric audit + rolling mid-iter triggers are well-designed. But the *document* is in a 3× over-budget state with the canonical skeleton thoroughly drifted and per-iter narrative pervasive; iter-145's chart-algebra disposition is bolted onto an iter-127 framing that hasn't been re-baselined. The format issue is not cosmetic — the M2 decomposition table at L161–228 still describes the bundled pile as the active critical path, contradicting the iter-144/145 pivot 470 lines later. The iter-146 compaction is overdue. Recommend the planner unbundle into iter-146 (mechanical excise of per-iter narrative blocks) + iter-147 (canonical-skeleton restructure with the live M2 table reconciled to chart-algebra), unless the planner has high confidence in landing both in a single bundled iter.
