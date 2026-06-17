# Session 121 — Review (iter-121)

## Metadata

- **Iteration**: 121 (review of iter-121)
- **Stage**: prover (Iter-121 strategic pivot per user directive in
  `USER_HINTS.md`: "act as a Mathlib contributor; fill the gap by
  writing it; no deferred tasks"). The previous "ship with one inline
  sorry" end-state was dropped this iter in favour of a multi-iter
  Mathlib-build-out roadmap (M1 bridge / M2 genus-0 witness / M3
  positive-genus witness).
- **Sorry count before**: **1** (`Jacobian.lean:179`
  `nonempty_jacobianWitness` — the foundational existence hypothesis;
  iter-120 close brought the project into its previous declared
  end-state).
- **Sorry count after**: **1** (unchanged — no prover dispatch this
  iter).
- **Targets attempted**: 0 (intentional skip per `blueprint-reviewer-iter121` HARD GATE).
- **Targets resolved**: 0.
- **New axioms introduced**: none. No Lean changes this iter.
- **Compile status**: project compiles as it did at iter-120 close.
  No `.lean` file was touched in iter-121.
- **Protected signatures touched**: none. `archon-protected.yaml`
  unchanged (9 protected declarations at original paths with unchanged
  signatures).
- **Meta**: `meta.json planValidate.status: ok_intentional_skip /
  objectives: 0`; `prover.durationSecs: 0` (no prover phase);
  `plan.durationSecs: 2587` (43 min, 6 plan-phase subagent dispatches:
  3 mandatory critics + 1 mathlib-analogist + 2 blueprint-writers).
- **Review-phase dispatches**: 3 (mandatory `lean-auditor`,
  `lean-vs-blueprint-checker` × 2 on `Differentials.lean` ↔
  `Differentials.tex` and `Jacobian.lean` ↔ `Jacobian.tex` — the two
  chapters that were significantly rewritten this iter).

## Iteration shape

Iter-121 was a **plan-phase-only strategic pivot iter** — no prover
lane ran. Three concurrent reasons drove the no-dispatch outcome:

1. **User-directive pivot**: the user posted a substantive directive
   in `USER_HINTS.md` asking the autonomous loop to drop "deferred
   tasks" and operate as a Mathlib contributor. The plan agent
   rewrote `STRATEGY.md` accordingly (end-state changes from "ship
   with one inline sorry" to "zero inline sorry, multi-iter Mathlib
   build-out"; previously-deferred Mathlib gaps recast as M1/M2/M3
   milestones with sub-step detail).

2. **`blueprint-reviewer-iter121` HARD GATE**: the per-chapter
   checklist returned `complete: partial` on **both** `Differentials.tex`
   (LaTeX syntax error, three broken refs, missing M1.b cofinality
   proof skeleton, wrong `\uses{...}` direction, "out-of-scope"
   prose not aligned with the pivot) and `Jacobian.tex` (C.2
   sub-step terseness). Per the descriptor's dispatcher_notes,
   prover dispatch on a `complete: partial` chapter is forbidden;
   the M1 prover lane was deferred to iter-122 and two
   blueprint-writers were dispatched to fix the chapters.

3. **`mathlib-analogist-bridge-iter121` proactive consult**: the
   plan agent dispatched the analogist on the not-yet-shipped
   bridge API shape (LinearEquiv vs ModuleCat.Iso vs PresheafOfModules
   natural iso; namespace; naming). The analogist returned with one
   `NEEDS_MATHLIB_GAP_FILL` (the M1.b cofinality argument needs
   re-framing — Mathlib has no off-the-shelf "colim of localizations
   = localization at M" lemma; use `IsLocalization.of_le` with
   cocone universality instead of `Functor.Final` colim comparison)
   and five `ALIGN_WITH_MATHLIB` verdicts (LinearEquiv shape with
   `@[simps]`; bare-theorem `IsLocalization` packaging; `_iso_` →
   `_equiv_` rename to match `tensorKaehlerEquivOfFormallyEtale`;
   namespace `IsAffineOpen.appLE_isLocalization` over `Scheme.…`;
   M1.c is NOT a Mathlib gap — Mathlib already supplies
   `Subsingleton Ω[L/A]` via `FormallyUnramified.of_isLocalization`).

The combined effect: **no prover work this iter, but substantial
strategic + blueprint scaffolding work**. The trade-off (1-iter
latency cost vs. avoiding a prover round on broken blueprint) is
endorsed by the loop's HARD GATE rule.

## Per-target detail (deferred, no attempts)

### Target: M1 bridge `relativeDifferentialsPresheaf_equiv_kaehler_appLE`

**Status**: **not_started** (declaration not yet introduced in the
Lean tree; iter-122 refactor-subagent dispatch will introduce it
with `sorry` body).

**Per `mathlib-analogist-bridge-iter121` recommended signature shape**:
```
def AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE
    {X S : Scheme} (f : X ⟶ S) (U : S.Opens) (V : X.Opens)
    (e : V ≤ f ⁻¹ᵁ U) (hU : IsAffineOpen U) (hV : IsAffineOpen V) :
    letI : Algebra Γ(S, U) Γ(X, V) := (f.appLE U V e).hom.toAlgebra
    (relativeDifferentialsPresheaf f).presheaf.obj (.op V) ≃ₗ[Γ(X, V)]
      Ω[Γ(X, V) ⁄ Γ(S, U)]
```

(LinearEquiv with `@[simps]`, namespace TBD per analogist's
recommendation `IsAffineOpen.…` vs `Scheme.…`.)

**Attempts this iter**: 0. The declaration is forward design only;
no Lean file was touched.

**Next iter**: iter-122 plan-phase dispatches a refactor subagent to
introduce the bridge declaration with `sorry` body using the analogist
shape, then dispatches the M1 prover lane targeting M1.a (the
submonoid `M ⊆ A` of "appLE-unit" elements; ~30 LOC) per the
progress-critic-iter121 lock-in advisory.

### Target: `nonempty_jacobianWitness` (single remaining project sorry)

**Status**: **not_started** (M2/M3 milestone work; queued behind M1
in the strategic roadmap).

**Strategic restructure planned (per `STRATEGY.md § Decomposition`)**:
```
theorem nonempty_jacobianWitness ... := by
  by_cases h : AlgebraicGeometry.genus (k := k) C.left = 0
  · exact ⟨genusZeroWitness C h⟩      -- closed by M2 (genus-0 arm)
  · exact ⟨positiveGenusWitness C (Nat.pos_of_ne_zero h)⟩  -- closed by M3
```

The `Nat`-valued `genus` is decidable-equality-friendly, so the
`by_cases` is well-formed. M2 thus becomes "close `genusZeroWitness`"
rather than "preparatory infrastructure for M3" — converting the
genus-stratification (previously implicit in the project's chapter
prose) into an explicit Lean-level decomposition.

**Attempts this iter**: 0. The body restructure is forward design;
no Lean file was touched.

**Next iter**: M2 deferred until M1 bridge produces structural
advance (target iter-124 earliest per the progress-critic's
cross-route attention rule).

## Aggregate findings this iter

### Plan-phase critic verdicts (mandatory triad + analogist)

- `strategy-critic-iter121` — **CHALLENGE** on M2, M3;
  **SOUND-with-clarifications** on M1. Three corrections accepted
  into `STRATEGY.md`:
  1. M1 explicitly labelled "upstream Mathlib infrastructure, NOT
     project-sorry reduction." The framing matters because M1's
     LOC/iter cost is justified by Mathlib-contributor value, not
     by reducing `nonempty_jacobianWitness`.
  2. M2.c's `C ≅ ℙ¹_k` step is **mathematically false** on the
     protected signature (Brauer–Severi conics over `ℚ` are
     smooth proper geometrically irreducible curves of genus 0
     with no `k`-rational point and are NOT isomorphic to `ℙ¹_k`).
     The corrected route is base change to `k̄` + Galois descent
     of constancy.
  3. M3 route-pick decision criterion + top-3 gating Mathlib
     pieces per route + per-iter progress signal rules were added.

- `progress-critic-iter121` — **UNCLEAR** on both routes (fresh
  M1 sub-problem; fresh M2 queue entry). No CHURNING/STUCK signals.
  Watch criteria committed for iter-122/iter-123 (sorry count
  must not stay at 2 for 3+ iters once M1 bridge is introduced;
  cap of 2 new helpers per iter; no re-emergence of iter-119
  presheaf-vs-appLE-form blocker; M1.a vs M1.b lock-in in iter-122).

- `blueprint-reviewer-iter121` — **HARD GATE** on both active-route
  chapters: `Differentials.tex` and `Jacobian.tex` both
  `complete: partial`. Six must-fix-this-iter items spread across
  the two chapters (4 on Differentials, 1 on Jacobian, 1 broken
  LaTeX gate). Two of the four Differentials items were fixed
  inline by the plan agent (LaTeX `\end{remark>` → `\end{remark}`;
  three broken `\ref{sec:bridge-out-of-scope}` → `\ref{sec:bridge}`);
  the rest were delegated to two blueprint-writer dispatches.

- `mathlib-analogist-bridge-iter121` — **ALIGN_WITH_MATHLIB** (5×)
  + **NEEDS_MATHLIB_GAP_FILL with REDESIGNED approach** (1×). All
  7 findings folded into the iter-122 plan preview in `PROGRESS.md`
  and persisted to `analogies/relative-differentials-presheaf-bridge.md`
  for future iter reference.

### Plan-phase blueprint-writer dispatches

- `blueprint-writer-differentials-iter121` — **COMPLETE** (669s).
  Landed the M1.b cofinality proof skeleton (4 concrete steps:
  cofinality of basic opens, single-element localization,
  colimit-of-localizations, assemble), fixed the wrong `\uses{...}`
  direction on `lem:kaehler_localization_subsingleton`, replaced 6
  occurrences of "out-of-autonomous-loop scope" with
  "milestone-Mx-scheduled" prose. Drift from the analogist
  recommendations is non-correctness (writer used `Functor.Final`
  framing the analogist advised against; kept M1.c as a standalone
  lemma the analogist said is not a gap; kept `_iso_` naming). The
  iter-122 refactor pass on the Lean side, using the analogist
  shapes, will drive a follow-up writer to align the chapter
  vocabulary.

- `blueprint-writer-jacobian-iter121` — **COMPLETE** (1011s).
  Expanded `(C.2)` from one sentence to a ~110-LOC nested
  itemize (C.2.a–C.2.g) covering: statement of rigidity over `k̄`,
  reduction to project's `GrpObj_eq_of_eqOnOpen` (with honest hedge
  on the source-side group-scheme hypothesis mismatch — `ℙ¹_{k̄}`
  is not a group scheme; a future Rigidity.lean refactor is the
  cleanest fix), image-dimension argument, Mumford's classical
  "proper rational curves on abelian varieties are constant" input
  with two proofs sketched, set-to-scheme promotion, Galois descent,
  and the provisional Mathlib-gap declaration name
  `AlgebraicGeometry.AbelianVariety.constant_of_P1_map`. Two stale
  phrases at lines 376, 387 left untouched per directive scope.

