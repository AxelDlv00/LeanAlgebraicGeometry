# lean-auditor-iter021: Quot-Foundations audit

**Date**: 2026-06-07
**Iteration**: Archon 021
**Scope**: All 8 `.lean` files in the project

---

## Per-file checklist

### 1. `AlgebraicJacobian.lean` (7 lines)

- [x] No sorries
- [x] All 6 submodule imports present; no duplicate imports
- [x] No declarations, no docstrings to audit

**Verdict**: CLEAN

---

### 2. `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (99 lines)

- [x] No sorries
- [x] `base_change_regroup_linearEquiv` fully proved via `TensorProduct.induction_on` +
      `cancelBaseChange_tmul`
- [x] Axiom-clean (`propext`, `Quot.sound` only, per module doc)
- [x] No stale comments

**Verdict**: CLEAN

---

### 3. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (1749 lines)

#### Known sorries (pre-acknowledged — reported but not flagged as new)

| Line | Declaration | Status |
|------|-------------|--------|
| 1421 | `base_change_mate_fstar_reindex_legs` | KNOWN — literal-form lock blocker (after `subst hfst/hsnd`, leg `g'` is locked and `rw [unitExpand]`/`rw [gammaDistribute]` cannot match); standalone witness lemmas `…_unitExpand` / `…_gammaDistribute` proved |
| 1551 | `base_change_mate_gstar_transpose` | KNOWN — PARTIAL; conjugate-equiv counit route documented; must reprove Seam-2 content inline (cannot cite the @1421-backed `base_change_mate_fstar_reindex`) |
| 1724 | `affineBaseChange_pushforward_iso` | KNOWN — affine restriction-compatibility of `pushforwardBaseChangeMap`, Mathlib-absent |
| 1746 | `flatBaseChange_pushforward_isIso` | KNOWN — Čech-cohomology infrastructure deferred |

#### New findings — stale / inaccurate comments

**M1 (minor) — L1573**, docstring of `base_change_mate_section_identity`:

> "typed `sorry` at the per-generator node below"

The sorry is **not** in the immediate proof body of `base_change_mate_section_identity`. Its body is:
```lean
  unfold pushforwardBaseChangeMap
  rw [Adjunction.homEquiv_counit]
  exact base_change_mate_gstar_transpose ψ φ M   -- sorry lives here (L1551)
```
The `below` locator is inaccurate; the sorry is inside the called lemma `base_change_mate_gstar_transpose`.

**M2 (minor) — L1641**, docstring of `pushforward_base_change_mate_cancelBaseChange`:

> "the outstanding obligation (typed `sorry` below)"

The sorry is not directly below. The call chain is:
`pushforward_base_change_mate_cancelBaseChange`
  → `base_change_mate_generator_trace`
  → `base_change_mate_section_identity`
  → `base_change_mate_gstar_transpose` (sorry at L1551)

Three call-levels deep. The `below` locator is inaccurate.

**M3 (minor) — L1537–1538**, inline comment inside `base_change_mate_gstar_transpose` body:

> "`base_change_mate_fstar_reindex` asserts exactly this but is currently sorry-backed
> (its `…_legs` apparatus carries a **dead** `sorry`)"

The phrase "dead `sorry`" is ambiguous. In context it means "blocked by a rewrite-matching issue pending a refactor, not a mathematical obstruction." The blocker is the literal-form lock after `subst`; the route description at L1412–1420 is still live and the mathematical claim of `base_change_mate_fstar_reindex_legs` is believed correct. A reader may incorrectly infer the mathematical claim is false. Adding "blocked by a rewrite-matching issue (not a mathematical obstruction)" would prevent misreading.

#### Fully proved content confirmed

