# Lean Audit Report

## Slug
iter048

## Iteration
048

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

- **outdated comments**: none (focus range); 0 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 8 pre-existing style warnings (3 × `Sheaf.val` deprecation; 5 × `maxHeartbeats` comment-placement); see notes
- **excuse-comments**: none
- **notes** (focus declarations — lines 1478–1543):
  - **No compiler errors or warnings** in the focus range (lines 1478–1543). `lean_diagnostic_messages` returns an empty list for that region.
  - **Axiom check clean.** Both `isIso_fromTildeΓ_app_basicOpen` and `isIso_fromTildeΓ_of_quasicoherent` use only `{propext, Classical.choice, Quot.sound}` — the standard Lean 4 axiom set. No sorry, no extra axioms.
  - **`change Function.Bijective ⇑c.hom` (line 1519).** This follows an `rw [ConcreteCategory.isIso_iff_bijective]` that changes the goal to bijectivity expressed with a coercion; `change` strips the coercion layer. The `change` target is definitionally equal to the post-rewrite goal — not a type mismatch or unsound defeq assumption.
  - **`suffices h : IsIso (modulesSpecToSheaf.map F.fromTildeΓ) from …` (line 1532).** Reduces to an isomorphism in the sheaf category and reflects it back through `SpecModulesToSheafFullyFaithful.isIso_of_isIso_map`, which is the correct Mathlib fully-faithful reflection API. Not masking a gap.
  - **`IsLocalizedModule.ext` call (lines 1513–1517).** Signature of `IsLocalizedModule.ext` (confirmed by hover): takes `f : M →ₗ[R] M'` as the localization map, `map_unit : ∀ x : S, IsUnit (algebraMap R (Module.End R M'') x)` for the *codomain* `M''` of the two maps being equated, and a commutativity hypothesis `j ∘ₗ f = k ∘ₗ f`. Here: `f = toOpen.hom` (localization `hlf`); `map_unit = hcl.map_units`, where `hcl : IsLocalizedModule (Submonoid.powers r) (c.hom ∘ₗ toOpen.hom)` — its `map_units` field lives over the codomain of `c.hom ∘ₗ toOpen.hom`, which equals the codomain of `c.hom` and `e.toLinearMap` (`M''`). The types match correctly; no coercion gap.
  - **`IsLocalizedModule.linearEquiv` (lines 1507–1511).** Constructs the canonical `R`-linear equivalence between two localization targets of the same source `M` at `S`. Here `f = toOpen.hom` (`hlf` instance) and `g = c.hom ∘ₗ toOpen.hom` (`hcl` instance, after `hcomp'` identifies it with `hlg`). Both share source `F.presheaf.obj ⊤`; the construction is legitimate.
  - **`IsLocalizedModule.linearEquiv_apply` (line 1517).** The simp lemma closes the `j ∘ₗ f = k ∘ₗ f` subgoal by reducing `e.toLinearMap ∘ₗ toOpen.hom` to `c.hom ∘ₗ toOpen.hom` via the defining property of `linearEquiv`. This is genuine content discharged by `simp`; not a vacuous or auto-closed goal.
  - **`e.bijective` (line 1521).** Bijectivity follows from `e : M' ≃ₗ[R] M''` being a `LinearEquiv`, whose `bijective` field is populated by the universal property. Clean.
  - **`IsCoverDense.iso_of_restrict_iso` synthesis (lines 1534–1542).** The Mathlib signature (confirmed by hover) is `[G.IsCoverDense K] [G.IsLocallyFull K] {ℱ ℱ' : Sheaf K A} (α : ℱ ⟶ ℱ') (i : IsIso (G.op.whiskerLeft α.hom)) : IsIso α`. `IsCoverDense` is provided explicitly via `hcd`. `IsLocallyFull` is NOT named in the proof — Lean must synthesize it from an instance for `inducedFunctor` on an open basis. Confirmed real: the elaboration produces no errors and the axiom check is clean. The `haveI : ∀ X, IsIso (...)` block (lines 1539–1541) correctly installs the component-iso predicate so that `NatIso.isIso_of_isIso_app _` (line 1542) can close the `IsIso (G.op.whiskerLeft α.hom)` goal via instance search.
  - **`NatIso.isIso_of_isIso_app` (line 1542).** The required `[∀ (X : C), IsIso (α.app X)]` typeclass is installed by the preceding `haveI`. Not a vacuous subsingleton-coherence closure.
  - **No `set_option maxHeartbeats` elevation in the focus declarations.** The five existing `set_option maxHeartbeats 1000000 in` blocks (lines 882, 978, 1017, 1053, 1068) are all pre-existing, each covering a genuinely heartbeat-heavy definitional check. The new declarations compile within the default budget.
  - **Pre-existing `Sheaf.val` deprecation warnings (lines 733, 742, 759).** These are outside the focus range and pre-date this iter. `CategoryTheory.Sheaf.val` is deprecated in favour of `ObjectProperty.obj`. Minor; no semantic impact.
  - **Pre-existing `maxHeartbeats` comment-placement warnings (lines 882, 978, 1017, 1053, 1068).** The Mathlib style linter requires the explanatory comment to appear on the line immediately after the `set_option maxHeartbeats ... in` line (not before it). All five blocks have the comment before the `set_option`, triggering the linter. Pre-existing style issue; no correctness impact.

---

## Must-fix-this-iter

None.

---

## Major

None.

---

## Minor

- `QcohTildeSections.lean:733` — `CategoryTheory.Sheaf.val` deprecated; migrate to `ObjectProperty.obj` (pre-existing, not introduced this iter).
- `QcohTildeSections.lean:742` — same deprecation (pre-existing).
- `QcohTildeSections.lean:759` — same deprecation (pre-existing).
- `QcohTildeSections.lean:882` — `set_option maxHeartbeats 1000000 in` has explanatory comment placed *before* the option line rather than after it; Mathlib style linter fires. Pre-existing; same pattern repeated at lines 978, 1017, 1053, 1068.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 4 (3 × deprecation of `Sheaf.val`; 1 × `maxHeartbeats` comment-placement pattern, counting all five instances as one pattern finding)
- **excuse-comments**: 0

Overall verdict: the two new iter-048 declarations (`isIso_fromTildeΓ_app_basicOpen` and `isIso_fromTildeΓ_of_quasicoherent`) are axiom-clean, error-free, and structurally sound — the localization-ext argument is genuine, the cover-dense reflection chain is a real synthesis path, and no `change`/`haveI` masks a type mismatch. Pre-existing minor style issues (Sheaf.val deprecation, heartbeats comment placement) remain but do not block downstream work.
