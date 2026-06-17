# Mathlib-analogist directive — FINISH Need#1 hqc + write up both recipes

## Mode: api-alignment

## Context — this is a re-dispatch; the prior run made major progress then died mid-Q1

We have a scheme iso `φ : U ≅ Spec R` (`U.isoSpec`) and the induced equivalence of module
categories `Φ = Scheme.Modules.pushforwardEquivOfIso φ : U.Modules ≌ (Spec R).Modules` (built,
axiom-clean). We need TWO transport facts to discharge two `sorry` holes
(`OpenImmersionPushforward.lean` lines 484/485 — `hjt`, `hqc`):

- **`hjt`** : `Φ.functor.obj (jShriekOU V) ≅ jShriekOU (φ.inv ⁻¹ᵁ V)`.
- **`hqc`** : `(Φ.functor.obj H).IsQuasicoherent`, where `H : U.Modules` is quasi-coherent.

### `hjt` IS ALREADY SOLVED — a prior run produced this compiling, axiom-clean proof
(`#print axioms` = `[propext, Classical.choice, Quot.sound]`). Reproduce/verify it, then write it
into the analogy file as the hjt recipe:

```lean
noncomputable def q2 {R : CommRingCat.{u}} (U : Scheme.{u}) (φ : U ≅ Spec R) (V : U.Opens) :
    (Scheme.Modules.pushforwardEquivOfIso φ).functor.obj (jShriekOU V)
      ≅ jShriekOU (φ.inv ⁻¹ᵁ V) := by
  set Φ := Scheme.Modules.pushforwardEquivOfIso φ
  set A := jShriekOU V
  have e1 : coyoneda.obj (Opposite.op (Φ.functor.obj A))
      ≅ Φ.inverse ⋙ coyoneda.obj (Opposite.op A) :=
    (Φ.toAdjunction.compCoyonedaIso).app (Opposite.op A)
  have cV : coyoneda.obj (Opposite.op A)
      ≅ AlgebraicGeometry.sectionsFunctor V ⋙ forget AddCommGrpCat :=
    (Functor.isoWhiskerRight (sectionsFunctorCorepIso V) (forget AddCommGrpCat)).symm
  have cV' : AlgebraicGeometry.sectionsFunctor (φ.inv ⁻¹ᵁ V) ⋙ forget AddCommGrpCat
      ≅ coyoneda.obj (Opposite.op (jShriekOU (φ.inv ⁻¹ᵁ V))) :=
    Functor.isoWhiskerRight (sectionsFunctorCorepIso (φ.inv ⁻¹ᵁ V)) (forget AddCommGrpCat)
  have big : coyoneda.obj (Opposite.op (Φ.functor.obj A))
      ≅ coyoneda.obj (Opposite.op (jShriekOU (φ.inv ⁻¹ᵁ V))) :=
    e1 ≪≫ Functor.isoWhiskerLeft Φ.inverse cV ≪≫
      (eqToIso (by rfl : Φ.inverse ⋙ (AlgebraicGeometry.sectionsFunctor V ⋙ forget AddCommGrpCat)
        = AlgebraicGeometry.sectionsFunctor (φ.inv ⁻¹ᵁ V) ⋙ forget AddCommGrpCat)) ≪≫ cV'
  exact (Coyoneda.fullyFaithful.preimageIso big).symm.unop
```
Key facts it rests on (ALL verified): `preadditiveCoyoneda.obj X ⋙ forget AddCommGrpCat = coyoneda.obj X`
is `rfl`; `Scheme.Modules.pushforward f ⋙ sectionsFunctor V = sectionsFunctor (f⁻¹ᵁ V)` is `rfl`
(sections of a pushforward = sections over the preimage, definitionally); `Coyoneda.fullyFaithful`
reflects isos; `Φ.toAdjunction.compCoyonedaIso` is the equivalence-coyoneda iso. So the "deep
adjunction-mate, high-LOC" framing in the old prover/blueprint notes is WRONG — record that.

## YOUR JOB THIS RUN — nail down `hqc` (and write up BOTH)

