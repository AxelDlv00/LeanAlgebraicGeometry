# Lean Audit Report

## Slug
iter020

## Iteration
020

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechAcyclic.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 109: intentional `sorry` in `CechAcyclic.affine` — confirmed as one of the two project-wide known sorries. The inline comment block (lines 79–108) accurately describes what is done (L3, both forms; CechLocalized exactness) and what remains (L1 categorical bridge). Not an excuse-comment.
  - Line 17 (module docstring): says "The proof body is `sorry`; filling it is the task of the P3 prover lane." Accurate as a status note; not an excuse-comment in the auditor's sense.
  - Lines 131–133 (module-level docstring for `CombinatorialCech`): says these declarations "exist only to close `CechAcyclic.affine` in this file." Imprecise — `cons_comp_zero_succAbove`, `cons_comp_succAbove_succ`, `comp_succAbove_swap` are also used by the public `CechLocalized.cech_hu`, `cech_hsh`, `cech_hcomm` lemmas later in the same file. The declarations serve a broader role than the comment claims. (Minor, no misleading effect — all in same file.)
  - Lines 78, 1107: line-length linter warnings (style, not logic).
  - Axiom hygiene: all audited declarations (`dDiff_exact`, `cechLocalized_exact`, `qcohSectionsAwayLocalized`, `qcohRestriction_eq_comparison`, `SectionCechModule.*`) depend only on `{propext, Classical.choice, Quot.sound}`. The `lean_verify` source scanner reports "opaque" at line 1065 — this is a false positive; the word appears inside a `/-- ... -/` docstring comment, not in code.
  - `spanIdx` (line 1068): `private noncomputable def spanIdx := ρ.2.choose`. Legitimate use of `Classical.choice` via `Exists.choose`; the docstring explains why a private opaque wrapper is preferred for the rewrite motive. No issue.
  - New declarations from this session (`AwayComparison.*`, `CechLocalized.*`, `SectionCechModule.*`, L1-bridge lemmas `basicOpen_sprod`, `qcohSectionsAwayLocalized`, `qcohRestriction_eq_comparison`) — all have genuine, non-vacuous proofs with real mathematical content (localisation transitivity, comparison-map uniqueness, multi-index product identification). No IsEmpty-elimination or trivially-discharged statements detected.

---

### AlgebraicJacobian/Cohomology/CechBridge.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - No sorries. All axiom checks pass (`{propext, Classical.choice, Quot.sound}` only). No compile errors.
  - Lines 52–64 (module docstring): three downstream declarations are listed as "planned": `injective_cech_acyclic` (gated on `cechFreeComplex_quasiIso`), `ses_cech_h1`, `cech_eq_cohomology_of_basis` / `affine_serre_vanishing`. These are correctly marked "planned" — not claiming they are proved. But they expand the module header's promise beyond what the file contains. Once proved they must be reclassified or the structure will look aspirational. Minor comment maintenance concern.
  - Lines 206, 208 (`freeYonedaHomAddEquiv_naturality`): Mathlib style linter flags `show` used as `change` (two occurrences). The `show` tactic changes the goal here instead of just displaying an intermediate state. The linter message is "please use `change` instead." This is a real style violation in a Mathlib-style project. No logical error; the proof is correct.
  - `homCechSectionIsoApp` (line 158, uses `asIso (piComparison ...)` at line 164): `asIso` asserts an `IsIso` instance is present for `piComparison`. Since `preadditiveYoneda.obj F` is left exact (preserves all limits), `piComparison` is indeed an iso; the instance is inferred. The file compiles without error, confirming the instance exists. No issue.
  - `preadditiveYoneda_obj_preservesFiniteColimits_of_injective` (line 397): uses `Functor.preservesFiniteColimits_iff_forall_exact_map_and_epi`. This name is not a standard Mathlib export by obvious inspection, but the proof compiles clean with no errors and axioms are standard-only. Accepted.
  - All new declarations (`homCechCosimplicial`, `homCechComplex`, `homCechSectionIsoApp`, `homCechSectionCosimplicialIso`, `cechComplex_hom_identification`, `homCechComplexMapOpIso`, `sectionCechComplexMapOpIso`, `preadditiveYoneda_obj_preservesFiniteColimits_of_injective`, `quasiIso_map_preadditiveYoneda_of_injective`) are genuine proofs with real mathematical content; none are vacuous or trivially discharged.

---