`pushforwardBaseChangeMap`, all locality criteria (`Modules.isIso_iff_*`), all Γ-fragment isos
(`gammaPushforwardIso`, `gammaPushforwardTildeIso`, `gammaPushforwardIsoAt`),
`tildeRestriction_isLocalizedModule`, `pushforward_spec_tilde_iso`, `pullback_spec_tilde_iso`,
`pullback_fst_snd_specMap_tensor`, `base_change_mate_domain_read`, `base_change_mate_regroupEquiv`,
`base_change_mate_unit_value` (Seam 1), `base_change_mate_inner_value`,
`base_change_mate_codomain_read_legs`, `pullbackPushforward_unit_comp`,
`base_change_mate_fstar_reindex_legs_unitExpand`, `base_change_mate_fstar_reindex_legs_gammaDistribute`,
`base_change_mate_fstar_reindex` (sorry-backed transitively; no direct sorry in body),
`base_change_mate_section_identity` (sorry-backed transitively),
`base_change_mate_generator_trace`, `pushforward_base_change_mate_cancelBaseChange`,
`base_change_mate_section_identity`, `base_change_mate_generator_trace`,
`base_change_map_affine_local`.

**Verdict**: 4 known sorries (pre-acknowledged); 3 minor comment inaccuracies (M1–M3).

---

### 4. `AlgebraicJacobian/Picard/RelativeSpec.lean` (293 lines)

- [x] No sorries in code
- [x] `QcohAlgebra`, `RelativeSpec`, `structureMorphism`, `UniversalProperty`, `affine_base_iff`
      all proved
- [x] Module doc's historical `sorry` references (lines 18–35) describe closed past state; current
      code is sorry-free
- [x] Forward-looking "iter-174+" notes in docstrings are not excuse-comments; current types are
      substantive
- [!] **M4 (minor)** `UniversalProperty` name implies full Yoneda-representability
      (`CategoryTheory.Functor.RepresentableBy` / Hom-bijection) but the theorem proves only
      `IsAffineHom (RelativeSpec.structureMorphism 𝒜)`. The docstring explicitly acknowledges
      this as a pending type refinement ("iter-174+: refine…"). The current type IS substantive
      and downstream-usable without a bridge lemma. Severity: minor (weakened type, documented).

**Verdict**: CLEAN (1 minor observation, documented)

---

### 5. `AlgebraicJacobian/Picard/FlatteningStratification.lean` (2112 lines)

#### Known sorries (pre-acknowledged — reported but not flagged as new)

| Line | Declaration | Status |
|------|-------------|--------|
| 2021 | `genericFlatnessAlgebraic` | KNOWN — B/𝔭 cascade; L4 + L5 both now closed; "pure assembly" comment at L1997–1998 accurate |
| 2109 | `genericFlatness` | KNOWN — geometric form; ring↔module localisation bridge documented accurately |

#### Must-fix finding

**MF1 (MAJOR, must-fix-this-iter) — L531**, inside `exists_localizationAway_finite_mvPolynomial`:

```
-- ===================================================================
-- iter-018 foundation (proved below, `g`-independent and reusable). The
-- remaining `sorry` is the denominator-clearing assembly; all the API it needs
-- is verified present and recorded in the roadmap comment that follows.
-- ===================================================================
```

`exists_localizationAway_finite_mvPolynomial` is **L4 — closed this iter**. Grep over the
entire file confirms zero `sorry` keywords between line 505 and line 1924 (`end GenericFreeness`);
the only `sorry` keywords in the file are at lines 2021 and 2109. The comment was written at
iter-018 when the denominator-clearing assembly was still open. It was not removed when L4 was
closed. It now **actively misleads**: anyone checking L4's sorry status reads "The remaining
`sorry` is the denominator-clearing assembly" and incorrectly concludes the function still carries
an active sorry.

**Corrective action**: Remove the iter-018 banner entirely, or replace the stale sentence with
"The denominator-clearing assembly is proved below (L4 closed iter-021)."

#### Fully proved content confirmed