### Verified hqc levers (from the prior run — confirm, then build on)
- Mathlib has **NO** direct "pushforward preserves qcoh" lemma (confirmed gap).
- `Φ.functor` (the equivalence functor) **preserves colimits AND finite limits**:
  both `Limits.PreservesColimitsOfSize.{u,u} Φ.functor` and `Limits.PreservesFiniteLimits Φ.functor`
  succeed by `infer_instance`. (Equivalence ⇒ both.)
- `SheafOfModules.Presentation.isQuasicoherent : F.Presentation → F.IsQuasicoherent` works on
  `(Spec R).Modules` (a single global presentation suffices).
- `SheafOfModules.IsQuasicoherent.of_coversTop F Y hY` (cover-local presentations ⇒ qcoh) typechecks
  but the instance `[∀ i, (F.over (Y i)).IsQuasicoherent]` synthesis **times out on nested over-site
  instances** even at `synthInstance.maxHeartbeats 1000000`.

### Q1 — find a VERIFIED (compiling) construction for `hqc`
Candidate routes, in rough order of promise — confirm which actually compiles:
1. **Transport `H`'s quasi-coherent data across the equivalence.** `H.IsQuasicoherent` unfolds (via
   `of_coversTop` / `QuasicoherentData`) to: a cover `{Y_i}` of `U` with a `Presentation` of each
   `H.over (Y_i)`. Since `Φ.functor` preserves colimits + finite limits (so it sends a presentation
   = cokernel of a map of coproducts of free/`jShriek` modules to a presentation) and behaves on
   `jShriekOU`/sections by the hjt machinery, transport gives a cover `{φ(Y_i)}` of `Spec R` with a
   `Presentation` of each `(Φ.functor.obj H).over (φ(Y_i))`, then `of_coversTop`. Investigate the exact
   Mathlib API: how `IsQuasicoherent` unfolds (`SheafOfModules.isQuasicoherent`,
   `QuasicoherentData`, `Presentation`, `.over`), whether `Φ.functor.obj (H.over (Y i))` relates to
   `(Φ.functor.obj H).over (φ Y i)`, and whether a functor preserving colimits/finite-limits has a
   `Presentation`-transport lemma (or build the ~10-line one).
2. **Single global presentation on Spec R.** On the affine target `Spec R`, qcoh ⟺ `tilde`. If
   `Φ.functor.obj H` admits a *global* `Presentation` (e.g. because `H` itself does on the abstract
   affine `U`, or via `tilde`/`Γ`), `Presentation.isQuasicoherent` closes it directly — much shorter
   than `of_coversTop`. Check whether qcoh on an abstract *affine* scheme `U` gives a global
   `Presentation` (Mathlib: is qcoh-on-affine ⟹ global presentation available? `tilde`, `Γ`,
   `AlgebraicGeometry.Scheme.Hom.toRingCatSheafHom` for `φ`).
3. **Resolve the `of_coversTop` timeout** — is it a genuine gap or just instance-search depth? Try
   providing the per-`i` `IsQuasicoherent` instances *explicitly* (as term-mode `haveI`s, not via
   class search) so synthesis never recurses into the nested over-site.

Produce the SHORTEST compiling route. If none fully compiles, give the precise minimal residual lemma
(exact statement) that would close it, and say which Mathlib API is missing.

## Deliverables (MUST write both)
1. `analogies/need1-transport.md` — the persistent recipe file: the hjt proof (verbatim, above) + the
   verified hqc construction (or the minimal residual), with exact Mathlib lemma names for every step,
   so a blueprint-writer can turn each into a construction-level proof sketch and a prover can
   formalize it. Explicitly correct the "deep adjunction-mate / confirmed Mathlib gap" framing for hjt.
2. Your `task_results/` report — summary + verdict (PROCEED / minimal-residual) per Q.

## Out of scope
- Do NOT edit any `.lean` file or blueprint chapter (read-only investigation + analogy/report writes).
- Do NOT re-investigate hjt beyond confirming the proof above compiles.
- Files to read: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`,
  `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` (for `jShriekOU`, `sectionsFunctorCorepIso`,
  `sectionsFunctor`), and Mathlib `SheafOfModules` qcoh API.
