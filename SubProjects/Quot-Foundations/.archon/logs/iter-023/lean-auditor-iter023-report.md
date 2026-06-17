# Lean Audit Report

## Slug
iter023

## Iteration
023

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 4 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 2 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 1 flagged
- **notes**:
  - **Line 1541–1542 (EXCUSE-COMMENT / must-fix)**: The docstring of `base_change_mate_inner_value_eq` says it is "re-derived INLINE through the proved standalone atoms (NOT via the sorry-backed `base_change_mate_fstar_reindex`)." The body has a `sorry` at line 1577. The phrase "re-derived INLINE through the proved standalone atoms" is an active false claim — the declaration is sorry-backed. The in-body comment at lines 1563–1576 is honest ("REMAINING: the genuine ~150-LOC `inner_eCancel` telescoping … deferred here"), but the leading docstring sentence claims the proof is done inline when it is not.
  - **Line 1783–1784 (stale/misleading, major)**: The docstring of `base_change_mate_section_identity` says "it is Mathlib-absent (typed `sorry` at the per-generator node below)." There is no `sorry` "below" in `base_change_mate_section_identity`'s own body; its body closes with `exact base_change_mate_gstar_transpose ψ φ M` at line 1802. The sorry is inside `base_change_mate_gstar_transpose` (line 1760), a called declaration, not "below" in this one. This comment is a stale relic from an earlier version where the sorry was inline.
  - **Lines 184–247 (stale section doc-comment, major)**: The `/-! ## Project-local Mathlib supplement — affine tilde dictionary (global sections) -/` body contains an inline progress log using iter numbers `iter-234`, `iter-236`, `iter-240 PIVOT`, `iter-241`, `iter-011`. These belong to a predecessor project's numbering, not the current Archon iteration scheme (where the current iter is 023). The technical content still accurately describes the current code, but the stale iter numbers create a false historical record and will mislead future readers about when events occurred.
  - **Lines 1425–1480 `base_change_mate_fstar_reindex` (dead-end / major)**: This theorem's body contains no `sorry` keyword, but it closes with `exact base_change_mate_fstar_reindex_legs ψ φ M _ _ hfst hsnd (IsPullback.…).w` at line 1479. That helper (`base_change_mate_fstar_reindex_legs`) has a `sorry` at line 1421. The docstring (lines 1323–1332) gives no indication that the proof is sorry-backed. A reader skimming declarations would mistake this for a proved theorem. The comment at lines 1683–1686 in `base_change_mate_gstar_transpose` correctly identifies `base_change_mate_fstar_reindex` as "currently sorry-backed (its `…_legs` apparatus carries a dead `sorry`)", confirming this is a known-dead branch — but that acknowledgement lives in a different declaration.
  - **Line 1421 `base_change_mate_fstar_reindex_legs` sorry (dead-end)**: The sorry body at line 1421 has detailed honest inline comments (iter-018/019 updates, specific blockers identified). The sorry is honest scaffolding, not an excuse-comment. The surrounding comments do NOT claim the declaration is live. The directive asked specifically whether the comments claim it is live — they do not. Note: the in-body comments reference iter-017, iter-018, iter-019 — consistent with the Archon iter numbering.
  - **Line 1532 `base_change_mate_gstar_generator_close` sorry (new gstar-chain B)**: Sorry at line 1532 with a detailed BLOCKER comment at lines 1527–1531 naming the specific technical obstacle (restrictScalarsComp'App transport resists rw through ModuleCat.Hom.hom) and a suggested re-break approach. Honest scaffolding.
  - **Line 1577 `base_change_mate_inner_value_eq` sorry (new gstar-chain A)**: Sorry at line 1577 with honest in-body comment at lines 1563–1576. DOCSTRING is the problem (see first bullet).
  - **Lines 1579–1627 `base_change_mate_gstar_counit_transport` (new gstar-chain C)**: Fully proved; closes with `exact huce` at line 1627. Comment at line 1603 ("Lifted verbatim from the landed `huce` scaffold in `base_change_mate_gstar_transpose`") is accurate. No issues.
  - **Line 1760 `base_change_mate_gstar_transpose` sorry**: The sorry at line 1760 is pre-existing (iter-022 scaffold). The surrounding comment (lines 1747–1759) accurately names the two remaining pieces (the inner reindex and the generator close) and explicitly instructs not to cite the sorry-backed `base_change_mate_fstar_reindex`. Honest scaffolding.
  - **Line 1933 `affineBaseChange_pushforward_iso` sorry** and **line 1955 `flatBaseChange_pushforward_isIso` sorry**: Both honest. The surrounding comments accurately identify what is missing (affine restriction compatibility for `pushforwardBaseChangeMap`, and the Čech-cohomology infrastructure). Neither is an excuse-comment.
  - **Lines 1482–1491 section header (minor)**: The "Seam 3, the gstar chain" section header references `inner_unitReduce` and `inner_eCancel` as named `\uses`-linked links, but these do not correspond to standalone declared lemmas — `base_change_mate_inner_value_eq` subsumes them inline (as a sorry-backed placeholder). This is a minor mismatch between the blueprint's planned decomposition and the actual declaration structure.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **Line 1956 (stale section header, must-fix)**: The `/-! ## Generic flatness, algebraic form -/` section header says "**Surviving residue** (`sorry` this iter): when `M` is finite over the *finite-type* algebra `B` but not module-finite over `A`…". This is factually wrong: `genericFlatnessAlgebraic` (lines 1981–2141) is **fully proved with no `sorry`** — both the primary route (module-finite case) and the surviving dévissage case (lines 1992–2141) close without a sorry. The phrase "sorry this iter" in the section header is a stale relic from before the dévissage assembly was completed. It actively misleads about the proof state of the most important declaration in the section.
  - **Lines 2199–2222 `genericFlatness` SIGNATURE FIX comment (accurate, no issue)**: The comment at lines 2199–2222 documents the addition of `[QuasiCompact p]` to `genericFlatness` with a counterexample and rationale. The surrounding in-body comments are accurate and up to date. The sorry at line 2264 is honest — the comment at lines 2261–2263 correctly explains why the construction terminates in a sorry ("the witness `V` cannot be produced soundly until G1 is available").
  - **Line 2166 `genericFlatness` docstring (minor, stale iter number)**: "iter-177+: the body follows Nitsure §4…" uses a predecessor project iter number. The content is accurate but the iter reference is stale.
  - **`genericFlatnessAlgebraic` docstring line 1977–1980 (accurate)**: "the finite-type residue is the classical §4 dévissage (Noether normalisation + the polynomial-ring core, **both proved above**)." This is confirmed correct — L4 (`exists_localizationAway_finite_mvPolynomial`) and L5 (`exists_free_localizationAway_polynomial`) are both proved without sorry, and the dévissage assembly at lines 1992–2141 closes without sorry.
  - **Lines 538–539 `exists_localizationAway_finite_mvPolynomial` roadmap comment (accurate)**: "L4 was closed iter-021; there is no `sorry` here." Confirmed correct — no sorry in L4.
  - **All `GenericFreeness.*` declarations**: No issues found. All proved without sorry. Comments are accurate.

---

## Must-fix-this-iter

- `FlatBaseChange.lean:1541` — `base_change_mate_inner_value_eq` docstring says "re-derived INLINE through the proved standalone atoms" — the body has a `sorry` at line 1577. The docstring's active claim of inline completion is false; it is an excuse-framing that describes what *should* happen rather than what *is* in the Lean file. Why must-fix: a docstring that claims a sorry-backed declaration is proved inlines misleads every downstream reader and the review agent.

- `FlatteningStratification.lean:1956` — Section header says "**Surviving residue** (`sorry` this iter)" about the finite-type dévissage case of `genericFlatnessAlgebraic`, but that declaration is fully proved (no sorry). The header actively misrepresents the proof state of the file's most important theorem. Why must-fix: a section comment claiming a proved theorem is sorry-backed is a false signal about what is axiom-clean; it corrupts the project's state accounting.

---

## Major

- `FlatBaseChange.lean:1783` — `base_change_mate_section_identity` docstring says "typed `sorry` at the per-generator node below" but no sorry appears below in that declaration's body; the sorry is in the called `base_change_mate_gstar_transpose` (line 1760). Stale description of where the sorry lives.

- `FlatBaseChange.lean:1425` — `base_change_mate_fstar_reindex` body contains no `sorry` keyword but is sorry-backed transitively via `exact base_change_mate_fstar_reindex_legs` (line 1479). The docstring (lines 1323–1332) does not flag the sorry-dependence. The declaration presents as apparently proved to any reader skimming the file. The in-body comment at line 1467 ("modulo the step-(iii) mate-unwinding crux carried by `base_change_mate_fstar_reindex_legs`") acknowledges the situation but only inside the proof body, not in the docstring where it would be visible.

- `FlatBaseChange.lean:184` — The `/-! ## affine tilde dictionary (global sections) -/` section doc-comment contains an inline proof-history log using iter numbers `iter-234`, `iter-236`, `iter-240 PIVOT`, `iter-241`. These are from a predecessor project's iteration numbering scheme and have no meaning in the current Archon session (iter-023). The technical content is accurate, but stale iter numbers pollute the project history record and confuse any reader trying to understand when events occurred.

- `FlatteningStratification.lean:2166` — `genericFlatness` docstring says "iter-177+: the body follows Nitsure §4…" — predecessor project iter number; should be iter-023 or removed.

---

## Minor

- `FlatBaseChange.lean:1482` — Seam 3 section header references `inner_unitReduce` and `inner_eCancel` as planned `\uses`-linked standalone lemmas but no such declarations exist; their content is subsumed inline inside `base_change_mate_inner_value_eq`. Minor mismatch between blueprint decomposition plan and actual declaration structure.

- `FlatBaseChange.lean:1603` — `base_change_mate_gstar_counit_transport` comment says it was "Lifted verbatim from the landed `huce` scaffold in `base_change_mate_gstar_transpose`." This is accurate, but the same setup block (lines 1699–1736 in `gstar_transpose`) is now duplicated: `gstar_counit_transport` holds the extracted version while `gstar_transpose` keeps its copy. Not harmful but creates redundancy.

- `FlatBaseChange.lean:845` — Inline comment in `base_change_mate_regroupEquiv` says "STATUS (iter-011, route (a) executed): the def is **fully proved, no `sorry`**." This uses iter-011, likely from the predecessor project. Confirmed accurate (no sorry in the body), but the predecessor iter reference is noise.

---

## Excuse-comments (always called out separately)

- `FlatBaseChange.lean:1541`: "re-derived INLINE through the proved standalone atoms (NOT via the sorry-backed `base_change_mate_fstar_reindex`)" in the docstring of `base_change_mate_inner_value_eq`, a sorry-backed declaration. The "re-derived INLINE" phrase frames the sorry-backed state as a completed inline proof. Severity: **must-fix** (the comment is attached to a load-bearing theorem whose sorry propagates to `base_change_mate_gstar_transpose` → `base_change_mate_section_identity` → `base_change_mate_generator_trace` → `pushforward_base_change_mate_cancelBaseChange` → `affineBaseChange_pushforward_iso`).

---

## Severity summary

- **must-fix-this-iter**: 2 — these misrepresent the proof state of named declarations and corrupt the project's axiom-clean accounting.
- **major**: 4
- **minor**: 3
- **excuse-comments**: 1 (also counted under must-fix above)

Overall verdict: Both files are structurally sound with honest sorry scaffolding in the proof bodies, but two stale/misleading comments in the *docstrings* (one per file) actively misrepresent the proof state of load-bearing declarations and should be corrected before the next plan cycle.
