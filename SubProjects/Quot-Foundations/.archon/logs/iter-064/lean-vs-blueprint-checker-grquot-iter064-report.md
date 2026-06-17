# Lean ↔ Blueprint Check Report

## Slug
grquot-iter064

## Iteration
064

## Files audited
- Lean: `AlgebraicJacobian/Picard/GrassmannianQuot.lean`
- Blueprint: `blueprint/src/chapters/Picard_GrassmannianQuot.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge_gammaSpec}` (chapter: `lem:gr_baseChange_bridge_gammaSpec`)
- **Lean target exists**: yes (line 1511)
- **Signature matches**: yes — blueprint says the counit square `(Spec φ)^♯ ∘ ΓSpec_A.inv = ΓSpec_B.inv ∘ φ` commutes; Lean states `(Scheme.ΓSpecIso A).inv ≫ Scheme.Hom.appTop (Spec.map φ) = φ ≫ (Scheme.ΓSpecIso B).inv`. Perfect match.
- **Proof follows sketch**: yes — proof is `Γ⊣Spec` counit naturality, matching the blueprint's "naturality of the counit" description.
- **notes**: `\leanok` is present in the blueprint. Axiom-clean (no sorry).

### `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge_left}` (chapter: `lem:gr_baseChange_bridge_left`)
- **Lean target exists**: yes (line 1534)
- **Signature matches**: yes — blueprint: the first projection `p^{IJ}_{IJK}` identified with `Spec(awayInclLeft)` through `tripleOverlapSections`; Lean: `(ΓSpecIso (L.Away P^I_J)).inv ≫ appTop (pullback.fst …) = CommRingCat.ofHom (awayInclLeft P^I_J P^I_K) ≫ tripleOverlapSections …`. Matches.
- **Proof follows sketch**: yes — uses `awayPullbackIso_inv_fst` + `baseChange_bridge_gammaSpec`, exactly as the blueprint describes.
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge_right}` (chapter: `lem:gr_baseChange_bridge_right`)
- **Lean target exists**: yes (line 1566)
- **Signature matches**: yes — analogous to `bridge_left` for `pullback.snd`/`awayInclRight`. Perfect match.
- **Proof follows sketch**: yes — parallel structure to `bridge_left`.
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge_transition}` (chapter: `lem:gr_baseChange_bridge_transition`)
- **Lean target exists**: yes (line 1600)
- **Signature matches**: yes — blueprint: the composite `t'_{IJK} ≫ p^{JK}_{JKI}` is identified with `Spec(Θ_{IJ} ∘ awayInclRight(P^J_I, P^J_K))`; Lean: `(ΓSpecIso (L.Away P^J_K)).inv ≫ appTop (chartTransition' … ≫ pullback.fst …) = CommRingCat.ofHom ((cocycleΘIJ …).comp (awayInclRight …)) ≫ tripleOverlapSections …`. Matches.
- **Proof follows sketch**: yes — uses `awayPullbackIso_inv_fst` + `baseChange_bridge_gammaSpec` + `awayMulCommEquiv_comp_awayInclLeft` to absorb the order-swap; blueprint mentions all three.
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Grassmannian.baseChange_bridge}` (chapter: `lem:gr_baseChange_bridge`)
- **Lean target exists**: yes (line 1657)
- **Signature matches**: yes — blueprint says the three bridges together imply the matrix product identity of base-changed Cramer inverses; Lean states the single matrix equation `(Θ_appTop mapMatrix inv_JK) * (fst_appTop mapMatrix inv_IJ) = (snd_appTop mapMatrix inv_IK)` (the combined cocycle over `Γ(V_IJK, ⊤)`). This is the correct combined form — the three individual bridges are `bridge_left/right/transition`.
- **Proof follows sketch**: yes — assembles the three bridges, collapses with `simp`/`calc`, and applies `bundleTransition_cocycle_matrix`. Matches the blueprint's "assembling the three gives the claim."
- **notes**: `\leanok` present. Axiom-clean.

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle_transport}` (chapter: `lem:gr_bundleCocycle_transport`)
- **Lean target exists**: yes (line 1734)
- **Signature matches**: yes — blueprint: "each transported transition is identified with `matrixEnd` of the base-changed Cramer inverse, composite satisfies `ĝ_{JK} ∘ ĝ_{IJ} = ĝ_{IK}`." Lean states the underlying morphism (`hom`-level) version of this iso equation, inserting the `pullbackCongr` endpoint casts exactly as required by `Scheme.Modules.glue`. The iso-level version is lifted in `bundleTransition_cocycle`.
- **Proof follows sketch**: yes — uses `pullbackBaseChangeTransport_matrixToFreeIso` (the (a)→(c) bridge), `pullbackFreeIso_inv_congr_hom`/`pullbackCongr_hom_app_free`/`pullbackFreeIso_inv_congr` (cast-collapse), `matrixEnd_comp`, and `baseChange_bridge`. Matches blueprint's "assembly of the two infrastructure pieces over the endpoint bridges."
- **notes**: `\leanok` present. Carries `set_option maxHeartbeats 1600000 in` (line 1721); the comment explains this covers the `isDefEq` cost of the triple-overlap localisation objects — consistent with the `chartTransition'_fac` precedent documented in project memory. Axiom-clean.

