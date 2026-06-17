# Mathlib Analogist Report

## Mode
api-alignment

## Slug
fbc-dict

## Iteration
235

## Question
For the affine reduction of `affineBaseChange_pushforward_iso`: (Q1) the Mathlib idiom
for the element-free Γ-fragment iso `restrictScalars φ (Γ (tilde M)) ≅ Γ (pushforward
(Spec.map φ)(tilde M))`, the accessor for the ring map underlying
`SheafOfModules.pushforward`, whether `(Spec.map φ) ⁻¹ᵁ ⊤ = ⊤` is rfl, and whether a
direct affine-pushforward-of-tilde iso already exists; (Q2) is "pushforward preserves
quasi-coherent" genuinely Mathlib-absent, and if so the cheapest project-side build path.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Missing `[IsQuasicoherent F]` on `affineBaseChange_pushforward_iso` | ALIGN_WITH_MATHLIB | critical |
| Hand-built section smul-dictionary vs `tilde`-full-faithfulness reduction | ALIGN_WITH_MATHLIB | critical |
| Direct affine-pushforward-of-tilde iso (Q1 top find) | NEEDS_MATHLIB_GAP_FILL | informational |
| QC-of-pushforward (Q2) | NEEDS_MATHLIB_GAP_FILL | informational |
| Accessor for the pushforward ring map (Q1 blocker) | PROCEED (idiom) | informational |
| `map_smul'` smul-compatibility idiom | PROCEED (idiom) | informational |

## Must-fix-this-iter

- **Missing `[IsQuasicoherent F]` hypothesis.** `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:213`
  (`affineBaseChange_pushforward_iso`) and `:246` (`flatBaseChange_pushforward_isIso`)
  take `F : X.Modules` with no quasi-coherence hypothesis. The blueprint chapter is titled
  "...of a **quasi-coherent** sheaf" and the affine-local statement is `F = tilde M`
  (`blueprint/src/chapters/Cohomology_FlatBaseChange.tex:1,18,229`). Without
  `[IsQuasicoherent F]` the statement is false (Stacks 02KH requires F quasi-coherent) and
  the intended proof is impossible — over an affine open a general `F` is not `tilde M`, so
  the Γ-fragment iso and `cancelBaseChange` simply do not apply. The declaration is **not**
  in `archon-protected.yaml`, so the planner/prover may add the hypothesis. Every iter spent
  on the Γ-fragment instance wall is in service of a theorem that, as currently typed,
  cannot consume it.

- **Reframe the affine reduction around `tilde` full-faithfulness, not a section
  smul-dictionary.** The iter-234 instance wall (`FlatBaseChange.lean:168-205`) is a symptom
  of working at the wrong altitude. `tilde.functor R` is fully faithful with essential image
  = QC (`Tilde.lean:312-316,340`, `isIso_fromTildeΓ_iff`) and a fully faithful functor
  reflects isos. For the base-change map `α` between QC `(Spec R)`-modules, counit
  naturality `fromTildeΓNatTrans` (`Tilde.lean:248`) with both `fromTildeΓ`s iso gives
  `IsIso α ↔ IsIso (moduleSpecΓFunctor.map α)`, reducing the whole goal to `IsIso` of a
  concrete `ModuleCat R` map (`cancelBaseChange`) with no section-level `Module`/`SMul`
  instances ever named. Confine any residual section-smul work to identifying that
  `ModuleCat` map, where Mathlib's own idiom applies (see Informational).

## Major

(none beyond the two must-fix items — both target shipped-but-sorried code whose signature
and proof-shape are editable.)

## Informational

