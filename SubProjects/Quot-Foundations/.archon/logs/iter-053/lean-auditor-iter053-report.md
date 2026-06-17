# Lean Audit Report

## Slug
iter053

## Iteration
053

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged
- **excuse-comments**: 0

**Notes:**

- *Line 539–545* (inside `exists_localizationAway_finite_mvPolynomial` body): embedded iteration diary — "iter-018 foundation (proved below, `g`-independent and reusable). L4 was closed iter-021" — stale cross-iter narrative inside an otherwise axiom-clean proof body. Will mislead future readers.

- *Lines 2843–2865* (inside `genericFlatness` sorry body): "SIGNATURE CORRECTNESS FIX (iter-023)" plus "it is reported in task_results + TO_USER for the planner/mathematician to ratify". The iter-023 cross-reference and the report/ratify action are long stale.

- *Lines 2892–2900* (inside `genericFlatness` sorry body): **Stale GAP G1 claim.** The comment says:
  > "GAP G1 — quasicoherent + finite-type ⟹ finite section module … the affine-local identification `F|_W ≅ (Γ(F,W))~` with finiteness preserved is NOT yet available."
  This is factually wrong: `gf_qcoh_fintype_finite_sections` at line 2674 closes G1 axiom-clean (confirmed by `lean_verify`: only `propext`, `Classical.choice`, `Quot.sound`). The sorry body will mislead the next plan or prover agent into believing G1 is still an open gap. **Major.**

- *High heartbeat budgets* (`set_option maxHeartbeats 4000000` at line 485, `1600000` at line 1966, `1000000` at lines 483, 1462, 1700, 1821): eight escalations in one file signals proof fragility. Not a correctness issue but a maintenance concern.

- *`@[reducible] def pullbackModuleAddEquiv`* (line 1358): marking a module-structure definition `reducible` has global synthesis effects; a brief comment documenting why this is needed (for downstream `letI` instance elaboration) would reduce surprise.

---

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 0
- **excuse-comments**: 4 flagged

**Notes:**

- *Line 271* (`glue` body): `sorry` with NOTE "NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be filled". The cocycle hypotheses `_hC1` and `_hC2` **are already present** in the signature — only the body is missing. The NOTE is slightly inaccurate, and "to be filled" qualifies as an excuse-comment on a load-bearing definition.

- *Line 346* (`universalQuotient := sorry`), *line 354* (`tautologicalQuotient := sorry`), *line 493* (`represents := sorry`): each carries "NOTE (scaffold): body to be filled once `glue` lands" / "once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land". These are honest-but-excused sorry stubs on load-bearing declarations.

- *Lines 457 and 485* (`functor` map_id / map_comp sorries): the two internal law-sorries are clearly marked in the docstring as "the sole open obstacle" and are **genuinely honest** — they are not laundered. The `lean_verify` confirms `sorryAx` in `functor` only, with all other new decls clean.

- `opensMap_final`, `pullbackFreeIso`, `pullback_isLocallyFreeOfRank`, `RankQuotient`, `RankQuotient.Rel`, `rqSetoid`, `rqPullback`: all verified axiom-clean (only `propext`, `Classical.choice`, `Quot.sound`).

---

### AlgebraicJacobian/Picard/SectionGradedRing.lean

- **outdated comments**: 1 flagged (minor)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (minor)
- **excuse-comments**: 0

**Notes:**

- *Line 307* (`actRmap_tmul`), *line 310* (`actLmap_tmul`): live linter warnings for unused section variables — `[Module S M]` not used in `actRmap_tmul` and `[Module S N]` not used in `actLmap_tmul`. Easily fixed with `omit … in`.

- *Lines 462–464* (deferred-comment block): "ITER-052 STATUS" and "ITER-053 PROGRESS" labels are iter-specific journal entries embedded in source. Fine as a handoff record this iter, but will become stale noise next iter.

- `RelativeTensorCoequalizer.isColimitCofork` (and all members of the namespace): verified axiom-clean (`propext`, `Classical.choice`, `Quot.sound` only). The coequalizer proof via `TensorProduct.liftAddHom` + `cancel_epi (piMor …)` is clean.

- All declarations in the "launching pad" block (`sheafificationCounitIso`, `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`, `sectionsMul`, `isIso_sheafification_map_iff`, `localIso_toPresheaf_map_unit`, `isIso_sheafification_map_unit`): no sorry, no new axioms.

- `tensorPowAdd` is correctly **absent** rather than backed by a sorry, per the deferred-comment block. No issue.

---

## Must-fix-this-iter

None.

