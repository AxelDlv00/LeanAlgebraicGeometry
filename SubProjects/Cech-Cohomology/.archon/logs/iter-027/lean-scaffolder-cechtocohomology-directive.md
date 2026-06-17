# lean-scaffolder directive — scaffold the 01EO chain (`CechToCohomology.lean`) + naturality stub

## Goal
Create a NEW, COMPILING Lean file `AlgebraicJacobian/Cohomology/CechToCohomology.lean` holding the
five-link 01EO decomposition (Stacks Tag 01EO, blueprint chapter
`Cohomology_CechHigherDirectImage.tex`) as declarations with `sorry` bodies + the small bespoke
infrastructure they need, each carrying a rich `/- Planner strategy: … -/` comment block. Also add
ONE `sorry`-stub declaration (the naturality lemma) to the existing
`AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`. Wire both into the build. **No proofs** —
sorry bodies only; the file must compile (`lake env lean … exit 0`) with the sorries present. Do NOT
attempt to prove anything.

You MAY read project files and use Lean search/hover tools to pin EXACT signatures — that is
expected and encouraged, because several signatures below are sketches that you must make precise
against the real project decls.

## Blueprint source (read these blocks)
In `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`:
- `lem:cech_ses_of_basis` (L1), `lem:quotient_vanishing_cech` (L2),
  `lem:absolute_cohomology_one_vanishing` (L3), `lem:absolute_cohomology_pos_vanishing` (L4),
  `lem:cech_to_cohomology_on_basis` (top) — the 01EO chain.
- `lem:absolute_cohomology_zero_natural` — the naturality obligation (goes in AbsoluteCohomology.lean).
- `def:absolute_cohomology`, `lem:absolute_cohomology_zero/_injective_vanishing/_covariant_les` —
  the Ext wrappers already in AbsoluteCohomology.lean (use as anchors, do not re-create).

## Real project anchors (verified present — pin exact signatures from these)
- **Čech cohomology accessor** = the homology of the section Čech complex. The project uses
  `(sectionCechComplex (U) (P)).homology p` where `sectionCechComplex` is in
  `PresheafCech.lean:334` with signature roughly
  `sectionCechComplex {ι : Type u} (U : ι → TopologicalSpace.Opens X) (P : presheaf-of-modules) : CochainComplex …`.
  There is NO separate `cechCohomology` def and you do NOT need to add one — use `.homology p`
  directly. Confirm the exact type of the second argument `P` (it is a presheaf of `O_X`-modules;
  for an `F : X.Modules` it is `(Scheme.Modules.toPresheafOfModules X).obj F` — see how
  `injective_cech_acyclic` passes it).
- **`injective_cech_acyclic`** (`CechBridge.lean:872`):
  `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] (I : X.Modules) [Injective I] … : IsZero ((sectionCechComplex (coverOpen 𝒰) ((Scheme.Modules.toPresheafOfModules X).obj I)).homology p)` for `p > 0`. Pin its exact statement by hover.
- **`ses_cech_h1`** (`CechBridge.lean`) — produces section-level exactness `0→F(U)→I(U)→Q(U)→0`
  from `Ȟ¹(𝒰,F)=0` + cofinality. Pin its exact signature.
- **Ext wrappers in `AbsoluteCohomology.lean`**: `absoluteCohomologyZeroAddEquiv`
  (`Ext (jShriekOU U) F 0 ≃+ Γ(U,F)`), `absoluteCohomology_eq_zero_of_injective`,
  `absoluteCohomology_covariant_exact₁/₂/₃`. Pin by reading the file.

## What to scaffold in `CechToCohomology.lean`

Imports: `Mathlib`, `AlgebraicJacobian.Cohomology.CechBridge`,
`AlgebraicJacobian.Cohomology.AbsoluteCohomology` (and whatever else the signatures need, e.g.
`PresheafCech`). `namespace AlgebraicGeometry`, `universe u`, `variable {X : Scheme.{u}}`.

Follow the effort-breaker's plan (task result `effort-breaker-split-01eo.md`) — reproduced here:

1. **Infra (defs, will be axiom-clean — but still scaffold with the right shape; bodies for a
   `structure`/`def` are not `sorry`, they are the actual definition):**
   - `structure BasisCovSystem (X : Scheme.{u})` with fields: `B : Set (Opens X)` (basis closed
     under the relevant ∩); `Cov` = the admissible covers (each an open + an indexed family of opens
     covering it, with all finite intersections again in `B`); a `faces_mem` field (condition (1):
     `U` and every `U_{i₀…i_p}` lie in `B`); a `cofinal` field (condition (2): the covers of any
     `V ∈ B` occurring in `Cov` are cofinal among all covers of `V`, stated in exactly the shape
     `ses_cech_h1` consumes). Keep it lightweight — NO colimit / Čech-over-a-basis machinery.
   - `def HasVanishingHigherCech (s : BasisCovSystem X) (F : X.Modules) : Prop` := for every cover
     `c ∈ s.Cov` and every `p > 0`, `IsZero ((sectionCechComplex (family of c) ((toPresheafOfModules X).obj F)).homology p)`.
   - If applying `injective_cech_acyclic` to covers of an arbitrary open `V` (not all of `X`) needs
     a shape adaptation (it is stated for `𝒰 : X.OpenCover`), scaffold a clearly-commented helper
     stub `injective_cech_acyclic_open` with `sorry` for the general-open-family case rather than
     silently assuming — and flag it in your report as a possible infra item. Do NOT fabricate that
     it already holds for arbitrary families.

