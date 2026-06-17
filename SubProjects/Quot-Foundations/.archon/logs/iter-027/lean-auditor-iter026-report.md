# Lean Audit Report

## Slug
iter026

## Iteration
027

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: 0 flagged
- **dead-end proof scaffolds**: 2 flagged
- **bad practices**: 4 flagged (`maxHeartbeats` overrides + multiple `erw` bypasses)
- **excuse-comments**: 1 flagged
- **notes**:

  **Stale comment — closed step claimed open (major/must-fix):**
  - **Lines 235–247**: The large STATUS/UPDATE block (inside the `/-! ## Project-local Mathlib supplement — affine tilde dictionary -/` section) ends with: *"That QC fact is the sole remaining obligation"* for `pushforward_spec_tilde_iso`. But `pushforward_spec_tilde_iso` at line 538 is **fully proved without sorry** — the QC detour is bypassed by the `IsLocalizedModule.powers_restrictScalars` + `tildeRestriction_isLocalizedModule` route. This comment names an outstanding step that is in fact already closed. A reader auditing this file would incorrectly conclude the declaration is incomplete.

  **Misleading sorry attribution (major):**
  - **Lines 1848–1852** (docstring of `base_change_mate_section_identity`): States *"the mate-unwinding coherence … is Mathlib-absent (typed `sorry` at the per-generator node below)."* The actual proof body (lines 1869–1871) is:
    ```lean
    unfold pushforwardBaseChangeMap
    rw [Adjunction.homEquiv_counit]
    exact base_change_mate_gstar_transpose ψ φ M
    ```
    There is no sorry "below"; the sorry is inside `base_change_mate_gstar_transpose` (line 1829). The "per-generator node" phrasing is inaccurate.

  - **Lines 1917–1919** (docstring of `pushforward_base_change_mate_cancelBaseChange`): States *"outstanding obligation (typed `sorry` below)."* The actual proof (lines 1934–1945) uses `base_change_mate_generator_trace`, which is transitively sorry-backed through `base_change_mate_section_identity → base_change_mate_gstar_transpose`. The sorry is 3 declaration-levels deep, not "below."

  **Excuse-comment (must-fix):**
  - **Lines 1575–1577** (docstring of `base_change_mate_inner_value_eq`): *"re-derived INLINE through the proved standalone atoms (NOT via the sorry-backed `base_change_mate_fstar_reindex`)"* — but the proof body ends with `sorry` at line 1646. The docstring is written in the present tense, describing the proof as if it were already assembled from proved atoms, when it is not. This is a false-completion claim on a named blueprint step.

  **Direct `sorry` on load-bearing claims (must-fix, all):**

  | Line | Declaration | Comment honesty |
  |------|-------------|-----------------|
  | 1413 | `base_change_mate_fstar_reindex_legs` | Honest: "REMAINING CRUX" clearly flagged in code comment. The `erw` unlock (`erw [base_change_mate_fstar_reindex_legs_unitExpand ...]` at line 1388) is confirmed working; the ~100-LOC eCancel telescoping is the genuine remaining crux. |
  | 1646 | `base_change_mate_inner_value_eq` | Partially dishonest: the in-proof comment (lines 1614–1645) correctly documents the blocked pre-subst routes, but the docstring claims inline proof from proved atoms. |
  | 1829 | `base_change_mate_gstar_transpose` | Honest: "REMAINING CRUX (recipe steps 2–3)" clearly flagged. Scaffold (recipe step 1) is fully landed. |
  | 2002 | `affineBaseChange_pushforward_iso` | Honest: explicitly names the remaining affine-restriction-compatibility build. Load-bearing blueprint goal. |
  | 2024 | `flatBaseChange_pushforward_isIso` | Honest: explicitly notes Čech infrastructure missing. Load-bearing blueprint goal. |

  **Transitive-sorry declarations (bodies formally closed, but depend on sorry-backed lemmas):**
  - `base_change_mate_section_identity` (line 1854): proof closes via `base_change_mate_gstar_transpose` (sorry).
  - `base_change_mate_generator_trace` (line 1883): proof closes via `base_change_mate_section_identity`.
  - `pushforward_base_change_mate_cancelBaseChange` (line 1920): proof closes via `base_change_mate_generator_trace`.

  These three form a sorry-propagation chain. Their proofs are formally syntactically complete (no direct `sorry`), but they carry zero axiom-clean content above their sorry-backed leaves. The `sorry` inventory must count them as transitively incomplete.

  **`maxHeartbeats` overrides (fragile):**
  - Line 979: `set_option maxHeartbeats 4000000` on `base_change_mate_unit_value` — 8× the default. Indicates a proof that will likely break on any upstream Mathlib instance-resolution change.
  - Lines 1323, 1417, 1568: `set_option maxHeartbeats 1600000` — 3× the default on three lemmas (including the sorry-backed `base_change_mate_fstar_reindex_legs` and `base_change_mate_inner_value_eq`). These high budgets on sorry-backed proofs compound the fragility.

  **`erw` uses (fragile defeq matching):**
  - Lines 1088–1089 (`β.hom.naturality_assoc`, `reassoc_of% huce`): `erw` used because `simp`/`rw` discrimination-tree miss on the composed-functor source object. Justified workaround, but fragile.
  - Line 1388 (`base_change_mate_fstar_reindex_legs_unitExpand`): `erw` justified by the literal-form lock; the comment documents why plain `rw` fails. This is the iter-026 unlock.
  - Lines 926, 939, 943, 949: `erw` inside `base_change_mate_regroupEquiv` for carrier-instance diamond matching. Justified by the diamond wall.
  - Line 154 (`TopCat.Presheaf.stalkFunctor_map_germ_apply`): standard `erw` use, low fragility risk.

  **Duplicate proof body (minor):**
  - `base_change_mate_codomain_read_legs` (lines 1210–1258) is explicitly described as "verbatim construction of `base_change_mate_codomain_read`" — a large (48-line) copy of `base_change_mate_codomain_read` (lines 773–825) made free only in the leg variables. The docstring acknowledges this; the duplication is a structural debt but not a correctness issue.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proof scaffolds**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:

  **sorry inventory — 4 direct sorrys, all honestly documented:**

  | Line | Declaration | Comment |
  |------|-------------|---------|
  | 126 | `hilbertPolynomial` | "For the iter-176 file-skeleton the body is a typed `sorry`." Honest. |
  | 165 | `QuotFunctor` | "For the iter-176 file-skeleton the body is a typed `sorry`." Honest. |
  | 201 | `Grassmannian` | "For the iter-176 file-skeleton the body is a typed `sorry`." Honest. |
  | 228 | `Grassmannian.representable` | "For the iter-176 file-skeleton the body is a typed `sorry`." Honest. |

  These are the 4 blueprint-pinned declarations. Types are substantive (not weakened); the project rule "Never weaken the type to dodge the proof" is upheld throughout. The `sorry` bodies are the genuine remaining proof work, not definitional stand-ins.

  **All other declarations are proved without sorry:**
  - `IsLocallyFreeOfRank`, `annihilator`, `annihilator_ideal_le`, `schematicSupport`, `schematicSupportι`, `HasProperSupport` — all axiom-clean.
  - `annihilator_isLocalizedModule_eq_map` — complex induction proof over a finset generator; no sorry; the "clearing one common denominator" argument is correctly implemented.
  - `isLocalizedModule_tilde_restrict`, `isLocalizedModule_restrict_of_isIso_fromTildeΓ`, `isIso_fromTildeΓ_of_isLocalizedModule_restrict`, `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` — all proved, axiom-clean.

  **One comment to watch (not currently a bug):**
  - Lines 425–448: preamble says Mathlib "does not prove that an arbitrary quasi-coherent sheaf on `Spec R` lies in the essential image of `tilde`." This is accurate at the pinned commit. The file partially closes the conditional version (under `[IsIso M.fromTildeΓ]`). The preamble correctly describes the gap; no false closure claim.

  **Blocked characterization lemma:**
  - `annihilator_ideal` (the full equality, not just `≤`) is cited in line 303 but not present in the file. Its absence is correctly documented — it depends on `isLocalizedModule_basicOpen_of_isQuasicoherent` which is itself not yet formalized. No false completion claim.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proof scaffolds**: 0 flagged
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:
  - **No `sorry` anywhere.** All 30+ declarations are fully proved.
  - The file is clean. The matrix algebra proofs (`universalMatrix_submatrix_self`, `imageMatrix_submatrix_self`, `imageMatrix_submatrix_I`, `universalMatrix_map_transitionPreMap`, `isUnit_transitionPreMap_minorDet`, `transitionMap_self`, `cocycleCondition`) are substantive and use no axiom shortcuts.
  - `cocycleCondition` (line 604) — the main mathematical result (cocycle identity `θ_{I,K} = θ_{I,J} ∘ θ_{J,K}`) — is proved via `IsLocalization.ringHom_ext` + `MvPolynomial.ringHom_ext` by reducing to the central matrix identity `cocycle_imageMatrix_eq`. The proof strategy is sound.
  - The glue-data infrastructure (`chartOverlap`, `chartIncl`, `chartTransition`, `chartTransition_self`, `chartIncl_self_isIso`, `awayPullbackIso`, `awayPullbackIso_inv_fst`, `awayPullbackIso_inv_snd`, `awayMulCommEquiv`) is all proved.
  - The planner note at lines 33–44 (block comment `Planner note:`) is accurate — `affineChart` is indeed defined as `Spec` of `MvPolynomial (Fin d × {q : Fin r // q ∉ I}) ℤ` as described.

