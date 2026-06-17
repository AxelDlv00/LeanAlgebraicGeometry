# Lean ↔ Blueprint Check Report

## Slug
g0bo-iter165

## Iteration
165

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (consolidated chapter; `% archon:covers` line at L3 lists both
  `AlgebraicJacobian/AbelianVarietyRigidity.lean` and the new
  `Genus0BaseObjects.lean`)

## Per-declaration

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects`, L912)
- **Lean target exists**: yes — `Genus0BaseObjects.lean:108`, `def ProjectiveLineBar (kbar : Type u) [Field kbar] : Over (Spec (.of kbar))`.
- **Signature matches**: yes — informal "projective line `ℙ¹_{k̄}` as an object of `Over (Spec k̄)`" matches the Lean encoding `(ProjectiveLineBarScheme kbar).asOver (Spec (.of kbar))` exactly. The `Over (Spec (.of kbar))` orientation matches every downstream consumer in `AbelianVarietyRigidity.lean`.
- **Proof follows sketch**: N/A — this is a `def`, not a proof.
- **notes**:
  - The `def:genus0_base_objects` block in the chapter prose names *three* primary objects (`ℙ¹`, `𝔾_a`, `𝔾_m`) but only `\lean{...}`-pins the first (`ProjectiveLineBar`). The chapter uses `[expected]` annotations in the prose for `Ga`, `Gm`, the three `ℙ¹` points; the corresponding Lean decls all exist (`Ga` L229, `Gm` L294, `ProjectiveLineBar.{zeroPt, onePt, inftyPt}` L199/204/209). The single primary `\lean{...}` hint *covers* the block but individual hints for the per-object decls would tighten `sync_leanok` resolution and pin substantive decls explicitly. See "Blueprint adequacy" below — flagged as **minor**, not must-fix.
  - The chapter claims `ℙ¹_{k̄}` is "a smooth proper geometrically irreducible curve of genus 0". The Lean file provides:
    - `projectiveLineBar_isProper` (L127): PROVEN axiom-clean ✓
    - `projectiveLineBar_geomIrred` (L175): **scaffold `sorry`** — plan-allowed per the iter-165 PARTIAL gate scorecard (plan.md L107–115).
    - `projectiveLineBar_smoothOfRelDim` (L182): **scaffold `sorry`** — plan-allowed.
    - The "genus 0" claim is *not* discharged here; this file does not install a `genus`-instance. That is iter-166's lane (no false claim).
  - The chapter mentions "the two standard affine charts $\mathbb A^1 = \mathbb P^1 \setminus \{\infty\}$ (coordinate $x$) and $\mathbb P^1 \setminus \{0\}$ (coordinate $u = 1/x$)". The Lean file does **not** provide named affine-chart decls — they are not on the iter-165 scaffold either, and the iter-166 chartwise glue of `gmScalingP1` (which is what would consume them) is plan-deferred. No must-fix because the chapter does not pin the charts via `\lean{...}`.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`, L943)
- **Lean target exists**: yes — `Genus0BaseObjects.lean:366`, `def gmScalingP1 (kbar : Type u) [Field kbar] : ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar`.
- **Signature matches**: yes — informal `σ_× : ℙ¹ × 𝔾_m → ℙ¹`, `(x, λ) ↦ λx`, matches the Lean type exactly (the monoidal product `⊗` in `Over (Spec k̄)` is the standard ℙ¹ ×_{k̄} 𝔾_m fibre product over `Spec k̄`). This is the load-bearing signature that the iter-166 consumer `morphism_P1_to_grpScheme_const` will compose with.
- **Proof follows sketch**: **N/A** — body is `:= sorry` (plan-allowed scaffold, iter-166's lane is the chartwise glue via `AlgebraicGeometry.Scheme.Cover.glueMorphisms`, mirroring the chapter's chartwise-construction prose at L960–965).
- **notes**:
  - Companion lemma `gmScalingP1_collapse_at_zero` (L381) is **not** pinned by its own `\lean{...}` hint in the chapter, but the chapter prose at L51–53, 970–972, 1090–1097, 1241–1259 describes exactly this fixed-point property as the `W`-axis-collapse hypothesis Cor 1.5 consumes. The named lemma should arguably be pinned in a future chapter revision (see "Blueprint adequacy" — minor).
  - The `def:gaTranslationP1` block in the chapter also describes a *second* action, the demoted `ℙ¹ × 𝔾_a → ℙ¹` translation `σ` (`[expected]` Lean name `gaTranslationP1`). That decl is **deliberately absent** from this Lean file (off the primary route per iter-164 strategy, and not on the iter-165 scaffold lane). No must-fix: the chapter is explicit that this companion is demoted-route-only, and the `\lean{...}` hint pins only the primary `gmScalingP1`.
  - The chapter discusses "left action of 𝔾_m on ℙ¹" identities (`σ_×(x, 1) = x`, `σ_×(σ_×(x, λ), μ) = σ_×(x, λμ)`) and the second fixed point `∞`. The Lean file installs **only** the load-bearing `gmScalingP1_collapse_at_zero` (collapse at `0`), not the full `MulAction`-style API. This is consistent with the analogist D3 verdict ("no `IsAction`/`MulAction`-style typeclass at scheme level") recorded in the file docstring at L347–349 and with the rigidity consumer's actual `_hf` needs. The chapter prose currently says more than the file ships; consider tightening the chapter to flag explicitly that only the collapse-at-`0` identity is formalised, or scope the prose to match the analogist verdict. Flagged as **minor** under blueprint adequacy.

