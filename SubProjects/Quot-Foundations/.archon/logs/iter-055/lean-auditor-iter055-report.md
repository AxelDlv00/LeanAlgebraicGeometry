# Lean Audit Report

## Slug
iter055

## Iteration
055

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[L538-540] Stale iter-number references inside a mid-proof comment.** The block `-- iter-018 foundation (proved below, `g`-independent and reusable). L4 was closed iter-021; there is no sorry here. The roadmap comment that follows…` bakes old iteration numbers into source code. The statement "there is no sorry here" is accurate and the proof below is closed, so this is not misleading about correctness — but the iter refs are obsolete. Minor.
  - **[L3192] Sole remaining `sorry` in the file** — in the body of `genericFlatness`, per-piece flatness check. The comment at L3119-3126 accurately describes the missing Mathlib ingredient (`IsBaseChange Γ(S,U) id` from an open-immersion flat epimorphism). Honest and well-documented.
  - **All newly closed declarations axiom-clean.** The full `GenericFreeness` namespace (L95-1940), `genericFlatnessAlgebraic` (L1982), all G1/G3/B2 sub-lemmas, and `gf_common_basicOpen_basis` (L2895) carry no sorries. The G3 flat-locality sub-results (G3.1–G3.4, B1–B2.4), `gf_section_span_flat_descent`, and `gf_flat_of_isBaseChange_id` are all sorry-free.
  - **[L1358] `@[reducible]` on `pullbackModuleAddEquiv`.** Marking this `@[reducible]` forces definitional unfolding throughout downstream elaboration. It is a deliberate performance trade-off (enabling `IsScalarTower` instance inference at L1395-1401), but can cause elaboration slowness if the definition is referenced heavily. No correctness issue; noted for maintainability.
  - **[L2895-2912] `gf_common_basicOpen_basis` proof.** Uses `exists_basicOpen_le_affine_inter` from Mathlib; the docstring accurately describes this Mathlib anchor. The ▸-rewrite steps (`hbo.symm ▸ hgbarWi`, `hbo ▸ hgW`) are correct. Declaration is axiom-clean.
  - **[L483-485, L1462-1465, L1700-1701, L1821-1822] `set_option maxHeartbeats` and `set_option synthInstance.maxHeartbeats` overrides.** Each is accompanied by a comment explaining the heavy instance-search situation that necessitates the increase. Appropriate.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **[L170-173] Stale comment in the `glue` section header — MAJOR.** The `/-!` docblock for `Scheme.Modules.glue` states: *"the body and the module-cocycle hypotheses on `g` are still to be filled; the transition data `g` (per-overlap pullback isos) is recorded in the signature, the multiplicative cocycle conditions remain to be added before the construction is closed."* However, looking at the actual `glue` signature (L245-271), both C1 (`_hC1`) and C2 (`_hC2`) hypotheses are **already present** in the parameter list. The comment is stale: it predates the addition of these hypotheses. What remains is only the `sorry` body. Callers reading this section comment will be misled about the current state of the signature.
  - **[L844-845] Stale dependency list in `represents` NOTE.** The docstring says "body to be filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land." As of iter-055 `functor` is fully proved — the NOTE overstates the remaining blockers. Minor.
  - **[L271] `glue` body is `sorry`.** Honest: the construction genuinely needs module-descent infrastructure. The `_hC1`/`_hC2` parameters use leading underscores (not yet consumed), accurately signalling that the body hasn't been filled.
  - **[L347] `universalQuotient` body is `sorry`.** Documented as depending on `glue`. Honest.
  - **[L354-356] `tautologicalQuotient` body is `sorry`.** Documented as depending on `glue`. Honest.
  - **[L847] `represents` body is `sorry`.** Documented as depending on `functor` (now done), `tautologicalQuotient`, and `glue`. The body note is accurate about the remaining dependencies even if `functor` should be removed from the list.
  - **[L769-838] `functor` declaration — fully proved, axiom-clean.** Both `map_id` (L773-791) and `map_comp` (L793-837) are discharged via `Quotient.sound` with explicit iso witnesses and term-mode proof chains. The `map_id` uses `pullbackFreeIso_id` and `(pullbackId).hom.naturality`; the `map_comp` uses `pullbackFreeIso_comp` via the auxiliary `hstar` computation. No sorry.
  - **[L376-384] `RankQuotient` structure fixed at universe `0` (`Scheme.{0}`).** The `functor` return type is `Type 1`. The file comment at L369 correctly explains this was a deliberate universe fix forced by the size of `F : T.Modules`. No issue.
  - **[L449-538] `pullbackObjUnitToUnit_id`, `pullbackFreeIso_id`, `homEquiv_conjugateEquiv_app`, `pullbackObjUnitToUnit_comp`, `pullbackFreeIso_comp` — all axiom-clean.** These are the building blocks for `functor`'s functoriality laws; all carry complete term-mode proofs.

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 minor
- **excuse-comments**: none
- **notes**:
  - **[L450-467] `relTensorDomainPresheaf` — fully proved, axiom-clean.** The presheaf `obj U = P.obj U ⊗[ℤ] Q.obj U`, `map f = TensorProduct.map (restriction_P f) (restriction_Q f)`. The `map_id` and `map_comp` laws are proved by `TensorProduct.induction_on`; each case closes by `simp` (plus `rfl` on the `tmul` case) or `simp only [map_add, ...]`. Correct.
  - **[L461, L465] `simp; rfl` pattern after `TensorProduct.induction_on` in `map_id`/`map_comp`.** After `simp`, the `tmul` case leaves a goal of the form `m ⊗ₜ[ℤ] n = m ⊗ₜ[ℤ] n` (identity restriction maps reduce to id). The `rfl` closes it. This works but is fragile: if `simp`'s normal form changes upstream, `rfl` could fail. Consider `simp [TensorProduct.map_tmul]` or closing the goal inline. Minor.
  - **[L218-258] `isIso_sheafification_map_iff`, `localIso_toPresheaf_map_unit`, `isIso_sheafification_map_unit` — all axiom-clean.** The proofs correctly apply `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`, `toPresheaf_map_sheafificationAdjunction_unit_app`, and `GrothendieckTopology.W_toSheafify`.
  - **[L260-421] `RelativeTensorCoequalizer` namespace — all axiom-clean.** `isColimitCofork` is the primary result: universal property via `TensorProduct.liftAddHom` (existence) and `cancel_epi (piMor ...)` (uniqueness). No sorry.
  - **[L469-584] Block-comment deferred section `tensorPowAdd`.** This is correctly written as a Lean `/- ... -/` block comment, NOT as a sorry-backed declaration. The handoff accurately documents the single missing ingredient (strong-monoidality of module sheafification) and the three blocked routes. No issue.
  - **[L79] `private abbrev MonoidalPresheaf`.** The comment "This is *definitionally* `X.PresheafOfModules`" is accurate. The `private abbrev` pattern is used correctly to provide the form expected by `PresheafOfModules.monoidalCategory`.