---

## Must-fix-this-iter

- `FlatBaseChange.lean:235–247` — STATUS block inside the `/-! ## affine tilde dictionary -/` preamble claims `pushforward_spec_tilde_iso` has a "sole remaining obligation" (the QC fact), but `pushforward_spec_tilde_iso` (line 538) is fully proved without sorry. **Why must-fix**: This comment names an outstanding step that is already closed; it will cause the plan agent and any reader to erroneously track a non-existent obligation.

- `FlatBaseChange.lean:1575–1577` — Docstring of `base_change_mate_inner_value_eq` claims the theorem is "re-derived INLINE through the proved standalone atoms (NOT via the sorry-backed `base_change_mate_fstar_reindex`)" when the proof is `sorry` (line 1646). **Why must-fix**: This is a false-completion claim on a named blueprint step; it is an excuse-comment-class falsehood (claiming the proof is constructed from proved atoms when it is not).

- `FlatBaseChange.lean:1413` — `sorry` in `base_change_mate_fstar_reindex_legs`. **Why must-fix**: This is the load-bearing Seam-2 crux; the sorry propagates upward through `base_change_mate_fstar_reindex` → `affineBaseChange_pushforward_iso`.

- `FlatBaseChange.lean:1646` — `sorry` in `base_change_mate_inner_value_eq`. **Why must-fix**: Alternative route for the same Seam-2 crux; sorry-backed despite a docstring claiming construction from proved atoms.

