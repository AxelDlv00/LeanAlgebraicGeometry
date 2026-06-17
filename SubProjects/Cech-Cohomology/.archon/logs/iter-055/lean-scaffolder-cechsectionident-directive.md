# Scaffolder directive — create `CechSectionIdentification.lean` (Sub-brick A chain)

## Goal

Create the NEW Lean file
`AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
with `sorry`-bodied declaration stubs for the **7 Sub-brick A lemmas** of the
blueprint chapter, correct imports + namespace boilerplate, and rich
`/- Planner strategy: ... -/` block comments above each stub. **Do NOT attempt
to prove anything** — every body is `sorry`. Then wire the new file into the
build root.

This file is the SHARED section-identification chain that discharges the long-stuck
`cechAugmented_exact` residual (`hSec` in `CechAugmentedResolution.lean`) and is
also reusable by the dead `CechAcyclic.affine`. The whole math content is already
written in the blueprint — your job is the structural skeleton only.

## Source of truth (READ FIRST)

- Blueprint chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`,
  the **Sub-brick A block sequence** (lemmas `lem:cech_backbone_left_sigma`,
  `lem:pushPull_sigma_iso`, `lem:pushPull_leg_sections`, `lem:pushPull_eval_prod_iso`,
  `lem:cechSection_complex_iso`, `lem:cechSection_contractible`,
  `lem:cechSection_isZero_homology`) — these are the lemma blocks around lines
  7495–7731. Each block has the full statement + informal proof.
- `analogies/subbrickA.md` — the mathlib-analogist's decomposition (exact Mathlib
  decl names + the single new-infra leaf).

## Imports (the file is most-downstream of the object layer)

```
import AlgebraicJacobian.Cohomology.CechHigherDirectImage   -- pushPullObj, coverCechNerveOver(Aug), cechAugmentedComplex, pushPullFunctor
import AlgebraicJacobian.Cohomology.CechAcyclic             -- CombinatorialCech.Dependent engine (now public), sectionCechProductEquiv, sectionCech_objD_apply, coverInterOpen, le_coverInterOpen_iff, SectionCechModule.*
```

No import cycle: `CechAugmentedResolution.lean` already imports both of these and
will import THIS file next iter to discharge `hSec`. Verify the two imports above
resolve the symbols you reference; if a needed symbol (e.g. `coverInterOpen`,
`pushPullObj`, `cechAugmentedComplex`) lives in a different already-imported file,
adjust the import list to match (use `lean_local_search` / `lean_declaration_file`
to confirm where each symbol is defined). Do not import `AffineSerreVanishing` /
`QcohTildeSections` — the section-identification chain needs none of the qcoh/tilde
machinery.

Namespace: `AlgebraicGeometry` (open it; the 7 names must resolve as
`AlgebraicGeometry.<name>`).

## The 7 stubs (exact `\lean{}` names — bottom-up order)

