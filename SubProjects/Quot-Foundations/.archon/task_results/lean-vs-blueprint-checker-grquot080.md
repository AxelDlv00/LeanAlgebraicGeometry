# Lean ↔ Blueprint Check Report

## Slug
grquot080

## Iteration
080

## Files audited
- Lean: `/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

The chapter contains **~96 `\lean{...}` pins** (plus 2 `\mathlibok`).
Declarations are grouped below; individual entries are given for every case deviating from "exists, signature matches, proof follows sketch."

---

### Batch check — infrastructure (`Scheme.Modules.*`, Group A, lines 56–512)

Covers: `pullbackComp` (`\mathlibok`), `pullbackBaseChangeTransport`, `glueData_bridge_src/mid/tgt`, `glue`, `glue_unique` (forward decl), `glueHom` (forward decl), `opensMap_final`, `pullbackFreeIso`, `pullbackFreeIso_eqToHom`, `pullbackFreeIso_trans_symm_eqToIso`, `pullback_isLocallyFreeOfRank`, `pullbackObjUnitToUnit_id`, `pullbackFreeIso_id`, `pullbackObjUnitToUnit_comp`, `homEquiv_conjugateEquiv_app`, `pullbackFreeIso_comp`.

All these declarations reside in `GlueDescent.lean` or `RegroupHelper.lean` (not `GrassmannianQuot.lean`). All `\lean{}` pins resolve to the correct fully-qualified names.

- **Lean target exists**: yes — all verified by grep in `GlueDescent.lean` and `RegroupHelper.lean`
- **Signature matches**: yes — blueprint prose matches the Lean signatures as read in context
- **Proof follows sketch**: yes / N/A (forward decls correctly annotated `% NOTE: forward declaration`)
- **`\leanok` state**: `pullbackComp` correctly `\mathlibok`; all others (`opensMap_final` through `pullbackFreeIso_comp`) correctly `\leanok` on both statement and proof blocks; `glueData_bridge_{src,mid,tgt}` lack `\leanok` despite existing in `GlueDescent.lean` — sync gap (minor; see §Severity summary)
- **Forward declarations** `glue_unique` / `glueHom`: correctly annotated as planned work; partial implementations exist in `GlueDescent.lean` under different names

---

### Batch check — chart quotient and scalar/matrix end (`Grassmannian.*`, lines 524–1670)

Covers (all in `GrassmannianQuot.lean`): `globalUnitSection`, `scalarEnd`/`scalarEnd_one`/`zero`/`comp`/`add`/`sum`, `matrixEnd`/`matrixEnd_comp`/`matrixEnd_one`, `matrixToFreeIso`/`matrixToFreeIso_hom`/`matrixToFreeIso_mul`, `chartQuotientMap`, `chartQuotientMap_epi`, `universalMinorInv_self`, `bundleTransition`, `bundleTransition_self`, `bundleTransitionData`, `bundleTransition_cocycle_matrix`, `scalarEnd_pullback`, `matrixEnd_pullback`, `baseChange_bridge_gammaSpec`/`left`/`right`/`transition`, `baseChange_bridge`, `bundleTransition_cocycle_transport`, `bundleTransition_cocycle` (= `lem:gr_bundleCocycle_mul`), `universalQuotient` (= `def:gr_universal_quotient_sheaf`), `matrixEnd_eq_matrixEndRect`, `matrixEndRect_one`, `matrixEndRect_comp_rect`, `matrixEndRect_injective`, `freeMap_matrixEndRect`, `exists_section_of_epi_free_spec`, `exists_rightInverse_of_epi_matrixEndRect_spec`, `exists_rightInverse_of_epi_matrixEndRect`, `pullbackFreeIso_inv_freeMap`, `presentedMatrix`, `matrixEndRect_presentedMatrix`, `matrixEndRect_presentedMatrix_minor`, `presentedMatrix_changeOfBasis`, `isUnit_of_isIso_matrixEndRect`.

- **Lean target exists**: yes — all verified by grep (line numbers 38–1305, 2966–3165)
- **Signature matches**: yes — informal statements in the chapter match the Lean signatures as read in prior iterations; no type-class substitutions detected
- **Proof follows sketch**: yes — proof bodies in Lean correspond to the blueprint sketches (rewrite/simp arguments for ring identities; pseudofunctor/biproduct extensionality for pullback lemmas; matrix-entry extraction for `matrixEndRect_injective`)
- **`\leanok` state**: NONE of these ~35 blocks have `\leanok` on either statement or proof. This is a **pervasive sync gap** (see §Severity below). Root cause: blueprint-writer `grquot-univ` ran this iteration and reorganized / significantly expanded the chapter after `sync_leanok` completed. The markers are absent from newly-written or moved blocks; they will be populated by the next `sync_leanok` run.

**Exception — `chartQuotientMap_ιFree`** (see individual entry below).
**Exception — `exists_isUnit_submatrix`** (see individual entry below).

---

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree}` (chapter: `lem:gr_chartQuotientMap_iFree`)