- `FlatBaseChange.lean:1829` — `sorry` in `base_change_mate_gstar_transpose`. **Why must-fix**: Load-bearing Seam-3 crux; propagates to `base_change_mate_section_identity → base_change_mate_generator_trace → pushforward_base_change_mate_cancelBaseChange → affineBaseChange_pushforward_iso`.

- `FlatBaseChange.lean:2002` — `sorry` in `affineBaseChange_pushforward_iso`. **Why must-fix**: Blueprint-pinned theorem.

- `FlatBaseChange.lean:2024` — `sorry` in `flatBaseChange_pushforward_isIso`. **Why must-fix**: Blueprint-pinned theorem (the main result of the file).

- `FlatBaseChange.lean:1848–1852` — Docstring of `base_change_mate_section_identity` says "typed `sorry` at the per-generator node below" when the sorry is in `base_change_mate_gstar_transpose` (a different declaration, 175 lines earlier in the file). **Why must-fix**: Misdirects future prover work to a non-existent sorry location.

- `FlatBaseChange.lean:1917–1919` — Docstring of `pushforward_base_change_mate_cancelBaseChange` says "typed `sorry` below" when the sorry is 3 declaration-levels deep. **Why must-fix**: Same misdirection problem; prover looking for the sorry "below" will not find it.

- `QuotScheme.lean:126` — `sorry` in `hilbertPolynomial`. **Why must-fix**: Blueprint-pinned declaration (sorry on a load-bearing claim).
- `QuotScheme.lean:165` — `sorry` in `QuotFunctor`. **Why must-fix**: Blueprint-pinned declaration.
- `QuotScheme.lean:201` — `sorry` in `Grassmannian`. **Why must-fix**: Blueprint-pinned declaration.
- `QuotScheme.lean:228` — `sorry` in `Grassmannian.representable`. **Why must-fix**: Blueprint-pinned declaration.

