# Strategy critic — iter 030

You are a fresh-context critic of the project's global strategy. Read ONLY the
files named below. Do NOT read PROGRESS.md, task ledgers, iter sidecars, or any
prover/review narrative — your value is an uninvested view.

## Read these
- `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — the strategy under review).
- `/home/archon/proj/Cech-Cohomology/references/summary.md` (reference index).
- The first ~15 lines of each blueprint chapter for chapter titles + topic:
  - `blueprint/src/chapters/Cohomology_HigherDirectImage.tex`
  - `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`
  - `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Project goal (one paragraph)
Formalize Stacks 02KE: for `f : X ⟶ S` separated quasi-compact, `F` quasi-coherent,
`𝒰` a finite affine open cover, Čech cohomology computes higher direct images —
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ ((pushforward f).rightDerived i).obj F)`.
The protected target is `AlgebraicGeometry.cech_computes_higherDirectImage`.

## What changed this iter (assess these specifically)
1. **Design-fork resolution (the load-bearing new decision).** The 02KG affine
   instantiation needs injective Čech-acyclicity over standard covers of *arbitrary*
   distinguished opens `D(f)`, but the shipped `injective_cech_acyclic` was stated
   over `X.OpenCover` (covers the whole space ⊤). The planner's decision: re-parameterize
   the free-Čech resolution machinery (FreePresheafComplex.lean) from `X.OpenCover` to a
   raw finite family of opens `{ι}[Finite ι](U : ι → Opens X)`, making
   `injective_cech_acyclic` cover-agnostic. Justification: the planner verified the cover
   *morphisms* `𝒰.f` are used ONLY in `coverOpen 𝒰 i := (𝒰.f i).opensRange`, and the
   augmentation target `coverStructurePresheaf := image(cechFreeAug)` references no
   `⊤`/`iSup`/covering hypothesis — so the resolution is intrinsically about the indexed
   family of opens, and re-parameterizing is mechanical.
   - **Question for you:** Is this sound? In particular: is it mathematically true that
     positive-degree Čech cohomology of an injective `O_X`-module vanishes over an *arbitrary*
     finite family of opens (not required to cover anything)? Or does the vanishing secretly
     rely on the family covering its sup? Flag if the re-parameterized statement could be
     vacuous, false, or hide a covering hypothesis that must be re-added.
   - The rejected alternative was to realize each `D(f) ≅ Spec R_f` and restrict — which
     re-introduces "restriction preserves injectives", exactly what the Form-B absolute-
     cohomology choice was made to avoid. Confirm this rejection is correct.
2. **01I8 globalisation** (`F ≅ ~(ΓF)` for quasi-coherent `F` on an affine) reduced to one
   instance `[IsQuasicoherent F] → IsIso F.fromTildeΓ` via a 3-step affine global-generation
   argument. Conditional + presentation forms already landed. Assess whether the 3-step
   decomposition is the right route or whether a cleaner path exists.
3. The remaining 02KG geometry: `surj_of_vanishing` via `ses_cech_h1` + "sheaf-of-modules epi
   ⇒ local section surjectivity over a basic-open cover". Is this the minimal honest route?

## Output
Per the strategy-critic format: SOUND / SOUND-with-CHALLENGE / REJECT, with explicit
challenges. Focus on the design-fork resolution's mathematical soundness above all —
that is the decision the planner is about to spend prover budget on.