## Red flags

(No must-fix findings.)

### Placeholder / suspect bodies

**All 9 `:= sorry` bodies in the file are plan-allowed scaffold sorries** (per the iter-165 PARTIAL gate scorecard, plan.md L107–115). They are NOT red flags by directive instruction. Recorded here for completeness:

- `projectiveLineBar_geomIrred` (L175–177): `GeometricallyIrreducible (ProjectiveLineBar kbar).hom := sorry`. Mathlib does not ship this for `Proj`. Plan-allowed.
- `projectiveLineBar_smoothOfRelDim` (L182–184): `SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom := sorry`. Mathlib does not ship this for `Proj`. Plan-allowed.
- `ProjectiveLineBar.zeroPt` (L199–201): `𝟙_ ⟶ ProjectiveLineBar kbar := sorry`. Iter-166 lane (`Proj.awayι ≫ Spec.map` construction). Plan-allowed.
- `ProjectiveLineBar.onePt` (L204–206): same pattern. Plan-allowed.
- `ProjectiveLineBar.inftyPt` (L209–211): same pattern. Plan-allowed.
- `ga_grpObj` (L264): `GrpObj (Ga kbar) := sorry`. Iter-166 lane (`GrpObj.ofRepresentableBy` + additive-group functor). Plan-allowed; *not* consumed by the primary `𝔾_m`-scaling route, so does not block the live consumer.
- `gm_grpObj` (L329): `GrpObj (Gm kbar) := sorry`. Iter-166 lane (units functor via `IsLocalization.Away`-Spec bijection). Plan-allowed; **this one IS consumed by the iter-166 consumer** `morphism_P1_to_grpScheme_const` (Cor 1.5 with `W = Gm`).
- `gmScalingP1` (L366–368): `ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar := sorry`. Iter-166 lane (chartwise glue). Plan-allowed; this is the load-bearing morphism for the entire primary route.
- `gmScalingP1_collapse_at_zero` (L381–385): proof body `sorry`. Iter-166 lane. Plan-allowed.

### Excuse-comments

None. The file's docstrings and section comments clearly distinguish "iter-165 lands the *type signature*" / "the chartwise glue body is iter-166's lane" from any "wrong / will fix later" framing — these are explicit lane-allocation notes, not excuses for wrong code. The pattern is consistent throughout (L264 docstring, L324 `gm_grpObj` docstring, L361–365 `gmScalingP1` docstring, L378–380 collapse-lemma docstring).

### Axioms / Classical.choice on non-trivial claims

None. No `axiom` declarations; no suspect `:= Classical.choice _` patterns.

### Forward-acyclicity / laundering check

