# Lean Audit Report

## Slug
aud251

## Iteration
251

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/TensorObjSubstrate.lean

- **outdated comments**: 2 flagged (module status header; sub-module layout bullet)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (`backward.isDefEq.respectTransparency false` pragma; `maxHeartbeats` bumps are load-bearing and documented)
- **excuse-comments**: none
- **notes**:
  - L44 (`## Status (current)` docstring block): says "There is now ONE tracked typed-`sorry` residual: the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`, ~L699)". As of this iter there are **THREE**: also `sheafifyTensorUnitIso_hom_natural` (sorry at L1954) and `pullbackTensorMap_natural` (sorry at L1983). The header count is stale.
  - L123 (sub-module layout bullet for this file): "public API: … `exists_tensorObj_inverse` (sorry)" — does not mention the two new sorries added this iter. Stale.
  - **`pullbackValIso_hom_natural` (L1879)**: CLOSED axiom-clean. Body is genuine `erw`-naturality paste; `maxHeartbeats 1600000` at L1872 is load-bearing (documented). No issues.
  - **`sheafifyTensorUnitIso_hom_eq` (L1853, private)**: CLOSED, body `rfl`. Correct; serves as a carrier-normalisation bridge consumed by the next helper.
  - **`sheafifyTensorUnitIso_hom_natural` (L1914, sorry at L1954)**: honest `sorry` — body does partial work (`simp only [MonoidalCategory.tensorHom_def]` expands, then hits the exact identified blocker: `▷`/`◁` in the goal come from a local `MonoidalCategoryStruct` that is defeq-but-not-syntactic to the canonical instance, so Mathlib whisker lemmas do not fire). Comment at L1944–1953 precisely names the blocker and the next step ("re-state the whiskers via the canonical instance"). NOT laundered. `maxHeartbeats 1600000` at L1909 is partly wasted (sorry fires first), but defensible.
  - **`pullbackTensorMap_natural` (L1960, sorry at L1983)**: honest `sorry` — body expands `pullbackTensorMap` and `tensorObj_functoriality` via `simp only`, then hits Step-S3 dependency. Comment at L1975 explicitly names that S3 = `sheafifyTensorUnitIso_hom_natural` "its presheaf residual is the one open `sorry`". Transitive dependency is clearly acknowledged. NOT laundered.
  - L1821–1823: **duplicate comment block** — an earlier draft of the `restrictScalarsId_map` strip explanation (lines 1821–1823) was retained verbatim immediately before the expanded successor comment at L1824–1832. Scratch leftover.
  - L1654: `set_option backward.isDefEq.respectTransparency false in` before `epsilonPresheafToSheafUnit` — non-standard pragma that changes isDefEq transparency for instance synthesis. Documented as necessary (`CommRing` instance on `(restrictScalars f).obj 𝟙_`). Load-bearing but worth tracking in case it hides latent diamonds.
  - All `maxHeartbeats` bumps (L1691 ×1600000, L1733 ×3200000, L1872 ×1600000) are load-bearing with specific justifications; no concern.
  - No deprecated `Sheaf.val` misuses, no axiom laundering, no weakened-wrong definitions found.

---

### AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean

- **outdated comments**: 1 flagged (module header falsely marks `dual_isLocallyTrivial` "CLOSED")
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (planner-strategy blocks embedded inside docstrings)
- **excuse-comments**: none
- **notes**:
  - **`dual_restrict_iso` (L228, sorry at L254)**: honest `sorry`. Steps 1–3 are concrete tactic steps (L232–252 use `restrictFunctorIsoPullback`, `sheafificationCompPullback`, `mapIso`, and the H1 `leftAdjointUniq` assembly). The residual at L254 is the single identified presheaf goal `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`, documented inline. NOT laundered. The module header at L15–21 correctly says "**PARTIAL**" for this declaration.
  - **`dual_isLocallyTrivial` (L330–339)**: The body contains NO explicit `sorry` — it calls `dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso`. Since `dual_restrict_iso` has a sorry at Step 4, this compiles (the sorry produces an `Iso` axiomatically) but is mathematically incomplete. The module header at **L25 calls this "**CLOSED** (iter-251)"** without any transitive-sorry caveat. This is a **false "CLOSED" claim** per the directive's focus area (a). The declaration will remain mathematically unproven until `dual_restrict_iso` Step 4 is closed.
  - L293 (within `dual_isLocallyTrivial`'s embedded planner-strategy block): the heading reads "Uses (all CLOSED):" but the list includes `lem:dual_restrict_iso → dual_restrict_iso (this file, §A above — **STUB**)`. The "all CLOSED" header is internally inconsistent with the "STUB" annotation for one dep. Minor documentation inconsistency within a planning note.
  - **`unitDualSectionEquiv` (L61–98)**: CLOSED; substantial linear-equiv construction. `left_inv` proof uses `globalSMul_hom_apply` + `naturality_apply` + `unit_map_one`. Structure is correct; `HEq`-free. No issues.
  - **`dualUnitIsoGen` (L103–137)**: CLOSED; uses `PresheafOfModules.isoMk` with `naturality_apply`. Naturality proof correctly reduces to `hdt` (eval-at-`1` through `homAppHEq`). No issues.
  - **`presheafDualUnitIso` (L261–265)**: CLOSED; one-liner instantiating `dualUnitIsoGen`. Correct.
  - **`dual_unit_iso` (L272–277)**: CLOSED axiom-clean; mirrors `tensorObj_unit_iso` with `presheafDualUnitIso` in place of the left unitor. Correct.
  - **`homOfLocalCompat` (L411–420)**: honest `sorry`; the signature is correctly typed (uses `HEq` for the compatibility condition, justified because the double-restriction objects are propositionally but not definitionally equal). The two-step construction (ab-sheaf gluing + `homMk` promotion) is documented. NOT laundered.
  - L159–227, L287–327, L369–410: **planner-strategy blocks embedded inside docstrings** using nested `/- ... -/` inside `/-- ... -/`. Syntactically valid in Lean 4 (nested block comments). These construction notes become part of the public-facing documentation. Unusual but not incorrect.
  - No deprecated `Sheaf.val` misuses. No axiom laundering. No weakened-wrong definitions.

---

## Must-fix-this-iter

- `DualInverse.lean:25` — module docstring claims `dual_isLocallyTrivial` is "**CLOSED** (iter-251)" without transitive-sorry caveat. `dual_isLocallyTrivial` (L330–339) calls `dual_restrict_iso` which has a sorry at L254 (Step 4); it compiles only because that sorry produces an `Iso` axiomatically. Describing it as "CLOSED" without caveat misrepresents the proof status to every downstream reader and the review agent. **Why must-fix**: false "CLOSED" claim on a load-bearing lemma (`dual_isLocallyTrivial` feeds `exists_tensorObj_inverse`). Fix: change "**CLOSED**" to "**TRANSITIVELY PARTIAL** (depends on `dual_restrict_iso` Step-4 sorry at L254)" or equivalent.

---

## Major

- `TensorObjSubstrate.lean:44` — `## Status (current)` block asserts "There is now ONE tracked typed-`sorry` residual: the deferred `⊗`-inverse lane (`exists_tensorObj_inverse`, ~L699)". After this iter's edits there are **THREE** sorries in the file: also `sheafifyTensorUnitIso_hom_natural` (L1954) and `pullbackTensorMap_natural` (L1983). Any reader of the header counts and acts on one sorry is misinformed.

- `TensorObjSubstrate.lean:123` — Sub-module layout bullet lists "public API: … `exists_tensorObj_inverse` (sorry)" with no mention of the two new sorry-bearing declarations added this iter. Stale inventory.

---

## Minor

- `DualInverse.lean:293` — Inside the `dual_isLocallyTrivial` planner-strategy block (embedded in the docstring), the heading "Uses (all CLOSED):" introduces a dep list that explicitly marks `dual_restrict_iso` as "STUB". The "all CLOSED" assertion is inconsistent with "STUB". Minor internal inconsistency within a planning note.

- `TensorObjSubstrate.lean:1821–1823` — Duplicate comment block retained from an earlier draft of the `restrictScalarsId_map`-strip explanation. Lines 1821–1823 are immediately superseded by the expanded version at L1824–1832. Scratch leftover.

- `TensorObjSubstrate.lean:1654` — `set_option backward.isDefEq.respectTransparency false in` is a non-standard pragma (alters isDefEq transparency for instance synthesis). Documented as load-bearing (CommRing instance on `(restrictScalars f).obj 𝟙_`). Flag for awareness: if the instance hierarchy changes, this pragma may silently accept a diamond or stop being necessary.

- `TensorObjSubstrate.lean:1909` — `maxHeartbeats 1600000` applied before `sheafifyTensorUnitIso_hom_natural`, which has a sorry at L1954. The sorry discharges the remaining goal early; the heartbeat budget above is partially wasted. Harmless, but noting the asymmetry.

- `DualInverse.lean` (multi-location: L159–227, L287–327, L369–410) — Planner-strategy blocks embedded as nested `/- ... -/` inside `/-- ... -/` docstrings for `dual_restrict_iso`, `dual_isLocallyTrivial`, and `homOfLocalCompat`. Syntactically valid and informative, but they cause prover/planning notes to appear as public API documentation. Consider moving to `-- `  comments inside the tactic block or to a separate planning section outside the docstring.

---

## Excuse-comments (always called out separately)

None. The four documented `sorry` residuals all have specific technical blockers named and an identified next step. None of the sorry bodies contains language of the form "will fix later", "placeholder", "wrong but works", or similar. They are honest, typed stubs.

---

## Severity summary

- **must-fix-this-iter**: 1 — false "CLOSED" claim on `dual_isLocallyTrivial` at `DualInverse.lean:25`
- **major**: 2 — stale sorry-count in `TensorObjSubstrate.lean` header (L44, L123)
- **minor**: 5 — planner-in-docstring pattern; duplicate comment; `backward.isDefEq.respectTransparency` pragma; wasted `maxHeartbeats` before sorry; Uses-all-CLOSED inconsistency
- **excuse-comments**: 0

**Sorry honesty verdict**: All four sorry-bearing declarations (`sheafifyTensorUnitIso_hom_natural` L1954, `pullbackTensorMap_natural` L1983, `dual_restrict_iso` L254, `homOfLocalCompat` L420) carry honest, typed sorries with documented residuals and identified next steps. None is laundered.

**Overall verdict**: Two files are in good structural shape with all four sorries honestly typed; the single must-fix is a false "CLOSED" label on `dual_isLocallyTrivial` in the DualInverse module header — it compiles transitively through `dual_restrict_iso`'s sorry and must be relabelled "TRANSITIVELY PARTIAL" to accurately represent project state.