### `\lean{AlgebraicGeometry.Grassmannian.bundleTransition_cocycle}` (chapter: `lem:gr_bundleCocycle_mul`)
- **Lean target exists**: yes (line 1896)
- **Signature matches**: yes — blueprint: the iso-level C2 equation `ĝ_{JK}^I ≪≫ pullbackCongr_mid ≪≫ ĝ_{IJ}^K ≪≫ pullbackCongr_tgt = pullbackCongr_src ≪≫ ĝ_{IK}^J`, in the form the `glue` primitive requires. The Lean statement uses the `bundleTransitionData` packaging and matches exactly.
- **Proof follows sketch**: yes — `Iso.ext` + `bundleTransition_cocycle_transport`. Blueprint says "three steps: matrix core, linkage, transport."
- **notes**: `\leanok` present. Carries `set_option maxHeartbeats 1600000 in` (line 1886); comment explains the `Iso.ext`-reduction unifies inferred `.app _` instances across the `X.Modules` diamond. Axiom-clean.

### `\lean{AlgebraicGeometry.Grassmannian.universalQuotient}` (chapter: `def:gr_universal_quotient_sheaf`)
- **Lean target exists**: yes (line 1929)
- **Signature matches**: yes — `noncomputable def universalQuotient (d r : ℕ) : (scheme d r).Modules`. Blueprint: a locally free rank-d sheaf on `Gr(r,d)`.
- **Proof follows sketch**: yes — body is `Scheme.Modules.glue (theGlueData d r) (fun I => SheafOfModules.free … (Fin d)) (bundleTransitionData d r) (fun I => bundleTransition_self …) (fun I J K => bundleTransition_cocycle …)`. Matches blueprint's "gluing the free rank-d chart sheaves along the bundle transitions with C1 and C2."
- **notes**: `\leanok` present in blueprint. Axiom-clean (no sorry in body; all sorries are in upstream declarations already accounted for). This declaration is genuinely closed.

### `\lean{AlgebraicGeometry.Grassmannian.tautologicalQuotient}` (chapter: `def:tautological_quotient`)
- **Lean target exists**: yes (line 1956)
- **Signature matches**: yes — `noncomputable def tautologicalQuotient (d r : ℕ) : SheafOfModules.free (R := (scheme d r).ringCatSheaf) (Fin r) ⟶ universalQuotient d r`. Blueprint: "a surjective `O_{Gr(r,d)}`-linear homomorphism `u : O^r ↠ U`."
- **Proof follows sketch**: partial — the body uses `Scheme.Modules.glueLift` with `tautologicalQuotientComponent` per chart; the overlap compatibility condition is `sorry`. Blueprint says the chart quotients are compatible with the bundle gluing because `X^J = (X^I_J)^{-1} X^I` (`universalMatrix_map_transitionPreMap` / `imageMatrix`). The remaining work is correctly identified.
- **notes**: `\leanok` in the blueprint statement block is **semantically correct** per the documented convention (AGENTS.md: "`\leanok` — statement block: declaration is formalized (at least a `sorry` present)"). This is NOT sorry-laundering. The sorry comment at line 1966–1973 accurately describes the open obligation (rectangular `matrixEnd_pullback`/`matrixEnd_comp` analogue for the `r→d` chart quotient plus adjunction bookkeeping).

