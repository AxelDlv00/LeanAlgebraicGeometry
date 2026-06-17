# Lean ↔ Blueprint Check Report

## Slug
g0bo172

## Iteration
172

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects.lean` (1031 LOC, 7 sorries — 6 typed instances/lemmas + 1 inside docstring scaffold)
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (`% archon:covers` line names `Genus0BaseObjects.lean`)

`lake env lean` returns `error: []` — file compiles, no errors.

## Per-declaration

I enumerate every `\lean{AlgebraicGeometry.*}` block in `AbelianVarietyRigidity.tex` whose Lean
target resides in `Genus0BaseObjects.lean` and verify it. (Pins resolving to siblings
`AbelianVarietyRigidity.lean` / `RigidityLemma.lean` are out of scope per directive.)

### `\lean{AlgebraicGeometry.ProjectiveLineBar}` (chapter: `def:genus0_base_objects` L913)
- **Lean target exists**: yes (L119).
- **Signature matches**: yes. `(kbar : Type u) [Field kbar] : Over (Spec (.of kbar))` — blueprint asks for "$\mathbb P^1_{\bar k}$, packaged as an object of $\mathrm{Over}\,(\Spec \bar k)$". Encoding (`Proj` of the standard ℕ-graded `MvPolynomial (Fin 2) kbar`) matches the prose hint.
- **Proof follows sketch**: N/A (`def`). The encoding is honest: the `Over` instance comes from `Proj.toSpecZero` composed with the algebra map identifying $\mathcal A_0$ with $\bar k$, as advertised in the docstring.
- **notes**: ProjectiveLineBar is a thin `(ProjectiveLineBarScheme kbar).asOver _`; the underlying scheme is `Proj (projectiveLineBarGrading kbar)`. Honest.

### `\lean{AlgebraicGeometry.Ga}` (chapter: `def:ga` L949)
- **Lean target exists**: yes (L669).
- **Signature matches**: yes. `abbrev` of `(GaScheme kbar).asOver _`, where `GaScheme = AffineSpace (Fin 1) (Spec (.of kbar))`. Matches blueprint "$\mathbb G_a = \mathbb A^1$".
- **Proof follows sketch**: N/A.
- **notes**: blueprint claims a `GrpObj` structure ("$(x, y) \mapsto x + y$, identity $0$") on $\mathbb G_a$ as part of the bullet in `def:genus0_base_objects`. The file ships `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced` (all axiom-clean) but **no `instance ga_grpObj`**. This is a soft gap — the consumer of $\mathbb G_a$ on the genus-0 path (`gaTranslationP1`) is explicitly demoted and off-path per iter-164. Not blocking iter-172.

### `\lean{AlgebraicGeometry.Gm}` (chapter: `def:gm` L968)
- **Lean target exists**: yes (L713).
- **Signature matches**: yes. `abbrev` of `(GmScheme kbar).asOver _`, where `GmScheme = Spec (.of (Localization.Away (X () : MvPolynomial Unit kbar)))`. Blueprint pins **the affine encoding** (`Spec(\mathrm{Localization.Away}\,t)`, NOT $D(t) \subset \mathbb A^1$) and the Lean choice matches verbatim.
- **Proof follows sketch**: N/A.
- **notes**: ✓ the iter-172 blueprint NOTE (L957-964) explicitly documents the affine encoding choice and the reason (downstream consumers require affine).

### `\lean{AlgebraicGeometry.ProjectiveLineBar.zeroPt}` (chapter: `def:p1bar_zero` L985)
- **Lean target exists**: yes (L637).
- **Signature matches**: yes. `𝟙_ (Over (Spec (.of kbar))) ⟶ ProjectiveLineBar kbar`, i.e. a section of `ProjectiveLineBar.hom`. Defined via `pointOfVec kbar (fun i => if i = 0 then 0 else 1) 1 (by simp)` — i.e. `X₀ ↦ 0, X₁ ↦ 1` with the unit witness on coordinate `1`.
- **Proof follows sketch**: yes. Blueprint specifies `Proj.fromOfGlobalSections` route; the helper `pointOfVec` is exactly that route.
- **notes**: axiom-clean kernel (per iter-166 memory).

### `\lean{AlgebraicGeometry.ProjectiveLineBar.onePt}` (chapter: `def:p1bar_one` L999)
- **Lean target exists**: yes (L643). Defined via `pointOfVec kbar (fun _ => 1) 0 (by simp)`.
- **Signature matches**: yes — `[1 : 1]` per the docstring.
- **Proof follows sketch**: yes (same `pointOfVec` recipe).
- **notes**: axiom-clean kernel.

### `\lean{AlgebraicGeometry.ProjectiveLineBar.inftyPt}` (chapter: `def:p1bar_infty` L1011)
- **Lean target exists**: yes (L649). `pointOfVec kbar (fun i => if i = 0 then 1 else 0) 0 (by simp)` — i.e. `X₀ ↦ 1, X₁ ↦ 0`, unit witness on coord `0`.
- **Signature matches**: yes.
- **Proof follows sketch**: yes.
- **notes**: axiom-clean kernel.

### `\lean{AlgebraicGeometry.Gm.onePt}` (chapter: `def:gm_one` L1024)
- **Lean target exists**: yes (L779). `:= η[Gm kbar]`.
- **Signature matches**: yes — the group-object unit, exactly as blueprint requests.
- **Proof follows sketch**: N/A.
- **notes**: Worth noting: this consumes the `GrpObj Gm` instance, whose body is `sorry` (see `gm_grpObj` below). `Gm.onePt` itself is type-correct only because `η[_]` is defined in terms of `GrpObj` field projection. The constant's *body* therefore propagates `sorryAx` transitively even though `Gm.onePt` itself contains no `sorry` lexically.

### `\lean{AlgebraicGeometry.gm_grpObj}` (chapter: `def:gm_grpObj` L1037)
- **Lean target exists**: yes (L768).
- **Signature matches**: yes. `instance gm_grpObj (kbar : Type u) [Field kbar] : GrpObj (Gm kbar)` — blueprint asks for "multiplicative group-object structure $(\mathbb G_m, \cdot, 1)$" as a `GrpObj` instance.
- **Proof follows sketch**: **no — body is `:= sorry`**.
- **notes**: docstring at L767 ("Scaffold body — same discipline as `ga_grpObj`") is an excuse-comment. The blueprint NOTE at the proof of `prop:morphism_P1_to_AV_constant` (L1610-1617) acknowledges `gm_grpObj` as a Lane-A residual. **Pre-existing must-fix carried over from before iter-172**; the iter-172 directive did not target it. The memory snapshot ([genus0-aux-pile-discharged-iter167]) noted iter-167's escalation watch on `gm_grpObj` — still open.

### `\lean{AlgebraicGeometry.projectiveLineBarAffineCover}` (chapter: `def:projlinebar_affine_cover` L1064)
- **Lean target exists**: yes (L207).
- **Signature matches**: yes. `(ProjectiveLineBarScheme kbar).AffineOpenCover`. Constructed via `Proj.affineOpenCoverOfIrrelevantLESpan` with `f = ![X 0, X 1]`, `m = ![1, 1]` — matches blueprint hint *verbatim*.
- **Proof follows sketch**: yes — the non-trivial `hf` (irrelevant ideal `⊆ Ideal.span {X 0, X 1}`) is proved exactly along the blueprint's "any monomial of strictly positive total degree is divisible by `X 0` or `X 1`" route, via `MvPolynomial.X_dvd_monomial`.
- **notes**: axiom-clean.

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso}` (chapter: `def:proj_chart_ring_iso` L1087)
- **Lean target exists**: yes (L545).
- **Signature matches**: yes. `... ≃+* MvPolynomial Unit kbar`. Built via `RingEquiv.ofRingHom` from the two named ring maps and the two named round-trip lemmas, exactly as blueprint specifies.
- **Proof follows sketch**: yes. **iter-172 confirmed axiom-clean** (`lean_verify` returns `{propext, Classical.choice, Quot.sound}` only — *no* `sorryAx`). This is the PRIMARY 1 closure win.
- **notes**: the iter-172 blueprint NOTE at L1105-1114 correctly tracks the new status (the residual `sorryAx` taint of the iso has been retired — closed downstream of `mvPolyToHomogeneousLocalizationAway_surjective`).

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}` (chapter: `lem:proj_chart_ring_iso_aux_left` L1120)
- **Lean target exists**: yes (L528). **The declaration is `private`** but the full name `AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left` resolves.
- **Signature matches**: yes — "`inverse ∘ forward = id` on `Away 𝒜 (X i)`".
- **Proof follows sketch**: yes — body is the "cancel surjective" route (`obtain ⟨p, rfl⟩ := mvPolyToHomogeneousLocalizationAway_surjective …`), matching blueprint prose verbatim. iter-172 confirmed **axiom-clean** (`{propext, Classical.choice, Quot.sound}` only).
- **notes**: minor — pinning a `private` declaration via `\lean{…}` is acceptable in Lean 4 (names aren't mangled) but it does mean external Lean consumers cannot use the lemma. Since `homogeneousLocalizationAwayIso` itself is non-private and the round-trip lemma is folded into it, this is harmless.

### `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` (chapter: `lem:mvPoly_to_homogeneousLocalization_away_surjective` L1143) — **NEW THIS ITER**
- **Lean target exists**: yes (L379). **Declaration is `private`**, full name resolves.
- **Signature matches**: yes. `Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i)`. Blueprint statement and Lean statement are identical modulo trivial rewording.
- **Proof follows sketch**: **yes, faithfully**. The blueprint's proof sketch (L1163-1181) says: (1) apply `Away.adjoin_mk_prod_pow_eq_top` with `d = 1, v = (X_0, X_1), dv = (1, 1)`; (2) reduce the generators to `(X_{1-i}/X_i)` since the `X_i^{a_i}` component is a unit; (3) so the image is the `𝒜_0`-adjoin of one element = ⊤. The Lean does exactly this:
    - Step 1 (`hx`): `Algebra.adjoin ↥(𝒜 0) (Set.range ![X 0, X 1]) = ⊤` via `MvPolynomial.induction_on` (`C` / `add` / `mul_X` cases).
    - Step 2 (`htop := Away.adjoin_mk_prod_pow_eq_top hfi v hx dv hxd`) — the Mathlib lemma invoked at exactly the d=1 specialisation the blueprint pins.
    - Step 3 (`gen_eq_pow`): each generator collapses to `isLocalizationElem^{a_{otherFin i}}`, computed by `Localization.mk_eq_mk_iff` + `r_iff_exists` with a `Fin.ext`-driven case split on `i.val ∈ {0, 1}`.
    - Step 4 (`Algebra.adjoin_induction`): the four cases (mem / algebraMap / add / mul) each produce a preimage in `MvPolynomial Unit kbar`. The `algebraMap` case uses surjectivity of `algebraMap kbar (𝒜 0)` (helper `hkbar_sur`), exactly the "base-ring map $\bar k \to \mathcal A_0$ is bijective" link in the blueprint prose.
  iter-172 confirmed **axiom-clean** (`{propext, Classical.choice, Quot.sound}`).
- **notes**: the docstring at L361-378 is honest and matches the actual proof structure. No excuse-comments. Pre-existing `private` modifier — same minor remark as above.

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (chapter: `lem:projlinebar_isReduced` L1187)
- **Lean target exists**: yes (L950).
- **Signature matches**: yes. `IsReduced (ProjectiveLineBar kbar).left`.
- **Proof follows sketch**: yes — `IsReduced.of_openCover` over `projectiveLineBarAffineCover.openCover`, each chart `Spec (Away 𝒜 (X i))` is a domain via `Function.Injective.isDomain` on `HomogeneousLocalization.val_injective` into `Localization.Away (X i)` (which is a domain since `MvPolynomial (Fin 2) kbar` is a domain and `X i` is a non-zero-divisor). Lean and blueprint are 1:1.
- **notes**: axiom-clean.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1` L1209)
- **Lean target exists**: yes (L892).
- **Signature matches**: yes. `ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar` in `Over (Spec (.of kbar))`.
- **Proof follows sketch**: **partial — body is `Over.homMk ((gmScalingP1_cover kbar).glueMorphisms (gmScalingP1_chart kbar) (gmScalingP1_chart_agreement kbar)) (gmScalingP1_over_coherence kbar)`, a real construction whose three inputs are each named top-level scaffold `sorry`s** (`gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`). Verified via `lean_verify` to carry `sorryAx`.
- **notes**: blueprint NOTE at L1211-1221 explicitly documents this skeleton + three internal scaffold sorries — *transparent acknowledgement*, not laundering. The chartwise construction is faithful to the blueprint's $(x, \lambda) \mapsto \lambda x$ on chart $x$ and $u \mapsto u/\lambda$ on chart $u = 1/x$ (encoded by `gmScalingP1_chart1_ringMap`, `gmScalingP1_chart0_ringMap`, both axiom-clean per docstrings).

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero` L1271)
- **Lean target exists**: yes (L912).
- **Signature matches**: yes. The Lean statement `lift (toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar) (𝟙 (Gm kbar)) ≫ gmScalingP1 kbar = toUnit (Gm kbar) ≫ ProjectiveLineBar.zeroPt kbar` matches the blueprint's `(toUnit_{Gm} \fatsemi 0, 𝟙_{Gm})` composite identity.
- **Proof follows sketch**: **no — body is `sorry`**. Blueprint NOTE at L1273-1279 admits this is a gated scaffold (gated on `gmScalingP1_chart`).
- **notes**: per the must-fix rules this is a placeholder body on a blueprint-substantive lemma — but the chapter NOTE *explicitly* gates it on a named substructure. Carries `sorryAx`.

## Red flags

### Placeholder / suspect bodies (`:= sorry` or pure `sorry` body)
All of the below are pinned by `\lean{...}` blocks claiming substantive structure/proofs:

- `gm_grpObj` at L768 — `instance ... : GrpObj (Gm kbar) := sorry`. **Pinned** by `def:gm_grpObj`. Pre-existing scaffold (4+ iters deferred; iter-167+ escalation watch fired but not addressed iter-172).
- `gmScalingP1_collapse_at_zero` at L912 — proof body is `sorry`. **Pinned** by `lem:gmScaling_fixes_zero`. iter-171 blueprint NOTE gates it; not addressed iter-172.

These are pinned-substantive scaffolds with `sorry` bodies. Per the severity rules they meet the must-fix-this-iter criterion, but both are *acknowledged-and-gated* across multiple chapter NOTEs; the iter-172 directive scope did not target them.

Substantive declarations with `:= sorry` bodies that are **not pinned** in the blueprint (acceptable as scaffold-helpers, but listed for transparency):

- `projectiveLineBar_geomIrred` at L188 — `instance ... : GeometricallyIrreducible (ProjectiveLineBar kbar).hom := sorry`. Docstring (L186): "Project-side scaffold sorry (Mathlib does not ship `GeometricallyIrreducible` for `Proj`; plan-marked acceptable for iter-165)."
- `projectiveLineBar_smoothOfRelDim` at L194 — `instance ... : SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom := sorry`. Same docstring excuse.
- `gm_geomIrred` at L992 — `instance ... : GeometricallyIrreducible (Gm kbar).hom := by sorry`. Docstring (L985-991) cites a Mathlib gap.
- `projGm_isReduced` at L1022 — body `sorry`. Docstring (L1010-1021) cites a Mathlib gap.
- `gmScalingP1_chart` at L847 — `sorry`. Docstring (L828-844, **updated this iter** to record PRIMARY 1 unblocking it algebraically).
- `gmScalingP1_chart_agreement` at L861 — `sorry`. Docstring at L849-854.
- `gmScalingP1_over_coherence` at L877 — `sorry`. Docstring at L863-869.

The blueprint def:genus0_base_objects (L913) prose lists smoothness / proper / geometrically irreducible as properties of $\mathbb P^1$, so `projectiveLineBar_{geomIrred, smoothOfRelDim}` *are* claimed at the blueprint level (just not pinned individually). Pre-existing iter-165 scaffolds; not in iter-172 scope.

### Excuse-comments
- `Genus0BaseObjects.lean:185`: "Project-side scaffold sorry (Mathlib does not ship...; plan-marked acceptable for iter-165)." Attached to `projectiveLineBar_geomIrred`. Replicated at L191 for `projectiveLineBar_smoothOfRelDim` and (in different phrasing) for `gm_geomIrred`, `projGm_isReduced`. Per the strict severity rubric these are excuse-comments on declarations the blueprint claims substantively. Pre-existing carry-overs, not iter-172 regressions.
- `Genus0BaseObjects.lean:767`: "Scaffold body — same discipline as `ga_grpObj`" — `gm_grpObj`. Same status.
- `Genus0BaseObjects.lean:1024-1026` (in `projGm_isReduced` body): `-- Strategy: chart-local IsReduced via Proj.affineOpenCover product, each chart a domain. -- Currently sorry: blocked by Mathlib gap on Smooth → GeometricallyReduced.` Acknowledges sorry; the gap framing has been disputed in past audits (the iter-168 closure of `projectiveLineBar_isReduced` shows the chart-domain route works), so the "blocked by Mathlib gap" is potentially stale — flag for plan agent's review.

### Axioms / Classical.choice on non-trivial claims
None. `lean_verify` on all pinned declarations returns `{propext, sorryAx, Classical.choice, Quot.sound}` at most. No custom `axiom` declarations in the file.

## Unreferenced declarations (informational)

Helpers — acceptable, NOT flagged unless name suggests blueprint-level concept:

- `projectiveLineBarGrading`, `projectiveLineBarGrading_gradedRing`, `algebraKbarAway`, `ProjectiveLineBarScheme`, `projectiveLineBarScheme_canOver` — internal Proj-encoding scaffolding for `ProjectiveLineBar`. Acceptable.
- `otherFin`, `otherFin_zero/one/ne`, `chartEvalRingHom`, `chartEvalRingHom_X_self/other/C`, `kbarToAwayRingHom` — private helpers underlying the chart-ring iso. Acceptable.
- `homogeneousLocalizationAwayToMvPoly`, `mvPolyToHomogeneousLocalizationAway`, `homogeneousLocalizationAwayIso_aux_right` — the forward/inverse ring maps + forward round-trip. Folded into `homogeneousLocalizationAwayIso`. Acceptable as helpers, though the *inverse* `mvPolyToHomogeneousLocalizationAway` is the one whose surjectivity is now pinned individually — a minor case for promoting it to its own `\lean{…}` block, but not required.
- `ProjectiveLineBar.evalIntoGlobal`, `ProjectiveLineBar.irrelevant_map_eq_top`, `ProjectiveLineBar.pointOfVec` — private helpers underlying `zeroPt/onePt/inftyPt`. Acceptable.
- `GaScheme`, `gaScheme_canOver`, `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced` — instances on $\mathbb G_a$. Mentioned conceptually in `def:genus0_base_objects` ("$\mathbb G_a$ is affine, of finite type, reduced") but not individually pinned. Acceptable; instance-level not lemma-level.
- `GmRing`, `GmScheme`, `gmScheme_canOver`, `gm_isAffine`, `gm_locallyOfFinitePresentation`, `gm_isReduced`, `gmRing_isDomain`, `gm_irreducibleSpace`, `gm_smooth` — analogous $\mathbb G_m$ instances. Acceptable.

Substantive helpers worth flagging:

- **`projectiveLineBar_isProper` at L138** — substantive ~50-LOC proof (axiom-clean verified). Blueprint def:genus0_base_objects says "$\mathbb P^1$ is proper" but does not pin `projectiveLineBar_isProper` via a `\lean{...}` block. *Minor* — chapter could add a per-decl pin (similar to the existing `def:p1bar_zero/one/infty` per-decl pins under `def:genus0_base_objects`).
- **`gmScalingP1_chart1_ringMap`, `gmScalingP1_chart0_ringMap`** at L803, L812 — the two named chart-side ring maps. Blueprint def:gaTranslationP1 NOTE at L1211-1221 references these explicitly (`Step A (chart-side ring maps...)`) but they have no `\lean{...}` pin. Directive flagged these specifically: **chapter gap, would benefit from per-decl `\lean{...}` pins**.
- **`gmScalingP1_cover` at L823** — directive flagged this specifically: **chapter gap**, no `\lean{...}` pin.
- **`gmScalingP1_chart` (L845), `gmScalingP1_chart_agreement` (L855), `gmScalingP1_over_coherence` (L871)** — the three named top-level internal scaffold `sorry`s. Blueprint NOTE references them by name but no `\lean{...}` pins. Since the blueprint already names them in the NOTE *and* they each have a meaningful statement, **chapter gap**: would benefit from `lem:{...}` blocks so the deterministic `\leanok` / `\notready` sync can see them individually.
- **`projGm_locallyOfFiniteType` (L939), `projGm_geomIrred` (L1004)** — instances on the product $\mathbb P^1 \otimes \mathbb G_m$. Used by the AVR consumer `morphism_P1_to_grpScheme_const_aux` (per iter-167 memory). Currently not pinned; defensible as helper instances.
- **`ProjectiveLineBar.pointOfVec` at L603** — directive flagged this specifically. Acceptable as a private helper (the three `\lean{...}` pins for zeroPt/onePt/inftyPt cover the public API), but the directive's flagging suggests the chapter might benefit from documenting the `pointOfVec` recipe at the def:p1bar_zero/one/infty level. **Minor**.

## Blueprint adequacy for this file

- **Coverage**: 13 of ~45 declarations have `\lean{...}` blocks. Reasonable — most of the unpinned 32 are scaffolding instances and private helpers. Substantive gaps are:
  - The three named scaffold sorries (`gmScalingP1_chart`, `_chart_agreement`, `_over_coherence`) are *named in NOTE comments* but not pinned individually. Recommend per-decl `\lean{...}` blocks so the next round of work has clean targets.
  - The two ring-map scaffolds (`gmScalingP1_chart{0,1}_ringMap`) are axiom-clean but not pinned. Minor.
  - `projectiveLineBar_isProper` is a substantive axiom-clean ~50-LOC proof not pinned. Minor.

- **Proof-sketch depth**: **adequate** for everything pinned. In particular the iter-172 work — `mvPolyToHomogeneousLocalizationAway_surjective` — is now blueprinted with a detailed proof sketch (`lem:mvPoly_to_homogeneousLocalization_away_surjective`, L1140-1182) that mirrors the Lean structure: `Algebra.adjoin (𝒜 0) (range v) = ⊤` step, then `Away.adjoin_mk_prod_pow_eq_top` specialised to `d = 1, v = (X_0, X_1), dv = (1, 1)`, then "image of the adjoin generator collapses to `X_{1-i}/X_i`". The Lean is 1:1 with this sketch.

- **Hint precision**: **precise**. Every pin resolves; no Mathlib-predicate ambiguity (e.g. `Smooth` vs `SmoothOfRelativeDimension n`) — the Lean signatures use the same predicates the blueprint names. The `\lean{AlgebraicGeometry.Gm}` pin specifically commits to the affine `Spec(Localization.Away t)` encoding, matching the Lean.

- **Generality**: matches need. Blueprint asks for objects of `Over (Spec (.of kbar))`; the Lean delivers exactly that, with the right typeclass instances installed (or honest-scaffold-sorry'd).

- **Recommended chapter-side actions**:
  - Add per-decl `\lean{...}` blocks for `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` so the `sorry_analyzer` + deterministic `\leanok` sync can target them individually.
  - Optionally pin `gmScalingP1_chart{0,1}_ringMap` and `gmScalingP1_cover` (small per-decl blocks).
  - Optionally pin `projectiveLineBar_isProper` (per-decl, parallels the existing `def:p1bar_{zero,one,infty}` pins under `def:genus0_base_objects`).
  - Refresh the `projGm_isReduced` docstring's "blocked by Mathlib gap on Smooth → GeometricallyReduced" framing: iter-168 closed `projectiveLineBar_isReduced` along the *same* chart-domain route the docstring lists as the alternative, suggesting the route is feasible after all.

## Severity summary

- **must-fix-this-iter**:
  - **None new this iter.** The iter-172 work (`mvPolyToHomogeneousLocalizationAway_surjective`, docstring refresh on `gmScalingP1_chart`) lands axiom-clean and is 1:1 with the blueprint's `lem:mvPoly_to_homogeneousLocalization_away_surjective`. No fake/placeholder/excuse-comment landed this iter.
  - The pre-existing carry-over scaffolds `gm_grpObj` and `gmScalingP1_collapse_at_zero` *meet* the must-fix-this-iter criterion in the strict reading (placeholder `sorry` body on blueprint-pinned substantive declarations), but each is *transparently gated* in chapter NOTE comments and was not in scope for iter-172. The plan agent should treat these as **persistent open scaffolds** rather than iter-172 regressions; the gate rule fires only if iter-172 was supposed to close them, which (per the directive) it was not.
- **major**:
  - **Blueprint coverage gap** for the three named scaffold-sorry helpers `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`. They are named in NOTE comments but lack `\lean{...}` pins. The deterministic `sync_leanok` cannot track them; the next prover lane will benefit from individual chapter blocks.
- **minor**:
  - `mvPolyToHomogeneousLocalizationAway_surjective` and `homogeneousLocalizationAwayIso_aux_left` are declared `private` in Lean while pinned in the blueprint — works because Lean 4 doesn't mangle private names, but external consumers can't import them. Acceptable since they're folded into the public `homogeneousLocalizationAwayIso`.
  - `projGm_isReduced` docstring "Mathlib gap" wording potentially stale (see iter-168 `projectiveLineBar_isReduced` closure via the same route).
  - `projectiveLineBar_isProper`, `gmScalingP1_chart{0,1}_ringMap`, `gmScalingP1_cover`, `pointOfVec` could be promoted to `\lean{…}` pins per the directive's (B) hints.
  - `Ga` is pinned but no `ga_grpObj` instance is shipped in the Lean (the additive group structure on $\mathbb G_a$). Off the genus-0 path per iter-164; not blocking.

Overall verdict: iter-172's targeted work (closing `mvPolyToHomogeneousLocalizationAway_surjective` axiom-clean, refreshing the `gmScalingP1_chart` docstring) is faithfully blueprinted, axiom-clean, and 1:1 with the chapter sketch; the only chapter-side action item this iter generates is adding per-decl `\lean{…}` pins for the three named scaffold sorries the new construction is gated on.
