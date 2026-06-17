# Mathlib-analogist directive

## Mode: api-alignment

## Context
P3's `CechAcyclic.affine` (`lem:cech_acyclic_affine`) has been STUCK for 2 prover iters: both built
the combinatorial L3 cores (now DONE, axiom-clean) but bounced off the **L1 categorical→module
bridge**, which prior review flagged "Mathlib support unconfirmed". Before dispatching a mathlib-build
prover at L1, confirm the L1 API path is real on today's Mathlib so the lane does not burn a 3rd iter.

## Setup
- `R : CommRingCat`, `F : (Spec R).Modules` (`= SheafOfModules` on `Spec R`) with
  `F.IsQuasicoherent`. `M := Γ(Spec R, F)`.
- Standard cover by basic opens `D(s_i)`, `s : ι → R`, `Ideal.span (Set.range s) = ⊤`.
- The project's relative Čech complex `CechComplex f 𝒰 F` has degree-p term
  `pushforward f` applied to `pushPullObj F (D(s_σ) ↪ Spec R) = (incl)_* (incl)^* F`,
  `s_σ = ∏_k s_{σ k}`.

## Confirm/refute each, with exact Mathlib decl name + namespace, or "ABSENT":
1. **Section = localisation.** Sections of `pushPullObj F (D(g) ↪ Spec R)` (or of `F` itself) over a
   basic open `D(g)` identified with the away-localisation `M_g = LocalizedModule (.powers g) M` /
   `IsLocalizedModule (.powers g) …`. The iter-016 prover found in `AlgebraicGeometry.Modules.Tilde`:
   `instance (g : R) : IsLocalizedModule (Submonoid.powers g) (tilde.toOpen M (basicOpen g)).hom` and
   `isUnit_algebraMap_end_basicOpen`. Confirm these exist and give the bridge from an arbitrary
   quasicoherent `F : (Spec R).Modules` to `tilde M` (quasicoherence ⇒ `F ≅ tilde (Γ F)`?) — name the
   Mathlib decl for that equivalence (e.g. `AlgebraicGeometry.Modules.…`).
2. **Restriction = localisation map.** The restriction map `F(D(g₁)) → F(D(g₂))` for `D(g₂) ⊆ D(g₁)`
   identified with the canonical localisation map between `M_{g₁}` and `M_{g₂}` — the input the
   alternating localisation coboundary `δ` needs. (Stacks Schemes 01HV(5).)
3. **Homology ↔ exactness.** For a cochain complex in `(Spec R).Modules` (`SheafOfModules`), reducing
   `IsZero (C.homology p)` to `Function.Exact` of the underlying `R`-module maps. What is the Mathlib
   idiom — sectionwise evaluation on the affine (does `SheafOfModules.evaluation`/global-sections
   preserve homology here?), or a `HomologicalComplex`-level `exact ↔ IsZero homology` lemma, then
   `exact_of_isLocalized_span`? Name the relevant lemmas.
4. **Pushforward along `f : Spec R ⟶ S`.** The outer `pushforward f` in each Čech term — does it
   complicate the section/homology identification, or is the vanishing checkable before/independent of
   it (e.g. `pushforward` faithful/exact enough that `IsZero homology` upstairs suffices)?

## What I need back
- A PROCEED / ALIGN / NOT-FEASIBLE-YET verdict on the L1 bridge as a mathlib-build lane THIS iter.
- If PROCEED: the recommended bottom-up API skeleton (ordered list of Mathlib decls to compose),
  and which pieces are genuinely project-side new infrastructure.
- If a piece is ABSENT: whether it is buildable project-side via the Mathlib-gradient (one lemma at a
  time) or a hard block — and if a hard block, the cheapest alternative route.
- Read `analogies/p3-localisation.md` and `analogies/cech-koszul-precedent.md`; say whether the
  designs there still hold.

Write your persistent findings to `analogies/l1-bridge.md`.
