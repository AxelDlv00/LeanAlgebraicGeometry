# Blueprint Writer Report

## Slug
repin271

## Status
COMPLETE — but with a **directive-premise correction** (see Notes for Plan Agent). No `\lean{}`
pin was changed, because verification proved that none of the 9 directive-named "real" target
declarations exist in the Lean source. Each block was instead annotated with a precise pin-status
`% NOTE` per the directive's explicit fallback rule.

## Target chapter
blueprint/src/chapters/Picard_TensorObjSubstrate.tex

## Key finding (the premise was wrong)
The blueprint-reviewer (iter-270) classified ~9 `unmatched_lean` entries in this chapter as
**renames** ("the real Lean names are now different from the blueprint pins") and guessed the new
names. I grepped the entire Lean tree (`AlgebraicJacobian/**/*.lean`) for every one of the
directive's "real" names. **None of them exist as a Lean declaration** — they appear only inside
docstrings/comments as *planned future* targets (e.g. "the eventual `pullbackTensorIso`",
"i.e. `IsInvertible.pullback` — **not yet landed**", "the `addCommGroup_via_tensorObj` **stub**").

Consequences:
- These 9 pins are **forward references to not-yet-formalized declarations**, not stale renames.
  Their `unmatched_lean` status is the normal "unformalized target" state, identical to the
  TODO-pinned specification chapters the reviewer itself accepts as "expected per strategy"
  (Picard_FlatteningStratification, Picard_QuotScheme, Cohomology_FlatBaseChange).
- For items 1–5 the chapter's **current pins already equal the directive's "real" names verbatim**
  (up to the `AlgebraicGeometry.` namespace prefix the directive abbreviated). There is literally
  nothing to repin — the names were never wrong; the declarations simply have not been built yet.
- Items 8 & 9 (`lem:jw_ismonoidal`, `lem:stalk_tensor_commutation_naturality_right`) are
  **deliberate `AlgebraicGeometry.TODO.*` placeholders** already carrying explicit
  `% \lean: TODO placeholder` annotations: the first is the route-(e) off-path packaging that
  "must not be formalized"; the second was inlined into
  `PresheafOfModules.isLocallyInjective_whiskerLeft_of_W` (no standalone decl by design). These are
  correct as-is and were left untouched.

Per my descriptor's hard rule ("Verify each new pin name actually exists in the Lean source before
writing it") I did **not** write any of the non-existent names as if real. Per the directive's
stated fallback ("leave the pin as-is and add a `% NOTE: pin target not found in Lean source as of
iter-271` comment"), I annotated each forward-reference block.

## Changes Made
No `\lean{}`, `\uses{}`, `\cref{}`, `\label{}`, or `\leanok` was modified. Seven `%`-comment
pin-status NOTEs were added (one per forward-reference block), each stating the target is absent
from the Lean source as of iter-271 (verified by grep), is a forward reference / not-yet-formalized
declaration, and is **not** a stale rename:

- **Annotated** `lem:pullback_compatible_with_tensorobj` (pin `…OnProduct.pullback_tensorObj_iso`) — absent in Lean; forward ref.
- **Annotated** `lem:pullback_tensor_iso` (pin `…Scheme.Modules.pullbackTensorIso`) — absent; forward ref to an ABANDONED/off-path decl.
- **Annotated** `lem:pullback0_tensor_iso` (pin `…pullback0TensorIso`) — absent; forward ref to an ABANDONED/off-path decl.
- **Annotated** `lem:pullback_tensor_iso_loctriv` (pin `…pullbackTensorIsoOfLocallyTrivial`) — absent; LIVE D4′ build target.
- **Annotated** `lem:isinvertible_implies_locallytrivial` (pin `…IsInvertible.isLocallyTrivial`) — absent; off-path forward ref.
- **Annotated** `lem:isinvertible_pullback` (pin `…IsInvertible.pullback`) — absent; forward ref (three-line consequence pending its loc-triv input).
- **Annotated** `thm:rel_pic_addcommgroup_via_tensorobj` (pin `…PicSharp.addCommGroup_via_tensorObj`) — absent; the real Lean instance is `PicSharp.addCommGroup`, the `_via_tensorObj` upgrade is unbuilt.

**Left unchanged (already correct):**
- `lem:jw_ismonoidal` — deliberate `TODO.jw_ismonoidal` placeholder, already annotated.
- `lem:stalk_tensor_commutation_naturality_right` — deliberate `TODO.…` placeholder, already annotated (iter-238 review note explains the inlining).

## Cross-references introduced
None. No `\uses{}`/`\cref{}` were added or changed (no blueprint *label* was renamed — only the Lean
decls are unbuilt, which does not affect intra-blueprint edges).

## Verification
- `grep` over `AlgebraicJacobian/**/*.lean`: all 9 directive target names absent as declarations
  (present only in comments/docstrings). Real neighbours that DO exist: `tensorObj_isLocallyTrivial`,
  `dual_isLocallyTrivial`, `OnProduct.isLocallyTrivial`, `IsLocallyTrivial.pullback`,
  `pullbackTensorMap`, `pullback0`, `pullbackLanDecomposition`, `PicSharp.addCommGroup` — none is the
  same statement as the corresponding blueprint block, so none is a valid repin target.
- LaTeX integrity: only `%`-comment lines added; all 9 `\lean{}` pins intact. The 84/83
  `\begin/\end{lemma}` raw-count 1-off is **pre-existing** (commented-out `% "\begin{lemma}` examples
  inside `SOURCE QUOTE` blocks at lines 633/1650/1891/…), not introduced here.
