# Lean Audit Report

## Slug
ts213

## Iteration
213

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 6 flagged
- **suspect definitions**: 2 flagged (transitively sorry-dependent proofs presented as closed)
- **dead-end proofs**: 1 flagged (`isLocallyInjective_whiskerLeft_of_W`)
- **bad practices**: 1 flagged (dead hypotheses in non-protected signature)
- **excuse-comments**: 2 flagged

**notes**:

- **Line 419** (`isLocallyInjective_whiskerLeft_of_W`): `sorry` body on a load-bearing lemma. This is the ROUTE (d) residual: the theorem is correctly stated and the mathematical justification (stalkwise `id ⊗ g_x` is iso since `g_x` is a stalkwise iso for `g ∈ J.W`) is coherent. The two missing Mathlib ingredients (d.1: module-level stalk characterisation of `J.W`; d.2: commutation of stalk with presheaf-of-modules tensor) are correctly identified in the docstring. The `sorry` is substantive and correctly quantified — not vacuous, not overfit. It IS load-bearing: `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`, and therefore `tensorObj_assoc_iso` all depend on it.

- **Lines 427–436** (`W_whiskerLeft_of_W`): Syntactically a genuine proof (no top-level `sorry`), but it calls `isLocallyInjective_whiskerLeft_of_W` (sorry). The proof structure is logically correct: it rewrites via `W_iff_isLocallyBijective` and applies the two half-lemmas. It is however a **disguised sorry** — it presents as closed without alerting downstream consumers that it is sorry-dependent. No inline annotation warns of this.

- **Lines 440–452** (`W_whiskerRight_of_W`): Syntactically a genuine proof. The braiding-conjugate argument is mathematically sound: `g ▷ F = β_{M,F}.hom ≫ (F ◁ g) ≫ β_{N,F}.inv` follows from braiding naturality (`BraidedCategory.braiding_naturality_left`), and `J.W.cancel_left/right_of_respectsIso` reduces to `W_whiskerLeft_of_W`. The tactic chain `[← Category.assoc, ← braiding_naturality_left, Category.assoc, Iso.hom_inv_id, Category.comp_id]` is the standard braiding-conjugation pattern. The argument is sound. It is, however, transitively sorry-dependent through `W_whiskerLeft_of_W`.

- **Lines 615–658** (`tensorObj_assoc_iso` docstring): **Severely stale.** The docstring describes iter-212 state and a flatness-based proof strategy that the body has completely abandoned. Specific mismatches:
  - Line 622: "iter-212 status (typed `sorry`; **go/no-go bridge CLEARED, a NEW residual located**)" — the body is now a sorry-free 3-step composite (transitively sorry-dependent, but not a top-level sorry).
  - Lines 627–628: Step 1 cites "`W_whiskerRight_of_flat`" as the tool. The body uses `W_whiskerRight_of_W` (flatness-free ROUTE (d)).
  - Lines 631–632: Step 3 cites "`W_whiskerLeft_of_flat`" (M flat). The body uses `W_whiskerLeft_of_W`.
  - Lines 641–658: The "genuine residual is now the flatness feeding steps 1 and 3" paragraph describes an obstacle that ROUTE (d) has bypassed. This entire paragraph is dead context. It also describes "carrier friction" (`X.ringCatSheaf.val` vs `X.presheaf ⋙ forget₂`) as an open obstacle — but the body resolves it via `letI instMS = inferInstanceAs (...)`.
  - Line 639: Claims "`W_whiskerRight_of_flat` is also closed axiom-clean" as a newly-closed helper — this is accurate, but irrelevant to the current body.

- **Lines 663–666** (`tensorObj_assoc_iso` body comment): "the locally-trivial hypotheses are not even consumed ... but are retained to match the blueprint pin." Consistent and accurate. The `hM`, `hN`, `hP` are indeed unused in the body (grepping the body for any use of these identifiers finds nothing). The justification cites "blueprint pin," but the comment also says "(decl unprotected)" — so the declaration is NOT in `archon-protected.yaml`. The dead hypotheses cannot be justified by the frozen-signature rule; the reason given is voluntary blueprint-pin matching for a mutable decl.

- **Line 669–671** (`letI instMS = inferInstanceAs (...)`): The `rfl`-defeq bridge between `Sheaf.val X.ringCatSheaf` and `X.presheaf ⋙ forget₂ CommRingCat RingCat` is a known Lean carrier-friction pattern. The comment at lines 667–668 explains why it is needed. This is legitimate and not suspicious.

