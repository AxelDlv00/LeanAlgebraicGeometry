# Strategy-critic directive — iter-032

Provide a fresh-context critique of the project strategy. Read ONLY the files named below — do NOT read
PROGRESS.md, task ledgers, iter sidecars, or any prover/review narrative.

## What to read
1. `/home/archon/proj/Cech-Cohomology/.archon/STRATEGY.md` (verbatim — the current strategy).
2. `/home/archon/proj/Cech-Cohomology/references/summary.md` (reference index).
3. Blueprint chapter titles + one-line topic each (skim the top `\chapter{}`/section headers only):
   - `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` — consolidated chapter covering the
     entire Čech→cohomology→higher-direct-image arc (Čech complexes, free/section resolutions, the Čech↔
     derived bridge, absolute cohomology Form B, 01EO comparison, 02KG affine Serre vanishing, 01I8
     tilde-sections globalisation).
   - `blueprint/src/chapters/Cohomology_AcyclicResolution.tex` — Leray acyclic-resolution lemma (P4).
   - `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` — push–pull functor + Čech nerve/complex.

## Project goal
Prove `AlgebraicGeometry.cech_computes_higherDirectImage` (protected, frozen signature): for `f : X ⟶ S`
separated quasi-compact, `F` quasi-coherent, `𝒰` a finite affine open cover, an isomorphism
`Nonempty ((CechComplex f 𝒰 F).homology i ≅ higherDirectImage f i F)` under `[HasInjectiveResolutions
X.Modules]`. Route A (acyclic-resolution comparison) is chosen.

## What changed this iter (focus your critique here)
1. The 02KG affine Serre-vanishing phase: the cover-agnostic re-parameterization of the free Čech machinery
   is now COMPLETE on both the free side and the bridge side, so the AffineSerreVanishing cover-system
   infrastructure is unblocked. Estimate trimmed ~5–6 → ~4–5 iters.
2. The 01I8 `F≅~(ΓF)` Route-P chain: P1 `qcoh_localized_sections` has been SPLIT into P1a (affine
   restriction infra: `D(f)≅Spec R_f` + a `Presentation` of `F|_{D(f)}` from `IsQuasicoherent F`) and
   P1b (pure-algebra `IsLocalizedModule` local-on-a-finite-spanning-cover patching primitive, built via
   `IsLocalizedModule.mk`).

## Questions
- Is the P1a/P1b split sound and non-circular? In particular: is P1b (`IsLocalizedModule` local on a span-1
  finite cover) genuinely a self-contained pure-algebra fact provable from current Mathlib independently of
  the cohomology machinery it ultimately serves, so building it first introduces no regress?
- Is anything in the P0–P4 Route-P chain or the 02KG cover-system decomposition mis-stated relative to the
  Stacks sources (01HV / 01I8 / 02KG / 009L)?
- Is the top `affine_serre_vanishing` correctly understood as gated on BOTH the cover-system infra AND the
  unconditional `qcoh_iso_tilde_sections` (which needs the full 01I8 chain)? Any hidden circularity there?
- Any structural concern with carrying `[EnoughInjectives X.Modules]` as an explicit hypothesis with the
  connector deferred to P5b assembly?
