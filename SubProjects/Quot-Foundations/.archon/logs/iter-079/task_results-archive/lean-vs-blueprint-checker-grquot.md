# Lean ↔ Blueprint Check Report

## Slug
grquot

## Iteration
078

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean` (3942 lines)
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex` (2182 lines)

---

## Per-declaration

Only declarations in `GrassmannianQuot.lean` whose `\lean{...}` pin points into this file
(`AlgebraicGeometry.Grassmannian.*` or `AlgebraicGeometry.Scheme.Modules.*` declared here)
are listed. Declarations whose pin resolves to another file (GlueDescent, FlatBaseChange,
Mathlib) are omitted — cross-file consistency belongs to code-audit subagents.

### `\lean{AlgebraicGeometry.Grassmannian.globalUnitSection}` (def:gr_globalUnitSection)
- **Lean target exists**: yes (`globalUnitSection`, line ~510)
- **Signature matches**: yes — global unit section of O_X
- **Proof follows sketch**: yes / N/A
- **notes**: straightforward; no concerns

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd}` (def:gr_scalarEnd)
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes / N/A
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_one}`, `scalarEnd_zero`, `scalarEnd_comp`, `scalarEnd_add`, `scalarEnd_sum`
- **Lean target exists**: yes (all five)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: arithmetic lemmas, all look correct

### `\lean{AlgebraicGeometry.Grassmannian.matrixEnd}` (def:gr_matrixEnd)
- **Lean target exists**: yes
- **Signature matches**: yes — square `d×d` matrix to endomorphism of free sheaf
- **Proof follows sketch**: yes / N/A
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.matrixEnd_comp}` / `matrixEnd_one`
- **Lean target exists**: yes
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.matrixToFreeIso}` / `matrixToFreeIso_hom` / `matrixToFreeIso_mul`
- **Lean target exists**: yes
- **Signature matches**: yes — invertible square matrix gives iso of free sheaves
- **Proof follows sketch**: yes
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.chartQuotientMap}` / `chartQuotientMap_ιFree` / `chartQuotientMap_epi`
- **Lean target exists**: yes (around lines 810–938; `chartQuotientMap_eq_matrixEndRect` at line 938 confirms)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv_self}`
- **Lean target exists**: not found under this name in the declaration grep
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **major** — `\lean{...}` pin is broken. The concept may be captured in `freeMap_chartMatrixHom` (line 3703) or `chartMatrix_minor` (line 3843), but neither matches the pinned name. Blueprint line 898 should be updated to use the actual Lean name.

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition}` / `bundleTransition_self` / `bundleTransitionData` / `bundleTransition_cocycle_matrix`
- **Lean target exists**: yes (all four)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.scalarEnd_pullback}` / `matrixEnd_pullback`
- **Lean target exists**: need to verify; `scalarEnd_pullback` and `matrixEnd_pullback` do not appear in the declaration grep of GrassmannianQuot.lean
- **Signature matches**: N/A (names absent)
- **Proof follows sketch**: N/A
- **notes**: **major** — both pins may resolve to declarations in another file (GlueDescent or earlier) or may be stale names. If they live in GrassmannianQuot.lean they are missing from the file; if they live elsewhere the pins were wrongly placed in this chapter. Needs resolution.

### `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge_gammaSpec}` / `baseChange_bridge_left` / `baseChange_bridge_right` / `baseChange_bridge_transition` / `baseChange_bridge`
- **Lean target exists**: yes (lines 1420, 1443, 1475, 1509, 1566)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport}` / `bundleTransition_cocycle`
- **Lean target exists**: yes (lines 1643, 1805)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}`
- **Lean target exists**: yes (line 1838)
- **Signature matches**: yes — Zariski gluing of the tautological free sheaves
- **Proof follows sketch**: yes / N/A
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.matrixEndRect}`
- **Lean target exists**: yes (line ~1075; `matrixEndRect` is the rectangular `d×r` variant)
- **Signature matches**: yes
- **Proof follows sketch**: yes / N/A
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.matrixEndRect_pullback}` (chapter line 1414)
- **Lean target exists**: **no** — no declaration named `matrixEndRect_pullback` exists in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: **major** — the concept is realized as `pullback_conj_matrixEndRect` (line 1050). The `\lean{...}` pin is broken and will cause `blueprint-doctor` to report an orphan. Blueprint must update the pin to `AlgebraicGeometry.Grassmannian.pullback_conj_matrixEndRect`.