- **Lean target exists**: yes — `private lemma chartQuotientMap_ιFree` at line 314
- **Signature matches**: yes — proves `SheafOfModules.ιFree k ≫ chartQuotientMap = SheafOfModules.ιFree k` for the chart quotient, matching the prose ("the chart quotient composed with the k-th free inclusion equals the k-th free inclusion of the target")
- **Proof follows sketch**: N/A (no proof sketch in chapter)
- **notes**: Declaration is **`private`**. The `\lean{}` pin names `AlgebraicGeometry.Grassmannian.chartQuotientMap_ιFree` but this identifier is inaccessible from outside the module; the blueprint web view will fail to hyperlink. Not a mathematical error; see §Severity.

---

### `\lean{AlgebraicGeometry.Grassmannian.exists_isUnit_submatrix}` (chapter: `lem:gr_exists_isUnit_submatrix`)

- **Lean target exists**: yes — `private lemma exists_isUnit_submatrix` at line 2544
- **Signature matches**: yes — existence of an invertible `d×d` submatrix of a surjective `d×r` matrix over a field, matching the prose
- **Proof follows sketch**: N/A (no proof sketch in chapter)
- **notes**: Same as above — **`private`** declaration, `\lean{}` pin cannot resolve externally. Minor.

---

### Batch check — rectangular matrix calculus extension and tautological quotient (`Grassmannian.*`, lines 1671–1961)

Covers: `matrixEndRect`, `matrixEndRect_pullback`, `matrixEndRect_comp`, `tautologicalQuotientComponent_transpose`, `tautologicalQuotient_overlap`, `tautologicalQuotient`.

- **Lean target exists**: yes — all present in `GrassmannianQuot.lean`
- **Signature matches**: yes
- **Proof follows sketch**: yes — `tautologicalQuotientComponent_transpose` uses matrix-transpose and projection-restriction arguments as stated; `tautologicalQuotient_overlap` uses the transition isomorphism and cocycle identity as stated
- **`\leanok` state**: none present (same blueprint-writer rewrite gap as Group B)

---

### `\lean{AlgebraicGeometry.Grassmannian.RankQuotient, RankQuotient.Rel, rqPullback, rqPullback_rel}` (chapter: `def:gr_rankQuotient`)

- **Lean target exists**: yes — `structure RankQuotient` (lines ~2288–2302), `rqPullback` (line 2303), `rqPullback_rel` (line 2318)
- **Signature matches**: yes — `RankQuotient r d T` is the quotient set of locally-free-of-rank-d sheaves on `T` modulo isomorphism, matching the prose; `rqPullback` acts by `ψ^*`; `rqPullback_rel` proves it respects the relation
- **Proof follows sketch**: yes
- **notes**: The single `\lean{...}` block lists four names; all four resolve.

---

### `\lean{AlgebraicGeometry.Grassmannian.functor}` (chapter: `def:grassmannian_functor`)

- **Lean target exists**: yes — `noncomputable def functor (d r : ℕ) : Scheme.{0}ᵒᵖ ⥤ Type 1` at line 2343
- **Signature matches**: yes — contravariant functor `Sch → Set` assigning `RankQuotient r d T` to `T`, with functoriality via `rqPullback`, matching the prose
- **Proof follows sketch**: yes — identity and composition laws use `rqPullback_rel` and the pseudofunctor comparison `pullbackFreeIso_id`/`pullbackFreeIso_comp`
- **`\leanok` state**: none (same gap)