### AlgebraicJacobian/Cohomology/FreePresheafComplex.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (code duplication)
- **excuse-comments**: none
- **notes**:
  - No sorries. No compile errors or warnings. All axiom checks pass.
  - **Stale module docstring (lines 11–31)**: The file header declares it "owns the two free-complex declarations", listing `cechFreePresheafComplex` and `cechFreeComplex_quasiIso`. Only `cechFreePresheafComplex` (line 201) is actually in the file. `cechFreeComplex_quasiIso` is referenced six times in comments/docstrings within this file (lines 21, 30, 72, 279, 337, 432) and once in `PresheafCech.lean` (line 23 cross-ref), but the declaration does not exist anywhere in the project. The module header is aspirational, not descriptive. **(Major)**
  - **Stale `cechFreeComplexAug` docstring (line 337)**: "The quasi-isomorphism claim `cechFreeComplex_quasiIso` asserts this map is a quasi-isomorphism." — implies the claim exists; it does not. **(Minor)**
  - **`FreeCechEngine` namespace duplicates `CombinatorialCech` from `CechAcyclic.lean` (lines 445–553)**: Nine declarations (`combDifferential`, `combHomotopy`, `combHomotopy_zero`, `cons_comp_succAbove_succ`, `combHomotopy_spec`, `combDifferential_eq_of_cocycle`, `combSign_flip`, `combDifferential_comp`, `combDifferential_exact`) are re-proved with identical proof bodies. The comment at line 439 explains: "those declarations are `private` there, hence unavailable here." This is a valid justification (the `private` barrier in `CechAcyclic.lean` prevents cross-file reuse). However, the correct fix is to de-privatize `CombinatorialCech.*` in `CechAcyclic.lean` (or extract to a shared file), not to duplicate. Additionally, `FreeCechEngine.*` are *not* private, while `CombinatorialCech.*` are — an inconsistent visibility design. **(Major)**
  - `freeYonedaEval_iso_of_le` (line 612): uses `Finsupp.LinearEquiv.finsuppUnique` applied to the unique hom-set `V ⟶ W` when `V ≤ W`. This is a genuine identification, not a vacuous shortcut. ✓
  - `isZero_sigma_of_forall_isZero` (line 621): a real lemma about zero coproducts, proved by showing `id = 0` via the universal property. ✓
  - `cechFreeEval_quasiIso_of_isEmpty` (line 687): handles the empty-cover-member case. Proof is genuine: it uses `Limits.isIso_of_source_target_iso_zero` to show both source and target homology vanish. ✓

---

## Must-fix-this-iter

None. No new sorries were introduced. No excuse-comments. No weakened-wrong definitions. All axiom hygiene passes.

---

## Major

- `FreePresheafComplex.lean:21` — Module header states this file owns `cechFreeComplex_quasiIso` as one of "the two free-complex declarations", but the declaration is absent project-wide. The file contains only the supporting machinery (`quasiIso_of_evaluation`, `cechFreeEval_quasiIso_of_isEmpty`, etc.) building toward it. The header is aspirational. Should be corrected to reflect actual content ("building toward `cechFreeComplex_quasiIso`") until the declaration is proved.

- `FreePresheafComplex.lean:445–553` + `CechAcyclic.lean:135–460` — `FreeCechEngine` duplicates 9 lemmas from `CombinatorialCech` with identical proofs. The privacy barrier in `CechAcyclic.lean` is the technical cause, but duplication of this scale accumulates maintenance debt. The fix is to de-privatize `CombinatorialCech.*` (making them reusable from `FreePresheafComplex.lean`) or to extract both into a shared file. The current design also creates a visibility inconsistency: `FreeCechEngine.*` is public while the logically prior `CombinatorialCech.*` is private.

---

## Minor

- `CechBridge.lean:206,208` — `show` tactic used to change the proof goal in `freeYonedaHomAddEquiv_naturality` (Mathlib style: `change` should be used instead). Linter warning is live.

- `CechAcyclic.lean:78,1107` — Line-length linter warnings (lines exceed 100-char limit). Cosmetic.

- `CechAcyclic.lean:131–133` — Docstring for `CombinatorialCech` namespace says declarations "exist only to close `CechAcyclic.affine`." In fact three of them (`cons_comp_zero_succAbove`, `cons_comp_succAbove_succ`, `comp_succAbove_swap`) are also used by the public `CechLocalized.*` lemmas (`cech_hu`, `cech_hsh`, `cech_hcomm`) elsewhere in the same file. Slightly imprecise docstring; no misleading effect.

- `FreePresheafComplex.lean:337` — `cechFreeComplexAug` docstring says "`cechFreeComplex_quasiIso` asserts this map is a quasi-isomorphism" without noting the declaration is absent. Once `cechFreeComplex_quasiIso` is proved, this becomes accurate; until then it implies something that doesn't exist.

- `CechBridge.lean:52–64` — Planned downstream declarations (`injective_cech_acyclic`, `ses_cech_h1`, `cech_eq_cohomology_of_basis`, `affine_serre_vanishing`) listed in the module header under the proved items. Currently labelled "planned" so not misleading, but the format will require maintenance when they are proved.

---

## Excuse-comments (always called out separately)

None found. No declaration in any of the three files carries a comment of the form "placeholder", "TODO: replace", "wrong but works", "temporary", or "will fix later."

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: Three files are axiom-clean with no new sorries and no excuse-comments; the single pre-existing sorry in `CechAcyclic.affine` is known and intentional. The two major findings are a stale module docstring in `FreePresheafComplex.lean` (claims to own `cechFreeComplex_quasiIso`, which is absent) and a 9-lemma code duplication between `FreeCechEngine` and `CombinatorialCech` that should be resolved by de-privatizing or extracting the combinatorial core.