- **Q1 highest-value find — direct affine-pushforward-of-tilde iso: GENUINELY ABSENT.**
  No `pushforward … tilde` / `tilde … restrictScalars` lemma exists in Mathlib (full grep
  empty; `leansearch` returns only structural `pushforward` defs). The clean functor-level
  statement `tilde.functor R' ⋙ pushforward (Spec.map φ) ≅ restrictScalars φ ⋙
  tilde.functor R` does not exist. **Cheapest build = the single object iso**
  `pushforward (Spec.map φ)(tilde M) ≅ tilde (restrictScalars φ.hom M)`. Build it once and
  it discharges *both* Q1 (Γ-fragment, via `moduleSpecΓFunctor` of the iso +
  `tilde.toTildeΓNatIso`, `Tilde.lean:273`) and Q2 (QC-of-pushforward, via
  `(isQuasicoherent R).IsClosedUnderIsomorphisms` `Quasicoherent.lean:330` +
  `(tilde N).IsQuasicoherent` `Tilde.lean:394`). This is the highest-leverage brick for the
  lane.

- **Q2 — QC-of-pushforward: GENUINELY ABSENT.** `IsQuasicoherent` occurs in exactly two
  files (`Modules/Tilde.lean`, `Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean`); there
  is no `AlgebraicGeometry/Morphisms/QuasiCoherent.lean` and no
  pushforward/affine/closed-immersion/finite preservation lemma. It is *not* an independent
  obligation: for the concrete `tilde M` it is a corollary of the Q1 object iso (above), so
  no general theorem need be proved.

- **Q1 accessor blocker — use `.hom`, not `.val`.** `f.toRingCatSheafHom`
  (`Modules/Presheaf.lean:42`) is built `where hom := Functor.whiskerRight f.c _`. In current
  Mathlib `Sheaf J A` is an `ObjectProperty.FullSubcategory` of presheaves
  (`Sheaf.Hom.mk := ObjectProperty.homMk`, `Sites/Sheaf.lean:315`) — hence the prover's
  `.val.app` hit an `InducedCategory.Hom` and failed. The RingCat map at `⊤` is
  `f.toRingCatSheafHom.hom.app (op ⊤)`, defeq `(forget₂ CommRingCat RingCat).map
  (f.c.app (op ⊤))`. Simpler still: the comparison ring map at `⊤` is `f.appTop`
  (`Γ(Y,⊤) ⟶ Γ(X,⊤)`, on the scheme morphism directly), conjugate to `φ` for `f = Spec.map φ`
  by `Scheme.ΓSpecIso_inv_naturality` (`Scheme.lean:619`) — no need to dig through
  `SheafOfModules.pushforward` internals.

- **`(Spec.map φ) ⁻¹ᵁ ⊤ = ⊤` is `rfl`** (`Scheme.preimage_top`, `Scheme.lean:259`). Combined
  with `pushforward_obj_obj` (rfl, `Sheaf.lean:155`), the section identification
  `Γ((pushforward f).obj M, ⊤) = Γ(M, ⊤)` needs no `eqToHom`/`homOfLE` transport.

- **`map_smul'` idiom — the action IS nameable.** If a `ModuleCat`-level smul identity
  remains, copy Tilde.lean's own discharge of the identical goal:
  `letI := Module.compHom … (algebraMap …)`,
  `haveI : IsScalarTower R _ _ := .of_algebraMap_smul fun _ _ ↦ rfl`, then
  `IsScalarTower.algebraMap_smul` / `IsLocalization.linearMap_compatibleSMul …` (`Tilde.lean:71-79`,
  `:103`). The iter-234 claim that the intermediate action "is not a synthesizable instance"
  is refuted by Mathlib materialising it with `letI`/`haveI` rather than relying on synthesis.

## Persistent file
- `analogies/fbc-dict.md` — design-rationale captured for future iters.

Overall verdict: the Γ-fragment instance wall is a wrong-altitude symptom — fix the missing
`[IsQuasicoherent F]` hypothesis (critical, signature editable) and reduce `IsIso` via
`tilde`-full-faithfulness, leaving one Mathlib-absent object iso
`pushforward (Spec.map φ)(tilde M) ≅ tilde (restrictScalars φ.hom M)` to build, which
discharges both Q1 and Q2.