### Review-phase audit findings

Subagent reports at:
- `task_results/lean-auditor-review121.md`
- `task_results/lean-vs-blueprint-checker-differentials-review121.md`
- `task_results/lean-vs-blueprint-checker-jacobian-review121.md`

#### `lean-auditor-review121` — 12 files audited, 0 new must-fix, 0 new major, 3 new minor

- **Overall verdict**: clean. Files on the iter-121 prover roadmap
  (`Differentials.lean`, `Jacobian.lean`, `Rigidity.lean`) read as
  honest Lean — no excuse-comments, no suspect placeholder bodies,
  no axioms outside the Mathlib-standard three. The sole `sorry`
  in `Jacobian.lean:179` `nonempty_jacobianWitness` is documented
  load-bearing-by-design, not an excuse.
- **New minor findings (3)**:
  1. `AlgebraicJacobian/Genus.lean:39–61` — 23-line commented-out
     "Sketch of the route" block describing an abandoned
     `AddCommGrpCat`-based design; pure reading noise, recommend
     deletion or compression in a future tidy-up.
  2. `AlgebraicJacobian/AbelJacobi.lean:51-56, 62-68, 82-90` — the
     four `letI := (jacobianWitness C).{grpObj, proper, smooth,
     geomIrred}` instance scaffolds are duplicated verbatim across
     `ofCurve`, `comp_ofCurve`, and `exists_unique_ofCurve_comp`;
     could be factored into a single namespace-level `letI` block.
  3. Six lines over 100 chars across `AbelJacobi.lean:22, 59`,
     `Jacobian.lean:96, 105, 199`, `MayerVietorisCore.lean:438`
     (Mathlib-style line-length lint, mostly docstrings).
