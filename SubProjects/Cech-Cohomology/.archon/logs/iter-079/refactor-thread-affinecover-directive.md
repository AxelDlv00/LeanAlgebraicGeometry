# Refactor Directive

## Slug
thread-affinecover

## Problem
`AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` does NOT compile. The theorem
`cech_computes_higherDirectImage_of_affineCover` (currently line ~197) calls the producer lemma
`cechTerm_pushforward_acyclic` (in `CechTermAcyclic.lean`, line ~699) with the WRONG argument list.
The producer's (correct, already-landed, green) signature now additionally requires the instance
`[S.IsSeparated]` and an explicit hypothesis `hres`; the consumer supplies neither. This is the
sole remaining compile error in the project's mathematical cone — everything else is proved.

## Mathematical Justification
The producer `cechTerm_pushforward_acyclic` requires `[S.IsSeparated]` (forced by a doubled-origin
counterexample — termwise `f_*`-acyclicity routes through `R^q(j_σ)_* = 0` for the affine
morphisms `j_σ`, which needs the diagonal of `S` affine, i.e. `S` separated) and an explicit
`hres` family providing `HasInjectiveResolutions` on each intersection subscheme `U_σ` (a Mathlib
synthesis gap, threaded as a hypothesis exactly like the top-level `[HasInjectiveResolutions
X.Modules]`). The consumer is the assembly that feeds the producer into the acyclic-resolution
machinery, so it must carry and forward both. `[X.IsSeparated]` is mathematically redundant
(derivable from `[IsSeparated f] + [S.IsSeparated]`) but is carried EXPLICITLY in both producer and
consumer for the lowest-risk type-check — do NOT attempt to drop/derive it. This is pure signature
plumbing: the proof body is already complete and stays unchanged except for supplying `(hres n)`.

## Changes Requested

- File: `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`

  - Change 1 — signature of `cech_computes_higherDirectImage_of_affineCover`.
    - Old (lines ~197–201):
      ```
      theorem cech_computes_higherDirectImage_of_affineCover [HasInjectiveResolutions X.Modules]
          (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated]
          (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
          (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ) :
          Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F) := by
      ```
    - New:
      ```
      theorem cech_computes_higherDirectImage_of_affineCover [HasInjectiveResolutions X.Modules]
          (f : X ⟶ S) [QuasiCompact f] [IsSeparated f] [X.IsSeparated] [S.IsSeparated]
          (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (h𝒰 : ∀ i, IsAffine (𝒰.X i))
          (F : X.Modules) (hF : F.IsQuasicoherent) (i : ℕ)
          (hres : ∀ (n : ℕ) (σ : Fin (n + 1) → 𝒰.I₀),
            HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules) :
          Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F) := by
      ```
    Note: the `hres` binder type must match the producer's binder VERBATIM. The producer
    (`CechTermAcyclic.lean:703–704`) reads:
    `(hres : ∀ σ : Fin (p + 1) → 𝒰.I₀, HasInjectiveResolutions (Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules)`.
    If the term `(Scheme.Opens.toScheme (coverInterOpen 𝒰 σ)).Modules` does not elaborate in the
    consumer, copy the exact term from `CechTermAcyclic.lean:703–704` (both files are in the
    `AlgebraicGeometry` namespace and the consumer imports `CechTermAcyclic`).

  - Change 2 — the producer call site.
    - Old (lines ~206–207):
      ```
        haveI : ∀ n, (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X n) :=
          fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n
      ```
    - New:
      ```
        haveI : ∀ n, (Scheme.Modules.pushforward f).IsRightAcyclic ((cechComplexOnX 𝒰 F).X n) :=
          fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n (hres n)
      ```
    The instances `[S.IsSeparated]` and `[X.IsSeparated]` are now in scope and resolve by instance
    search; `(hres n)` supplies the producer's `hres` explicit argument at degree `n`.

  - Change 3 (cosmetic, do it only if trivial) — the theorem docstring (lines ~185–196) describes
    the hypotheses; if cheap, add `[S.IsSeparated]` and `hres` to the prose so the docstring matches
    the new signature. Not required for compilation.

## Affected Files
- `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` (the only file changed).
- No other file calls `cech_computes_higherDirectImage_of_affineCover` (verified: only docstring
  mentions elsewhere). Adding the `hres` parameter breaks no downstream caller.

## Expected Outcome
`CechToHigherDirectImage.lean` compiles with **0 errors and 0 sorries**;
`cech_computes_higherDirectImage_of_affineCover` is fully PROVED. No new sorries anywhere.

## BUILD-WALL note
This file cold-builds the full heavy chain (CechAugmentedResolution + CechTermAcyclic + the CSI
Leg); a cold `lake build` is ~25+ min and may hit the sandbox memory cap (exit 137). Established
workflow: verify with `lake build AlgebraicJacobian.Cohomology.CechToHigherDirectImage` or
`lake env lean AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`, or
`lean_diagnostic_messages` on the file against the existing oleans. If you hit exit-137/timeout,
LAND THE EDITS ANYWAY and report the exact diagnostic state you obtained — the downstream
review-build gate (larger cap) verifies. Do NOT trust `lean_run_code`/`lean_multi_attempt` for a
pass/fail verdict on this instance-sensitive file (stale-olean false positives); trust only
`lake build` / `lake env lean` / `lean_diagnostic_messages`.