### `\lean{AlgebraicGeometry.Grassmannian.matrixEndRect_comp}` (chapter line 1454)
- **Lean target exists**: **no** — no declaration named `matrixEndRect_comp` exists; the file has `matrixEndRect_comp_rect` (line 1166)
- **Signature matches**: no — `matrixEndRect_comp_rect` is the FULLY RECTANGULAR composition `(d×e) * (e×r)`; the blueprint likely described square composition which was later generalized
- **Proof follows sketch**: N/A (wrong name)
- **notes**: **major** — broken `\lean{...}` pin. Blueprint must update to `AlgebraicGeometry.Grassmannian.matrixEndRect_comp_rect` and note the rectangular generalization. This is used in `presentedMatrix_changeOfBasis` and `isUnit_of_isIso_matrixEndRect`.

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotientComponent_transpose}` / `tautologicalQuotient_overlap`
- **Lean target exists**: yes (lines 2173, 1872)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (def)
- **Lean target exists**: yes (line 2232)
- **Signature matches**: yes — the tautological epi `O_{Gr}^r ↠ U`
- **Proof follows sketch**: yes / N/A
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.RankQuotient, ...}`  (structure + related defs)
- **Lean target exists**: yes (line 2261 ff.; `RankQuotient`, `Rel`, `rqSetoid`, `rqPullback`, `functor`)
- **Signature matches**: yes
- **Proof follows sketch**: yes / N/A
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.functor}`
- **Lean target exists**: yes (line 2343)
- **Signature matches**: yes — contravariant functor `Scheme^op ⥤ Type`
- **Proof follows sketch**: yes / N/A
- **notes**: no concerns

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient_epi}` (lem:tautologicalQuotient_epi)
- **Lean target exists**: yes (line 2469)
- **Signature matches**: yes (statement matches)
- **Proof follows sketch**: **no** — proof body is `:= by sorry`
- **notes**: **must-fix-this-iter** — The blueprint block carries `\leanok`, but the Lean proof is entirely `:= sorry`. The Lean comment at lines 2456–2468 explains the missing ingredient: "joint-reflection lemma" (epi-ness chart-local via `isIso_pullback_isoLocus_map`, requiring a "reflect epi" step not yet available). The `\leanok` marker is incorrect; `sync_leanok` should have removed it. Additionally, the blueprint's proof sketch does not mention the "joint-reflection" approach; the chapter gives no guidance toward a proof route. Both violations: invalid `\leanok` AND missing proof sketch.

### `\lean{AlgebraicGeometry.Grassmannian.isoLocus}` (def)
- **Lean target exists**: yes (line 2497)
- **Signature matches**: yes — `sSup {U : X.Opens | IsIso ((Scheme.Modules.pullback U.ι).map φ)}`
- **Proof follows sketch**: yes / N/A
- **notes**: `mem_isoLocus` (line 2502) and `isIso_pullback_map_of_le` (line 2511) are immediate companions with no blueprint pins — minor gap (helpers).

### `\lean{AlgebraicGeometry.Grassmannian.isIso_pullback_isoLocus_map}` (lem:isIso_pullback_isoLocus_map)
- **Lean target exists**: yes (line 2866)
- **Signature matches**: yes — `IsIso ((Scheme.Modules.pullback (isoLocus φ).ι).map φ)`
- **Proof follows sketch**: **yes** — the docstring at lines 2857–2865 explicitly labels the proof as "the blueprint's stalk-wise route" and the actual proof (lines 2866–2913) follows: stalk invertibility → restriction stalkwise invertible → stalk criterion (`isIso_of_stalkFunctor_map_iso`) → reflect to `X.Modules`. This matches the blueprint's `lem:isIso_pullback_isoLocus_map` proof sketch precisely.
- **notes**: no concerns; blueprint-Lean alignment is exemplary for this declaration.

### `\lean{AlgebraicGeometry.Grassmannian.chartLocus}` (def)
- **Lean target exists**: yes (line 2534)
- **Signature matches**: yes — `isoLocus (chartComposite x I hI)`
- **Proof follows sketch**: yes / N/A
- **notes**: `chartComposite` (line 2527) has no blueprint pin — see "Unreferenced declarations".