- **Lines 497–498** (`tensorObj` docstring): "iter-202 Lane TS scaffold: the body is a typed `sorry`; the iter-203+ body lifts..." — the actual body is a real definition (sheafification applied to `PresheafOfModules.Monoidal.tensorObj`). Not a sorry. Stale excuse-claim.

- **Lines 511–512** (`tensorObj_functoriality` docstring): Same issue — "the body is a typed `sorry`; the iter-203+ body inherits the morphism action..." — the actual body maps `MonoidalCategory.tensorHom` through sheafification. Not a sorry.

- **Lines 37–46** (file-level module docstring): "Status (iter-202 Lane TS — file-skeleton scaffold)" and "the 4 blueprint-pinned declarations carry ... a `sorry` body" — now inaccurate for `tensorObj`, `tensorObj_functoriality`, `tensorObj_assac_iso`, and `tensorObjOnProduct`, all of which have real bodies.

- **Lines 876–880** (`tensorObjOnProduct` docstring): "iter-202 Lane TS scaffold: typed `sorry`." The body is a real constructor using `tensorObj` and `tensorObj_isLocallyTrivial`. Not a sorry. However, it is transitively sorry-dependent (via `tensorObj_isLocallyTrivial` → `tensorObj_restrict_iso`).

- **Lines 829** (`tensorObj_restrict_iso`): Top-level `sorry` — known/expected off-path residual. Body comment provides the correct corrected decomposition with ~200–300 LOC estimate and 4 absent Mathlib ingredients (H1, H2). Accurate and detailed.

- **Lines 872** (`exists_tensorObj_inverse`): Top-level `sorry` — known/expected. Docstring accurately describes the construction needed.

- **Lines 911** (`addCommGroup_via_tensorObj`): Top-level `sorry` — known/expected. Docstring is accurate.

- **The flat-whiskering section** (`isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`, `W_whiskerRight_of_flat`, `restrictScalarsLaxMonoidal`): All are syntactically genuine proofs with no `sorry`. The `restrictScalarsLaxMonoidal` instance and the two flat-whisker lemmas are correct and complete. They are now off the critical path for `tensorObj_assac_iso` (which uses the ROUTE (d) `_of_W` variants), but they stand as valid supporting infrastructure.

---

## Must-fix-this-iter

- `TensorObjSubstrate.lean:419` — `sorry` body on `isLocallyInjective_whiskerLeft_of_W`. Why must-fix: this is the single remaining residual of ROUTE (d); `W_whiskerLeft_of_W`, `W_whiskerRight_of_W`, and `tensorObj_assac_iso` all transitively depend on it, making the "closed" associator a fiction until this lands.

- `TensorObjSubstrate.lean:622–658` — Docstring of `tensorObj_assac_iso` describes a FLATNESS-based iter-212 proof strategy ("W_whiskerRight_of_flat", "genuine residual is the flatness feeding steps 1 and 3") and an iter-212 `sorry` status, while the body implements ROUTE (d) (flatness-free, `W_whiskerRight_of_W`/`W_whiskerLeft_of_W`, no sorry at top level). A reader of the docstring would reconstruct a completely different proof and misdiagnose the current residual. Why must-fix: the docstring actively misinforms about the proof strategy, the residual, and the completion status.

- `TensorObjSubstrate.lean:498` — `tensorObj` docstring says "the body is a typed `sorry`" — body is a real definition. Why must-fix: a stale "typed sorry" claim on a load-bearing definition is an excuse-comment grade misdescription.

- `TensorObjSubstrate.lean:512` — `tensorObj_functoriality` docstring says "the body is a typed `sorry`" — body is a real definition. Why must-fix: same as above.

---

## Major

- `TensorObjSubstrate.lean:427–436` (`W_whiskerLeft_of_W`) — Presented as a closed proof; is a disguised sorry (calls `isLocallyInjective_whiskerLeft_of_W`). No inline annotation warns of the sorry dependency. Downstream consumers (e.g. `tensorObj_assac_iso`) see a non-sorry call chain and may believe the associator is axiom-clean.

- `TensorObjSubstrate.lean:440–452` (`W_whiskerRight_of_W`) — Same issue: closed-looking proof, transitively sorry-dependent. The braiding argument is mathematically sound; the issue is the undisclosed sorry dependency.