- `leandag build --json`: parses cleanly, `conflicts: []`, **`unknown_uses: 0`** — no broken
  dependency edges introduced. The 9 `unmatched_lean` entries persist by design (forward refs).

## References consulted
None — this was a pure pin-correctness/verification pass against the Lean source; no external
reference material or citation blocks were involved.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **The reviewer's "stale rename" diagnosis for this chapter is incorrect.** The 9 `unmatched_lean`
  entries are forward references to declarations that have not been formalized yet (and several are
  intentionally never-to-be-formalized: the ABANDONED general-pullback route `lem:pullback_tensor_iso`
  / `lem:pullback0_tensor_iso`, and the route-(e) `lem:jw_ismonoidal`). A "repin to the real name"
  pass is therefore **impossible** — there is no existing decl to point at. These entries will keep
  showing as `unmatched_lean` until the corresponding provers land the decls under exactly these
  names, at which point deterministic `sync_leanok` resolves them with no blueprint edit.
- **To clear the reviewer's `correct: partial` gate without churn**, the right move is for the
  reviewer/leandag pass to treat these 7 (+2 TODO) as *expected unformalized forward references*
  (the same posture it already grants the FlatteningStratification / QuotScheme / FlatBaseChange
  TODO pins), rather than as fixable stale pins. The pin-status NOTEs added this pass make that
  classification explicit in-source so the diagnosis does not recur next iter.
- **Items 1–5 needed no edit at all**: the chapter pins already matched the directive's "real" names
  byte-for-byte. If a future reviewer re-flags them, it is again the not-yet-built condition, not a
  pin defect.
- The two LIVE forward targets the active Picard provers should land are
  `Scheme.Modules.pullbackTensorIsoOfLocallyTrivial` (D4′) and `Scheme.Modules.IsInvertible.pullback`
  (its three-line consequence). Those two pins are correct and ready for `sync_leanok` the moment the
  prover decls exist.

## Strategy-modifying findings
None at the STRATEGY.md level. The math/strategy of the chapter is sound; the issue was purely a
mistaken diagnosis (rename vs. unbuilt-forward-reference) in the iter-270 review that propagated into
this directive. No strategy change is required — only a corrected understanding that this chapter's
remaining `unmatched_lean` entries are unbuilt targets, not broken pins.
