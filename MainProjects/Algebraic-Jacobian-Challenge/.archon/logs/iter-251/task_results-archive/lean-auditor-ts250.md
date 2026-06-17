# Lean Audit Report

## Slug
ts250

## Iteration
250

## Scope
- files audited: 1 (per directive)
- files skipped: 0
- file: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` (1857 lines)

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 1 flagged (stale D2′ "handoff" section note, lines 1452–1476)
- **suspect definitions**: 1 flagged (`exists_tensorObj_inverse` := sorry, line 705)
- **dead-end proofs**: 0
- **bad practices**: 3 flagged (non-standard `set_option`, deprecated API, duplicate comment block)
- **excuse-comments**: 0

- **notes**:

  **FOCUS AREA 1 — Genuine closure of `pullbackEtaUnitSquare` / `pullbackTensorMap_unit_isIso`**

  - `pullbackTensorMap_unit_isIso` (line 1844): a clean two-line term-mode proof delegating to
    `isIso_pullbackTensorMap_unitPair_of_isIso_sheafifyEta` + `isIso_sheafifyEta_of_unitSquare` +
    `pullbackEtaUnitSquare`. No `sorry`, no `admit`, no `native_decide`/`decide`, no axiom shim.
  - `pullbackEtaUnitSquare` (line 1743): tactic proof, `set_option maxHeartbeats 3200000`.
    No `sorry` anywhere in the proof body. Ends with:
    `rw [restrictScalarsId_map, restrictScalarsId_map]` followed by the `erw` chain.
  - **Verified axiom-clean** via `lean_verify`:
    `pullbackTensorMap_unit_isIso` axioms = `{propext, Classical.choice, Quot.sound}`.
    `pullbackEtaUnitSquare` axioms = `{propext, Classical.choice, Quot.sound}`.
    Only standard Lean 4 foundational axioms. No `sorry` in the axiom tree.
  - Verdict: **genuinely closed**. The module-status claim "D2′ is CLOSED axiom-clean (iter-250)"
    is verified correct.
  - The `lean_verify` tool also reported a line-478 "opaque" pattern warning from its source
    scanner. Inspection of line 478 shows `congr($(...))` (term-level congruence quotation
    syntax, not an `opaque` declaration) — this is a scanner false positive; not a real concern.

  **FOCUS AREA 2 — `set_option` flags**

  - `set_option maxHeartbeats 3200000` (line 1733, for `pullbackEtaUnitSquare`): The companion
    comment at line 1730–1732 explains the need (mate-calculus telescope + `.val` reshaping +
    syntactic `restrictScalars (𝟙)` strip exceed the 200 000 default). Axiom-clean by
    `lean_verify`. The proof is not mathematically wrong; the budget is a CPU-time guard, not a
    defeq gate. **Reasonable.** The Lean linter fires at line 1733 ("Please add a comment
    explaining the need") because its comment-proximity check expects the explanatory text
    immediately after the `set_option` line, not in the docstring above — this is a style issue
    only.
  - `set_option maxHeartbeats 1600000` (line 1691, for `pullbackSheafifyUnitEtaTriangle`): Same
    pattern. Axiom-clean. The companion comment at lines 1689–1690 explains the `whnf` pressure
    from `𝟙_Yp` vs `(unit Y).val` defeq. **Reasonable.**
  - `set_option backward.isDefEq.respectTransparency false` (line 1654, for
    `epsilonPresheafToSheafUnit`): **Flagged (major)**. This is a non-standard unifier option that
    makes the backward elaborator more aggressively unfold terms when checking defeq. The proof
    ends with `rfl`, which requires Lean to recognise a definitional equality between
    `ε (pushforward φ')` and `(unitToPushforwardObjUnit φ).val`. Verified axiom-clean
    (`{propext, Classical.choice, Quot.sound}`) — the mathematical content (both sides act
    sectionwise as `φ.hom.app X`) appears sound. However, correctness depends on this non-standard
    option; a Lean or Mathlib update that changes backward-elaboration transparency behaviour
    could silently break the proof. An additional linter warning at line 1673 (`ext did not
    consume the patterns r`) is benign but confirms the proof is operating near the edge of
    standard inference.

  **FOCUS AREA 3 — `erw` usage in `pullbackEtaUnitSquare`**

  - Final `erw` chain at line 1837:
    `erw [Category.assoc, ← Functor.map_comp, pullbackSheafifyUnitEtaTriangle f, presheafUnit_comp_map_eta f, epsilonPresheafToSheafUnit f]`
    This is **load-bearing** in a keyed-defeq tolerance sense. The inline comment at lines
    1834–1836 explains: `pf₁ = pushforward (Hom.toRingCatSheafHom f).hom` and
    `pf₂ = pushforward φ.hom` are definitionally equal but syntactically different spellings (one
    comes from `leftAdjointUniqUnitEta`, the other from the `set`-local `φ`); plain `rw` cannot
    unify the connecting object. `erw` uses the extended-rewrite engine's keyed-defeq tolerance
    to match.
  - **Fragility level**: moderate. The proof is mathematically correct, but if Lean's
    zeta-reduction or `erw` unification changes in a future update, this could silently break. The
    alternative (using `show`/`change` to align spellings) would trigger the catastrophic `whnf`
    on sheafification-laden composites, so `erw` is the intentional choice. Flagged minor.
  - Similar `erw` usage in `pullbackObjUnitToUnit_comp` at lines 973–986 (inside `hcomp'`)
    follows the same pattern.

  **FOCUS AREA 4 — Dead/unused declarations, stale comments, module-status accuracy**

  - **Module-status block (lines 39–98)**: Verified accurate. "ONE tracked typed-sorry residual"
    is correct (only `exists_tensorObj_inverse` has a sorry). "D2′ is CLOSED axiom-clean
    (iter-250)" is confirmed by `lean_verify`. The narrative about the iter-250 assembly
    (`restrictScalarsId_map`, `epsilonPresheafToSheafUnit`, `pullbackSheafifyUnitEtaTriangle`,
    `presheafUnit_comp_map_eta`, `pullbackEtaUnitSquare`) matches the actual declarations.
  - **Stale "D2′ onward — handoff" section note (lines 1452–1476)**: **Flagged (major)**. This
    comment (written at iter-246) states "the SOLE remaining content of D2′ is the **η-bridge**"
    and lists the η-bridge as open work. Iter-250 HAS closed that bridge: `pullbackEtaUnitSquare`
    (lines 1743–1838) and `pullbackTensorMap_unit_isIso` (lines 1844–1848) sit below this comment.
    A reader encountering the comment block before the declarations would incorrectly conclude D2′
    is still open. The D3′/D4′ sub-bullet (lines 1478–1482) accurately describes future work and
    is not stale.
  - **`sheafificationCompPullback_eq_leftAdjointUniq` (lines 1588–1599)**: Declared as a
    "project-local linchpin" but never explicitly called in the file. Its content is reproved
    inline via `rfl` at line 1638 inside `leftAdjointUniqUnitEta`. Grep confirms zero code
    references to this lemma name (only comments). Flagged minor (dead within this file; may be
    exported for documentation purposes).
  - **`PullbackLanDecomposition` section (lines 1241–1303)**: Five declarations (`pullback0`,
    `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction`, `pullbackLanDecomposition`)
    are explicitly marked "OFF-PATH (iter-243 pivot)" and are not called anywhere in the remainder
    of this file. Flagged minor.
  - **`pullbackObjUnitToUnit_comp` (line 900)**: Declared as "retained … of independent use for
    the harder Phase-2 tensor comparison" but Phase 2 was abandoned (iter-242/243). The declaration
    is mentioned in five inline comments but never called as code. Flagged minor.
  - **Duplicate comment paragraph at lines 1819–1821**: An earlier draft of the
    `restrictScalarsId_map` strip comment appears at lines 1819–1820, immediately followed by the
    fuller superseding version at lines 1822–1832. The first two comment lines are leftover and
    should be removed. Flagged minor.

  **FOCUS AREA 5 — `exists_tensorObj_inverse` sorry (line 705)**

  - **Classification: must-fix-this-iter** (per auditor rules: `:= sorry` on a load-bearing
    claim). The lemma is load-bearing: it feeds `IsInvertible.pullback` and the relative Picard
    group inverse.
  - **Presentation**: cleanly guard-railed and NOT misleading. The body comment (lines 687–704)
    accurately names the two remaining bridges (C: `dual_isLocallyTrivial`; A: SheafOfModules
    morphism descent), explains the forbidden d.2 shortcut, and cites the relevant documentation
    files. The module-status block (line 43) correctly identifies this as the sole tracked sorry.
    The Lean compiler reports "declaration uses `sorry`" at line 683. No excuse-comment language;
    the sorry is not pretending to be temporary in a misleading way.
  - Context: this sorry was open as of iter-226 and is the project's ONE documented open gap.

  **OTHER OBSERVATIONS**

  - **Deprecated API — `CategoryTheory.Sheaf.val` (major)**: The Lean compiler emits ~45
    deprecation warnings for `CategoryTheory.Sheaf.val` (lines 152, 168, 208, 220, 255, 272, 274,
    284, 286, 294, 296, 304, 339, 342, 347, 366, 368, 1063, 1065, 1068–1071, 1074, 1076, 1092,
    1094, 1187, 1193, 1209, 1319, 1324, 1346, 1396, 1401, 1407, 1412, 1417, 1445, 1492, 1496,
    1536, 1542, 1547, 1594, 1598, 1613, 1622, 1629, 1633, 1704, 1707, 1714, 1717, 1723, 1748,
    1776, 1778, 1789, 1791, 1794, 1798–1799, 1802, 1805), with the message "Use
    `ObjectProperty.obj`". The deprecation is in the pinned Mathlib commit. Iter-250's new
    declarations (lines 1700+) add further instances. The file will accumulate increasing
    deprecation noise at the next Mathlib bump. Not a soundness issue at the current pin.
  - **No errors**: `lean_diagnostic_messages` returns zero errors.
  - **Long-line warnings**: 20+ lines exceed the 100-character linter limit. Concentrated in the
    iter-250 region (lines 1645–1836). These are type-signature lines and cannot reasonably be
    shortened without reformatting; they are not a concern for correctness.
  - **`dualIsoOfIso` (line 218)**: Not called within this file but not private; it is an exported
    API item for the dual construction and a natural companion to `tensorObjIsoOfIso`. Not dead —
    it is a public API building block.

---

## Must-fix-this-iter

- `TensorObjSubstrate.lean:705` — `exists_tensorObj_inverse := sorry` on a load-bearing lemma
  (tensor inverse existence for line bundles). Per auditor rules, `:= sorry` on a load-bearing
  claim is must-fix. **Context**: this is the sole tracked open sorry; it is correctly documented,
  not misleadingly presented. Two bridges remain (C: `dual_isLocallyTrivial`; A: SheafOfModules
  morphism descent). The classification is mechanical — the gap is known and managed.

---

## Major

- `TensorObjSubstrate.lean:1654` — `set_option backward.isDefEq.respectTransparency false`
  applied to `epsilonPresheafToSheafUnit`. Correctness of the final `rfl` depends on this
  non-standard unifier option. Axiom-clean, mathematically sound, but fragile to elaboration
  changes. Per the directive's explicit requirement, any proof whose correctness depends on a
  non-standard `set_option` is flagged.

- `TensorObjSubstrate.lean:1452–1476` — Stale "D2′ onward — handoff" section comment. States
  "the SOLE remaining content of D2′ is the **η-bridge**" as if it is open work — but the
  η-bridge was closed by `pullbackEtaUnitSquare` (line 1743, same file, same iter). A reader
  scanning the file top-to-bottom would incorrectly infer D2′ is still open.

- `TensorObjSubstrate.lean:152+` — Widespread use of deprecated `CategoryTheory.Sheaf.val` API
  (~45 warnings in the pinned Mathlib version), including in iter-250's new declarations. Not a
  soundness issue at the current pin, but accumulates as maintenance debt and will produce
  compile-time noise at the next Mathlib bump.

---

## Minor

- `TensorObjSubstrate.lean:1837` — `erw [Category.assoc, ← Functor.map_comp, ...]` chain in
  `pullbackEtaUnitSquare` is load-bearing in a keyed-defeq tolerance sense (`pf₁`/`pf₂` spelling
  mismatch). Documented, intentional, and the correct choice given the `whnf`-bomb alternative,
  but fragile to Lean elaboration updates. A similar pattern occurs in `pullbackObjUnitToUnit_comp`
  at lines 973–986.

- `TensorObjSubstrate.lean:1588` — `sheafificationCompPullback_eq_leftAdjointUniq` is declared
  and described as a "project-local linchpin" but is never explicitly called. Its content is used
  inline via `rfl` in `leftAdjointUniqUnitEta`. Docstring overclaims its load-bearing status.

- `TensorObjSubstrate.lean:1241–1303` — `PullbackLanDecomposition` section (`pullback0`,
  `extendScalars`, `pullback0Adjunction`, `extendScalarsAdjunction`, `pullbackLanDecomposition`)
  marked "OFF-PATH (iter-243 pivot)" and unused in the rest of this file. Off-path status is
  documented; these are exported but not actively consumed.

- `TensorObjSubstrate.lean:900` — `pullbackObjUnitToUnit_comp` not called as code anywhere in
  the file (only referenced in comments). Phase 2 (its stated consumer) was abandoned. Potential
  dead code.

- `TensorObjSubstrate.lean:1819–1821` — Duplicate/stale comment paragraph: the strip-comment for
  `restrictScalarsId_map` starts twice, with the first two lines (1819–1820) being an earlier
  draft superseded by the fuller block at lines 1822–1832.

- `TensorObjSubstrate.lean:1673` — `ext r` emits linter warning "ext did not consume the
  patterns `r`". The `r` is introduced and used implicitly; benign.

- `TensorObjSubstrate.lean:1691,1733` — Linter fires "Please add a comment explaining the need
  for modifying the maxHeartbeat limit": the explanation exists in the docstring above, not
  immediately below `set_option`. Style-only; does not affect correctness.

---

## Excuse-comments (always called out separately)

None. No declaration in this file carries excuse-comment language ("temporary", "placeholder",
"will fix later", "wrong but works"). The `exists_tensorObj_inverse` sorry is presented with
accurate, forward-looking documentation about what remains — not as an admission of a shortcut.

---

## Severity summary

- **must-fix-this-iter**: 1
  (`exists_tensorObj_inverse := sorry`, load-bearing — tracked and documented, not hidden)
- **major**: 3
  (non-standard `set_option backward.isDefEq.respectTransparency false`; stale D2′ handoff
  comment; widespread deprecated `Sheaf.val` API)
- **minor**: 7
  (load-bearing `erw` chain; dead `sheafificationCompPullback_eq_leftAdjointUniq`; off-path
  `PullbackLanDecomposition` section; dead-within-file `pullbackObjUnitToUnit_comp`; duplicate
  comment; `ext r` linter; `maxHeartbeats` comment-proximity linter)
- **excuse-comments**: 0

Overall verdict: The iter-250 closure of D2′ (`pullbackEtaUnitSquare` and
`pullbackTensorMap_unit_isIso`) is **genuine and axiom-clean** — verified by `lean_verify` (axioms:
`propext`/`Classical.choice`/`Quot.sound` only). The one must-fix is the pre-existing tracked
`exists_tensorObj_inverse` sorry; no new sorries were introduced. The three major findings are: the
non-standard `backward.isDefEq.respectTransparency false` option on `epsilonPresheafToSheafUnit`
(fragile but sound), a stale intermediate comment that incorrectly presents D2′ as still open, and
a file-wide deprecated API accumulation.