---

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient_epi}` (chapter: `lem:tautologicalQuotient_epi`)

- **Lean target exists**: yes — `theorem tautologicalQuotient_epi (d r : ℕ) : Epi (tautologicalQuotient d r)` at line 2469
- **Signature matches**: yes — epi statement for the tautological quotient `O^r → U` on `Gr(d,r)`, matching the blueprint prose
- **Proof follows sketch**: **no** — proof body is `:= sorry`; no proof in the Lean file
- **`\leanok` state**: statement block has NO `\leanok` (sync gap — the declaration exists, so the statement block should receive `\leanok` next sync; the directive notes this); proof block has NO `\leanok` (correct — sorry present)
- **notes**: This is the **sole residual sorry** in the file. Acknowledged as "honestly open" in the directive. See §Red flags.

---

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient_restrictionIso}` (chapter: `def:gr_universalQuotient_restrictionIso`)

- **Lean target exists**: yes — `noncomputable def universalQuotient_restrictionIso (d r : ℕ) (I : ...)` at line 2419
- **Signature matches**: yes — restriction of the universal quotient sheaf to the `I`-th chart is isomorphic to `chartQuotientMap d r I hI`, matching the prose
- **Proof follows sketch**: yes
- **`\leanok` state**: none (same gap; this declaration existed before this iter and should have been marked by sync_leanok — the blueprint-writer's reorganization explains the absence)

---

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient_isLocallyFreeOfRank}` (chapter: `lem:gr_universalQuotient_isLocallyFreeOfRank`)

- **Lean target exists**: yes — `theorem universalQuotient_isLocallyFreeOfRank (d r : ℕ)` at line 2434
- **Signature matches**: yes — states `universalQuotient d r` is locally free of rank `d`
- **Proof follows sketch**: yes — proof uses `universalQuotient_restrictionIso` to reduce to chart-local freeness, then `pullback_isLocallyFreeOfRank`; this matches the blueprint sketch ("choose the affine-chart cover, restrict via `universalQuotient_restrictionIso`, apply the pullback-preserves-rank lemma")
- **`\leanok` state**: neither statement nor proof block has `\leanok`; the proof has **no sorry** (closed this iteration); the statement marker is missing because the blueprint-writer ran after `sync_leanok`; the proof marker will be added next sync

---

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalRankQuotient}` (chapter: `def:gr_tautologicalRankQuotient`)

- **Lean target exists**: yes — `noncomputable def tautologicalRankQuotient (d r : ℕ) : RankQuotient r d (scheme d r)` at line 2475
- **Signature matches**: yes — packages the universal quotient as a `RankQuotient r d Gr(d,r)` using `tautologicalQuotient_epi` (sorry-bodied) and `universalQuotient_isLocallyFreeOfRank`
- **Proof follows sketch**: yes — definition body matches blueprint construction
- **notes**: Carries the sorry transitively via the `epi` field; `\leanok` on the proof block is blocked until `tautologicalQuotient_epi` closes.

---

### Batch check — iso-locus and chart machinery (`Grassmannian.*`, lines 2234–2670)

Covers: `isoLocus`, `isIso_pullback_isoLocus_map`, `chartComposite`, `chartLocus`, `chartLocus_isOpenCover`, `chartMatrix`, `chartMorphism`, `isIso_pullback_map_comp`, `presentedMatrix_congr`, `chartMatrix_eq_presentedMatrix`, `presentedMatrix_comp`, `presentedMatrix_submatrix_self`, `universalMatrix_map_presentedMatrix`, `imageMatrix_map_ringHom`, `comp_chartMorphism`, `chart_point_eq`, `chartMorphism_glue_compat`.

Plus `\mathlibok`: `TopCat.Presheaf.isIso_of_stalkFunctor_map_iso` — verified `\mathlibok` in blueprint.

- **Lean target exists**: yes — all present, line numbers confirmed (2497, 2867+, 3201, 3927, 3978, 3995, 4038, 4194, etc.)
- **Signature matches**: yes
- **Proof follows sketch**: yes — the stalk-iso criterion, chart-cover construction, matrix algebra, and glue-compatibility arguments in Lean follow the blueprint sketches
- **`\leanok` state**: none on any `Grassmannian.*` block (same gap); `isIso_of_stalkFunctor_map_iso` correctly `\mathlibok`

---

### `\lean{AlgebraicGeometry.Grassmannian.grPointOfRankQuotient}` (chapter: `def:grPointOfRankQuotient`)