- **Re-confirmed (severity unchanged)**:
  - `StructureSheafModuleK.lean:458–520` dead
    `IsAffineHModuleHomFinite` chain — must-fix from review118,
    still pending. Not on iter-121's M1/M2 surface.
  - `MayerVietorisCover.lean:490, 675` producerless scaffolding
    classes — major from review118.
  - `Rigidity.lean:62-67` redundant typeclass arguments — major
    from review118.
  - `Differentials.lean` L101/L106 line-length — minor from
    review120; under raw `awk 'length>100'` no line exceeds 100
    chars at iter-121 head (the prior warning may have used a
    stricter Mathlib-linter threshold; effectively resolved).

#### `lean-vs-blueprint-checker-differentials-review121` — 3+4 declarations checked, 0 red flags

- **Overall verdict**: **PASS**. The 3 existing Lean declarations
  (`relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`,
  `smooth_locally_free_omega`) faithfully track the unchanged parts
  of the blueprint. The 4 new forward-design M1 declarations
  (`relativeDifferentialsPresheaf_iso_kaehler_appLE`,
  `appLE_isLocalization`, `kaehler_localization_subsingleton`,
  `kaehler_quotient_localization_iso`) are intentionally pre-Lean
  per iter-121's deferral.
- **Chapter-side action surfaced**: critical for iter-122 — revise
  `lem:kaehler_localization_subsingleton` (chapter line 138) to
  drop the incorrect "Mathlib has no off-the-shelf lemma" claim
  (Mathlib's `FormallyUnramified.of_isLocalization` +
  `subsingleton_kaehlerDifferential` discharges it). This is the
  new manifestation of the iter-121 analogist finding that the
  blueprint M1.c framing predates: now that the chapter states
  a concrete plan-of-attack contradicting the analogist's verdict,
  the chapter is the failure mode.
