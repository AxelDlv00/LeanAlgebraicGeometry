# Lean Audit Report

## Slug
ts249

## Iteration
249

## Scope
- files audited: 1 (directive-narrowed to `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`)
- files skipped: all other `.lean` files — directive explicitly limits scope to the one file above

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:

#### Sorry-count verification (Focus area 1)

The module-status docstring (L41–51) claims "TWO tracked typed-`sorry` residuals." A grep for the literal keyword `sorry` yields exactly **two `sorry` bodies** at execution sites in the file:

- **L699**: body of `exists_tensorObj_inverse`
- **L1741**: body of `pullbackEtaUnitSquare` (the `(∗∗)` step)

All other `sorry` occurrences in the file are inside comment text or docstrings (never a tactic or term). The count claim is **accurate**.

#### Docstring line-number accuracy

- Docstring L43 claims `exists_tensorObj_inverse` sorry is at "~L692." The declaration starts at L677; the sorry body is at **L699** — a 7-line offset error. Not materially misleading (the offset is small and the name is given), but factually imprecise.
- Docstring L44 claims the `pullbackEtaUnitSquare` presheaf residual is at "~L1717." The sorry is actually at **L1741** — a 24-line offset error. Slightly larger; the docstring narrative ("documented at the `sorry`") is accurate, but the line anchor is wrong by ~3.5%.

These are **minor** — they are the wrong line numbers in a comment, not code errors.

#### Telescope-closure claim verification (Focus area 1, continued)

The docstring (L45–50) asserts that "the entire abstract mate-calculus telescope is CLOSED axiom-clean this iter" and lists the named sub-steps:

| Claimed sub-step | Actual code location |
|---|---|
| `homEquiv` transposition | L1661–1663 (apply `.homEquiv … .injective`) |
| `compHomEquivFactor` / `leftAdjointUniqUnitEta` via `hkey` rewrite | L1676–1688 |
| two `homEquiv_naturality` folds | L1673 (left + right), L1691 (right_symm) |
| X-side sheafification triangle `hXtri` | L1694–1703 (`right_triangle_components`) |
| X-side `homEquiv` collapse `hrhs` | L1704–1714 |

Every named step is live Lean tactic code, not a `sorry`. The `rfl` linchpin `sheafificationCompPullback_eq_leftAdjointUniq` (L1582–1593) is verified to carry proof `:= rfl`. The claim is **accurate**.

The lone `sorry` at L1741 sits after all of the above telescope steps have been executed; the remaining obligation is explicitly labelled as a concrete presheaf-level identity in the preceding comment. The docstring's description of "a concrete PRESHEAF-level identity (Y-side sheafification triangle + step-7 ε-reconciliation)" matches the three-substep plan in the comment (L1721–1736). **No over-claim detected.**

#### `pullbackEtaUnitSquare` proof comments (Focus area 2)

The comments at L1719–1740 surrounding the `sorry`:

1. **L1720–1721 header**: "REMAINING (∗∗) — a single CONCRETE presheaf-level identity (the entire abstract mate-calculus telescope above is now CLOSED axiom-clean). EXACT goal: …" — accurate.

2. **L1725–1736 three-substep plan**:
   - (i) pushforward–forget compat: described as defeq, not yet shown via `Functor.map_comp`.
   - (ii) Y-side triangle: described as a combination of `naturality` + right-triangle.
   - (iii) `epsilonPresheafToSheafUnit`: named as a to-be-built lemma that "checked sectionwise."

   None of these steps are claimed to be **done** in the surrounding code. They are labeled as work remaining inside the `sorry` block. This is honest sorry documentation, not an excuse-comment.

3. **L1737–1739 "NOTE for next iter"**: "NOTE for next iter: the recurring blocker this iter was Lean's `Category.assoc` / `← Category.assoc` silently failing …" — this is an inline project-log entry recording a proof-technique finding. It is accurate and useful, but belongs in `task_results/` rather than in source code. Flagged as **minor** (slightly wrong venue for project notes, not wrong information).

4. **Reference to `epsilonPresheafToSheafUnit` (L1735)**: The lemma `epsilonPresheafToSheafUnit` is referenced by name in the sorry-block comment as a step to build. It does not appear anywhere in the file or its imports (verified via grep). The comment correctly describes it as something that needs to be constructed ("step 7 `epsilonPresheafToSheafUnit`"), not as something that already exists. No false claim of existence, but a reader who does not know this is planned could be confused. **Minor**.

#### General audit (Focus area 3)

