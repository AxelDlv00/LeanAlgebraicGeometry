# Lean Scaffolder Directive — p3-split (P3 file split + re-sign)

## Goal
Split the P3 affine-acyclicity lemma out of `CechHigherDirectImage.lean` into a new file
`AlgebraicJacobian/Cohomology/CechAcyclic.lean`, **re-signed** to carry the spanning-family
bundle (the design locked in `.archon/analogies/p3-localisation.md`). This isolates the P3
prover lane for parallelism (standing user directive). Bodies stay `sorry`; do NOT prove.

## Read first
- `.archon/analogies/p3-localisation.md` — the authoritative P3 design (cover encoding,
  `exact_of_isLocalized_span`, L1/L2/L3 decomposition).
- `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean` — current home of `CechAcyclic.affine`
  (`:764`) and `CechComplex` (`:737`); note its `variable` block and `open`s.
- `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — `lem:cech_acyclic_affine`
  (`:506`) and `def:standard_affine_cover` (`:482`).

## Task 1 — create `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- Header (copyright block matching the sibling files), then `import Mathlib` and
  `import AlgebraicJacobian.Cohomology.CechHigherDirectImage` (for `CechComplex`).
- `universe u`, `open CategoryTheory Limits`, `namespace AlgebraicGeometry`, plus whatever
  `open`s `CechAcyclic.affine` needs (mirror the source file).
- Create `CechAcyclic.affine` **re-signed** to the standard-cover bundle. Target shape (adapt
  variable/universe/instance details until it typechecks — this is the locked design):
  ```
  theorem CechAcyclic.affine {R : CommRingCat.{u}} {S : Scheme.{u}}
      (f : Spec R ⟶ S) [IsAffineHom f]
      {ι : Type u} [Finite ι] (s : ι → R) (hs : Ideal.span (Set.range s) = ⊤)
      (F : (Spec R).Modules) (hF : F.IsQuasicoherent) (p : ℕ) (hp : 1 ≤ p) :
      IsZero ((CechComplex f ((Scheme.affineOpenCoverOfSpanRangeEqTop s hs).openCover) F).homology p) := by
    sorry
  ```
  Notes you must resolve to make it compile:
  - `affineOpenCoverOfSpanRangeEqTop s hs : (Spec R).AffineOpenCover`; use `.openCover` to get a
    `(Spec R).OpenCover` for `CechComplex`. Verify the exact projection name
    (`AffineOpenCover.openCover`) via `lean_loogle`/hover.
  - `CechComplex` needs `[Finite 𝒰.I₀]`; supply/derive it from `[Finite ι]` (the cover's index
    is `ι`). If the instance isn't found automatically, add a `haveI`/instance or an explicit
    `Finite` argument so the application typechecks.
  - Keep the name `AlgebraicGeometry.CechAcyclic.affine` EXACTLY (it is the blueprint `\lean{}`
    pin; it is NOT protected, so the re-sign is permitted).
- Above the theorem, add a `/- Planner strategy (P3, see analogies/p3-localisation.md): -/`
  block comment with the L1/L2/L3 route in prose:
  - L1 (gap-fill): identify `CechComplex` on this standard cover with the module complex
    `∏_σ M_{s_σ}` via `Γ(D(s_σ)) = M_{s_σ}` (Away localisation).
  - L2 (ALIGN): feed each positive-degree node to
    `exact_of_isLocalized_span (Set.range s) hs` (`Mathlib.RingTheory.LocalProperties.Exactness`),
    localising at the spanning elements `Away (s r)` (not primes).
  - L3 (gap-fill): in the localisation `A_{s_r}` the fixed index `i_fix = r` makes `s_r`
    invertible, so the contracting homotopy `h(σ)_{i_0…i_p} = σ_{r i_0…i_p}` is global there and
    gives `Function.Exact` of the localised differentials. Do NOT route through Mathlib's
    simplicial `ExtraDegeneracy` (wrong variance, no cosimplicial dual).

## Task 2 — remove from `CechHigherDirectImage.lean`
- Delete the old `CechAcyclic.affine` theorem (`:764`) and its preceding doc comment (`:747`).
- Update the doc comment on `cech_computes_higherDirectImage` (`:776`–`:811`): the current
  comment describes the OLD two-spectral-sequence route, which is now actively misleading. The
  signature is FROZEN — do NOT change it — but replace the stale "Proof (Stacks 02KE): … two
  spectral sequences … absent from Mathlib" narrative with a one-paragraph Route-A description:
  "reduce to `S` affine; the augmented Čech complex is a termwise `f_*`-acyclic resolution of
  `F`, so the P4 acyclic-resolution lemma (`rightDerivedIsoOfAcyclicResolution`) gives
  `Hⁱ(f_* C•) ≅ Rⁱf_* F`; acyclicity reduces to affine Serre vanishing via the P3b bridge."
  Keep it short; no spectral sequences.

## Task 3 — wire the import root
- Add `import AlgebraicJacobian.Cohomology.CechAcyclic` to `AlgebraicJacobian.lean` (after the
  `CechHigherDirectImage` import).

## Hard requirement
`lake build` (or `lean_build`) must be GREEN for the whole project after your edits — both the
new `CechAcyclic.lean` and the trimmed `CechHigherDirectImage.lean` compile (the only remaining
hole is the `sorry` in `CechAcyclic.affine`). If the re-signed signature will not typecheck
after genuine effort, report the exact error and the closest signature that DID compile — do
NOT leave a broken build.

## Constraints
- Do NOT attempt the proof; body is `sorry`.
- Do NOT touch `CechComplex` or `cech_computes_higherDirectImage`'s SIGNATURE (frozen).
- Do NOT edit blueprint `.tex` (outside your domain). If you create a decl with no blueprint
  entry, list it under "Uncovered declarations" in your report (none expected — `CechAcyclic.affine`
  already has `lem:cech_acyclic_affine`).

## Report
The final compiling signature of `CechAcyclic.affine`, confirmation of green build, the import
wiring, and anything that did not go as specified.