All claimed axiom-clean declarations are genuinely sorry-free (verified by `lean_verify`):
- `gf_localizedModule_baseChange_tensor_comm` — clean.
- `gf_flat_localizedModule_sameBase` — clean.
- `opensMap_final`, `pullbackFreeIso`, `pullback_isLocallyFreeOfRank`, `rqPullback` — clean.
- `RelativeTensorCoequalizer.isColimitCofork` — clean.
- `gf_qcoh_fintype_finite_sections` (G1 assembly) — clean.

`functor` carries exactly 2 `sorryAx` uses (map_id line 473, map_comp line 485), matching the directive claim. `genericFlatness` carries exactly 1 `sorryAx` (line 2926). Both are honest.

No weakened definitions, no Mathlib-parallel APIs, no laundered closures found.

---

## Major

- `FlatteningStratification.lean:2892-2900` — **Stale "GAP G1" claim.** The comment inside the `genericFlatness` sorry body asserts G1 is blocked ("affine-local identification `F|_W ≅ (Γ(F,W))~` with finiteness preserved is NOT yet available"), but `gf_qcoh_fintype_finite_sections` at line 2674 has already closed G1 axiom-clean (verified). This will mislead the next plan agent about the remaining work for `genericFlatness`.

- `FlatteningStratification.lean:539-545` — Iter-diary entries "iter-018 foundation (proved below, `g`-independent and reusable). L4 was closed iter-021" embedded inside a completed proof body. Stale narrative in source.

- `FlatteningStratification.lean:2843-2865` — "SIGNATURE CORRECTNESS FIX (iter-023)" and "it is reported in task_results + TO_USER for the planner/mathematician to ratify" inside the `genericFlatness` sorry body. Both cross-references are stale; the sorry block should be updated to remove the dead action item.

- `GrassmannianQuot.lean:271,346,354,493` — Excuse-comments ("NOTE (scaffold): body to be filled …") on four load-bearing sorry definitions: `glue`, `universalQuotient`, `tautologicalQuotient`, `represents`. These are honest scaffold stubs, but "to be filled" qualifies as excuse-comment language under the auditor's rule. Major (not critical: the sorries are transparent and the project does not falsely claim these closed).

---

## Minor

- `GrassmannianQuot.lean:171-173` — `glue` NOTE says "the body and the module-cocycle hypotheses on `g` are still to be filled" — slightly inaccurate; `_hC1` and `_hC2` are already in the signature, only the body is open.

- `SectionGradedRing.lean:307,310` — Unused section variable linter warnings (`[Module S M]` in `actRmap_tmul`, `[Module S N]` in `actLmap_tmul`). Fix: `omit [Module S M] in theorem actRmap_tmul …` etc.

- `SectionGradedRing.lean:462-464` — "ITER-052 STATUS" / "ITER-053 PROGRESS" iter labels inside a deferred-comment block. Fine now but will age as inline journal.

- `FlatteningStratification.lean` (8 locations) — `set_option maxHeartbeats` values at 1M–4M. Signals deep instance stacks; not blocking but worth periodic review.

- `FlatteningStratification.lean:1358` — `@[reducible] def pullbackModuleAddEquiv`: global effect on instance synthesis; a one-line comment would document the intent.

---

## Excuse-comments (always called out separately)

- `GrassmannianQuot.lean:171` (attached to `glue`): "NOTE (scaffold): the body and the module-cocycle hypotheses on `g` are still to be filled". The body is `sorry`. Severity: major (load-bearing definition).

- `GrassmannianQuot.lean:344-346` (attached to `universalQuotient`): "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." Body is `sorry`. Severity: major (load-bearing).

- `GrassmannianQuot.lean:350-354` (attached to `tautologicalQuotient`): "NOTE (scaffold): rides on `Scheme.Modules.glue`; body to be filled once `glue` lands." Body is `sorry`. Severity: major (load-bearing).

- `GrassmannianQuot.lean:490-493` (attached to `represents`): "NOTE (scaffold): body (the local-to-global inverse construction of Nitsure §1) to be filled once `functor`, `tautologicalQuotient`, and `Scheme.Modules.glue` land." Body is `sorry`. Severity: major (load-bearing).

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 7 (stale G1 gap claim; stale iter-diary in proof; stale iter-023 action; 4 scaffold excuse-comments)
- **minor**: 5 (glue NOTE inaccuracy; 2 unused section vars; ITER-052 label; high heartbeat budgets; @reducible undocumented)
- **excuse-comments**: 4 (glue, universalQuotient, tautologicalQuotient, represents — all classified major above)

**Overall verdict:** The three files are in honest shape — all claimed axiom-clean declarations are verified sorry-free, the two `functor` law-sorries and one `genericFlatness` sorry are genuine and documented — but the `genericFlatness` sorry block carries a stale "GAP G1" claim that now contradicts the already-closed `gf_qcoh_fintype_finite_sections`; this should be corrected in the next prover pass to avoid re-opening settled work.