- **Lean target exists**: yes — `noncomputable def grPointOfRankQuotient {T : Scheme.{0}} (d r : ℕ)` at line 4887
- **Signature matches**: yes — map `RankQuotient r d T → T ⟶ scheme d r` sending a rank-quotient to a morphism into `Gr(d,r)`, matching the blueprint prose
- **Proof follows sketch**: yes — construction goes through `chartMorphism` and `chartMorphism_glue_compat`
- **notes**: The map `grPointOfRankQuotient` was part of "represents inverse laws" closed this iteration; proof has no sorry.

---

### `\lean{AlgebraicGeometry.Grassmannian.chartComposite_rqPullback}` and `chartLocus_rqPullback` (chapter: `lem:gr_chartComposite_rqPullback`, `lem:gr_chartLocus_rqPullback`)

- **Lean target exists**: yes — lines 3201 and 4574
- **Signature matches**: yes — pullback of `chartComposite` / membership in `chartLocus` is preserved under `grPointOfRankQuotient ∘ rqPullback`
- **Proof follows sketch**: yes — these are the tautological-pullback bridges closed this iteration
- **`\leanok` state**: none (same gap)

---

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (chapter: `thm:grassmannian_universal_property`)

- **Lean target exists**: yes — `noncomputable def represents (d r : ℕ) (hd : 1 ≤ d) (hdr : d ≤ r) : (functor d r).RepresentableBy (scheme d r)` at line 5469
- **Signature matches**: yes — the `RepresentableBy` structure packages the bijection `T-points of Gr(d,r) ↔ RankQuotient r d T`, with inverse maps `grPointOfRankQuotient` / `rqPullback (tautologicalRankQuotient)`, matching the blueprint's representability statement. Lean adds explicit bounds `hd` and `hdr` (blueprint's "throughout r ≥ d ≥ 1" hypothesis); this is correct and expected.
- **Proof follows sketch**: yes — body uses `grPointOfRankQuotient_rqPullback_tautological` (left inverse law) and `rqPullback_grPointOfRankQuotient_rel` (right inverse law), exactly the two bridge lemmas the blueprint calls for
- **`\leanok` state**: no `\leanok` on statement or proof block. Statement marker is missing (sync gap). Proof marker is correctly absent: though the proof body itself has **no sorry**, it is axiom-contaminated via the dependency chain `represents → tautologicalRankQuotient → tautologicalQuotient_epi (sorry)`. No `\leanok` on the proof block is the right call until `tautologicalQuotient_epi` closes.

---

## Red flags

### Placeholder / suspect bodies

- **`AlgebraicGeometry.Grassmannian.tautologicalQuotient_epi`** at line 2469: body is `:= sorry`. Blueprint (`lem:tautologicalQuotient_epi`) claims the tautological quotient map `O^r → U` on `Gr(d,r)` is an epimorphism — a substantive and nontrivial statement. This is the **sole sorry** in the file (confirmed by `grep -n "sorry"` returning exactly one hit).
  - **Classification**: must-fix-this-iter per the severity rules (sorry on substantive claimed statement).
  - **Mitigating context**: the directive explicitly acknowledges this as "honestly open." The blueprint proof block is correctly unmarked. The sorry is not a fake placeholder but genuinely open mathematics. Downstream effects: `tautologicalRankQuotient` carries the sorry, and `represents` is axiom-contaminated through it.

### Excuse-comments

None found. No `-- TODO replace with real def`, `-- temporary`, `-- placeholder`, `-- wrong but works for now`, or equivalent comments attached to any declaration.

### Axioms / Classical.choice on non-trivial claims

No new `axiom` declarations in `GrassmannianQuot.lean`. `Classical.choice` appears only through Lean's standard `Nonempty`/`Finset` API — no bespoke uses on substantive claims.

---

## Unreferenced declarations (informational)

`GrassmannianQuot.lean` has 148 declarations. ~96 are pinned by `\lean{}` blocks. Notable unpinned declarations:

- **`matrixToFreeIso_inv`** (`@[simp]` lemma, line 227): proves `(matrixToFreeIso M)⁻¹ = matrixToFreeIso M⁻¹`. This is used in the `bundleTransition` proof (line 2044 references it). The chapter covers `matrixToFreeIso_hom` and `matrixToFreeIso_mul` but not the inverse lemma. Borderline substantive; a blueprint block would improve traceability.
- **`ιFree_matrixEnd`** (line 789): local helper for column expansion; acceptable as unnamed helper.
- **`chartQuotientMap_eq_matrixEndRect`** (confirmed existing): relates the two presentations; currently treated as internal scaffolding. Could merit a blueprint block as it bridges two key definitions.
- **`projFree`, `unitEndSection` family** (lines ~1000–1200): internal rectangular-matrix calculus infrastructure; acceptable as helpers.
- **`grPointOfRankQuotient_rqPullback_tautological`** (line 4945) and **`rqPullback_grPointOfRankQuotient_rel`** (line 5244): these are the two inverse-law lemmas used directly by `represents`. They are not individually pinned in the blueprint (the universal-property proof block mentions them only implicitly). These are substantive enough to merit their own `\lean{}` blocks.
- Many private helpers (e.g. `imageMatrix_map_eq'` at line 539, `cocycle_imageMatrix_eq'` at line 567, `bundleMatrix_cancel`): correctly private.

---

## Blueprint adequacy for this file

- **Coverage**: ~96/148 Lean declarations have a `\lean{}` block. Unreferenced: ~52 helpers (mostly private or internal scaffolding, acceptable) + 2–3 borderline-substantive items (`matrixToFreeIso_inv`, `chartQuotientMap_eq_matrixEndRect`, `grPointOfRankQuotient_rqPullback_tautological`, `rqPullback_grPointOfRankQuotient_rel`).
- **Proof-sketch depth**: **adequate**. For every major declaration — including all the bundle transition calculations, the rectangular matrix calculus, the tautological-quotient overlap, the chart-matrix machinery, and the universal property — the blueprint provides a prose sketch giving the key mathematical step. The proofs in Lean correspond to these sketches. The one open sorry (`tautologicalQuotient_epi`) has a correctly-worded blueprint statement but no proof sketch, which is appropriate since the proof strategy is not yet known.
- **Hint precision**: **precise**. All `\lean{}` names match the actual Lean declarations. The one ambiguity (`chartQuotientMap_ιFree` and `exists_isUnit_submatrix` being private) is a minor documentation concern, not a precision failure.
- **Generality**: **matches need**. Definitions are at the right level — `RankQuotient` as a quotient type, `rqPullback` functorial, `grPointOfRankQuotient` a construction — with no narrowing that forced parallel API.
- **Recommended chapter-side actions**:
  1. Add a `\lean{}` block for `grPointOfRankQuotient_rqPullback_tautological` and `rqPullback_grPointOfRankQuotient_rel` — they are the load-bearing inverse laws of `represents` and deserve explicit blueprint presence.
  2. Add `matrixToFreeIso_inv` to the `matrixToFreeIso` section (one-line `@[simp]` lemma; easy to add).
  3. Remove or qualify the `\lean{chartQuotientMap_ιFree}` and `\lean{exists_isUnit_submatrix}` pins — both target private declarations that cannot be externally hyperlinked. Either make them public or annotate with `% NOTE: private helper`.
  4. After the next `sync_leanok` run, all `Grassmannian.*` blocks will receive `\leanok`; no manual corrections needed for those.

---

## Severity summary

| Finding | Severity | Count |
|---|---|---|
| `tautologicalQuotient_epi` `:= sorry` on substantive statement | **must-fix-this-iter** | 1 |
| `\lean{}` pins on `private` declarations (`chartQuotientMap_ιFree`, `exists_isUnit_submatrix`) | minor | 2 |
| Missing `\leanok` on `lem:gr_glueData_bridges` (decls exist in `GlueDescent.lean`) | minor | 1 |
| Pervasive absent `\leanok` on all `Grassmannian.*` blocks (blueprint-writer ran after sync_leanok) | minor | ~70 blocks |
| Missing `\lean{}` pins for `grPointOfRankQuotient_rqPullback_tautological`, `rqPullback_grPointOfRankQuotient_rel`, `matrixToFreeIso_inv` | minor | 3 |

**Overall verdict**: `GrassmannianQuot.lean` faithfully follows the blueprint in mathematical content and statement alignment across all ~96 pinned declarations; the sole correctness issue is the residual `tautologicalQuotient_epi` sorry (must-fix, acknowledged open); all other findings are minor marker-sync or documentation gaps attributable to the blueprint-writer running after sync_leanok this iteration.
