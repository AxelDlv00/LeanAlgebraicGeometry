# Lean Audit Report

## Slug
iter030

## Iteration
030

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 1 flagged (see notes)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **New lemma `base_change_mate_fstar_reindex_legs_link_distributeCollapse` (line 1333–1367):**
    Genuine, non-circular building block. It applies `base_change_mate_fstar_reindex_legs_gammaDistribute`
    (itself clean: calls only `base_change_mate_fstar_reindex_legs_unitExpand` + plain category theory)
    and then collapses factor 3 (the `pushforwardComp` hom-coherence, which is `rfl`-trivially `𝟙`) via a
    term-mode `congrArg`/`.trans`/`exact` chain. No sorry, no circularity, no axiom shortcut.
  - **`sorry` at line 1461 (`base_change_mate_fstar_reindex_legs`):**
    The `refine ... (base_change_mate_fstar_reindex_legs_link_distributeCollapse ...).trans ?_` correctly
    splices the new building block; the `sorry` covers the remaining "eCancel telescoping + survivor
    identification" obligation. The surrounding inline comment (lines 1427–1460) accurately describes
    what remains, including the three cancellation sub-goals and the `base_change_mate_unit_value` close.
    No false "closed" claim.
  - **`sorry` at line 1833 (`base_change_mate_gstar_transpose`):**
    Body comment at lines 1742–1832 is accurate: scaffold is landed (verified compiling per the comments),
    and the `sorry` marks two genuinely outstanding steps (inner-reindex reproof inline + generator close).
    The comment at line 1757–1760 correctly notes that `base_change_mate_fstar_reindex` is sorry-backed
    and must NOT be cited — this is an honest and important disclosure.
  - **Honest "transitively `sorry`-backed" docstrings:** `base_change_mate_section_identity` (lines 1852–1860)
    and `pushforward_base_change_mate_cancelBaseChange` (lines 1925–1931) both explicitly state
    "body has no inline `sorry`… but it is **transitively `sorry`-backed** through
    `base_change_mate_gstar_transpose`." Correct and honest.
  - **INCONSISTENT DISCLOSURE — `base_change_mate_fstar_reindex` (line 1475) and
    `base_change_mate_inner_value_eq` (line 1624):** Both are transitively sorry-backed through
    `_fstar_reindex_legs` → `sorry` at line 1461. Yet neither docstring carries the explicit
    "transitively `sorry`-backed" disclaimer that comparable declarations do. The body comment of
    `base_change_mate_inner_value_eq` (lines 1643–1650) does explain the dependency chain ("CASCADE
    (iter-028)"), and the comment in `base_change_mate_gstar_transpose` (line 1757) explicitly names
    `_fstar_reindex` as sorry-backed; but a reader looking only at the two affected docstrings
    would miss this. The inconsistency is a documentation gap rather than an active false claim.
  - **`sorry` at lines 2014 and 2036** (`affineBaseChange_pushforward_iso`,
    `flatBaseChange_pushforward_isIso`): both correctly documented in their bodies; the former
    explicitly names the remaining multi-hundred-LOC obligation (affine-restriction compatibility
    of `pushforwardBaseChangeMap`, Mathlib-absent), the latter states the Čech-cohomology gap.
  - **STATUS / UPDATE comment block (lines 183–246):** Historical progress notes referencing
    iter-234/236. They correctly describe the resolved carrier-instance wall and the element-free
    route that succeeded. The claim "fully proved, no `sorry`" for `pushforward_spec_tilde_iso`
    is verified accurate: the proof body (lines 541–653) contains no sorry.
  - **`set_option maxHeartbeats`:** Two instances (`4000000` at lines 979 and 1371; `1600000` at
    line 1465). The first (Seam-1 `base_change_mate_unit_value`) and second (new building block)
    are expected and carry explanatory comments. Not a bad practice for these heavy elaborations.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **4 pre-existing `sorry` bodies** (lines 126, 165, 201, 228): `hilbertPolynomial`,
    `QuotFunctor`, `Grassmannian`, `Grassmannian.representable` — all carry their docstrings
    accurately labeled "for the iter-176 file-skeleton the body is a typed `sorry`." These are
    known, honest stubs; not this iter's new additions.
  - **6 new declarations in `section OverSiteSheafEquivalence` (lines 776–882):**
    All are genuine proofs, free of `sorry`, `Classical.choice`, and unsanctioned axioms. Detail:

    1. **`overEquivalence_functor_isCocontinuous`** (line 786): `IsCocontinuous` proof by
       `GrothendieckTopology.mem_over_iff` + Subtype embedding argument + `Sieve.overEquiv_iff`
       + `Sieve.downward_closed`. Clean.
    2. **`overEquivalence_inverse_isCocontinuous`** (line 815): Dual direction.
       `apply Subsingleton.elim` at line 837 closes the commutativity obligation of
       `Over.homMk (homOfLE hdomle) ?_`. This is legitimate: morphism equalities in
       `TopologicalSpace.Opens` (a preorder category) are `Prop`-valued hence subsingleton;
       the use of `Subsingleton.elim` is correct and does not smuggle a false claim.
    3. **`overEquivalence_inverse_isDenseSubsite`** (line 841): One-line instance via
       `Equivalence.isDenseSubsite_inverse_of_isCocontinuous`. No sorry; both cocontinuity
       prerequisites are the immediately-preceding instances.
    4. **`overEquivalence_functor_isContinuous`** (line 849): Derived from the cocontinuity of
       the inverse (as `(Opens.overEquivalence U).symm.functor.IsCocontinuous`) via
       `toAdjunction.isContinuous_of_isCocontinuous`. Correct derivation.
    5. **`overEquivalence_inverse_isContinuous`** (line 860): Symmetric; applies
       `toAdjunction.isContinuous_of_isCocontinuous` on the forward adjunction. Clean.
    6. **`overEquivalence_sheafCongr`** (line 877): `noncomputable def` that directly applies
       `(Opens.overEquivalence U).sheafCongr`. Non-circular; all prerequisites are the five
       instances above plus Mathlib's `Equivalence.sheafCongr`. No sorry.

  - **Section/namespace balance:** `section OverSiteSheafEquivalence` opened at line 776, closed
    at line 882; `end AlgebraicGeometry` at line 884 matches the `namespace AlgebraicGeometry`
    re-opened at line 450. All balanced.
  - **Comments are accurate:** The section-header comment (lines 751–774) correctly describes
    the TODO being filled and the foundational/geometric layer division. Per-declaration
    docstrings correctly describe what each declaration does and its role in the downstream
    `overRestrictIso` chain.
  - **No excuse-comments**: No "temporary", "will fix later", or similar markers.
  - **`Subsingleton.elim` is the only one flagged:** Investigated and confirmed legitimate (see item 2 above).

---

## Must-fix-this-iter

None. No weakened-wrong definitions, no excuse-comments, no substantive false claims in docstrings,
no unauthorized axioms, no `Subsingleton.elim` smuggling.

The surviving `sorry` occurrences are all acknowledged in surrounding comments or in downstream
docstrings; none is concealed or mislabeled as closed.

---

## Major

- `FlatBaseChange.lean:1475` — `base_change_mate_fstar_reindex`: Docstring does not disclose that
  this theorem is transitively `sorry`-backed (through `_fstar_reindex_legs:1461`). Comparable
  declarations at lines 1852 and 1926 carry explicit "transitively `sorry`-backed" disclaimers;
  this one lacks that annotation. The body comment (lines 1494–1519) is accurate but a reader
  scanning only the docstring would miss the sorry dependency.

- `FlatBaseChange.lean:1624` — `base_change_mate_inner_value_eq`: Same documentation gap.
  Proof body is `exact base_change_mate_fstar_reindex ψ φ M`, which is sorry-backed. The body
  comment (lines 1643–1650) explains the dependency chain, but the docstring is silent on sorry
  status. Inconsistent with the explicit disclosures in `base_change_mate_section_identity` and
  `pushforward_base_change_mate_cancelBaseChange`.

---

## Minor

- `FlatBaseChange.lean:183–246` — The `STATUS (iter-234)` / `UPDATE (iter-236)` comment block
  is a large historical progress log embedded in a `/-! … -/` section comment. It is accurate
  (the claims about resolved routes and `pushforward_spec_tilde_iso` being sorry-free are
  verified correct), but its iter-number references will become opaque noise over time. Low-impact.

- `FlatBaseChange.lean:1757–1760` — Comment in `base_change_mate_gstar_transpose` says "must be
  REPROVEN INLINE here, not cited" to avoid citing the sorry-backed `_fstar_reindex`. The intent
  is correct, but the current `sorry` at 1833 means the reproof has not yet happened. This is
  accurate (the comment describes the plan, not the state), but a reader may interpret "must be
  reproven" as a post-facto description rather than a remaining obligation. Cosmetically: the
  "REMAINING CRUX" comment at 1820 is unambiguous and correct.

---

## Excuse-comments (always called out separately)

None found in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (both in `FlatBaseChange.lean`; documentation-only, not wrong mathematics)
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: Both files are mathematically honest and code-structurally sound. The new
`link_distributeCollapse` building block is genuine and non-circular. The 6 new `OverSiteSheafEquivalence`
declarations in `QuotScheme.lean` are axiom-clean genuine proofs. The two major findings are
inconsistent `sorry`-status disclosure in docstrings (`base_change_mate_fstar_reindex` and
`base_change_mate_inner_value_eq`); no incorrect mathematics is claimed closed.
