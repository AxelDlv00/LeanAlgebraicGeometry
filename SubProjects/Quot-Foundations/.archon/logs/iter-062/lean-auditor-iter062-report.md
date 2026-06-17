# Lean Audit Report

## Slug
iter062

## Iteration
062

## Scope
- files audited: 1 (per directive — `AlgebraicJacobian/Picard/GrassmannianQuot.lean` only)
- files skipped (per directive): all other `.lean` files — narrow-scope directive

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 2 flagged (lines 316–322, stale section NOTE)
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Line 320–322: The section-level NOTE in the `/-! ## Gluing a sheaf of modules…-/` block
    says `"the body and the module-cocycle hypotheses on 'g' are still to be filled"`.
    **This is stale.** The `glue` body (lines 419–456) is fully closed (`equalizer a b`,
    no sorry) and `_hC1`/`_hC2` **are** explicit arguments in the signature. The statement
    "still to be filled" no longer describes the actual code.
  - Lines 316–318: Same block describes the construction path as
    `"restrict to a chart through the open-immersion pullback equivalence
    (Scheme.Modules.overRestrictPullbackIso) and glue the local sections by locality of
    sections (existsUnique_gluing')"`. **The actual implementation uses a completely different
    approach** (equalizer of two maps `∏ᵢ(ιᵢ)_*Mᵢ ⇉ ∏(j_ij)_*(f_ij^*Mᵢ)` — no
    `overRestrictPullbackIso` or `existsUnique_gluing'` appear anywhere in the body).
    The description is a vestige of an earlier planned approach.
  - Lines 880–956 (L3 section, `unitToPushforward_scalarEnd_comm` and `scalarEnd_pullback`):
    **Closed, no sorry, genuine.** Both use adjunction transpose arguments and comorphism
    naturality, consistent with the claim. No `native_decide`, no `axiom`, no fake `rfl` on
    a non-trivial goal.
  - Line 981 (`matrixEnd_pullback`, `sorry`): **Honest, documented.** The directive
    explicitly marks this as an intentional partial sorry. The comment (lines 975–980)
    correctly describes the biproduct distributivity argument that remains to be done.
  - Line 1048 (`bundleTransition_cocycle`, `sorry`): **Honest, documented.** Labeled
    "REMAINING (L3, the substantive transport — flagged for iter-062 standalone)" with a
    detailed 30-line explanation of the missing steps. Accurate with respect to what is
    closed (L1 `bundleTransition_cocycle_matrix`, L2 `matrixToFreeIso_mul`) and what is
    open (L3(a) `matrixEnd_pullback` naturality and L3(b) base-change map identification).
  - Line 1068 (`universalQuotient`, `sorry`): **Honest.** NOTE accurately records that
    `glue` has landed and the remaining gap is the GL_d bundle cocycle.
  - Line 1079 (`tautologicalQuotient`, `sorry`): **Honest.** Documented as riding on
    `universalQuotient`.
  - Line 1573 (`represents`, `sorry`): **Honest.** Documented as riding on
    `tautologicalQuotient`.
  - **Pre-existing opaque (directive note ~line 1331):** There is **no Lean `opaque` keyword**
    in GrassmannianQuot.lean at line 1331 or anywhere else. Line 1336 contains a proof
    comment (`-- assemble in steps to avoid a single large isDefEq over the opaque
    pullbackComp`) describing a term-mode proof technique for keeping `pullbackComp`
    abstract — not an actual `opaque` declaration. The "opaque immersion trick" from
    iter-041 documented in memory is in QuotScheme.lean (abstract `j` in
    `section_localization_hfr_aux`), which is outside this file's scope and not re-flagged.
  - **No laundering:** No `native_decide`, no `axiom`, no `opaque` keyword, no `#check`
    bypass, no fake `:= rfl` on non-trivial claims, no `:= True`, no `Classical.choice _`
    without authorization.
  - **`_hC1`/`_hC2` unused in `glue` body:** The cocycle hypotheses take underscored names
    (suppressing the unused-variable warning) because the equalizer construction does not
    use them directly — they will be needed for downstream `glueRestrictionIso` lemmas.
    This is a valid and documented Lean pattern (line 424–426 explains it in the body
    comment). Not flagged.
  - **`scalarEnd_val_app_one` (line 91–94):** Closed by `exact one_smul _ _`. The `smul`
    identity matches: `SheafOfModules.unit` is a module over itself and the right-action
    scalar `1 • x = x` holds. Genuinely closed.

---

## Must-fix-this-iter

None.

---

## Major

- `GrassmannianQuot.lean:316–322` — Stale section NOTE in `/-! ## Gluing a sheaf of
  modules… -/`: two sub-issues in the same block.
  - Lines 320–322 claim "the body and the module-cocycle hypotheses on `g` are still to be
    filled" but the `glue` body is complete (lines 419–456, no sorry) and `_hC1`/`_hC2`
    are already in the signature.
  - Lines 316–318 describe the construction path via `overRestrictPullbackIso` /
    `existsUnique_gluing'`; the actual implementation is a descent equalizer of pushforwards
    and uses neither API.
  - A future reader inspecting this block might wrongly conclude `glue` still needs work,
    or try to switch to the described (but abandoned) construction path.

---

## Minor

None beyond what is noted above.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 (two-part stale section NOTE — lines 316–322)
- **minor**: 0
- **excuse-comments**: 0

Overall verdict: the new L3 block (lines 880–1080) is clean — both closed lemmas are
genuine with no laundering, all five remaining sorrys are honest and well-documented.
The only real issue is the stale section-level NOTE for `Scheme.Modules.glue` (lines
316–322), which describes both the completion status and the construction approach
inaccurately relative to the committed code.