2. **L1 `cechComplex_shortExact_of_basis`** — cover-LOCAL, hypothesis-driven (takes section-level
   surjectivity/exactness on every face as a hypothesis, so NEITHER `Cov` nor cofinality appears).
   Conclusion: the section Čech complexes form a `HomologicalComplex.ShortExact`. `sorry` body.

3. **L2 `quotient_cech_vanishing_of_basis`** — cover-local; from L1's `ShortExact` + `injective`
   acyclicity `hI` + inductive `hF`, conclude `Ȟᵖ(Q)=0` for `p>0`. `sorry` body.

4. **L3 `absoluteCohomology_one_eq_zero_of_basis`** — pure `Ext`-algebra; takes section
   surjectivity `I(U)↠Q(U)` as a hypothesis (transferred via the naturality lemma below); concludes
   `∀ e : Ext (jShriekOU U) S.X₁ 1, e = 0`. Uses the Ext wrappers + naturality stub. `sorry` body.

5. **L4 `absoluteCohomology_eq_zero_of_basis`** — the induction over `p`, generalized over all `F`
   with `HasVanishingHigherCech s F`; uses `BasisCovSystem s`. Concludes
   `∀ e : Ext (jShriekOU U) F p, e = 0` for `U ∈ s.B`, `p > 0`. `sorry` body.

6. **Top `cech_eq_cohomology_of_basis`** — the assembled 01EO statement (thin wrapper of L4).
   `sorry` body. This is the blueprint `\lean{}` pin for `lem:cech_to_cohomology_on_basis`.

Use the effort-breaker's signature sketches (in its report) as the spec; make them precise against
the real anchors. If a signature genuinely cannot be made well-typed without a design choice you
can't resolve mechanically, encode the most faithful version, leave `sorry`, and FLAG it in your
report — do not block.

## What to scaffold in `AbsoluteCohomology.lean`
Add ONE declaration `absoluteCohomologyZeroAddEquiv_naturality` (the blueprint
`lem:absolute_cohomology_zero_natural` pin `AlgebraicGeometry.absoluteCohomologyZeroAddEquiv_naturality`):
the naturality square of `absoluteCohomologyZeroAddEquiv : Ext (jShriekOU U) F 0 ≃+ Γ(U,F)` in the
coefficient sheaf `F`. Concretely, for `g : F₁ ⟶ F₂` in `X.Modules`, that transporting an
`Ext (jShriekOU U) F₁ 0` class along post-composition by `Ext.mk₀ g` and then `absoluteCohomologyZeroAddEquiv`
agrees with applying `absoluteCohomologyZeroAddEquiv` first and then the sections map `g` over `U`.
Pin the exact form by reading how `absoluteCohomologyZeroAddEquiv` and the section/Γ functor are
spelled in the file; `sorry` body. Do NOT change any existing declaration.

## Build wiring
- Add `import AlgebraicJacobian.Cohomology.CechToCohomology` to `AlgebraicJacobian.lean` (the root
  barrel), after the other `Cohomology.*` imports.
- Confirm the whole project compiles: `lake build` (or `lake env lean` on the new file and on
  `AlgebraicJacobian.lean`) exits 0 with only the intended `sorry` warnings. Report exit status.

## Rich comments (required)
Above each scaffolded lemma, a `/- Planner strategy: … -/` block containing: the blueprint label,
the one-paragraph proof step from the chapter, and the exact anchor decl names it will invoke
(`injective_cech_acyclic`, `ses_cech_h1`, `absoluteCohomology_covariant_exact₁/₂/₃`,
`absoluteCohomology_eq_zero_of_injective`, `absoluteCohomologyZeroAddEquiv`,
`absoluteCohomologyZeroAddEquiv_naturality`). This is what the next prover reads.

## Report
- Final decl names + exact signatures you settled on for all six new `CechToCohomology` decls + the
  infra + the naturality lemma (so the planner can confirm the `\lean{}` pins match).
- Any signature you could not make precise mechanically + the design fork (especially the
  arbitrary-open-cover vs `X.OpenCover` shape for `injective_cech_acyclic`).
- `lake build` / `lake env lean` exit status (must be 0) and the list of sorry sites created.
