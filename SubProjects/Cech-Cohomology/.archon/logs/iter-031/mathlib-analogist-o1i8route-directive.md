# mathlib-analogist directive — 01I8 affine qcoh structure theorem route selection

## Mode: api-alignment

## The decision to de-risk
The project needs the instance/lemma

    [IsQuasicoherent F] → IsIso (F.fromTildeΓ)      -- F : (Spec R).Modules

This is the last input to upgrade the project's `qcoh_iso_tilde_sections` from its conditional
`[IsIso F.fromTildeΓ] → F ≅ ~(ΓF)` form to the unconditional quasi-coherent form. It is Stacks tag
**01I8** (`lemma-quasi-coherent-affine` / `lemma-equivalence-quasi-coherent`): every quasi-coherent
sheaf on `Spec R` is `~M` for an `R`-module `M` (= `Γ(X,F)`).

Two iters of prover work (iter-029, iter-030) reduced the problem to EXACTLY this instance and
stopped, reporting the supporting facts (`Γ(D(f),F)=Γ(X,F)_f` for qcoh F; qcoh kernel-closure) are
ABSENT from Mathlib and the build is ~few-hundred LOC. Before committing multi-iter prover budget I
need YOU to pick the Mathlib-aligned route and name the precise first sub-lemma, OR find that Mathlib
already provides a shortcut I missed.

## Confirmed Mathlib facts (read these files to verify + extend)
- `.lake/packages/mathlib/Mathlib/AlgebraicGeometry/Modules/Tilde.lean`:
  - `Scheme.Modules.fromTildeΓ` (counit of `tilde ⊣ moduleSpecΓFunctor`), line ~195.
  - **`isIso_fromTildeΓ_iff` (line 340): `IsIso M.fromTildeΓ ↔ (tilde.functor R).essImage M`.** So our goal
    ⟺ `[IsQuasicoherent F] → F ∈ essImage(tilde.functor R)`.
  - `tilde.adjunction` is FULLY FAITHFUL with `IsIso unit` (lines 273-317).
  - `isIso_fromTildeΓ_of_presentation (M) (P : M.Presentation)` (line 398) — the ONLY current producer of
    `IsIso fromTildeΓ`; needs a GLOBAL `Presentation` (free ⟶ free ⟶ M exact).
  - `tildeFinsupp`, `free`/`unit` are essImage (lines 350-368); `(tilde M).IsQuasicoherent` (line 394).
  - The `IsQuasicoherent` section ENDS at `_of_presentation` — no qcoh→essImage / qcoh→fromTildeΓ lemma.
- `.lake/packages/mathlib/Mathlib/Algebra/Category/ModuleCat/Sheaf/Quasicoherent.lean`:
  - `structure QuasicoherentData M` (line 201): an index `I`, objects `X : I → C` with `J.CoversTop X`,
    and **`presentation (i) : (M.over (X i)).Presentation`** — i.e. a LOCAL presentation of `F|_{X i}`.
  - `class IsQuasicoherent M := Nonempty (QuasicoherentData M)` (line 249).
  - On `Spec R` the site is `(Spec R).Opens`; so `[IsQuasicoherent F]` gives an open cover `{Uᵢ}` of ⊤
    with each `F|_{Uᵢ}` presented. Refining to a standard cover `Uᵢ = D(fᵢ)` is available
    (`Scheme.isBasis_affineOpens` / `PrimeSpectrum.isBasis_basic_opens`).
- Project file `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` already has, axiom-clean:
  `isIso_fromTildeΓ_of_genSections (σ : F.GeneratingSections) (τ : (kernel σ.π).GeneratingSections)`
  (builds a `Presentation` from two GLOBAL generating families → `_of_presentation`), and
  `free_isQuasicoherent`.

## The two candidate routes (and the Mathlib API each needs)
- **Route G — gluing (the Stacks 01I8 proof).** Read `references/stacks-schemes.tex` lines 1278–1432
  (`lemma-quasi-coherent-affine` + `lemma-equivalence-quasi-coherent` + `lemma-kernel-cokernel-quasi-coherent`).
  From the local `~Mᵢ` on `D(fᵢ)`, glue the `R_{fᵢ}`-modules `Mᵢ` (with the overlap isos `(Mᵢ)_{fⱼ}≅(Mⱼ)_{fᵢ}`)
  into a global `R`-module `M` with `M_{fᵢ}=Mᵢ` (Stacks `algebra-lemma-glue-modules`), then `~M ≅ F`.
  **My grep found NO module-gluing in Mathlib** (`RingTheory`/`Algebra`). QUESTION: does Mathlib have
  ANY equivalent — `Module.GlueData`, a sheaf-of-modules descent/glueing, `TensorProduct`/equalizer
  descent along a finite affine cover, or `IsLocalizedModule` glueing — that yields the glued module?
- **Route P — global generation (Hartshorne II.5.14-17).** Prove `Γ(D(f),F) ≅ Γ(X,F)_f` for qcoh F
  (`IsLocalizedModule` of the restriction map at `f`), use it to extend local generators to global ones
  → `F.GeneratingSections`; same for `kernel σ.π` (needs qcoh kernel-closure, Stacks
  `lemma-kernel-cokernel-quasi-coherent`) → feed both to the project's ready `isIso_fromTildeΓ_of_genSections`.
  QUESTION: does Mathlib have `Γ(D(f),F)=Γ(X,F)_f` for qcoh (not just for `tilde M`, where it IS present),
  any qcoh-section localization, or the qcoh kernel/cokernel-closure on `Spec R`?

## What I need back (ranked, concrete)
1. **Shortcut check**: is there ANY Mathlib lemma/instance giving `[IsQuasicoherent F]→IsIso F.fromTildeΓ`
   (or `essImage tilde`, or a `QCoh(Spec R) ≃ Mod_R` equivalence) that the prover's grep missed? If yes,
   01I8 collapses to a wrapper — name it exactly.
2. If absent: **pick the route** (G vs P vs a third you find) that minimizes NEW project LOC and best reuses
   Mathlib, with citations to the specific Mathlib decls each route can stand on.
3. Name the **precise first atomic sub-lemma** to dispatch a `mathlib-build` prover at (signature in the
   project's notation), and the Mathlib API it builds on. This becomes the iter-032 first QcohTilde lane.
4. Flag any Mathlib API genuinely missing for the chosen route (so I log it as a gap-fill chain, not a
   blind sorry).

Persist the route analysis to `analogies/o1i8-qcoh-tilde-route.md`.