### `\lean{AlgebraicGeometry.Grassmannian.represents}` (chapter: `thm:grassmannian_universal_property`)
- **Lean target exists**: yes (line 2154)
- **Signature matches**: yes — `noncomputable def represents (d r : ℕ) (hd : 1 ≤ d) (hdr : d ≤ r) : (functor d r).RepresentableBy (scheme d r)`. Blueprint: "for every scheme T the natural map `Hom(T, Gr(r,d)) → Grass(r,d)(T)` is a bijection."
- **Proof follows sketch**: N/A (body is `:= sorry`; the sketch in the blueprint is complete and the sorry note at lines 2148–2153 documents the dependency on `tautologicalQuotient`).
- **notes**: `\leanok` in the blueprint statement block is semantically correct per documented convention (sorry present). Not laundering. The note explicitly records the upstream dependency.

---

### Previously-pinned declarations (iter-063 and earlier, spot-checked for regression):

**`\lean{AlgebraicGeometry.Grassmannian.bundleTransition_self}` (`lem:gr_bundleCocycle_id`)**
- Exists at line 678; axiom-clean; `\leanok` in blueprint. No regression.

**`\lean{AlgebraicGeometry.Scheme.Modules.glue}` (`def:scheme_modules_glue`)**
- Exists at line 399; axiom-clean (C1/C2 in signature); `\leanok` in blueprint. No regression.

**`\lean{AlgebraicGeometry.Grassmannian.matrixToFreeIso_mul}` (`lem:gr_matrixToFreeIso_mul`)**
- Exists at line 219; axiom-clean; `\leanok` in blueprint. No regression.

**`\lean{AlgebraicGeometry.Grassmannian.functor}` (`def:grassmannian_functor`)**
- Exists at line 2075; `map_id` and `map_comp` fully proved (no sorry); `\leanok` in blueprint. No regression.

---

## Red flags

### Placeholder / suspect bodies
- `tautologicalQuotient` (line 1964–1973): contains an inline `sorry` for the overlap condition. This is **expected and documented** — the directive explicitly lists it as a remaining sorry, and the comment accurately describes the open obligation. Not a red flag given the stated semantics of `\leanok`.
- `represents` (line 2156): body is `:= sorry`. Again, expected and documented.

### `set_option maxHeartbeats` flags (informational)
- `bundleTransition_cocycle_transport` (line 1721): `set_option maxHeartbeats 1600000 in`. Legitimate: the comment cites the heavy triple-overlap localisation `isDefEq` cost and the `chartTransition'_fac` precedent.
- `bundleTransition_cocycle` (line 1886): `set_option maxHeartbeats 1600000 in`. Legitimate: the `Iso.ext` reduction requires unifying instances across the `X.Modules` diamond.
- Neither is at an extreme level (the project removed a 1M limit in iter-060 for `bundleTransition_self`; 1.6M for heavier triple-overlap objects is consistent). Not a red flag.

### Excuse-comments
- None found. The sorry-accompanying comments are accurate engineering notes, not excuses for wrong code.

### Axioms / Classical.choice
- No new `axiom` declarations found in this file.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no direct `\lean{...}` pin in the blueprint chapter:

| Declaration | Line | Assessment |
|---|---|---|
| `tripleOverlapSections` | 1522 | Helper for the three bridge lemmas; common codomain `Γ(V_IJK, ⊤)` identification. Worth a brief blueprint mention but not critical. |
| `pullbackFreeIso_inv_congr_hom` | 1405 | Cast-collapse helper for `bundleTransition_cocycle_transport`. Pure infrastructure. |
| `pullbackCongr_hom_app_free` | 1418 | Cast-collapse helper. Pure infrastructure. |
| `pullbackFreeIso_inv_congr` | 1430 | Cast-collapse helper. Pure infrastructure. |
| `Scheme.Modules.glueLift` | 469 | **Substantive**: equalizer.lift primitive for the descent equalizer; the vehicle by which `tautologicalQuotient` is assembled. Blueprint references `def:gr_modules_glueHom` (a forward declaration, `% NOTE: not yet realised`) but `glueLift` is the implemented adjacent primitive. |
| `tautologicalQuotientComponent` | 1940 | Per-chart component helper for `tautologicalQuotient`; adjoint transpose of `chartQuotientMap`. No blueprint pin needed. |
| `unitToPushforward_scalarEnd_comm` | 946 | Private-ish helper for `scalarEnd_pullback`. No pin needed. |
| `pullbackBaseChangeTransport_matrixToFreeIso` | 1452 | The (a)→(c) bridge, abstract core of the bundle cocycle transport. No blueprint pin; used internally by `bundleTransition_cocycle_transport`. |
| Various helper lemmas for `baseChange_bridge_transition` | 1600ff | Purely proof-local. |

**Notable**: `Scheme.Modules.glueLift` is substantive — it is the `equalizer.lift` primitive for the glue construction, directly adjacent to `def:scheme_modules_glue` and used by `tautologicalQuotient`. The blueprint references `def:gr_modules_glueHom` (a forward declaration, `% NOTE: the \lean{} target is not yet realised`) but `glueLift` plays the role of the morphism-descent primitive at this stage. This is a **minor** adequacy gap (the blueprint could add a `\lean{}` reference to `glueLift` or note its role adjacent to `def:scheme_modules_glue`), but it does not block any work.

---

## Blueprint adequacy for this file

- **Coverage**: All 10 declaration blocks worked on this iter have correct `\lean{}` pins. Unreferenced declarations are 6 helpers + 1 substantive (`glueLift`). Total declarations in file: ~80; blueprint-pinned: ~60.
- **Proof-sketch depth**: **adequate** for all closed blocks. The `lem:gr_bundleCocycle_transport` and `lem:gr_bundleCocycle_mul` sketches accurately describe the three-step structure (matrix core → linkage → transport + endpoint alignment). The `def:gr_universal_quotient_sheaf` prose accurately describes the equalizer-of-pushforwards construction. The `def:tautological_quotient` prose accurately identifies the remaining obligation.
- **Hint precision**: **precise** — every `\lean{}` tag names the correct Lean identifier, and the prose descriptions match the Lean signatures.
- **Generality**: **matches need** — the blueprint's level of generality (scheme-level, glue datum) matches what the Lean needed.
- **Recommended chapter-side actions**:
  - Add a brief note or `\lean{}` reference for `Scheme.Modules.glueLift` adjacent to `def:scheme_modules_glue`, since it is the morphism-descent primitive currently implementing what `def:gr_modules_glueHom` will eventually cover. This would prevent confusion when `glueHom` is eventually realised.
  - Optionally, add a mention of `tripleOverlapSections` as the affine identifications-packaged codomain, so future readers of `lem:gr_baseChange_bridge_left/right/transition` have the name in context. Low priority.

---

## Severity summary

**must-fix-this-iter**: none

**major**: none

**minor**:
- `Scheme.Modules.glueLift` (line 469) has no blueprint pin and is substantive enough to deserve one; it is the morphism-descent equalizer.lift that currently fills the role of `def:gr_modules_glueHom`'s forward-declared target.
- `tripleOverlapSections` (line 1522) could benefit from a brief blueprint mention as the packaging of the affine identification of `Γ(V_IJK, ⊤)`.

**Overall verdict**: The closed Lean statements (`baseChange_bridge_*`, `bundleTransition_cocycle_transport`, `bundleTransition_cocycle`, `universalQuotient`) faithfully match their blueprint blocks in signature, mathematical content, and proof strategy; all `\lean{}` pins resolve; the `\leanok` markers on the sorried `tautologicalQuotient` and `represents` statement blocks are semantically correct per documented convention and do not constitute laundering. No must-fix findings. — 10 declarations checked, 0 red flags.
