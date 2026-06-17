# Mathlib analogist directive — iter-200 slug ab-natrecursive

## Mode: api-alignment

## The decl / situation we want aligned

The iter-200 Lane AB-gap1-NatRecursive prover is asked to iterate the iter-199 axiom-clean `RingTheory.Module.exists_minimalSurjection_finite_localRing` (a single-step per-syzygy minimal surjection from `R^n` for a finite module over a local ring) into a full **iterated minimal-free-resolution carving**: a function/lemma producing, for a finite module `M` of finite projective dimension over a Noetherian local ring `R`, a `ChainComplex ℕ (ModuleCat R)` of finite-rank free modules of length `pd_R(M)` whose transition maps all have image in `\mathfrak m`.

The corresponding Stacks tag is **00LK** (`lemma-add-trivial-complex`) + Bruns-Herzog §1.5.

The directive's iter-200 recipe takes ~40-80 LOC as a `Nat`-recursive construction on syzygies. The progress-critic `route200` returned this lane STUCK (5 iters of unchanged sorry count, 5 helpers added with 0 closures) and recommended a Mathlib analogy consult before another helper round.

## What we need from you

1. **Locate existing Mathlib infrastructure** for:
   - `Module.syzygy` / `Module.syzygies` — a per-step or iterated syzygy construction. Does Mathlib have this?
   - `ChainComplex ℕ (ModuleCat R)` of free modules — the Mathlib API for constructing free resolutions. Specifically: `Mathlib.Algebra.Category.ModuleCat.Free`, `Mathlib.CategoryTheory.Abelian.ProjectiveResolution`.
   - `Module.projectiveDimension` API — the iter-199 file uses `Module.projectiveDimension`. What's the Mathlib state on free-resolution-length-equals-projective-dimension lemmas?
   - Mathlib's `Module.Finite.exists_fin_basis` or analogous "finite module has finite generation" lemmas that the Nat-recursive iteration consumes.

2. **Identify the cleanest Mathlib idiom** for building a length-`n` `ChainComplex ℕ (ModuleCat R)` by `Nat`-recursion on `n`. Specifically: `Nat.rec` on chain complexes vs. `CategoryTheory.ProjectiveResolution.mk` vs. project-side raw construction.

3. **Stacks 00LK ↔ Mathlib bridge**: does Mathlib have a single lemma packaging "every finite free resolution of a finite module over a Noetherian local ring trims to a minimal one of the same projective dimension"? If yes, name it (file path). If no, propose the bridge as a project-side iterated-syzygy helper of ~40-80 LOC.

4. **Bruns-Herzog Construction 1.5.18 ↔ Mathlib**: this is the constructive minimal-free-resolution construction. Mathlib has `Module.Projective`, `Module.Free`, and bits of homological algebra. Does any of this give a direct iterated construction we can ride?

5. **Bottom line**: is the iter-200 lane's ~40-80 LOC budget realistic given current Mathlib? If yes, propose a 3-step recipe with named Mathlib helpers. If no, say so and propose a re-scoping.

## Search radius

`narrow` — the project sits in commutative algebra (`Mathlib.RingTheory.Module.*`) + homological algebra (`Mathlib.Algebra.Homology.*` + `Mathlib.CategoryTheory.Abelian.*`).

## What to produce

A ranked list of Mathlib infrastructure pieces relevant to Lane AB-gap1-NatRecursive, with named declarations and file paths. Plus:

- A verdict: PROCEED (the Mathlib substrate is sufficient for the ~40-80 LOC budget) or ALIGN-WITH-MATHLIB (rename / restructure to match Mathlib idioms) or RE-SCOPE (budget significantly under-estimated).
- A concrete iter-200 prover recipe with named Mathlib helpers + per-step LOC estimates.

## Out-of-scope

- Do NOT propose proofs for the prover.
- Do NOT touch `STRATEGY.md`, `PROGRESS.md`, blueprint chapters, or any `.lean` file.

## Write domain

- `analogies/**` (persistent: `analogies/ab-natrecursive.md`)
- `task_results/**`

## Report

`task_results/mathlib-analogist-ab-natrecursive.md` + persistent `analogies/ab-natrecursive.md`.