### `\lean{AlgebraicGeometry.Grassmannian.chartLocus_isOpenCover}` (lem:chartLocus_isOpenCover)
- **Lean target exists**: yes (line 2632)
- **Signature matches**: yes — `TopologicalSpace.IsOpenCover (fun I => chartLocus x I.1 I.2)`
- **Proof follows sketch**: **partial — route substitution**. See "Red flags" below for details.
- **notes**: Proof is complete (no sorry) and mathematically correct, but uses a different route than the blueprint's prose.

### `\lean{AlgebraicGeometry.Grassmannian.grPointOfRankQuotient}` (def:grPointOfRankQuotient)
- **Lean target exists**: yes (line 3196)
- **Signature matches**: yes — `T ⟶ scheme d r` built by gluing chart morphisms
- **Proof follows sketch**: **partial** — the gluing structure matches, but the overlap compatibility (the `fun I J => ...` proof argument at line 3199) is `sorry` (line 3217). The Lean comment enumerates a 4-step plan (localization lift + ring map comparison + `universalMatrix_map_transitionPreMap` + `glue_condition`) that the blueprint does not describe.
- **notes**: The definition block has `\leanok` (blueprint line 2029), which is on the statement/definition block ("at least sorry present") — acceptable per marker rules. However, the sorry blocks a complete formalization claim.

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (thm:grassmannian_universal_property)
- **Lean target exists**: yes (line 3918)
- **Signature matches**: yes — `(functor d r).RepresentableBy (scheme d r)`
- **Proof follows sketch**: **partial** — `left_inv` (line 3928) and `right_inv` (line 3933) are both `:= sorry`. The `homEquiv_comp` naturality is proven. Blueprint `\leanok` at line 2066 is on the definition block (acceptable per marker rules), but both inverse laws are unproven.
- **notes**: The sorry bodies carry comment descriptions that outline the strategy; the blueprint's informal sketch aligns with those comments at a high level but does not detail the matrix-level computation required.

---

## Red flags

### Placeholder / suspect bodies

- `AlgebraicGeometry.Grassmannian.tautologicalQuotient_epi` at line 2469: body is `by sorry` in full. Blueprint `lem:tautologicalQuotient_epi` claims this is a substantive lemma and carries `\leanok`. **must-fix-this-iter.**

- `AlgebraicGeometry.Grassmannian.grPointOfRankQuotient` at line 3217: `sorry` inside the `glueMorphisms` compatibility proof. The definition is structurally present but a key mathematical step (overlap compatibility of chart morphisms) is unproven.

- `AlgebraicGeometry.Grassmannian.represents` at lines 3928 and 3933: both `left_inv` and `right_inv` of the equivalence are `:= by sorry`. The forward direction naturality (`homEquiv_comp`) is the only proven part.

### Stale / misleading comments

- `chartLocus_isOpenCover` docstring (lines 2626–2631): says **"PROOF ROUTE (scoped iter-067, not yet formalized)"** followed by a description of the stalkwise Nakayama route. But the proof IS fully formalized immediately below (lines 2632–2852, no sorry). The "not yet formalized" label is false for the current state and constitutes a stale excuse-comment. Additionally, the route described in the docstring (stalkwise surjectivity → Nakayama → neighbourhood) does **not** match the actual proof route (affine splitting → field linear algebra → basic open). See "route substitution" below.

- `grPointOfRankQuotient` docstring (line 3189): says **"REALIZED (iter-067)"** but the definition has a sorry for the overlap compatibility. "REALIZED" overstates the current state.

### Route substitution (chartLocus_isOpenCover) — flagged per directive check (a)

Blueprint `lem:chartLocus_isOpenCover` prose (chapter lines ~2004–2027) describes:
> "work in an open neighbourhood V trivialising F … the fibre map q(t) : κ(t)^r ↠ κ(t)^d is surjective … a surjection κ(t)^r ↠ κ(t)^d carries some d of the r standard basis vectors to a basis … by Nakayama the isomorphism holds in a neighbourhood"