---

## Must-fix-this-iter

*(None.)*

No declaration in the three audited files uses an axiom on a non-trivial claim, carries a laundered sorry (sorry hidden behind a `\leanok`), weakens its type below what the docstring claims, or uses a structurally different stand-in definition. All sorries are honest open-math gaps.

---

## Major

- `GrassmannianQuot.lean:~L170-173` — The `/-! ## Gluing…` section docblock states the multiplicative cocycle conditions "remain to be added," but both `_hC1` and `_hC2` are already present in the `glue` signature (L252-269). The comment predates the addition of those hypotheses and now incorrectly describes the signature's state. Readers will expect that the cocycle hypotheses are absent when they are not. Should be updated to "body to be filled; signature (including C1/C2 hypotheses) is complete."

---

## Minor

- `GrassmannianQuot.lean:~L844` — `represents` NOTE lists `functor` as a remaining dependency ("once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land"), but `functor` is now fully proved. List should be reduced to `tautologicalQuotient` and `Scheme.Modules.glue`.
- `FlatteningStratification.lean:~L538-540` — Mid-proof comment references "iter-018 foundation" and "L4 was closed iter-021". These iter-number references are stale historical notes; they do not affect correctness but should be replaced with stable technical descriptions if they serve a documentation purpose.
- `SectionGradedRing.lean:L461,L465` — `simp; rfl` on the `tmul` case of `TensorProduct.induction_on` is slightly fragile (depends on `simp` leaving exactly one goal of the form `rfl`). No current correctness issue; prefer closing inline with an explicit lemma if robustness is desired.

---

## Excuse-comments (always called out separately)

*(None.)* No declaration in the three audited files carries an excuse-comment ("temporary", "placeholder", "will fix later", "wrong but works"). The `NOTE (scaffold)` comments on `glue`, `universalQuotient`, `tautologicalQuotient`, and `represents` are honest dependency-tracking notes, not admissions of wrong definitions.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (stale comment misstating the `glue` signature)
- **minor**: 3 (stale dep list in `represents`; old iter refs in FS; fragile `simp; rfl`)
- **excuse-comments**: 0

**Overall verdict**: All three headline closes (`Grassmannian.functor`, `gf_common_basicOpen_basis`, `relTensorDomainPresheaf`) are genuinely sorry-free and axiom-clean; the five documented sorries (GrassmannianQuot L271/347/356/847, FlatteningStratification L3192) are honest open-math gaps; one major stale comment in `GrassmannianQuot.lean` misstates what the `glue` signature currently contains and should be corrected.
