# Mathlib Analogist Report

## Mode
api-alignment

## Slug
quot-sigma-rebasing

## Iteration
041

## Question

What is Mathlib's canonical idiom for relating the `ModuleCat S` scalar action (used by
`isLocalizedModule_restrict_of_isIso_fromTildeΓ`, `S : CommRingCat`) on the sections of a module on
`Spec S` to the `Γ(Spec S, ⊤)` structure-sheaf action (along which
`gammaPullbackImageIso_hom_semilinear` is semilinear), given `ΓSpecIso S : Γ(Spec S,⊤) ≅ S`? Is the
bridge `restrictScalars` along `ΓSpecIso`, is it defeq, and is the project's
`σ = (ΓSpecIso S).symm ≪≫ gammaImageRingEquiv j ⊤` the Mathlib-aligned choice?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| bridge ModuleCat-S action ↔ Γ(Spec S,⊤) action | PROCEED | informational |
| shape of σ : S ≃+* A | PROCEED | informational |

## Answer to the three precise questions

**Q1 — is the bridge `restrictScalars` along `ΓSpecIso`, and is it defeq?**
Yes and yes. `modulesSpecToSheaf` (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean`) is *defined* as
`SheafOfModules.forgetToSheafModuleCat … ⋙ sheafCompose _ (ModuleCat.restrictScalars
(StructureSheaf.globalSectionsIso R).hom.hom)`. The `ModuleCat R`-object of sections is therefore a
double `restrictScalars` of the genuine structure-sheaf module: first
`forgetToSheafModuleCat` rebases the *variable* ring `Γ(Spec R,U)` to the *global* ring `Γ(Spec R,⊤)`
(`forgetToPresheafModuleCatObjObj = (restrictScalars (R.map (hX.to Y)).hom).obj …`,
`…/Presheaf.lean:372`; identity at `U = ⊤`), then `restrictScalars (globalSectionsIso R).hom` rebases
`Γ(Spec R,⊤)` to the constant `R`. Since `ModuleCat.restrictScalars.smul_def` is `rfl`
(`…/ChangeOfRings.lean:120`), for `s : S`, `x : Γ(M',⊤)`:
`s •_{ModuleCat S} x = (globalSectionsIso S).hom s •_{Γ(Spec S,⊤)} x` **definitionally**. And
`globalSectionsIso_hom = ΓSpecIso_inv = algebraMap S Γ(Spec S,⊤)` (`…/StructureSheaf.lean:938`,
`…/Scheme.lean:623`), so `s •_{ModuleCat S} x = (ΓSpecIso S).inv s • x`, defeq. **No explicit
transport lemma is required**; the named propositional surfacing is `ModuleCat.restrictScalars.smul_def`.

**Q2 — how does the functor re-base, is there a naturality lemma?**
It re-bases via the explicit `sheafCompose _ (ModuleCat.restrictScalars (globalSectionsIso R).hom.hom)`
factor (plus the global-ring forget). There is no separate "structure-sheaf action =
restrictScalars (ΓSpecIso).hom (ModuleCat-S action)" lemma because the equality is *definitional*, not
propositional. If a propositional handle is wanted, the canonical ones are
`ModuleCat.restrictScalars.smul_def` (the rfl smul) and `IsScalarTower.algebraMap_smul` (the latter is
what Mathlib's own `tilde.modulesSpecToSheafIso.map_smul'` uses for the analogous rebasing).

**Q3 — is there a cleaner σ?**
No. Mathlib provides no pre-built ring iso between the Spec-side `CommRingCat` and the
structure-sheaf-at-⊤ beyond `ΓSpecIso` / `globalSectionsIso` themselves (which are the *same* map,
`algebraMap`), and no packaged "pullback section ring iso" for a general open immersion onto a basic
open (so the `gammaImageRingEquiv = (j.appIso V).symm` leg is also irreducible). The composite is the
idiom, and `(ΓSpecIso S).symm` is exactly the inverse of the rebasing `modulesSpecToSheaf` bakes in —
not a hand-built kludge. `ΓSpecIso` is the idiomatic high-level name (vs the lower-level
`globalSectionsIso`); either spelling is defeq.

## Informational

- The reconciliation the project worried might need an explicit `LinearEquiv.restrictScalars` /
  `ModuleCat.restrictScalars` transport is in fact **defeq** — it falls out of `modulesSpecToSheaf`'s
  definition. The only lemma to cite when a `rfl` needs nudging is `ModuleCat.restrictScalars.smul_def`
  (rfl) together with `ΓSpecIso_inv` / `globalSectionsIso_hom` to identify the ring map as `algebraMap`.
- **Assembly caveat for the prover (not a σ-design issue):** `isLocalizedModule_powers_transport`
  uses one `σ` with one codomain `A`, but the `D(f')` leg (`e₂`) carries an *extra*
  `forgetToSheafModuleCat` restriction `Γ(Spec S,⊤) → Γ(Spec S,D(f'))` in its `ModuleCat S` action.
  Derive the `e₂` semilinearity at the ⊤-level `σ` by transporting the ⊤ semilinearity along the
  restriction square (`gammaPullbackImageIso_hom_naturality`, QuotScheme.lean:1833), rather than
  re-stating `σ` at `D(f')`.

## Persistent file
- `analogies/quot-sigma-rebasing.md` — design rationale + recipe captured for future iters.

Overall verdict: keep `σ = (ΓSpecIso S).symm ≪≫ gammaImageRingEquiv j ⊤` — the ModuleCat-S ↔
Γ(Spec S,⊤) bridge is defeq (the `restrictScalars (globalSectionsIso S).hom` baked into
`modulesSpecToSheaf`), so the project's composite is the minimal, Mathlib-aligned choice.