The Lean proof (lines 2633–2852) uses a **different route**:
1. (B4) `exists_rightInverse_of_epi_matrixEndRect MW` — splits the epimorphism of free sheaves GLOBALLY over the affine W via projectivity (module-theoretic splitting, not stalkwise Nakayama)
2. (B5–B6) Evaluates the right inverse at the residue field and applies `exists_isUnit_submatrix` (pure field linear algebra: right-invertible matrix over a field has invertible square submatrix)
3. (B7–B8) Uses the minor determinant to cut out the basic open Wb and verifies invertibility there

**Assessment**: The mathematical content is equivalent (both routes find the same open cover), but the proof mechanism is completely different:
- Blueprint says: stalkwise surjectivity → Nakayama
- Lean says: affine splitting (projectivity) → field linear algebra → basic open localization

The blueprint chapter **now mismatches** the Lean proof route. The stale docstring compounds this: a reader following the blueprint or the docstring will look for a Nakayama-style argument and not find one. The chapter's `\begin{proof}` block for `lem:chartLocus_isOpenCover` should be rewritten to describe the affine-splitting route, naming `exists_rightInverse_of_epi_matrixEndRect`, `exists_isUnit_submatrix`, and the basic-open localization step.

### Broken `\lean{...}` pins (major)

- Blueprint line 898: `\lean{AlgebraicGeometry.Grassmannian.universalMinorInv_self}` — no Lean declaration with this name. Closest candidates: `freeMap_chartMatrixHom` (morphism-level) and `chartMatrix_minor` (entry-level), both at lines 3703 and 3843.
- Blueprint line 1414: `\lean{AlgebraicGeometry.Grassmannian.matrixEndRect_pullback}` — no such declaration. The concept is `pullback_conj_matrixEndRect` (line 1050).
- Blueprint line 1454: `\lean{AlgebraicGeometry.Grassmannian.matrixEndRect_comp}` — no such declaration. The file has `matrixEndRect_comp_rect` (line 1166), which is the fully rectangular version `(d×e) * (e×r)`, not a square composition.

---

## Unreferenced declarations (informational)

The following declarations in `GrassmannianQuot.lean` have no `\lean{...}` pin in the blueprint. They are grouped by character:

**Helper-only (acceptable without blueprint blocks):**
`projFree` (951), `unitEndSection` / `unitEndSection_scalarEnd` / `scalarEnd_unitEndSection` (959–978), `ιFree_projFree` (997), `ιFree_matrixEndRect_projFree` (1010), `matrixEndRect_unitEndSection` (1025), `matrixEnd_eq_matrixEndRect` (1140), `matrixEndRect_one` (1144), `biproduct_matrix_comp_rect₂` (private, 1150), `matrixEndRect_injective` (1186), `freeMap_matrixEndRect` (1201), `pullbackBaseChangeTransport_matrixToFreeIso` (1361), `tripleOverlapSections` (1431), `baseChange_bridge_gammaSpec` helpers, `mem_isoLocus` (2502), `isIso_pullback_map_of_le` (2511), `exists_isUnit_submatrix` (private, 2544), `pullbackFreeIso_inv_freeMap` (2966), `matrixEndRect_presentedMatrix` (2998), `matrixEndRect_presentedMatrix_minor` (3016), `conjPullback_congr` (3270), `pullbackFreeIso_inv_pullbackComp` (3288), `chartComposite_rel` (3222), `chartLocus_rel` (3232), `chartMatrixHom_rel` (3490), `chartMatrixHom_transport` (3531), `isIso_pullback_chartLocus_map` (instance, 3693), `unitEndSection_id` (3831), `unitEndSection_zero` (3835)

**Substantive — warrant blueprint blocks (flagged as major gaps):**

