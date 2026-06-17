# Lean Audit Report

## Slug
iter045

## Iteration
045

## Scope
- files audited: 1 (directive scoped to single file)
- files skipped per directive: 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (linter violations on `set_option maxHeartbeats`)
- **excuse-comments**: none
- **notes**:
  - **Lines 1068–1108** — second comment block (`tile_scalar_compat / tile_section_comparison / tile_section_localization — PARTIAL this iter`) is a stale progress note from iter-043/044. Its headline claim at line 1090 ("**NEXT, full assembly now unblocked.**") directly contradicts the current W1–W3 blocker comment at lines 1003–1066 ("BLOCKED on compounding Lean-engineering walls (iter-045)"). Having both blocks in the file with no separation or supersession notice actively misleads any reader about the current assembly status.
  - **Lines 879–881 and 977–978** — both `set_option maxHeartbeats 1000000 in` usages trigger the Mathlib `linter.style.maxHeartbeats` warning ("Please, add a comment explaining the need…"). The explanatory comment is placed *before* the `set_option` line in both cases; the linter requires it *after*. Fix: swap comment and `set_option` or duplicate it in the inline position.
  - **Multiple lines** — 8 "line exceeds 100 character limit" style warnings (lines 879, 929, 932, 968, 975, 978, 979, 983). Low severity, but they accumulate and would block a Mathlib-style CI.

---

## Focus-area findings (directive-specified)

### 1. Soundness of the five new declarations

All five pass `#print axioms` checks and the file has zero errors from the LSP.

**`modulesRestrictBasicOpen_smul_eq'`** (lines 756–764) — `:= rfl`.  
Genuine definitional equality. It is the verbatim generalisation of the prior `modulesRestrictBasicOpen_smul_eq` (`:= rfl` at lines 740–750) from the fixed open `⊤` to an arbitrary open `V`. Both sides reduce to the same underlying `SMul` operation through the same `show`-coercion definitional path. No kernel-soundness trap.  
Axioms: `{propext, Classical.choice, Quot.sound}`. ✓

**`appIso_inv_res`** (private, lines 913–918) — `rw [Scheme.Hom.appIso_inv_naturality f (homOfLE h).op]; congr 1`.  
Genuine. After the rewrite, the residual goal is `Y.presheaf.map A.op = Y.presheaf.map B.op` where `A B : f ''ᵁ U' ≤ f ''ᵁ U` — a subsingleton morphism type in the thin opens-category. The `congr 1` produces this subsingleton goal and it auto-closes by proof irrelevance (propext). Not a spurious auto-close: it is correct by the thin-category structure of `Opens`. ✓

**`appIso_inv_res_assoc`** (private, lines 922–928) — `rw [← Category.assoc, appIso_inv_res, Category.assoc]`.  
Trivially correct rewrite chain. ✓

**`tile_section_ring_identity'`** (lines 934–973) — `calc` proof.  
Genuine. The three-step calc chain:
1. Factors the `D(g)-to-D(g)` restriction through the `V = ⊤` case via `← Functor.map_comp; congr 2` — the `congr 2` closes opens-category subsingleton goals.
2. Substitutes `base := tile_section_ring_identity` (the `V = ⊤` identity, already verified).
3. Pushes the `V`-restriction through the two open-immersion `appIso` isos via `appIso_inv_res` / `appIso_inv_res_assoc`, using `Subsingleton.elim` to eliminate the `⊤ ≤ ⊤` identity map. No subgoal left open; the `simp only [Category.assoc]` + two rewrites close the goal completely.  
Axioms: `{propext, Classical.choice, Quot.sound}`. ✓

**`tile_scalar_compat'`** (lines 986–1001, under `set_option maxHeartbeats 1000000`) — `rw [...]; rw [...]; rw [modulesRestrictBasicOpen_smul_eq']; congr 1; have hG := ...; simp only [...] at hG; convert hG using 2`.  
Genuine. The proof is the exact same template as `tile_scalar_compat` (lines 890–907), with `modulesRestrictBasicOpen_smul_eq'` (arbitrary `V`) replacing `modulesRestrictBasicOpen_smul_eq` (`V = ⊤`), and `tile_section_ring_identity'` replacing `tile_section_ring_identity`. The `convert hG using 2` produces goals at depth 2 about ring-map composites over opens-category morphisms; at that depth all remaining subgoals are thin-category propositional equalities that close automatically. This is the same verified `convert ... using 2` pattern as `tile_scalar_compat`, which was already `#print axioms`-clean in iter-044.  
Axioms: `{propext, Classical.choice, Quot.sound}`. ✓  
No spurious subsingleton or unsound kernel closure detected in any of the five declarations.