**Pass.** The blueprint chain consumes `def:gaTranslationP1` from `prop:morphism_P1_to_AV_constant`, `lem:hom_Ga_to_av_trivial`, `lem:hom_from_Ga_trivial` (all forward edges; verified by grep of `\uses{... def:gaTranslationP1 ...}` and `\cref{def:gaTranslationP1}`). No backward edge from any of these back to `def:gaTranslationP1`'s scaffold sorries. The directive-named live consumer `morphism_P1_to_grpScheme_const` in `AbelianVarietyRigidity.lean` is itself still a sorry per the directive — verified by grep on the chapter side that `prop:morphism_P1_to_AV_constant` has a proof block with `\leanok` only on the *statement* (L1199) per the deterministic sync, never laundered onto a sorry-bodied target.

**False-`\leanok`-on-sorry check.** The `def:genus0_base_objects` (L910–939) and `def:gaTranslationP1` (L941–989) blocks **currently carry no `\leanok` marker** (verified by grep — no `\leanok` between L909 and L991). This is the deterministic-sync's correct state: `def:gaTranslationP1` MUST NOT get one (body `gmScalingP1` is `sorry`), and `def:genus0_base_objects` is in `sync_leanok`'s next-run domain — `ProjectiveLineBar` itself has no sorry, so the statement block may legitimately receive `\leanok` once sync runs, but no false marker is currently in place.

## Unreferenced declarations (informational)

The Lean file has ~30 top-level declarations; only 2 are pinned by `\lean{...}` hints in the chapter. The unreferenced ones break down as:

- **Internal helpers (acceptable, no blueprint hint needed)**: `projectiveLineBarGrading`, `projectiveLineBarGrading_gradedRing`, `ProjectiveLineBarScheme`, `projectiveLineBarScheme_canOver`, `GaScheme`, `gaScheme_canOver`, `GmRing`, `GmScheme`, `gmScheme_canOver`. These are the under-the-hood scheme constructions that the consumer `ProjectiveLineBar` / `Ga` / `Gm` abstract over.
- **Per-object instances (acceptable as helpers)**: `projectiveLineBar_isProper`, `projectiveLineBar_geomIrred`, `projectiveLineBar_smoothOfRelDim`, `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced`, `ga_grpObj`, `ga_smooth`, `gm_isAffine`, `gm_locallyOfFinitePresentation`, `gm_isReduced`, `gm_grpObj`, `gm_smooth`. The chapter prose at L82 lists the abelian-variety typeclass set (`GrpObj`, `IsProper`, `Smooth`, `GeometricallyIrreducible`) and at L936 says "All three are of finite type over `k̄`; `ℙ¹` is proper, while `𝔾_a` and `𝔾_m` are affine". The named decls realise that prose. Could be promoted to their own `\lean{...}` blocks for tighter coverage, but the instance-resolution pattern means they fire automatically at consumer sites — flagged minor only.
- **Substantive named objects (worth promoting to `\lean{...}` blocks)**: `Ga`, `Gm`, `ProjectiveLineBar.zeroPt`, `ProjectiveLineBar.onePt`, `ProjectiveLineBar.inftyPt`, `Gm.onePt`, `gmScalingP1_collapse_at_zero`. Each of these is named in the chapter prose (the first five with `[expected]` annotations, `Gm.onePt` and the collapse lemma in the proof-sketch prose). They deserve individual `\lean{...}` hints. Minor.

## Blueprint adequacy for this file