- `chartComposite` (line 2527): the composition `freeMap σ_I ≫ x.q`, the fundamental building block of the whole chart construction. Blueprint never names it.
- `exists_section_of_epi_free_spec` (line 1237): the affine-splitting lemma — epimorphism of free modules over an affine scheme splits. This is the replacement for the blueprint's Nakayama step and the key non-trivial lemma enabling `chartLocus_isOpenCover`. Missing from the blueprint is a significant adequacy gap.
- `exists_rightInverse_of_epi_matrixEndRect` (line 1305): matrix-level corollary. Blueprint never mentions right-inverse extraction.
- `chartMatrixHom` (line 2919) / `chartMatrix` (line 2935) / `chartMorphism` (line 2945): the three-stage chart morphism construction (the Nitsure §1 core). None have blueprint blocks. The blueprint for `grPointOfRankQuotient` describes the construction but does not give individual declaration pins for these intermediate steps.
- `presentedMatrix` (line 2984) / `matrixEndRect_presentedMatrix` (2998) / `matrixEndRect_presentedMatrix_minor` (3016): Nitsure's "presented matrix" generalization; the minor identity is the M^I_I = 1 fact. No blueprint block.
- `presentedMatrix_changeOfBasis` (line 3086): the overlap matrix identity M^I = M^I_J · M^J (Nitsure §1). This is the matrix heart of the overlap compatibility and should have a dedicated blueprint block.
- `isUnit_of_isIso_matrixEndRect` (line 3165): square matrix presenting an iso is a unit. Used in the overlap compatibility plan. No blueprint block.
- `matrixEndRect_comp_rect` (line 1166): the fully rectangular composition identity. Blueprint refers to it under the wrong name `matrixEndRect_comp`.
- `tautologicalRankQuotient` (line 2475): the tautological rank quotient `(U, u)` on `scheme d r`. Used as the forward map of `represents`; not pinned in the blueprint.
- `grPointOfRankQuotient_rel` (line 3882): well-definedness of the inverse functor on equivalence classes. Required for `represents.invFun` to type-check; no blueprint block.
- `freeMap_chartMatrixHom` (line 3703) / `chartMatrix_minor` (line 3843): the M^I_I = 1 identity at morphism and entry levels. Blueprint references `universalMinorInv_self` (broken pin) instead.
- `conjPullback_comp` (line 3308): pseudofunctor coherence for the conjugated chart data; the transport engine for `chartMatrixHom_transport`. Substantive enough to mention in the overlap-compatibility proof sketch.
- `chartMatrix_rel` (line 3584) / `chartMorphism_rel` (line 3615): transport of presenting matrix and chart morphism along locus inclusions. These are the key steps of `grPointOfRankQuotient_rel` and deserve blueprint mention.

---

## Blueprint adequacy for this file

### Coverage
- `\lean{...}` blocks in chapter: ~63 (many pointing to other files; approximately 40 resolve to declarations in GrassmannianQuot.lean)
- Unreferenced substantive declarations in GrassmannianQuot.lean: **~15** (see above)
- Helper-only unreferenced: ~30 (acceptable)

### Proof-sketch depth: **under-specified** for three critical areas

1. **`lem:tautologicalQuotient_epi`**: Proof sketch absent or very thin in blueprint. The Lean comment names "joint-reflection lemma" as the missing ingredient — this concept does not appear anywhere in the chapter prose.

2. **`lem:chartLocus_isOpenCover`**: Proof sketch describes a stalkwise Nakayama route. The actual Lean proof uses an affine-splitting route (`exists_rightInverse_of_epi_matrixEndRect` + `exists_isUnit_submatrix`). The blueprint sketch does not mention:
   - epimorphism splitting via projectivity of free modules (the key Lean lemma `exists_section_of_epi_free_spec`)
   - right inverse of a matrix morphism
   - field linear algebra (`exists_isUnit_submatrix`)
   - basic open localization from minor determinant

3. **`thm:grassmannian_universal_property` (`represents`)**: Both inverse laws are sorry. Blueprint gives informal descriptions ("chart-locally, the pulled-back matrix is the ψ-image of the universal one" and "chart restriction isomorphisms identify the pullback with x chart by chart"). This is accurate as a high-level strategy, but the matrix-level computations required (using `presentedMatrix`, `presentedMatrix_changeOfBasis`, `chartMatrix_minor`, `chartMorphism_rel`) are absent.

### Hint precision: **loose to wrong**
- Three `\lean{...}` pins are broken (see Red flags): `universalMinorInv_self`, `matrixEndRect_pullback`, `matrixEndRect_comp`. Blueprint-doctor will report these as orphans.
- No pin for `chartComposite` / `chartMatrixHom` / `chartMatrix` / `chartMorphism` means provers have no Lean target guidance for the chart morphism chain.