### 2. `set_option maxHeartbeats 1000000` analysis

The bump is **justified**, not masking a fragile proof. The `convert ... using 2` goal involves unification through the `modulesSpecToSheaf` functor, which wraps module structures through multiple restriction/localisation layers; `whnf` must unfold `modulesSpecToSheaf.obj`, `restrict_obj`, and the associated `show`-coercions to match carriers. The same bump was required for the `V = ⊤` case (`tile_scalar_compat`) and that proof was verified clean by `#print axioms` in iter-044.

The performance is deterministic, not flaky: both invocations carry identical explanatory prose and both verify clean. The proof is not fragile; it is genuinely expensive for the elaborator.

**However**: both `set_option maxHeartbeats 1000000 in` usages trigger `linter.style.maxHeartbeats` because the comment explaining the need appears *before* the `set_option` line, while the linter expects it *after*. This is a **minor** style violation that would fail Mathlib CI.

### 3. The W1–W3 blocker comment (lines 1003–1066): accuracy

The description is **accurate** and does not over-state or mis-attribute:

- **W1** ("noncomputable aux from `letI`") — correctly describes a real Lean 4 limitation: `letI` for a `Spec`-dependent instance inside a `lemma` body causes codegen to hoist a noncomputable auxiliary definition, which is then rejected. The proposed workaround (full inline term) is technically sound.
- **W2** ("`SMul R (tile-carrier)` not synthesized") — correctly identifies that only `Module R_g M` is available on the tile carrier; without an explicit `[SMul R M]` instance, `@IsScalarTower.of_algebraMap_smul` cannot be applied. The inline-SMul workaround described is the standard fix.
- **W3** ("`whnf` timeout at 4,000,000 heartbeats") — consistent with the observed heartbeat cost of `tile_scalar_compat'` (which itself needs 1,000,000 heartbeats just for the scalar lemma, far short of the full assembly).

The comment does not over-state: it correctly labels these as Lean-engineering walls, not mathematical ones, and the proposed resolution path (one large inline term, no `letI`/`have` for `Spec`-dependent instances) is the standard technique for this class of Lean 4 typeclass threading problem.

### 4. Stale / outdated content

**Lines 1068–1108** — this second comment block is a carried-over progress note from iter-043/044. Its key claims are now stale:

- Line 1069: "tile_scalar_compat / tile_section_comparison / tile_section_localization — PARTIAL this iter" — "this iter" was iter-043; the phrase is now meaningless/misleading.
- Line 1090: "**NEXT, full assembly now unblocked.**" — directly contradicted by the iter-045 W1–W3 blocker comment above it.

The two comment blocks together give a reader contradictory signals about whether `tile_section_localization` is blocked. The old block should be deleted or clearly marked as superseded.

---

## Must-fix-this-iter

None.

---

## Major

- `QcohTildeSections.lean:1068–1108` — Stale iter-043/044 comment block claiming "full assembly now unblocked" directly contradicts the current iter-045 W1–W3 blocker documentation. A reader of the file receives contradictory status signals about `tile_section_localization`. Should be deleted; the W1–W3 block at lines 1003–1066 is the accurate current state.

---

## Minor

- `QcohTildeSections.lean:881` — `set_option maxHeartbeats 1000000 in` triggers `linter.style.maxHeartbeats`: explanatory comment must follow (not precede) the `set_option` line to satisfy the Mathlib linter.
- `QcohTildeSections.lean:977` — same `linter.style.maxHeartbeats` violation as line 881 on the `tile_scalar_compat'` instance.
- `QcohTildeSections.lean:879,929,932,968,975,978,979,983` — 8 lines exceed the 100-character style limit (`linter.style.longLine`). Not a soundness issue but would fail Mathlib-style CI if the project adopts it.
- `QcohTildeSections.lean:1069` — "PARTIAL this iter" in the old comment block is an ambiguous temporal reference (iter-043 "this iter" in an iter-045 context). Even if the block is retained, this phrasing should be updated to name the iteration explicitly.

---

## Excuse-comments (always called out separately)

None. The W1–W3 comment block is a technically accurate engineering limitation note, not an excuse-comment admitting wrong code. No declaration carries a body accompanied by "wrong but works", "placeholder", "TODO replace", or equivalent language.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 4 (2 linter violations + 1 multi-line style cluster + 1 ambiguous temporal reference in stale comment)
- **excuse-comments**: 0

Overall verdict: the five new declarations are all axiom-clean and kernel-sound; the single actionable issue is the stale iter-043/044 comment block that contradicts the current assembly-blocked status of `tile_section_localization`.