- `TensorObjSubstrate.lean:660–661` — Dead hypotheses `hM`, `hN`, `hP` in `tensorObj_assac_iso`. The body comment acknowledges they're unused, cites "blueprint pin" as justification, but also says "(decl unprotected)". If the declaration is genuinely unprotected, the justification for dead hypotheses is weak: blueprint pins can be updated. The signature should either be slimmed (to remove the hypotheses entirely, since ROUTE (d) needs none) or the declaration should be added to `archon-protected.yaml` to make the frozen-signature rationale explicit.

- `TensorObjSubstrate.lean:37–46` (file module docstring) — "Status (iter-202 Lane TS — file-skeleton scaffold)" is a stale status header. The file is no longer a scaffold: multiple declarations have real bodies. The statement "each of the 4 pinned declarations carries ... a `sorry` body" is now incorrect for at least 3 of the 4.

---

## Minor

- `TensorObjSubstrate.lean:641–658` (stale obstacle paragraph in `tensorObj_assac_iso` docstring) — The entire paragraph ("genuine residual is the flatness feeding steps 1 and 3", "carrier friction: X.ringCatSheaf.val is only defeq...") describes an approach abandoned by ROUTE (d). It is not just stale — it actively describes the body incorrectly, explaining an obstacle the body has already resolved. Should be excised and replaced with a brief ROUTE (d) summary.

- `TensorObjSubstrate.lean:877` (`tensorObjOnProduct` docstring) — "iter-202 Lane TS scaffold: typed `sorry`" — body is a real constructor. Minor because the transitive sorry dependency (via `tensorObj_isLocallyTrivial` → `tensorObj_restrict_iso`) makes the body's sorry-status partially correct at a semantic level, but the description is wrong syntactically.

- `TensorObjSubstrate.lean:853–855` (`tensorObj_isLocallyTrivial`) — Uses `tensorObj_restrict_iso` (sorry at line 829). The lemma has a real proof structure but is transitively sorry-dependent. No annotation at the call site warns that the proof depends on an off-path sorry.

---

## Excuse-comments (always called out separately)

- `TensorObjSubstrate.lean:498`: "the body is a typed `sorry`; the iter-203+ body lifts…" (attached to `tensorObj`, which is a load-bearing definition consumed by nearly every subsequent declaration). The body is NOT a sorry. Severity: **must-fix-this-iter** (stale excuse-claim on a load-bearing definition).

- `TensorObjSubstrate.lean:512`: "the body is a typed `sorry`; the iter-203+ body inherits the morphism action…" (attached to `tensorObj_functoriality`). The body is NOT a sorry. Severity: **must-fix-this-iter**.

---

## Severity summary

- **must-fix-this-iter**: 4
  1. `isLocallyInjective_whiskerLeft_of_W:419` — sorry on the ROUTE (d) residual
  2. `tensorObj_assac_iso` docstring:622–658 — describes flatness/iter-212 strategy when body implements ROUTE (d), no sorry
  3. `tensorObj` docstring:498 — stale "typed sorry" excuse-claim
  4. `tensorObj_functoriality` docstring:512 — stale "typed sorry" excuse-claim

- **major**: 4
  1. `W_whiskerLeft_of_W:427` — disguised sorry (calls `isLocallyInjective_whiskerLeft_of_W`)
  2. `W_whiskerRight_of_W:440` — disguised sorry transitively
  3. `tensorObj_assac_iso` dead hypotheses `hM hN hP`:660 — unprotected decl, unused args, "blueprint pin" justification ungrounded
  4. File module docstring:37 — "iter-202 scaffold, all bodies sorry" is stale

- **minor**: 3
  1. Stale flatness-obstacle paragraph in `tensorObj_assac_iso` docstring:641–658
  2. `tensorObjOnProduct` docstring:877 — "typed sorry" on a real constructor
  3. `tensorObj_isLocallyTrivial:853` — no annotation of transitive sorry dependency

- **excuse-comments**: 2 (lines 498 and 512 — both counted under must-fix-this-iter above)

**Overall verdict**: The file's new proof work (ROUTE (d) associator, flatness-free whiskering lemmas) is mathematically coherent and well-structured, but the docstring for `tensorObj_assac_iso` is severely stale — it describes the wrong proof strategy and wrong completion status — and two docstrings on closed defs (`tensorObj`, `tensorObj_functoriality`) still claim "typed sorry" bodies. The genuine residual (`isLocallyInjective_whiskerLeft_of_W`) is correctly identified and documented; the cascade of sorry-dependence through `W_whiskerLeft/Right_of_W` into `tensorObj_assac_iso` is real but undisclosed at call sites.