### Generality: **too narrow** for one declaration
- `matrixEndRect_comp` was planned as square composition but the Lean needed the fully rectangular version (`matrixEndRect_comp_rect`, `{n e d : ℕ}`). The blueprint is too narrow; the project needed higher generality.

### Recommended chapter-side actions
1. **Rewrite `lem:tautologicalQuotient_epi` proof sketch**: describe the chart-local reflection route and the missing "reflect epi" primitive; remove `\leanok` from proof block (or remove proof block `\leanok` entirely until the sorry is closed).
2. **Rewrite `lem:chartLocus_isOpenCover` proof sketch**: replace stalkwise Nakayama description with the affine-splitting route; name `exists_rightInverse_of_epi_matrixEndRect`, `exists_isUnit_submatrix`, basic open localization; fix docstring "not yet formalized" → actual proof route.
3. **Add blueprint blocks** (new declarations needed):
   - `def:gr_chartComposite`, `def:gr_chartMatrixHom`, `def:gr_chartMatrix`, `def:gr_chartMorphism` (Nitsure §1 chain)
   - `def:gr_presentedMatrix`, `lem:gr_presentedMatrix_changeOfBasis` (overlap matrix identity)
   - `lem:gr_exists_section_of_epi_free_spec` / `lem:gr_exists_rightInverse_of_epi_matrixEndRect` (affine splitting)
   - `lem:gr_chartMatrix_minor` (M^I_I = 1, replacing broken `universalMinorInv_self` pin)
   - `lem:gr_grPointOfRankQuotient_rel` (well-definedness)
4. **Fix broken `\lean{...}` pins**:
   - `universalMinorInv_self` → `chartMatrix_minor` (entry) + `freeMap_chartMatrixHom` (morphism)
   - `matrixEndRect_pullback` → `pullback_conj_matrixEndRect`
   - `matrixEndRect_comp` → `matrixEndRect_comp_rect` (note rectangular generalization)
5. **Expand `thm:grassmannian_universal_property` proof sketch** for both inverse laws: cite `presentedMatrix`, `presentedMatrix_changeOfBasis`, `chartMatrix_minor`, `chartMorphism_rel` as the formal ingredients.

---

## Severity summary

| Finding | Severity |
|---------|----------|
| `tautologicalQuotient_epi`: `:= sorry` body; blueprint claims substantive lemma; `\leanok` on proof block | **must-fix-this-iter** |
| `chartLocus_isOpenCover` route substitution: blueprint prose describes Nakayama/stalkwise; Lean uses affine-splitting; chapter mismatches | **must-fix-this-iter** (blueprint adequacy failure — chapter could not guide correct formalization) |
| Broken `\lean{...}` pins: `universalMinorInv_self`, `matrixEndRect_pullback`, `matrixEndRect_comp` | **major** |
| `matrixEndRect_comp` pinned name doesn't match Lean's rectangular generalization `matrixEndRect_comp_rect` | **major** |
| `grPointOfRankQuotient` overlap compatibility sorry; `represents` left/right inverse sorries (4 open sorries total) | **major** (not must-fix per se — definition blocks exist — but blocking `represents`) |
| Missing `\lean{...}` pins for ~15 substantive declarations (chartComposite, chartMatrixHom, chartMatrix, chartMorphism, presentedMatrix, presentedMatrix_changeOfBasis, exists_section_of_epi_free_spec, etc.) | **major** |
| Stale docstring "not yet formalized" on completed `chartLocus_isOpenCover` | **major** (misleading comment) |
| Stale "REALIZED" in `grPointOfRankQuotient` docstring while sorry present | **minor** |
| `mem_isoLocus`, `isIso_pullback_map_of_le`, `chartComposite` no blueprint pin (true helpers / immediate companions) | **minor** |

**Overall verdict**: Two must-fix findings (invalid `\leanok`/sorry on `tautologicalQuotient_epi` and blueprint route mismatch on `chartLocus_isOpenCover`), three broken `\lean{...}` pins, 15 substantive declarations unblocked by blueprint prose, and 4 open sorries blocking the represents theorem — the chapter needs significant updating to match the iter-067/078 Lean advances.

---
*Report written by lean-vs-blueprint-checker subagent, iteration 078, slug grquot.*