`exists_free_localizationAway_of_torsion`, `free_localizationAway_of_away_tower`,
`exists_free_localizationAway_of_finite`, `exists_free_localizationAway_polynomial`,
`exists_free_localizationAway_of_shortExact`,
**`exists_localizationAway_finite_mvPolynomial` (L4, newly closed this iter)**, all helper
lemmas in `GenericFreeness`, `gf_generic_rank_ses`, `gf_torsion_annihilator`,
`gf_nagata_monic_lastVar`, `mvPolynomial_quotient_finite_of_monic_lastVar`.

**Verdict**: 2 known sorries (pre-acknowledged); **1 must-fix stale comment at L531**.

---

### 6. `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` (1288 lines)

- [x] No sorries (grep confirms zero)
- [x] Module doc correctly states "Split from `AlgebraicJacobian/Picard/QuotScheme.lean`
      (iter-021)" — accurate split attribution
- [x] `import Mathlib` only — standalone from `QuotScheme.lean`, no circular dependency
- [x] No duplicate declarations with `QuotScheme.lean`
- [x] Ambient `M` strategy applied throughout (no `IsInternal`/`map_iSup` over `↥p`
      carriers) — consistent with `memory/graded-quotient-module-isdefeq-pathology.md`
- [x] `IsRatHilb` predicate and all 6 toolkit lemmas proved
- [x] `SubquotientDatum` structure and constructors proved
- [x] `gradedModule_hilbertSeries_rational` (Stacks 00K1) proved
- [x] No stale references to old single-file layout

**Verdict**: CLEAN

---

### 7. `AlgebraicJacobian/Picard/GrassmannianCells.lean` (635 lines)

- [x] No sorries
- [x] `universalMatrix`, `minorDet`, `universalMinor`, `isUnit_det_universalMinor`,
      `universalMinorInv`, `universalMinorInv_mul_cancel`, `imageMatrix`, `transitionPreMap`
      all proved
- [x] `universalMatrix_submatrix_self`, `imageMatrix_submatrix_self`,
      `imageMatrix_submatrix_I` proved
- [x] `universalMatrix_map_transitionPreMap`, `isUnit_transitionPreMap_minorDet`,
      `transitionMap` proved
- [x] `transitionMap_self` proved
- [x] `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK`, `cocycleCondition` all proved
- [x] Private helpers (`mul_submatrix_col`, `map_nonsing_inv`, `isUnit_incl_transitionPreMap_cross`,
      `cocycle_imageMatrix_eq`, etc.) correctly scoped
- [x] No stale comments

**Verdict**: CLEAN

---

### 8. `AlgebraicJacobian/Picard/QuotScheme.lean` (424 lines)

#### Known sorries (pre-acknowledged — all correctly documented file-skeleton stubs)

| Line | Declaration | Docstring status |
|------|-------------|-----------------|
| 126 | `hilbertPolynomial` | "iter-176 file-skeleton, typed `sorry`" — accurate |
| 165 | `QuotFunctor` | "iter-176 file-skeleton, typed `sorry`" — accurate |
| 201 | `Grassmannian` | "iter-176 file-skeleton, typed `sorry`" — accurate |
| 228 | `Grassmannian.representable` | "iter-176 file-skeleton, typed `sorry`" — accurate |

- [x] No stale references to old single-file (pre-split) layout
- [x] No duplicate declarations with `GradedHilbertSerre.lean`
- [x] Non-sorry content (`IsLocallyFreeOfRank`, `annihilator`, `annihilator_ideal_le`,
      `schematicSupport`, `schematicSupportι`, `HasProperSupport`,
      `Module.annihilator_isLocalizedModule_eq_map`) all proved
- [!] "iter-176 / iter-177+" labels in docstrings originate from the parent project
      (Algebraic-Jacobian-Challenge). The current project is at iter-021. These are historical
      timestamps from the extraction source, not the Quot-Foundations iteration counter. Not
      actively misleading (sorry status is accurately described under each label), but may
      confuse readers unfamiliar with the two-project history. Severity: minor/informational.

**Verdict**: 4 known sorries (pre-acknowledged); 1 minor informational observation.

---