Create each with the signature the blueprint block describes. Where the precise
Lean type is ambiguous, pick the shape that matches the existing object-layer
decls (`pushPullObj F Y`, `coverInterOpen 𝒰 σ`, `coverCechNerveOver 𝒰`) and leave
a `/- Planner strategy: -/` note flagging the intended type so the prover can
finalize it. The variable context is: a scheme `X`, an open cover `𝒰` of `X` (the
project's `Scheme.OpenCover`-style family with cover arrow `q`), an `F : X.Modules`,
and an open `V : Opens X` / index `p : ℕ`.

1. **`cechBackbone_left_sigma`** (`lem:cech_backbone_left_sigma`) — the degree-`p`
   backbone `Y_p = (coverCechNerveOver 𝒰).obj [p]` is canonically `∐_{σ : Fin(p+1)→I} U_σ`,
   `U_σ = coverInterOpen 𝒰 σ`, with structure map `Sigma.desc (σ ↦ jσ)`. Return an
   iso of schemes (or the data the downstream lemmas consume — see `pushPull_sigma_iso`).
   `\uses{def:cover_cech_nerve, def:cech_free_presheaf_complex}`.

2. **`pushPull_sigma_iso`** (`lem:pushPull_sigma_iso`) — **THE NEW-INFRA LEAF.**
   `pushPullObj F Y_p ≅ ∏_{σ} pushPullObj F (Over.mk jσ)` in `X.Modules`
   (equivalently `(q_p)_*(q_p)^*F ≅ ∏_σ (jσ)_*(jσ)^*F`). Build via `toPresheaf`
   faithful/reflects-iso/preserves-limits + the binary `coprodPresheafObjIso` /
   `isProductOfDisjoint` iterated over the finite index. Strategy note: cite
   `analogies/subbrickA.md` Q1.

3. **`pushPull_leg_sections`** (`lem:pushPull_leg_sections`) —
   `Γ(V, pushPullObj F (Over.mk jσ)) ≅ Γ(coverInterOpen 𝒰 σ ⊓ V, F)`. Off-the-shelf:
   `pushforward_obj_obj` (rfl) + `restrictFunctorIsoPullback` + `restrict_obj` (rfl) +
   image-of-preimage. Strategy note: `analogies/subbrickA.md` Q2 (pattern already in
   `QcohRestrictBasicOpen.lean`).

4. **`pushPull_eval_prod_iso`** (`lem:pushPull_eval_prod_iso`) —
   `Γ(V, pushPullObj F Y_p) ≅ ∏_{σ} Γ(coverInterOpen 𝒰 σ ⊓ V, F)`. Combines (2) +
   `SheafOfModules.evaluation` preserves products + (3).

5. **`cechSection_complex_iso`** (`lem:cechSection_complex_iso`) — the evaluated
   augmented Čech complex `D^• = (GV.mapHomologicalComplex cc).obj Kp`
   (`GV = toPresheaf ⋙ eval(op V)`) is iso, AS A COCHAIN COMPLEX, to the concrete
   section Čech complex `D'^•` with `D'^p = ∏_σ Γ(U_σ⊓V, F)` and the alternating
   coface differential. Degreewise iso = (4); differential match routes through the
   existing `sectionCech_objD_apply` + `sectionCechProductEquiv` (do NOT rebuild).

6. **`cechSection_contractible`** (`lem:cechSection_contractible`) — for
   `V ≤ coverOpen 𝒰 i_fix`, the complex `D'^•` admits `Homotopy (𝟙 D'^•) 0` via the
   prepend-`i_fix` map (which is the IDENTITY on each coefficient because
   `U_{i_fix}∩U_σ∩V = U_σ∩V`, by `le_coverInterOpen_iff`), supplied by the now-public
   `CombinatorialCech.Dependent` engine (`depDiff`, `depHomotopy`, `depHomotopy_spec`,
   `depDiff_exact`). `\uses{lem:cechSection_complex_iso, lem:cech_acyclic_affine, lem:cech_engine_complex}`.

7. **`cechSection_isZero_homology`** (`lem:cechSection_isZero_homology`) — TOP of the
   chain: for `V ≤ coverOpen 𝒰 i`, `IsZero ((D^•).homology p)` ∀p. Transport (6)
   across (5) then apply the EXISTING `isZero_homology_of_homotopy_id_zero` (already
   built in `CechAugmentedResolution.lean`, iter-054 — import it / it is reachable).
   This is EXACTLY the shape `hSec` in `CechAugmentedResolution.lean` consumes.

## Strategy comments

Above each stub, write a `/- Planner strategy: ... -/` block paraphrasing the
blueprint proof sketch for that lemma + naming the Mathlib decls from
`analogies/subbrickA.md`. Keep them mathematical (no tactic strings). These are
what the prover reads.

## Build wiring

Add `import AlgebraicJacobian.Cohomology.CechSectionIdentification` to the build
root `AlgebraicJacobian.lean` (place it AFTER `CechAcyclic` and
`CechHigherDirectImage` so import order is right; it is upstream of
`CechAugmentedResolution`).

## Verification before you finish

Run `lake env lean AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`
(or `lake build` on the file's target) and confirm it compiles with ONLY
`declaration uses sorry` warnings — no errors, no unresolved imports, no unknown
identifiers. If a stub's signature does not type-check (a symbol you referenced
does not exist / has a different shape), FIX the signature to type-check with a
`sorry` body and note the adjustment in its strategy comment — a compiling
sorry-stub is the deliverable; a non-compiling skeleton is not.

## Out of scope

- Do not prove anything. Do not touch any other `.lean` file except the build root.
- Do not edit the blueprint. Do not add `\leanok`.
- Do not re-define object-layer decls (`pushPullObj`, `coverCechNerveOver`,
  `cechAugmentedComplex`) — import them.