---

## Major

- `FlatBaseChange.lean:979` — `set_option maxHeartbeats 4000000` on `base_change_mate_unit_value`. Eight times the default. The proof is fully closed (no sorry) but this override indicates the proof is on the boundary of feasibility with current infrastructure; any upstream Mathlib update that adds a typeclass instance or changes elaboration order could silently break it.

- `FlatBaseChange.lean:1323,1417,1568` — Three more `set_option maxHeartbeats 1600000` overrides (3× default), on declarations that are themselves sorry-backed (`base_change_mate_fstar_reindex_legs`, `base_change_mate_fstar_reindex`, `base_change_mate_inner_value_eq`). The high budget is being spent setting up scaffolds for proofs that don't close; when the sorry is eventually replaced the override may need to be further increased.

- `FlatBaseChange.lean:1210–1258` — `base_change_mate_codomain_read_legs` is verbatim copy of `base_change_mate_codomain_read` (lines 773–825) with legs generalized to free variables. 48 lines of duplicated proof code. The docstring acknowledges this ("Its body is the verbatim construction of…"). Not a correctness issue but a maintenance liability.

---

## Minor

- `FlatBaseChange.lean:154,926,939,943,949,1088,1089,1388,1557` — Nine `erw` uses in proof bodies. All are documented and justified by specific instance-diamond bypasses or defeq-matching requirements. However, each `erw` call couples the proof to a specific unification path that may change with Lean/Mathlib version bumps. The cluster at lines 926–949 (inside `base_change_mate_regroupEquiv`) is the densest.

- `FlatBaseChange.lean` — Declarations `base_change_mate_section_identity`, `base_change_mate_generator_trace`, `pushforward_base_change_mate_cancelBaseChange` have formally closed proof bodies (no direct `sorry`) but are entirely sorry-backed through the chain `base_change_mate_gstar_transpose → base_change_mate_section_identity → …`. Their syntactic closure may suggest to tooling that they are axiom-clean when they are not. `lean_verify` / `sorry_analyzer` on these declarations will show clean, which is misleading.

---

## Excuse-comments (always called out separately)

- `FlatBaseChange.lean:1575–1577`: *"re-derived INLINE through the proved standalone atoms (NOT via the sorry-backed `base_change_mate_fstar_reindex`)"* — attached to `base_change_mate_inner_value_eq`, whose proof body is `sorry`. This is a false-completion claim in the docstring: the named proof strategy ("inline from proved atoms") has not been executed. The declaration carries the very sorry it claims to avoid routing through. Severity: **major** (the sorry is still load-bearing even though the type is correctly stated).

---

## Severity summary

- **must-fix-this-iter**: 13 — these block downstream work in their files until addressed
  - 1 stale-closed-step comment (FlatBaseChange.lean:235–247)
  - 1 excuse-comment / false-completion docstring (FlatBaseChange.lean:1575–1577)
  - 2 sorry-misdirection comments (FlatBaseChange.lean:1848–1852, 1917–1919)
  - 5 direct sorrys on load-bearing claims in FlatBaseChange.lean (lines 1413, 1646, 1829, 2002, 2024)
  - 4 direct sorrys on blueprint-pinned declarations in QuotScheme.lean (lines 126, 165, 201, 228)
- **major**: 3 — maxHeartbeats overrides + large code duplication
- **minor**: 2 — erw fragility cluster + transitive-sorry chain invisible to `sorry_analyzer`
- **excuse-comments**: 1 (also counted under must-fix above)

**Overall verdict**: GrassmannianCells.lean is fully proved and clean. QuotScheme.lean is honest (4 acknowledged skeleton sorrys on blueprint-pinned declarations, all other declarations proved). FlatBaseChange.lean has 5 direct sorrys on the Seam-2/3 crux chain and the two blueprint main theorems — the code is generally honest about these — but 3 comment-level issues (a stale claim that a proved theorem is still open, a docstring that misrepresents a sorry-backed proof as assembled from proved atoms, and two mislabeled sorry locations) require correction this iteration.