- **Coverage**: 2/2 explicitly-`\lean{...}`-pinned blocks have their Lean targets present and signature-faithful. Of the 30 Lean declarations, ~9 are internal helpers (acceptable unreferenced), ~13 are instance discharges (acceptable, flagged minor), and **7 are substantive named decls the chapter mentions in prose but does not pin via `\lean{...}`** (`Ga`, `Gm`, `Gm.onePt`, `ProjectiveLineBar.{zeroPt, onePt, inftyPt}`, `gmScalingP1_collapse_at_zero`). The chapter uses `[expected]` annotations for several of these, signalling that explicit hints were planned but not landed this iter.
- **Proof-sketch depth**: adequate for the load-bearing `gmScalingP1` chartwise definition (chapter L960–965 details the polynomial map `(x, λ) ↦ λx` on `𝔸¹ × 𝔾_m` and the `u/λ` rewrite on the `∞`-chart) and for the `gmScalingP1_collapse_at_zero` fixed-point property (chapter L1252–1259 makes the `σ_×(0, λ) = 0` collapse fully explicit, exactly what Cor 1.5's `_hf` needs). The `ProjectiveLineBar` `Proj`-of-graded-polynomial construction is mathematically standard and the file's docstring chain (L86–96, L111–126) is more detailed than the chapter prose — fine, this is the right asymmetry.
- **Hint precision**: precise for both pinned hints; the `\lean{...}` names match the actual Lean decls exactly. **Loose** on the `[expected]` annotations for `Ga`/`Gm`/`gaTranslationP1`/the three `ℙ¹` points — the chapter signals the intent without committing the hint, leaving the Lean / blueprint binding for those substantive objects implicit. For `gaTranslationP1` this is correct (decl deliberately absent, demoted-route-only); for `Ga`/`Gm`/the points it is a real chapter-side gap, since the Lean *does* ship the decls and the iter-166 consumer will reference them.
- **Generality**: matches need. The file's signature `ProjectiveLineBar (kbar : Type u) [Field kbar]` (NOT requiring `[IsAlgClosed kbar]`) is strictly more general than the chapter's "over `k̄` algebraically closed" prose, since the scheme construction itself does not need `IsAlgClosed` (only downstream `Smooth`/geometric-irreducibility instances do). Same observation for `Ga`/`Gm`: their `IsAffine`/`LocallyOfFinitePresentation`/`IsReduced` instances are char-free and need only `Field`. The `[IsAlgClosed]` typeclass enters only in the downstream `ga_smooth`/`gm_smooth` instances. This generality strictly helps downstream consumers — no over-narrowing.
- **Recommended chapter-side actions** (all minor, blueprint-writer's lane for a future iter):
  - Add per-decl `\lean{...}` hints to `def:genus0_base_objects` for `Ga`, `Gm`, `ProjectiveLineBar.zeroPt`, `ProjectiveLineBar.onePt`, `ProjectiveLineBar.inftyPt`, `Gm.onePt` (the chapter currently uses `[expected]` annotations; either drop them in favour of explicit hints or upgrade them to `\lean{...}` blocks once the iter-166 lane fills the bodies).
  - Add a `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` block for the companion fixed-point lemma — currently the chapter has the prose at L1252–1259 but no formal pin, while the Lean file (L381) has the named lemma.
  - Tighten the `def:gaTranslationP1` chapter prose at L967–970 to flag explicitly that the iter-165 scaffold ships *only* the `gmScalingP1` morphism + the `_collapse_at_zero` companion (no `MulAction`-style API at scheme level), per the analogist D3 verdict already recorded in the Lean docstring at L347–349. The chapter currently states the full `σ_×(x, 1) = x` and `σ_×(σ_×(x, λ), μ) = σ_×(x, λμ)` identities, which are mathematically true but are *not* what the Lean ships (and the iter-166 consumer does not need them).

## Severity summary

- **must-fix-this-iter**: none.
- **major**: none.
- **minor**:
  1. Chapter `def:genus0_base_objects` (L910–939) leaves `Ga`, `Gm`, `ProjectiveLineBar.{zeroPt, onePt, inftyPt}`, `Gm.onePt` un-pinned (only `[expected]` annotations in prose); Lean ships all of them. Suggest individual `\lean{...}` hints.
  2. Chapter has no `\lean{...}` block for the load-bearing companion lemma `gmScalingP1_collapse_at_zero`; Lean ships it at L381. Suggest adding a dedicated `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` block (so `sync_leanok` can track it separately from `gmScalingP1`'s own body).
  3. Chapter prose at `def:gaTranslationP1` L967–970 claims full `MulAction`-style identities (`σ_×(x, 1) = x`, associativity); Lean (per analogist D3 verdict, recorded at L347–349 of the Lean docstring) intentionally ships only the bare morphism plus `_collapse_at_zero`. Either trim the chapter prose to the bare-morphism + collapse spec, or note explicitly that the full action-law identities are out of scope for the formalisation.

**Overall verdict**: this Lean file faithfully realises the two `\lean{...}`-pinned blueprint blocks (`def:genus0_base_objects` via `ProjectiveLineBar` and `def:gaTranslationP1` via `gmScalingP1`), the 9 `sorry`s are all plan-allowed scaffold per the iter-165 gate, no false `\leanok` is in place, and the forward-acyclicity of the chain is intact; the only findings are three minor chapter-side coverage gaps for substantive decls the Lean ships but the chapter only references in prose.
