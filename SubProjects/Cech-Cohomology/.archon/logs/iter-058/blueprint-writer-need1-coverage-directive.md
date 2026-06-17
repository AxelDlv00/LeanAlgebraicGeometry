# Blueprint-writer directive — Need#1 (Route 3) decomposition + coverage debt + repoint

## Chapter (only)

`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the de-facto consolidated chapter for
all `AlgebraicJacobian/Cohomology/*.lean`).

Three tasks. All declarations below are Archon-original categorical / sheaf infrastructure (no external
math source) UNLESS they are Mathlib anchors — so omit `% SOURCE` citation lines except where noted.
Do NOT add `\leanok` (deterministic sync owns it). You MAY mark a genuine Mathlib dependency anchor
`\mathlibok`.

---

## TASK 1 — Decompose the Need#1 jShriekOU transport (Route-3 CHURNING corrective)

The lemma `lem:modules_isoSpec_ext_transport` (around line 8983) currently proves the whole Ext
transport, folding the hardest step — "a scheme isomorphism `φ` carries `j_!\mathcal{O}_V` along:
`Φ(j_!\mathcal{O}_V) ≅ j_!\mathcal{O}_{V'}`" — into a single sentence of its proof. A progress-critic
flagged Route 3 CHURNING because this multi-iter wall is undecomposed. Split it into named
build-target sub-lemmas (each its own `\begin{lemma}` with `\label`, `\lean{...}` build-target name,
`\uses{...}`, and a one-paragraph informal proof), then rewrite the `lem:modules_isoSpec_ext_transport`
proof to `\uses{}` them.

The Lean names below are the prover's build-targets (declarations that do not yet exist); mark each
block with a `% NOTE: build target. The Lean declaration does not exist yet.` comment.

1. **`lem:jshriek_transport_along_iso`** — `\lean{AlgebraicGeometry.jShriekOU_transport_along_iso}`.
   Statement: for a scheme isomorphism `φ : X ≅ Y` and an open `V ⊆ X`, the pushforward equivalence
   `Φ = pushforwardEquivOfIso φ : X.Modules ≌ Y.Modules` carries the corepresenting object along:
   `Φ.functor.obj (jShriekOU V) ≅ jShriekOU (φ.hom ''ᵁ V)`, where `φ.hom ''ᵁ V` is the image open.
   This is the assembly of sub-lemmas 2–4. `\uses{def:absolute_cohomology` (for `jShriekOU`)`,
   lem:pushforward_commutes_free, lem:pushforward_commutes_sheafify, lem:yoneda_transport_along_homeo}`.

2. **`lem:pushforward_commutes_free`** — `\lean{AlgebraicGeometry.pushforward_commutes_free}`.
   Pushforward of `O_X`-modules along an iso commutes with the free functor:
   `Φ.functor.obj (free.obj P) ≅ free.obj (Φ_pre P)`, where `free` is the free-module functor on the
   presheaf and `Φ_pre` is the corresponding presheaf pushforward. Route: pushforward along an
   isomorphism of ringed spaces is itself an equivalence and commutes with the left adjoint `free`
   (a left adjoint composed with an equivalence; the mate of the identity). `\uses{}` may reference the
   existing free-functor definition node if one exists in the chapter; otherwise state `free` inline.

3. **`lem:pushforward_commutes_sheafify`** — `\lean{AlgebraicGeometry.pushforward_commutes_sheafify}`.
   Pushforward along an iso commutes with sheafification:
   `Φ.functor.obj (sheafify Q) ≅ sheafify (Φ_pre Q)`. Route: both are left adjoints / the
   sheafification adjunction transports along the equivalence of sites induced by the homeomorphism `φ`.

4. **`lem:yoneda_transport_along_homeo`** — `\lean{AlgebraicGeometry.yoneda_transport_along_homeo}`.
   The representable presheaf transports across the homeomorphism: `Φ_pre (yoneda V) ≅ yoneda (φ.hom ''ᵁ V)`
   on `Opens`, induced by the open-map equivalence `Opens X ≃ Opens Y` of the homeomorphism `φ`.

5. **`lem:pushforward_iso_preserves_qcoh`** — `\lean{AlgebraicGeometry.pushforward_iso_preserves_qcoh}`.
   `% NOTE: build target.` For a scheme iso `φ` and quasi-coherent `H : X.Modules`, the pushforward
   `Φ.functor.obj H` is quasi-coherent. Route: pushforward along an isomorphism of ringed spaces is a
   transport along the induced iso of structure-ring sheaves `X.ringCatSheaf ≅ Y.ringCatSheaf`; quasi-
   coherence (a local-presentation condition) is preserved under such a transport. The prover noted no
   off-the-shelf Mathlib instance — this is genuine but bounded infra.

6. **Mathlib anchor** `lem:isAffineOpen_image_of_iso_mathlib` — `\lean{AlgebraicGeometry.Scheme.Hom.isAffineOpen_iff_of_isOpenImmersion}`, marked `\mathlibok`. State: the
   image of an affine open under an open immersion (a fortiori an isomorphism) is affine. This backs
   "`V'` is an affine open of `Spec Γ U`" in `lem:modules_isoSpec_ext_transport`.

Then **rewrite the proof of `lem:modules_isoSpec_ext_transport`**: replace the single sentence about
`j_!` carrying along by `\ref{lem:jshriek_transport_along_iso}`, the affineness claim by
`\ref{lem:isAffineOpen_image_of_iso_mathlib}`, and the quasi-coherence-preservation claim by
`\ref{lem:pushforward_iso_preserves_qcoh}`; update its `\uses{}` (both statement and proof) to include
`lem:jshriek_transport_along_iso, lem:pushforward_iso_preserves_qcoh, lem:isAffineOpen_image_of_iso_mathlib`
and drop the stale `lem:jshriek_corepr` reference if it no longer matches.

---

## TASK 2 — Clear coverage debt (13 unmatched Lean decls)

Each Lean declaration below was built axiom-clean by a prover but has no blueprint entry (it shows in
`archon dag-query unmatched`). Give each EITHER its own small block (statement + `\label` + `\lean{...}`
+ accurate `\uses{...}` + one-line informal proof) OR — for the private helpers — bundle its `\lean{...}`
name into a closely related block's `\lean{...}` list (a block's `\lean{}` may name several decls).
The dependency lists come from the provers' "Needs blueprint entry" sections.

**CechAcyclic seed helpers** (route B1 change-of-ring seed). The seed block
`lem:affine_cech_vanishing_general_seed` (around line 8761) currently pins a placeholder — **repoint
its `\lean{}` to `AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen`** (the consumer-facing
target the prover built), and cover the supporting chain:
- `AlgebraicGeometry.isLocalizedModule_baseChange_away` — relies on `Mathlib.RingTheory.Localization.BaseChange`
  (`isLocalizedModule_iff_isBaseChange`), `Mathlib.RingTheory.IsTensorProduct` (`IsBaseChange.comp`,
  `TensorProduct.isBaseChange`). Give it a small block (the one genuinely-new Mathlib ingredient).
- `AlgebraicGeometry.SectionCechModule.dDiff_exact_of_affineCover` — relies on
  `isLocalizedModule_baseChange_away` + `SectionCechModule.dDiff_exact` + `IsLocalizedModule.iso` +
  `Function.Exact.of_ladder_addEquiv_of_exact`. Small block; mirror of the done `_of_localizationAway`.
- `AlgebraicGeometry.sectionCech_homology_exact_of_affineCover` — relies on the (private)
  `sectionCechAbExact_affine` + `sectionCech_isZero_homology_of_objD_exact`. Small block.
- `AlgebraicGeometry.sectionCechAbExact_affine` (private) and `AlgebraicGeometry.basicOpen_algMap_section`
  (private) — bundle these two names into the `\lean{}` of the blocks that use them
  (`dDiff_exact_of_affineCover` / `sectionCech_homology_exact_of_affineOpen` respectively), or give
  one-line aside blocks. Either is acceptable; bundling is fine for private helpers.

**CechSectionIdentification coproduct leaf**:
- `AlgebraicGeometry.coverArrowOverSigmaIso` — in `Over X` the cover arrow `Over.mk (Sigma.desc 𝒰.f)`
  is the coproduct of the member arrows `Over.mk (𝒰.f i)`. Give it a block (suggested
  `lem:coverArrow_over_sigma`, wired under `lem:coproduct_distrib_fibrePower` or
  `lem:cech_backbone_left_sigma`), and bundle the two helpers
  `AlgebraicGeometry.coverArrowOverCofan`, `AlgebraicGeometry.coverArrowOverIsColimit` into its
  `\lean{}` (they are implementation details). Relies on `mkCofanColimit`, `coproductIsCoproduct`,
  `Sigma.{ι_desc,hom_ext}`, `Over.{homMk,w}`.

**OpenImmersionPushforward transport core** — bundle these three names into the `\lean{}` of
`lem:modules_isoSpec_ext_transport` (they are its construction internals), and ensure the proof prose
mentions them:
- `AlgebraicGeometry.Scheme.Modules.pushforwardEquivOfIso` (the module-cat equivalence along the iso),
- `AlgebraicGeometry.pushforwardEquivOfIso_functor_additive` (instance),
- `AlgebraicGeometry.Scheme.Modules.pushforwardExtAddEquiv` (the `AddEquiv.ofBijective` via
  `Functor.mapExt_bijective_of_preservesInjectiveObjects`).

(The dead `AlgebraicGeometry.CechAcyclic.affine` stub is superseded and scheduled for deletion by a
refactor — do NOT fabricate a block for it.)

---

## TASK 3 — Repoint the Need#2 consumer pin

`lem:affine_serre_vanishing_general_open` (around line 8925) pins
`\lean{AlgebraicGeometry.affine_serre_vanishing_general_open_TODO}` — a placeholder. The Lane-1 prover
will create the real declaration `AlgebraicGeometry.affine_serre_vanishing_general_open` this iter.
**Repoint the `\lean{}` to the real name** (drop `_TODO`) and remove the `% NOTE: build target … does
not exist yet` comment if present. Its proof already references the now-built seed
`lem:affine_cech_vanishing_general_seed`; leave that wiring intact.

---

## Out of scope

Do not touch the Stub-1 decomposition blocks the effort-breaker just wrote
(`lem:widePullback_overX_eq_prod`, `lem:coproduct_distrib_fibrePower_zero`,
`lem:prod_coproduct_distrib`, `lem:coproduct_fibrePower_reindex`, the reduced
`lem:coproduct_distrib_fibrePower`) — they are complete. Do not add `\leanok`. Do not edit any `.lean`
file. If you discover you need a source you don't have, you may spawn a reference-retriever (your
write-domain includes `references/**`).