- **`tensorObj` / `tensorObj_functoriality` (L145–164)**: Clean; both docstrings say "fully defined, no `sorry`" and the bodies contain none. ✓
- **`IsInvertible` (L173–174)**: Simple `Prop` definition using `∃`. No issues.
- **`dual` (L201–204)**: Mirrors `tensorObj` construction exactly; no sorry. ✓
- **`dualIsoOfIso` (L212–216)**: Clean mapIso. ✓
- **`tensorObj_assoc_iso` (L325–366)**: Long but axiom-clean; all tactics are meaningful (two `hW` proofs, two `hi` instances, one `e2` mapIso, final `≪≫` chain). No sorry. ✓
- **`restrictIsoUnitOfLE` (L378–400)**: Clean; factored chain, no sorry. ✓
- **`tensorObj_restrict_iso` (L430–507)**: The key substrate linchpin. Body is concrete and no sorry. ✓
- **`isIso_of_isIso_restrict` (L551–583)**: B-bridge; stalkwise iso criterion. Clean. ✓
- **`homMk` + `toPresheaf_map_homMk` (L592–605)**: Both clean; the simp lemma has `:= rfl`. ✓
- **§3 C-wiring diagnostic comment (L607–650)**: Long explanatory comment correctly notes "The diagnostic def is intentionally NOT committed." This is appropriate — it documents a route explored but not formalised into a sorry. Not an excuse-comment.
- **`exists_tensorObj_inverse` (L677–699)**: Body is `sorry`. The in-body comment (L681–698) accurately describes the two remaining bridges (C: `dual_isLocallyTrivial`; A: SheafOfModules morphism descent) and explicitly warns against the forbidden shortcut. The comment is honest documentation. ✓
- **`picCommGroup` (L805–832)**: All group axioms have concrete, non-sorry tactic proofs. ✓
- **`picInv` (L785–798)**: Uses `Classical.choose` on `a.2 : IsInvertible M`; this is standard for a Picard group inverse and not suspect.
- **§6 Pullback-monoidality section (L834–1760)**: Long but well-structured.
  - `pullbackObjUnitToUnit_comp` (L894): proof uses `erw` in several places with an explanatory comment (L890–893). The comment correctly explains why `erw` is needed rather than `rw`. Not a smell — `erw` is appropriate when `rw` fails on defeq-but-not-syntactic compositions.
  - `sheafifyTensorUnitIso` (L1055): `private`. Clean `W`-argument pattern.
  - `presheafPushforwardLaxMonoidal` (L1108): `instance`. Uses a `let φ'` cast + `have h := inferInstance` pattern to avoid a kernel-rejected diamond. The docstring explains the issue. ✓
  - `pullbackLanDecomposition` (L1290–1295): Docstring (L1229–1234) clearly marks it as "OFF-PATH (iter-243 pivot)" and retained only as correct reusable infrastructure. Not a dead declaration (it has the status note) but a reader should know it is off-path. **Minor**: could carry a `-- OFF-PATH` note directly on the `def` line.
  - `pullbackTensorMap_unit_isIso` (L1747–1751): No sorry in its body, but it transitively depends on `pullbackEtaUnitSquare` (which has sorry). The sorry warning will propagate. The docstring does not state it is axiom-clean — it correctly describes it as "D2′" which the module status reports as partially sorry. Not misleading, but implicit.
  - `isIso_sheafifyEta_of_unitSquare` (L1525–1551): Axiom-clean. ✓
  - `sheafificationCompPullback_eq_leftAdjointUniq` (L1582–1593): `:= rfl`. ✓
  - `leftAdjointUniqUnitEta` (L1602–1637): Axiom-clean; proof uses `rfl`, `Adjunction.homEquiv_leftAdjointUniq_hom_app`, `comp_unit_app`. ✓

- **Status note about `internalHomEval` at L60–64**: This discusses a declaration that lives in the imported `PresheafInternalHom.lean`, not in this file. Including per-sub-module closed-status notes in the top-level module docstring makes the docstring harder to maintain and risks becoming stale. **Minor** (wrong venue for sub-module status).

---

## Must-fix-this-iter

*None.*

---

## Major

*None.*

---

## Minor

- `TensorObjSubstrate.lean:43–44` — Docstring line-number anchors for the two tracked sorries are off: `exists_tensorObj_inverse` sorry claimed at "~L692" but is at L699 (+7); `pullbackEtaUnitSquare` sorry claimed at "~L1717" but is at L1741 (+24). Misleads the reader searching for the sorry by line number.

- `TensorObjSubstrate.lean:60–64` — Status note about `internalHomEval` and `iter-224` is documentation for `PresheafInternalHom.lean` embedded in the top-level module docstring. Should live in that sub-module's docstring to avoid cross-module status drift.

- `TensorObjSubstrate.lean:1737–1739` — "NOTE for next iter" comment is an inline project-log entry (proof-technique tip for the next prover session). Correct information, but project-log material belongs in `task_results/` rather than in source code where it will age.

- `TensorObjSubstrate.lean:1735` — Reference to not-yet-created lemma `epsilonPresheafToSheafUnit` inside the sorry-block comment. The comment accurately describes it as something to build, but a reader skimming the comment could mistake the name for a currently available lemma. Consider adding "to be built" explicitly.

- `TensorObjSubstrate.lean:1231–1234` — `pullbackLanDecomposition` and its `PullbackLanDecomposition` section are documented as "OFF-PATH" in the module header but carry no `-- OFF-PATH` marker on the individual `def` or section header, requiring a reader to cross-reference the section prose to know it is retained-but-not-used. Minor navigational issue.

---

## Excuse-comments (always called out separately)

*None found.* All sorry-adjacent comments in this file describe what work remains (accurately) and explicitly flag the open steps. No comment claims a sorry-guarded step is done when it is not. The `exists_tensorObj_inverse` body comment names two bridges that must still be built before the sorry closes; the `pullbackEtaUnitSquare` body comment names three presheaf-level substeps that must still be proved. Both match the actual state of the code.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The file is honest and internally consistent. The module-status docstring's two key claims — that exactly two typed-`sorry` residuals remain and that the abstract mate-calculus telescope is CLOSED axiom-clean — are both verified correct by reading the code. No over-claiming, no laundered sorries, no excuse-comments. The five minor findings are cosmetic or navigational (wrong line numbers in a comment, misplaced project notes, a missing inline "OFF-PATH" marker).
