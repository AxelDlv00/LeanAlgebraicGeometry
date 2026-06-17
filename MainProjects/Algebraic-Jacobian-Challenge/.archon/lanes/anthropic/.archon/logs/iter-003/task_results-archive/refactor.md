# Refactor Report — iter-004

## Status
COMPLETE

## Directive

### Problem
Iter-003 cleanly closed the two helper-scaffold targets created by iter-002
(`Rigidity.lean`'s `eq_of_eqOnOpen` and `Picard/LineBundle.lean`'s
`LineBundle`/`instCommGroupLineBundle`/`Pic.pullback`), reducing the sorry
count from 13 → 9. All remaining sorries are protected (Jacobian.lean five,
AbelJacobi.lean three, Genus.lean one) and not honestly closeable in
`b80f227` without multi-iteration upstream work.

To keep momentum, iter-004 opens two parallel low-coupling helper tracks:

1. Phase A step 1 — `HasSheafCompose` instance for the structure-sheaf
   forget composite `CommRingCat ⥤ RingCat ⥤ AddCommGrpCat`, the gateway to
   `H¹(C, O_C)` (and downstream `genus`).
2. Phase C step 2 — relative Picard functor `S ↦ Pic(C ×_k S) / p_S^* Pic(S)`
   plus a deferred FGA-level representability theorem; closure of
   representability jointly unblocks the four `Jacobian.lean` sorries.

### Changes requested
- Create `AlgebraicJacobian/Cohomology/SheafCompose.lean` with a single new
  `sorry`-instance `instHasSheafCompose_forget_CommRing_AddCommGrp`.
- Create `AlgebraicJacobian/Picard/Functor.lean` with two new `sorry`
  declarations: `PicardFunctor` (def) and `PicardFunctor.representable`
  (theorem).