## Cross-file checks

### Split correctness (iter-021 refactor)

| Check | Result |
|-------|--------|
| `GradedHilbertSerre.lean` imports only `Mathlib` | PASS — no circular dep with `QuotScheme.lean` |
| `QuotScheme.lean` imports only `Mathlib` | PASS — no reference to split-off content |
| `AlgebraicJacobian.lean` imports both | PASS |
| No declaration appears in both files | PASS — namespaces disjoint |
| `GradedHilbertSerre` module doc attributes split to iter-021 | PASS — accurate |

### Sorry inventory (project-wide)

| File | Count | Lines | All pre-acknowledged? |
|------|-------|-------|-----------------------|
| `FlatBaseChange.lean` | 4 | 1421, 1551, 1724, 1746 | YES |
| `FlatteningStratification.lean` | 2 | 2021, 2109 | YES |
| `QuotScheme.lean` | 4 | 126, 165, 201, 228 | YES |
| `GradedHilbertSerre.lean` | 0 | — | n/a |
| `GrassmannianCells.lean` | 0 | — | n/a |
| `RegroupHelper.lean` | 0 | — | n/a |
| `RelativeSpec.lean` | 0 | — | n/a |
| **Total** | **10** | | **YES** |

No unacknowledged sorries found.

### Axiom hygiene

- No `axiom` keyword in any source file (inspection confirms).
- All sorry-carrying theorems are correctly presented as incomplete obligations.
- `RegroupHelper.lean` is axiom-clean per module doc.

---

## Issue summary

### Must-fix-this-iter (1)

| File | Line | Finding |
|------|------|---------|
| `FlatteningStratification.lean` | 531 | Stale iter-018 comment inside the now-complete `exists_localizationAway_finite_mvPolynomial` (L4) claims "The remaining `sorry` is the denominator-clearing assembly." L4 was closed this iter; no sorry exists in this function. **Action**: remove or update the banner. |

### Major (0 new beyond must-fix)

None.

### Minor (4)

| ID | File | Line(s) | Finding |
|----|------|---------|---------|
| M1 | `FlatBaseChange.lean` | 1573 | "typed `sorry` at the per-generator node below" in docstring of `base_change_mate_section_identity` — sorry is inside called lemma `base_change_mate_gstar_transpose` (L1551), not "below" in the immediate proof body |
| M2 | `FlatBaseChange.lean` | 1641 | "outstanding obligation (typed `sorry` below)" in docstring of `pushforward_base_change_mate_cancelBaseChange` — sorry is three call-levels deep, not directly below |
| M3 | `FlatBaseChange.lean` | 1537–1538 | "carries a dead `sorry`" applied to `base_change_mate_fstar_reindex_legs` — ambiguous; means "blocked pending a rewrite-matching refactor," not "mathematical claim is false"; a clarifying parenthetical would prevent misreading |
| M4 | `RelativeSpec.lean` | ~230 | `UniversalProperty` name implies full Yoneda `RepresentableBy` witness; theorem proves only `IsAffineHom`; acknowledged in docstring as pending refinement; no bridge needed for current downstream use |

### Excuse-comments (0)

None found. All sorry-adjacent comments contain route descriptions, accurate status updates, or
historical iteration markers. No comment excuses a wrong definition or admits a claim is
unprovable.

---

## Overall verdict

**PASS-WITH-ISSUES** — 8 files audited, 10 sorries (all pre-acknowledged), 1 must-fix + 4 minor issues.

The must-fix (FlatteningStratification.lean:531) is a stale comment inside a theorem whose sorry
was closed this iter; it does not affect elaboration or proof correctness, but will actively
mislead any future reader checking L4's status. The four minors are comment inaccuracies
(imprecise "below" locators, an ambiguous adjective, and one documented type-weakening) with no
correctness impact.

The iter-021 file-split (QuotScheme → GradedHilbertSerre) is structurally correct: no dangling
references, no duplicate declarations, no stale cross-references.