- **Minor name-divergences (non-defect)**: Step 1 cites
  `smoothOfRelativeDimension_iff` (blueprint) vs.
  `SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension`
  (Lean — same conclusion via field accessor). Step 4.5's
  `Nontrivial B` discharge is via `Nonempty V`+`haveI` in Lean vs.
  named `Scheme.component_nontrivial` in chapter prose.

#### `lean-vs-blueprint-checker-jacobian-review121` — 12 declarations checked, 0 must-fix, 2 major (chapter-side), 3 minor

- **Overall verdict**: **Aligned**. All 12 `\lean{...}` blocks
  resolve to the exact declaration names in
  `AlgebraicJacobian/Jacobian.lean`. The C.2 sub-step rewrite is
  mathematically faithful to the protected
  `nonempty_jacobianWitness` signature (no genus parameter, no
  `C(k) ≠ ∅` hypothesis). The single `:= sorry` at line 179 is the
  authorised foundational hypothesis.
- **Chapter-side major findings (2 — both stale phrases left
  untouched per writer's out-of-scope rule)**:
  - `Jacobian.tex:376` bullet (γ): still says "rigidity theorem
    `Hom(ℙ¹_k, A) = A(k)` together with the genus-0 identification
    `C ≅ ℙ¹_k` for a smooth proper geometrically irreducible curve
    with a `k`-rational point". Drifts from the C.2 base-change-to-`k̄`
    framing.
  - `Jacobian.tex:387` Layer I item: same stale framing — should be
    rephrased to refer to `ℙ¹_{k̄}`-side rigidity + Galois descent.
  Both flagged for an iter-122/iter-123 follow-up blueprint-writer.
- **Chapter-side minor findings (3)**:
  - `def:IsAlbanese` prose says "morphism of group schemes" for the
    universal factorising `g`; Lean signature only requires a
    scheme morphism (and group-homomorphism property is a
    consequence, not a requirement).
  - `geometricallyIrreducible_id_Spec` and `jacobianWitness` lack
    `\lean{...}` blocks (genuine helpers; promotion optional).
  - **`\leanok` mismatch at `Jacobian.tex:249`** inside the proof
    block of `thm:nonempty_jacobianWitness` — Lean proof is
    `sorry`, but the chapter has `\leanok` on the proof block. This
    is `sync_leanok`'s deterministic responsibility, not the
    reviewer's; defer to that phase. I (this review agent) do NOT
    touch `\leanok` per the review prompt's explicit rule.

### Summary of severity counts (review-phase)

- **must-fix-this-iter**: 0 new findings across all 3 reports.
- **major**: 2 new (both chapter-side stale phrases in
  `Jacobian.tex`) + 1 chapter-side critical-for-iter-122
  recommendation on Differentials.tex M1.c framing.
- **minor**: 6 new across the project (cosmetic + helper-promotion
  candidates + the `\leanok` proof-block mismatch on
  `nonempty_jacobianWitness` for sync_leanok).
- **Excuse-comments**: 0.
- **Re-confirmed from prior iters**: 1 must-fix (dead chain), 2
  major (scaffolding classes, redundant typeclasses) — all
  unchanged from review118/review120.

## Blueprint markers updated (manual)

None this iter. No `\mathlibok` was justified (no Mathlib re-export
landed; the M1 bridge declarations are forward design, not Mathlib
aliases). No `\notready` was stripped (none was present on a now-
formalized block). No `\lean{...}` macro corrections were needed
(no Lean renames happened this iter).

(`\leanok` placement is handled deterministically by the
`sync_leanok` phase; the review agent does not touch `\leanok`.)

## Recommendations for the next plan-agent iteration (iter-122)

See `recommendations.md`. Headline: re-dispatch
`blueprint-reviewer` to confirm both chapters now clear the HARD
GATE; dispatch a `refactor` subagent to introduce the bridge
declaration in `AlgebraicJacobian/Differentials.lean` with `sorry`
body and the analogist-recommended shape; dispatch the M1 prover
lane targeting M1.a as the locked-in first sub-step.