- Update the umbrella `AlgebraicJacobian.lean` import order.
- No `archon-protected.yaml` changes; no axioms; no protected signature
  modifications.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/SheafCompose.lean` (new)

- **What:** Created the new file (and parent directory `AlgebraicJacobian/Cohomology/`).
  Declares a single `sorry` instance:
  ```
  instance instHasSheafCompose_forget_CommRing_AddCommGrp (X : TopCat) :
      (Opens.grothendieckTopology X).HasSheafCompose
        (CategoryTheory.forget₂ CommRingCat RingCat ⋙
         CategoryTheory.forget₂ RingCat AddCommGrpCat) := sorry
  ```
  Namespace: `AlgebraicGeometry.Cohomology`. File header follows the style of
  `Picard/LineBundle.lean`. Documents the iter-005 prover's discovery objectives
  (limit-preservation lemma route).
- **Why:** Phase A step 1 of `STRATEGY.md`. This is the gateway to the
  abstract `Sheaf.H` cohomology API for the structure sheaf; closing it
  unblocks the chain `HasSheafCompose → HasSheafify → HasExt →
  Module k on H¹ → Serre finiteness → genus`.
- **Cascading:** None. The only consumer is the umbrella `AlgebraicJacobian.lean`
  (import added).
- **Deviation from directive sketch:** The directive's sketch wrote
  `(TopologicalSpace.Opens.grothendieckTopology X).HasSheafCompose ...`. In
  current Mathlib (`b80f227`) the fully qualified name is
  `Opens.grothendieckTopology` (declared inside `namespace TopologicalSpace.Opens`
  but exposed under the shorter alias once `TopologicalSpace` is opened by the
  `open ... ` chain that brings `Opens` into scope). I replaced
  `TopologicalSpace.Opens.grothendieckTopology` with `Opens.grothendieckTopology`
  to compile. The instance name and full mathematical content are unchanged.

### File: `AlgebraicJacobian/Picard/Functor.lean` (new)

- **What:** Created the new file. Declares two new `sorry` declarations:
  ```
  noncomputable def PicardFunctor
      {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k))) :
      Scheme.{u}ᵒᵖ ⥤ Type u := sorry

  theorem PicardFunctor.representable
      {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
      [SmoothOfRelativeDimension 1 C.hom]
      [IsProper C.hom]
      [GeometricallyIrreducible C.hom] :
      (PicardFunctor C).IsRepresentable := sorry
  ```
  Namespace: `AlgebraicGeometry.Scheme`. Imports `AlgebraicJacobian.Picard.LineBundle`.
  File header records (a) the iter-005 prover's instructions for filling the
  *definition* and (b) the explicit forbidden-shortcut warning that
  `representable` must remain unfilled while `LineBundle` is still the
  global-sections approximation.
- **Why:** Phase C step 2 of `STRATEGY.md`. The relative Picard functor is the
  natural input to FGA-style representability; the four `Jacobian.lean`
  sorries (and `smoothOfRelativeDimension_genus` once Phase A is done) all
  reduce to the single `representable` theorem. Closing the *definition* in
  iter-005 is honest work; closing `representable` on top of the global-sections
  approximation is forbidden and explicitly flagged in the docstring.
- **Cascading:** None. The only consumer is the umbrella file.
- **Deviation from directive sketch:** The directive's sketch wrote
  `(C : Scheme.{u}) [C.Over (Spec (.of k))]` with the field `{k : Type u}`
  implicit. With this exact shape, `k` cannot be inferred from `C : Scheme.{u}`
  at any *call site* of `PicardFunctor` (typeclass synthesis on
  `C.Over (Spec (.of ?k))` gets stuck on the metavariable `?k`):
  ```
  typeclass instance problem is stuck
    C.Over (Spec (CommRingCat.of ?m.4))
  ```
  This is the same issue that `Jacobian.lean` already side-steps by taking
  `C : Over (Spec (.of k))` (an object of the over-category, which determines
  `k` from its type). I therefore reshaped the binders to
  `(C : Over (Spec (CommRingCat.of k)))` matching `Jacobian.lean`. The
  directive explicitly authorises this: *"If the most natural formulation
  requires re-shaping the conditions (e.g. unbundling `[Over]`), preserve the
  intent of the statement and document the chosen shape in
  `task_results/refactor.md`."* The intent is preserved: `C` is still a
  scheme over `Spec k`, and the smooth-proper-geometrically-irreducible
  hypotheses survive verbatim (as `[SmoothOfRelativeDimension 1 C.hom]` etc.).
- **Idiom for representability:** The directive flagged `Scheme.IsRepresentable`
  as a candidate. The actual Mathlib idiom is `Functor.IsRepresentable`
  (declared in `Mathlib/CategoryTheory/Yoneda.lean`):
  ```
  @Functor.IsRepresentable :
    {C : Type u_3} → [inst : Category.{u_2, u_3} C] → Cᵒᵖ ⥤ Type u_1 → Prop
  ```
  This is exactly what the blueprint chapter says, and the term
  `(PicardFunctor C).IsRepresentable` resolves correctly via dot-notation to
  this `Functor.IsRepresentable`. **No blueprint change needed** — the
  `\lean{...}` macros in `Picard_Functor.tex` already point at the
  unqualified `representable`.

### File: `AlgebraicJacobian.lean` (umbrella)

- **What:** Added two new imports in dependency-correct order:
  ```
  import AlgebraicJacobian.Cohomology.SheafCompose
  import AlgebraicJacobian.Genus
  import AlgebraicJacobian.Picard.LineBundle
  import AlgebraicJacobian.Picard.Functor
  import AlgebraicJacobian.Jacobian
  import AlgebraicJacobian.Rigidity
  import AlgebraicJacobian.AbelJacobi
  ```
- **Why:** Make the new declarations reachable from the project root.
- **Cascading:** None.

### File: `archon-protected.yaml`

- **No change** (per directive Action 4). No protected declaration was
  moved, renamed, or re-signed.

### Blueprint chapter `\lean{...}` macros

- **No change.** The blueprint chapters
  `Cohomology_SheafCompose.tex` and `Picard_Functor.tex` already cite the
  declaration names that now exist verbatim:
  - `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp`
  - `AlgebraicGeometry.Scheme.PicardFunctor`
  - `AlgebraicGeometry.Scheme.PicardFunctor.representable`

## New Sorries Introduced

- `AlgebraicJacobian/Cohomology/SheafCompose.lean:38` —
  `instHasSheafCompose_forget_CommRing_AddCommGrp` (Phase A step 1
  scaffold; iter-005 prover target).
- `AlgebraicJacobian/Picard/Functor.lean:63` —
  `PicardFunctor` (Phase C step 2 *definition*; iter-005 prover target).
- `AlgebraicJacobian/Picard/Functor.lean:76` —
  `PicardFunctor.representable` (Phase C step 2 *theorem*; intentionally
  deferred — iter-005 prover **must not** attempt to close on top of the
  global-sections-approximate `LineBundle`).

## Compilation Status

Verified via `lean_diagnostic_messages` and `lake env lean AlgebraicJacobian.lean`:

| File | Status | Sorries |
|------|--------|---------|
| `AlgebraicJacobian.lean` (umbrella) | compiles | – |
| `AlgebraicJacobian/Cohomology/SheafCompose.lean` (new) | compiles | 1 |
| `AlgebraicJacobian/Picard/Functor.lean` (new) | compiles | 2 |
| `AlgebraicJacobian/Picard/LineBundle.lean` | compiles | 0 |
| `AlgebraicJacobian/Genus.lean` | compiles | 1 |
| `AlgebraicJacobian/Jacobian.lean` | compiles | 5 |
| `AlgebraicJacobian/Rigidity.lean` | compiles | 0 |
| `AlgebraicJacobian/AbelJacobi.lean` | compiles | 3 |
| **Total** | | **12** (was 9 pre-refactor → +3 from new scaffolds) |

This matches the directive's expected post-refactor sorry count exactly
(1 + 2 + 0 + 1 + 5 + 0 + 3 = 12).

## Final names of new declarations

- `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp`
  (instance) — `AlgebraicJacobian/Cohomology/SheafCompose.lean:38`
- `AlgebraicGeometry.Scheme.PicardFunctor`
  (noncomputable def) — `AlgebraicJacobian/Picard/Functor.lean:63`
- `AlgebraicGeometry.Scheme.PicardFunctor.representable`
  (theorem) — `AlgebraicJacobian/Picard/Functor.lean:76`

## Confirmation of constraints

- **No axiom added.** `Grep '^axiom' AlgebraicJacobian/` returns no matches.
  The two pre-existing matches for the substring `axiom` are inside comments
  (`Genus.lean:95`, `Jacobian.lean:76`) and do not declare anything.
- **No protected signature changed.** `archon-protected.yaml` is byte-identical;
  none of the protected declarations (`AlgebraicGeometry.genus`,
  `AlgebraicGeometry.Jacobian`, `AlgebraicGeometry.Jacobian.instGrpObj`,
  `…smoothOfRelativeDimension_genus`, `…instIsProper`,
  `…instGeometricallyIrreducible`, `…ofCurve`, `…comp_ofCurve`,
  `…exists_unique_ofCurve_comp`) were touched.
- **No new sorries outside the directive scope.** Pre-refactor sorries
  (9 protected) are all unchanged; the 3 new sorries are exactly the three
  scaffold sites named in Actions 1–2.
- **`Rigidity.lean`, `Picard/LineBundle.lean`, `Genus.lean`,
  `Jacobian.lean`, `AbelJacobi.lean`** are untouched (verified by
  `lean_diagnostic_messages`: their sorry counts are unchanged at 0, 0, 1,
  5, 3 respectively, matching the pre-refactor state).

## Notes for Plan Agent

- The directive's mathematical justification was sufficient: both new files
  scaffolded cleanly without surprise dependencies. The two deviations
  (the `Opens.grothendieckTopology` rename, and the `Over (Spec (.of k))`
  reshaping of `PicardFunctor`'s curve argument) were anticipated by the
  directive's "if the natural formulation differs, document and adjust"
  clause and required no out-of-scope changes.
- `Functor.IsRepresentable` (rather than `Scheme.IsRepresentable` or
  `RepresentableBy`) is the natural Mathlib idiom in `b80f227`. The blueprint
  chapter `Picard_Functor.tex` writes the theorem cleanly enough that no
  prose adjustment was needed; only the (already correct) `\lean{...}`
  macro is involved.
- Forward-compatibility hazard for iter-005 prover: the prover assigned to
  `Picard/Functor.lean` *must not* attempt `PicardFunctor.representable`.
  This is recorded in the file docstring, in the blueprint chapter
  forward-compatibility note, and (per directive) here. The plan agent
  should re-emphasise this in `PROGRESS.md` when scoping iter-005.
- Suggested follow-up refactors:
  1. Once Phase A step 1 closes (`HasSheafCompose`), Phase A step 2 follow-up
     scaffold (`HasSheafify (Opens.gT X) AddCommGrpCat`) is the natural next
     refactor target. The current `Cohomology/` directory makes a tidy home.
  2. Once Phase C step 2 *definition* closes, Phase C step 3 (étale
     sheafification of `PicardFunctor`) is the natural next refactor target,
     and would also benefit from a fresh helper file.
  3. The shared `forbidden shortcut: do not close representability on the
     global-sections-approximate LineBundle` warning lives in three places
     today (Functor.lean docstring, blueprint chapter forward-compatibility
     note, this report). When `LineBundle` is upgraded to a sheaf-theoretic
     definition, all three need to be updated together.
